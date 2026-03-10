import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/constants/routes.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/Colors/Colors.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/Drop_Down/drop_down.dart';
import 'package:rpskindisease/widgets/snakbar/snakbar.dart';

class DogDetailScreen extends StatefulWidget {
  final Map<String, dynamic> dogData;

  const DogDetailScreen({super.key, required this.dogData});

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late String? _genderValue;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.dogData;
    _nameController = TextEditingController(text: d["name"]?.toString() ?? "");
    _breedController = TextEditingController(text: d["breed"]?.toString() ?? "");
    _ageController = TextEditingController(text: d["age"]?.toString() ?? "");
    _weightController = TextEditingController(text: d["weight"]?.toString() ?? "");
    _genderValue = d["gender"]?.toString() ?? "Male";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.dogData["id"]?.toString() ?? "";
    final name = _nameController.text.trim();
    final breed = _breedController.text.trim();
    final age = _ageController.text.trim();
    final weight = _weightController.text.trim();
    final gender = _genderValue ?? "Male";

    final same = name == (widget.dogData["name"]?.toString() ?? "") &&
        breed == (widget.dogData["breed"]?.toString() ?? "") &&
        age == (widget.dogData["age"]?.toString() ?? "") &&
        weight == (widget.dogData["weight"]?.toString() ?? "") &&
        gender == (widget.dogData["gender"]?.toString() ?? "");

    if (same) {
      showTopSnackBar(context, "No changes to save", Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _updateDogInFirestore(id, name, breed, age, weight, gender);
      await SharedPreferencesHelper.setString("local_storage_dog_name", name);
      await SharedPreferencesHelper.setString("local_storage_dog_age", age);
      await SharedPreferencesHelper.setString("local_storage_dog_gender", gender);
      await SharedPreferencesHelper.setString("local_storage_dog_weight", weight);

      if (!mounted) return;
      showTopSnackBar(context, "Pet updated successfully", Colors.green);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      showTopSnackBar(context, "Failed to update", Colors.red);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _updateDogInFirestore(
    String dogId,
    String name,
    String breed,
    String age,
    String weight,
    String gender,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("dogs")
        .doc(dogId)
        .update({
      "name": name,
      "breed": breed,
      "age": age.isNotEmpty ? int.tryParse(age) : null,
      "weight": weight.isNotEmpty ? double.tryParse(weight) : null,
      "gender": gender,
      "image": widget.dogData["image"] ??
          "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    });
  }

  Future<void> _deletePet() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete pet"),
        content: const Text(
          "Are you sure you want to remove this pet? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: primaryRedColor),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final dogId = widget.dogData["id"]?.toString() ?? "";
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("dogs")
            .doc(dogId)
            .delete();
      }
      if (!mounted) return;
      showTopSnackBar(context, "Pet removed", Colors.green);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      showTopSnackBar(context, "Failed to delete", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.dogData["image"]?.toString() ?? "";
    final name = widget.dogData["name"]?.toString() ?? "Pet";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // —— Pet photo card ——
                Center(
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: paleColor1,
                              child: Icon(
                                Icons.pets_rounded,
                                size: 64,
                                color: primaryGreyColor,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // —— Details card ——
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryBlackColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        autovalidate: true,
                        controller: _nameController,
                        labelText: "Name",
                        obscure: false,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                      const ColumnSpacer(0.03),
                      CustomTextFormField(
                        autovalidate: true,
                        readOnly: true,
                        controller: _breedController,
                        labelText: "Breed",
                        obscure: false,
                      ),
                      const ColumnSpacer(0.03),
                      CustomDropdown(
                        autovalidate: true,
                        labelText: "Gender",
                        hintText: "Choose one",
                        items: const ["Male", "Female"],
                        value: _genderValue,
                        onChanged: (v) => setState(() => _genderValue = v),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Gender is required";
                          }
                          return null;
                        },
                      ),
                      const ColumnSpacer(0.03),
                      CustomTextFormField(
                        autovalidate: true,
                        controller: _ageController,
                        labelText: "Age (years)",
                        obscure: false,
                        textInputType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Age is required";
                          }
                          final n = int.tryParse(v.trim());
                          if (n == null || n < 0 || n > 20) {
                            return "Enter 0–20";
                          }
                          return null;
                        },
                      ),
                      const ColumnSpacer(0.03),
                      CustomTextFormField(
                        autovalidate: true,
                        controller: _weightController,
                        labelText: "Weight (kg)",
                        obscure: false,
                        textInputType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Weight is required";
                          }
                          final n = double.tryParse(v.trim());
                          if (n == null || n < 5 || n > 100) {
                            return "Enter 5–100";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // —— Save button ——
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Save changes"),
                  ),
                ),
                const SizedBox(height: 12),

                // —— Delete ——
                TextButton.icon(
                  onPressed: _isSaving ? null : _deletePet,
                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: primaryRedColor),
                  label: Text(
                    "Remove pet",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryRedColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
