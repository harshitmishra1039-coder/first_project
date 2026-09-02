import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal();

  // Location State
  String currentCity = "Ghaziabad, Uttar Pradesh";
  String currentMandi = "Ghaziabad Mandi";

  // User Profile State
  String userName = "Ramesh Kumar";
  String userEmail = "ramesh.farmer@agriconnect.com";
  String userMobile = "+91 98765 43210";
  String userLocation = "Ghaziabad, Uttar Pradesh";
  String userPhotoUrl = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80";

  void updateUserProfile({
    String? name,
    String? email,
    String? mobile,
    String? location,
    String? photoUrl,
  }) {
    if (name != null && name.isNotEmpty) userName = name;
    if (email != null && email.isNotEmpty) userEmail = email;
    if (mobile != null && mobile.isNotEmpty) userMobile = mobile;
    if (location != null && location.isNotEmpty) {
      userLocation = location;
      currentCity = location;
    }
    if (photoUrl != null && photoUrl.isNotEmpty) userPhotoUrl = photoUrl;
    notifyListeners();
  }

  void setCity(String city) {
    currentCity = city;
    userLocation = city;
    notifyListeners();
  }

  void setMandi(String mandi) {
    currentMandi = mandi;
    notifyListeners();
  }

  // Cart State
  List<Map<String, dynamic>> cartItems = [
    {
      "id": "c1",
      "name": "Wheat (High Quality)",
      "quantity": "20 Quintal",
      "price": 42000,
      "pricePerQtl": "₹2,100",
      "farmer": "Ramesh Kumar",
      "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=300&auto=format&fit=crop&q=80",
    },
    {
      "id": "c2",
      "name": "Rice (Paddy - A Grade)",
      "quantity": "15 Quintal",
      "price": 44250,
      "pricePerQtl": "₹2,950",
      "farmer": "Suresh Yadav",
      "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&auto=format&fit=crop&q=80",
    },
    {
      "id": "c3",
      "name": "Hybrid Maize",
      "quantity": "25 Quintal",
      "price": 47000,
      "pricePerQtl": "₹1,880",
      "farmer": "Vikram Singh",
      "image": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=300&auto=format&fit=crop&q=80",
    },
  ];

  int get cartCount => cartItems.length;

  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  // Live Listings State
  List<Map<String, dynamic>> listings = [
    {
      "id": "l1",
      "title": "Wheat",
      "category": "Cereals",
      "quantity": "20 Quintal",
      "quality": "A Grade",
      "price": "₹2,100",
      "unit": "/ Quintal",
      "priceValue": 2100,
      "farmer": "Ramesh Kumar",
      "location": "Ghaziabad, UP",
      "rating": "4.8 ★",
      "ratingCount": 120,
      "postedOn": "20 May 2024",
      "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80",
      "description": "This wheat is A grade quality. Well cleaned and properly dried in natural sunlight.",
    },
    {
      "id": "l2",
      "title": "Rice (Paddy)",
      "category": "Cereals",
      "quantity": "15 Quintal",
      "quality": "Basmati Grade 1",
      "price": "₹2,950",
      "unit": "/ Quintal",
      "priceValue": 2950,
      "farmer": "Suresh Yadav",
      "location": "Meerut, UP",
      "rating": "4.7 ★",
      "ratingCount": 95,
      "postedOn": "18 May 2024",
      "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80",
      "description": "Premium quality Basmati paddy. Long grain and fragrant aroma.",
    },
    {
      "id": "l3",
      "title": "Maize",
      "category": "Cereals",
      "quantity": "25 Quintal",
      "quality": "Standard Grade",
      "price": "₹1,880",
      "unit": "/ Quintal",
      "priceValue": 1880,
      "farmer": "Vikram Singh",
      "location": "Bulandshahr, UP",
      "rating": "4.6 ★",
      "ratingCount": 82,
      "postedOn": "15 May 2024",
      "image": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80",
      "description": "Yellow hybrid corn maize. High moisture retention and organic standard.",
    },
    {
      "id": "l4",
      "title": "Yellow Mustard",
      "category": "Oilseeds",
      "quantity": "12 Quintal",
      "quality": "Super Oil Grade",
      "price": "₹5,620",
      "unit": "/ Quintal",
      "priceValue": 5620,
      "farmer": "Kisan Lal",
      "location": "Agra, UP",
      "rating": "4.9 ★",
      "ratingCount": 110,
      "postedOn": "22 May 2024",
      "image": "https://images.unsplash.com/photo-1508747703725-719777637510?w=600&auto=format&fit=crop&q=80",
      "description": "Pure yellow mustard seed. High oil percentage extract guaranteed.",
    },
    {
      "id": "l5",
      "title": "Chana (Chickpeas)",
      "category": "Pulses",
      "quantity": "30 Quintal",
      "quality": "Bold Seed A+",
      "price": "₹5,120",
      "unit": "/ Quintal",
      "priceValue": 5120,
      "farmer": "Harish Sharma",
      "location": "Kanpur, UP",
      "rating": "4.8 ★",
      "ratingCount": 64,
      "postedOn": "19 May 2024",
      "image": "https://images.unsplash.com/photo-1515543237350-b3eea1ec8082?w=600&auto=format&fit=crop&q=80",
      "description": "Desi Chana chickpeas. Dried naturally, zero pest infestation.",
    },
  ];

  void addListing(Map<String, dynamic> listing) {
    listings.insert(0, listing);
    notifyListeners();
  }

  // Orders State
  List<Map<String, dynamic>> orders = [
    {
      "id": "ord1",
      "crop": "Wheat",
      "quantity": "20 Quintal",
      "status": "Confirmed",
      "price": "₹42,000",
      "orderId": "#ORD12345",
      "date": "20 May 2024",
      "farmer": "Ramesh Kumar",
      "location": "Ghaziabad, UP",
      "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=300&auto=format&fit=crop&q=80",
      "steps": [
        {"title": "Order Placed", "time": "20 May 2024, 09:15 AM", "done": true},
        {"title": "Confirmed by Farmer", "time": "20 May 2024, 10:30 AM", "done": true},
        {"title": "Packed & Quality Checked", "time": "21 May 2024, 02:00 PM", "done": true},
        {"title": "In Transit", "time": "22 May 2024, 08:00 AM", "done": false},
        {"title": "Delivered", "time": "Expected 24 May", "done": false},
      ]
    },
    {
      "id": "ord2",
      "crop": "Rice (Paddy)",
      "quantity": "15 Quintal",
      "status": "Pending",
      "price": "₹44,250",
      "orderId": "#ORD12346",
      "date": "18 May 2024",
      "farmer": "Suresh Yadav",
      "location": "Meerut, UP",
      "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&auto=format&fit=crop&q=80",
      "steps": [
        {"title": "Order Placed", "time": "18 May 2024, 04:20 PM", "done": true},
        {"title": "Awaiting Confirmation", "time": "Pending", "done": false},
        {"title": "Packed & Quality Checked", "time": "-", "done": false},
        {"title": "In Transit", "time": "-", "done": false},
        {"title": "Delivered", "time": "-", "done": false},
      ]
    },
    {
      "id": "ord3",
      "crop": "Maize",
      "quantity": "25 Quintal",
      "status": "Completed",
      "price": "₹46,750",
      "orderId": "#ORD12347",
      "date": "15 May 2024",
      "farmer": "Vikram Singh",
      "location": "Bulandshahr, UP",
      "image": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=300&auto=format&fit=crop&q=80",
      "steps": [
        {"title": "Order Placed", "time": "15 May 2024, 11:00 AM", "done": true},
        {"title": "Confirmed by Farmer", "time": "15 May 2024, 12:30 PM", "done": true},
        {"title": "Packed & Quality Checked", "time": "16 May 2024, 09:00 AM", "done": true},
        {"title": "In Transit", "time": "16 May 2024, 03:00 PM", "done": true},
        {"title": "Delivered", "time": "17 May 2024, 01:15 PM", "done": true},
      ]
    },
  ];

  void addOrder(Map<String, dynamic> order) {
    orders.insert(0, order);
    notifyListeners();
  }

  // Mandi Prices State
  Map<String, List<Map<String, dynamic>>> mandiData = {
    "Ghaziabad Mandi": [
      {
        "name": "Wheat",
        "category": "Cereals",
        "price": "₹2,125",
        "unit": "/ Quintal",
        "change": "+2.35%",
        "isPositive": true,
        "chartData": [2020.0, 2050.0, 2080.0, 2100.0, 2125.0],
        "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Rice (Paddy)",
        "category": "Cereals",
        "price": "₹2,980",
        "unit": "/ Quintal",
        "change": "-1.25%",
        "isPositive": false,
        "chartData": [3030.0, 3010.0, 2995.0, 2985.0, 2980.0],
        "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Maize",
        "category": "Cereals",
        "price": "₹1,870",
        "unit": "/ Quintal",
        "change": "+0.85%",
        "isPositive": true,
        "chartData": [1840.0, 1850.0, 1860.0, 1865.0, 1870.0],
        "image": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Mustard",
        "category": "Oilseeds",
        "price": "₹5,620",
        "unit": "/ Quintal",
        "change": "+1.45%",
        "isPositive": true,
        "chartData": [5510.0, 5550.0, 5580.0, 5600.0, 5620.0],
        "image": "https://images.unsplash.com/photo-1508747703725-719777637510?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Soyabean",
        "category": "Oilseeds",
        "price": "₹4,350",
        "unit": "/ Quintal",
        "change": "-0.75%",
        "isPositive": false,
        "chartData": [4400.0, 4380.0, 4370.0, 4360.0, 4350.0],
        "image": "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Chana",
        "category": "Pulses",
        "price": "₹5,120",
        "unit": "/ Quintal",
        "change": "+1.10%",
        "isPositive": true,
        "chartData": [5040.0, 5070.0, 5090.0, 5100.0, 5120.0],
        "image": "https://images.unsplash.com/photo-1515543237350-b3eea1ec8082?w=150&auto=format&fit=crop&q=80",
      },
    ],
    "Meerut Mandi": [
      {
        "name": "Wheat",
        "category": "Cereals",
        "price": "₹2,150",
        "unit": "/ Quintal",
        "change": "+3.10%",
        "isPositive": true,
        "chartData": [2010.0, 2040.0, 2090.0, 2120.0, 2150.0],
        "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Rice (Paddy)",
        "category": "Cereals",
        "price": "₹2,950",
        "unit": "/ Quintal",
        "change": "+0.50%",
        "isPositive": true,
        "chartData": [2920.0, 2930.0, 2940.0, 2945.0, 2950.0],
        "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Sugarcane",
        "category": "Cereals",
        "price": "₹385",
        "unit": "/ Quintal",
        "change": "+1.20%",
        "isPositive": true,
        "chartData": [375.0, 378.0, 380.0, 382.0, 385.0],
        "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=150&auto=format&fit=crop&q=80",
      },
    ],
    "Delhi Mandi": [
      {
        "name": "Wheat",
        "category": "Cereals",
        "price": "₹2,210",
        "unit": "/ Quintal",
        "change": "+1.80%",
        "isPositive": true,
        "chartData": [2150.0, 2170.0, 2190.0, 2200.0, 2210.0],
        "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=150&auto=format&fit=crop&q=80",
      },
      {
        "name": "Mustard",
        "category": "Oilseeds",
        "price": "₹5,750",
        "unit": "/ Quintal",
        "change": "+2.10%",
        "isPositive": true,
        "chartData": [5600.0, 5650.0, 5700.0, 5720.0, 5750.0],
        "image": "https://images.unsplash.com/photo-1508747703725-719777637510?w=150&auto=format&fit=crop&q=80",
      },
    ],
  };

  List<Map<String, dynamic>> get currentMandiPrices {
    return mandiData[currentMandi] ?? mandiData["Ghaziabad Mandi"]!;
  }
}
