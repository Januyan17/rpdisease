import 'package:flutter/material.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/Drop_Down/drop_down.dart';
import 'package:rpskindisease/widgets/LoadingButton/loading_button.dart';

class DogMediceSuggestion extends StatefulWidget {
  final Map<String, dynamic> dogData; // Receive dog details

  const DogMediceSuggestion({super.key, required this.dogData});

  @override
  State<DogMediceSuggestion> createState() => _DogMediceSuggestionState();
}

class _DogMediceSuggestionState extends State<DogMediceSuggestion> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();

  String? currentMedication;
  String? lifeStyle;
  String? environmentTemperature;
  String? vaccinationStatus;
  String? livingCondition;
  String? stage;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.dogData["age"]);
    ageController.text = widget.dogData["age"].toString();
    weightController.text = widget.dogData["weight"].toString();
    breedController.text = widget.dogData["breed"].toString();
    diseaseController.text = widget.dogData["breed"].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suggest Medicine For Your Dog"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  readOnly: true,
                  autovalidate: true,
                  controller: ageController,
                  labelText: "Age",
                  obscure: false,
                  textInputType: TextInputType.number,
                ),
                const ColumnSpacer(0.01),
                CustomTextFormField(
                  readOnly: true,
                  autovalidate: true,
                  controller: weightController,
                  labelText: "Weight",
                  obscure: false,
                  textInputType: TextInputType.number,
                ),
                const ColumnSpacer(0.01),
                CustomTextFormField(
                  readOnly: true,
                  autovalidate: true,
                  controller: breedController,
                  labelText: "Breed",
                  obscure: false,
                  textInputType: TextInputType.number,
                ),
                const ColumnSpacer(0.01),
                CustomTextFormField(
                  readOnly: true,
                  autovalidate: true,
                  controller: diseaseController,
                  labelText: "Disease",
                  obscure: false,
                  textInputType: TextInputType.number,
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "Current Medication",
                  hintText: "Choose one",
                  items: const [
                    "None",
                    "Antihistamines",
                    "Heartworm" "Preventative",
                    "Insulin",
                    "Beta-blockers"
                  ],
                  value: currentMedication,
                  onChanged: (newValue) {
                    setState(() {
                      currentMedication = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Current Medication is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "LifeStyle",
                  hintText: "Choose one",
                  items: const ["Active", "Indoor", "Outdoor"],
                  value: lifeStyle,
                  onChanged: (newValue) {
                    setState(() {
                      lifeStyle = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "LifeStyle is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "Environment Temperature",
                  hintText: "Choose one",
                  items: const ["Wet", "Dry", "Cold", "Humid"],
                  value: environmentTemperature,
                  onChanged: (newValue) {
                    setState(() {
                      environmentTemperature = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Environment Temperature is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "Vaccination Status",
                  hintText: "Choose one",
                  items: const ["Not Up-to-date", "Up-to-date"],
                  value: vaccinationStatus,
                  onChanged: (newValue) {
                    setState(() {
                      vaccinationStatus = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vaccination Status is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "Living Condition",
                  hintText: "Choose one",
                  items: const ["Multi-pet", "Single-pet"],
                  value: livingCondition,
                  onChanged: (newValue) {
                    setState(() {
                      livingCondition = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Living Condition is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.01),
                CustomDropdown(
                  autovalidate: true,
                  labelText: "Stage",
                  hintText: "Choose one",
                  items: const ["Severe", "Initial"],
                  value: stage,
                  onChanged: (newValue) {
                    setState(() {
                      stage = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Stage is Required";
                    }
                    return null;
                  },
                ),
                const ColumnSpacer(0.03),
                LoadingButton(
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                    // _uploadSkinDiseasePrediction();
                    // _showPickerDialogOption();
                    // if (_formKey.currentState!.validate()) {
                    //   signInUser(context);
                    // }
                  },
                  label: 'Submit',
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
