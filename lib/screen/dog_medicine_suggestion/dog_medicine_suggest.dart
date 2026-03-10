import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/shared_preferences.dart';
import 'package:rpskindisease/utils/log_util.dart';
import 'package:rpskindisease/utils/navigation_utils.dart';
import 'package:rpskindisease/utils/spacers/spacers.dart';
import 'package:rpskindisease/widgets/AuthReusable/AuthReusable.dart';
import 'package:rpskindisease/widgets/Drop_Down/drop_down.dart';
import 'package:rpskindisease/widgets/LoadingButton/loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:rpskindisease/data/demo.dart';

class DogMediceSuggestion extends StatefulWidget {
  final Map<String, dynamic> dogData; // Receive dog details

  const DogMediceSuggestion({super.key, required this.dogData});

  @override
  State<DogMediceSuggestion> createState() => _DogMediceSuggestionState();
}

class _DogMediceSuggestionState extends State<DogMediceSuggestion> {
  final _formKey = GlobalKey<FormState>();
  final _formKeypopup = GlobalKey<FormState>();

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
  String? dropdownDisease;
  String? location;
  String? month;
  List<dynamic> conventionalTreatment = [];
  List<dynamic> naturalRemedies = [];

  bool _isLoading = false;

  String dogDisease = "";
  var apiBaseUrl;

  @override
  void initState() {
    super.initState();
    getApiUrlFromFirestore();
    ageController.text = widget.dogData["age"].toString();
    weightController.text = widget.dogData["weight"].toString();
    breedController.text = widget.dogData["breed"].toString();

    _loadDogDisease();
  }

  Future<void> _loadDogDisease() async {
    String? storedDisease =
        await SharedPreferencesHelper.getString("local_storage_dog_disease");

    if (mounted) {
      setState(() {
        if (storedDisease == "Hypersensitivity Allergic") {
          dogDisease = "Hypersensitivity Allergic Dermatosis";
          printLog(dogDisease);
        } else {
          dogDisease = storedDisease ?? "";
        }
      });
    }
    diseaseController.text = dogDisease.toString();
  }

