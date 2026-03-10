/// Demo data for the app when API is not available.
/// Set [useDemoData] to true to use dummy values instead of API calls.
library;

/// When true, all API calls are replaced with dummy data so the UI works without the backend.
const bool useDemoData = true;

/// Simulated delay (ms) for demo responses to mimic network.
const int demoDelayMs = 600;

// ─────────────────────────────────────────────────────────────────────────────
// Food Identification (food_identification.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Response for food-predict API: { "predicted_class": "..." }
Map<String, dynamic> get demoFoodPredictResponse => {
      "predicted_class": "Chicken",
    };

/// Response for predict_allergy API: "Allergic Food" | "Non-Allergic"
Map<String, dynamic> get demoPredictAllergyResponse => {
      "predicted_class": "Non-Allergic",
    };

/// Response for suggest-food API: { "suitable", "food", "reason" }
Map<String, dynamic> get demoSuggestFoodResponse => {
      "suitable": true,
      "food": "Chicken",
      "reason":
          "Chicken is suitable for your dog's condition and provides good protein without common allergens.",
    };

// ─────────────────────────────────────────────────────────────────────────────
// Dog Swipe / Add Dog (dogswipewidget.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Response for predict-with-voice: { "predicted_breed": "..." }
Map<String, dynamic> get demoPredictWithVoiceResponse => {
      "predicted_breed": "Labrador Retriever",
    };

/// Response for predict-with-image: { "prediction": { "breed": "..." } }
Map<String, dynamic> get demoPredictWithImageResponse => {
      "prediction": {"breed": "Golden Retriever"},
    };

/// Demo list of dogs when Firestore is empty or demo mode is on.
List<Map<String, dynamic>> get demoDogsList => [
      {
        "id": "demo_dog_1",
        "name": "Max",
        "breed": "Labrador Retriever",
        "age": 3,
        "weight": 28.5,
        "gender": "Male",
        "image":
            "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      },
      {
        "id": "demo_dog_2",
        "name": "Bella",
        "breed": "Golden Retriever",
        "age": 2,
        "weight": 25.0,
        "gender": "Female",
        "image":
            "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      },
    ];

// ─────────────────────────────────────────────────────────────────────────────
// Dog Skin Disease (dog_skin_disease_identification.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Response for predict-text (skin disease): { "prediction": "disease_name" }
Map<String, dynamic> get demoSkinDiseasePredictResponse => {
      "prediction": "Bacterial dermatosis",
    };

// ─────────────────────────────────────────────────────────────────────────────
// Dog Medicine Suggestion (dog_medicine_suggest.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Response for suggest-medicine API
Map<String, dynamic> get demoSuggestMedicineResponse => {
      "predicted_conventional_treatment": ["Amoxicillin", "Cephalexin"],
      "predicted_natural_remedies": ["Coconut oil", "Oatmeal bath", "Aloe vera"],
    };

/// Response for predict_business (shop availability)
Map<String, dynamic> get demoPredictBusinessResponse => {
      "best_match": "Pet Care Plus - Jaffna",
      "majority_matches": [
        {
          "business": "Pet Care Plus - Jaffna",
          "address": "123 Main Street, Jaffna",
          "available_items": ["Amoxicillin", "Cephalexin", "Coconut oil"],
          "stock_priority_score": 95,
        },
        {
          "business": "Healthy Pets Pharmacy",
          "address": "45 Hospital Road, Jaffna",
          "available_items": ["Amoxicillin", "Oatmeal bath"],
          "stock_priority_score": 72,
        },
      ],
      "missing_items": ["Aloe vera gel"],
    };
