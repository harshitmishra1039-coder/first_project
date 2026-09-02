class CropListing {
  final String cropName;
  final String farmerName;
  final String quantity;
  final String price;
  final String location;

  CropListing({
    required this.cropName,
    required this.farmerName,
    required this.quantity,
    required this.price,
    required this.location,
  });
}

class MandiPrice {
  final String cropName;
  final String mandiName;
  final double price;

  MandiPrice({
    required this.cropName,
    required this.mandiName,
    required this.price,
  });
}

class CropOrder {
  final String cropName;
  final String buyerName;
  final String status;

  CropOrder({
    required this.cropName,
    required this.buyerName,
    required this.status,
  });
}

class CropPredictionResult {
  final String cropName;
  final String estimatedYield;
  final String growthDuration;

  CropPredictionResult({
    required this.cropName,
    required this.estimatedYield,
    required this.growthDuration,
  });
}