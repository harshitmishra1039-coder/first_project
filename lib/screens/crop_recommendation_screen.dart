import 'package:flutter/material.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState
    extends State<CropRecommendationScreen> {
  String result = "";

  final soilController = TextEditingController();
  final seasonController = TextEditingController();

  void recommendCrop() {
    String soil =
        soilController.text.trim().toLowerCase();
    String season =
        seasonController.text.trim().toLowerCase();

    if (soil.contains("loamy") &&
        season.contains("winter")) {
      result = "Recommended Crop: Wheat";
    } else if (soil.contains("clay") &&
        season.contains("rain")) {
      result = "Recommended Crop: Rice";
    } else if (soil.contains("black")) {
      result = "Recommended Crop: Cotton";
    } else {
      result = "Recommended Crop: Maize";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Recommendation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: soilController,
              decoration: const InputDecoration(
                labelText: "Soil Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: seasonController,
              decoration: const InputDecoration(
                labelText: "Season",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: recommendCrop,
              child: const Text(
                "Recommend Crop",
              ),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}