  @override
  Widget build(BuildContext context) {
    // // print(widget.dogData["age"]);
    // ageController.text = widget.dogData["age"].toString();
    // weightController.text = widget.dogData["weight"].toString();
    // breedController.text = widget.dogData["breed"].toString();
    // diseaseController.text = widget.dogData["breed"].toString();

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
                dogDisease == ""
                    ? CustomDropdown(
                        autovalidate: true,
                        labelText: "Disease",
                        hintText: "Choose one",
                        items: const [
                          "Staph Infection",
                          "Bacterial Dermatosis",
                          "Fungal Infections",
                          "Hypersensitivity Allergic Dermatosis"
                        ],
                        value: dropdownDisease,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownDisease = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Disease  is Required";
                          }
                          return null;
                        },
                      )
                    : CustomTextFormField(
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
                  items: const ["Temperate", "Wet", "Dry", "Cold", "Humid"],
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
                    if (_formKey.currentState!.validate()) {
                      sendDogData();
                    }
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

  //! Mikk API Call

  Future<void> getApiUrlFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("config")
          .doc("prediction")
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          apiBaseUrl = data["url"];
        });
      }
    } catch (e) {
      print('Error fetching API URL: $e');
    }
  }

  Future<void> sendDogData() async {
    setState(() {
      _isLoading = true;
    });

    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      var responseData = demoSuggestMedicineResponse;
      if (responseData["predicted_conventional_treatment"] is String) {
        conventionalTreatment = [
          responseData["predicted_conventional_treatment"]
        ];
      } else {
        conventionalTreatment = List<dynamic>.from(
            responseData["predicted_conventional_treatment"]);
      }
      naturalRemedies =
          List<dynamic>.from(responseData["predicted_natural_remedies"]);
      setState(() => _isLoading = false);
      showMedicinePopup(context, conventionalTreatment, naturalRemedies);
      return;
    }

    final String apiUrl = "${apiBaseUrl}/mikshan/suggest-medicine";

    Map<String, dynamic> requestBody = {
      "Age": ageController.text.toString(),
      "Weight": weightController.text.toString(),
      "Breed": breedController.text.toString(),
      "Current Medications": currentMedication.toString(),
      "Lifestyle": lifeStyle.toString(),
      "Environment": environmentTemperature.toString(),
      "Vaccination Status": vaccinationStatus.toString(),
      "Living Conditions": livingCondition.toString(),
      "Disease": dogDisease == "" ? dropdownDisease : dogDisease,
      "Stage": stage.toString()
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Request successful: ${response.body}");
        var responseData = jsonDecode(response.body);
        if (responseData["predicted_conventional_treatment"] is String) {
          conventionalTreatment = [
            responseData["predicted_conventional_treatment"]
          ];
        } else {
          conventionalTreatment = List<dynamic>.from(
              responseData["predicted_conventional_treatment"]);
        }

        naturalRemedies =
            List<dynamic>.from(responseData["predicted_natural_remedies"]);
        setState(() {
          _isLoading = false;
        });
        showMedicinePopup(context, conventionalTreatment, naturalRemedies);
      } else {
        print("Request failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> predictLocations() async {
    if (useDemoData) {
      await Future.delayed(Duration(milliseconds: demoDelayMs));
      showShopResultsPopup(context, demoPredictBusinessResponse);
      return;
    }

    final String secondApiUrl = "${apiBaseUrl}/mikshan/predict_business";

    Map<String, dynamic> requestBody = {
      "location": location,
      "month": month,
      "medicines": conventionalTreatment,
      "remedies": naturalRemedies
    };

    try {
      var response = await http.post(
        Uri.parse(secondApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Second API call successful: ${response.body}");
        var responseData = jsonDecode(response.body);

        showShopResultsPopup(context, responseData);
      } else {
        print("Second API call failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error in second API call: $e");
    }
  }

//! Show POP UPSS
  void showMedicinePopup(
      BuildContext context, List<dynamic> treatments, List<dynamic> remedies) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Recommended Treatment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🩺 Conventional Treatment:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...treatments.map((treatment) => Text("- $treatment")).toList(),
              const SizedBox(height: 8),
              const Text("🌿 Natural Remedies:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...remedies.map((remedy) => Text("- $remedy")).toList(),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  popScreen(context);
                  ShowPlacesPopUp(context);
                  // Future.delayed(Duration(milliseconds: 300), () {
                  //   if (mounted) {
                  //     ShowPlacesPopUp(context);
                  //   }
                  // });
                },
                child: Text("View Places ")),
          ],
        );
      },
    );
  }

  void ShowPlacesPopUp(BuildContext parentcontext) async {
    showDialog(
      context: parentcontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Show The Relative Places"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeypopup,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropdown(
                    autovalidate: true,
                    labelText: "Location",
                    hintText: "Choose one",
                    items: const [
                      "Jaffna",
                      "Kilinochchi",
                      "Mannar",
                      "Mullaitivu",
                      "Vavuniya"
                    ],
                    value: location,
                    onChanged: (newValue) {
                      setState(() {
                        location = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "location is Required";
                      }
                      return null;
                    },
                  ),
                  ColumnSpacer(0.02),
                  CustomDropdown(
                    autovalidate: true,
                    labelText: "Month",
                    hintText: "Choose one",
                    items: const [
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December"
                    ],
                    value: month,
                    onChanged: (newValue) {
                      setState(() {
                        month = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "month is Required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKeypopup.currentState!.validate()) {
                  predictLocations();
                  popScreen(context);
                  // saveDogData(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showShopResultsPopup(
      BuildContext context, Map<String, dynamic> responseData) {
    List<dynamic> majorityMatches = responseData["majority_matches"];
    List<dynamic> missingItems = responseData["missing_items"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Shop Availability"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Best Match Section
                Text("🏆 Best Match:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(responseData["best_match"],
                    style: TextStyle(color: Colors.blue)),
                SizedBox(height: 10),

                // 🔹 Majority Matches Section
                Text("🏪 Majority Matches:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...majorityMatches.map((shop) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🏠 ${shop["business"]}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("📍 Address: ${shop["address"]}"),
                        Text(
                            "🛒 Available Items: ${shop["available_items"].join(', ')}"),
                        Text("🔢 Stock Score: ${shop["stock_priority_score"]}"),
                        Divider(),
                      ],
                    )),

                SizedBox(height: 10),

                // 🔹 Missing Items Section
                if (missingItems.isNotEmpty) ...[
                  Text("⚠️ Missing Items:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  Text(missingItems.join(', ')),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
