import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import 'marketplace_screen.dart';
import 'weather_screen.dart';
import 'disease_detection_screen.dart';
import 'crop_recommendation_screen.dart';
import 'crop_details_screen.dart';
import '../widgets/sparkline_widget.dart';
import '../services/app_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AppState appState = AppState.instance;

  @override
  void initState() {
    super.initState();
    appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  void _showLocationPicker() {
    final cities = [
      "Ghaziabad, Uttar Pradesh",
      "Meerut, Uttar Pradesh",
      "Delhi NCR",
      "Agra, Uttar Pradesh",
      "Lucknow, Uttar Pradesh",
      "Kanpur, Uttar Pradesh",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Your Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
              ),
              const SizedBox(height: 12),
              ...cities.map((city) {
                final isSelected = appState.currentCity == city;
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: isSelected ? const Color(0xFF1E6F3D) : Colors.grey,
                  ),
                  title: Text(
                    city,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF1E6F3D) : const Color(0xFF212121),
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1E6F3D)) : null,
                  onTap: () {
                    appState.setCity(city);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Location updated to $city")),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.notifications_active, color: Color(0xFF1E6F3D)),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.trending_up, color: Color(0xFF1E6F3D))),
                title: const Text("Wheat Price Surged +2.35%"),
                subtitle: const Text("Ghaziabad Mandi today at 08:30 AM"),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3E0), child: Icon(Icons.wb_sunny, color: Colors.orange)),
                subtitle: const Text("Partly cloudy skies expected in UP west region"),
                title: const Text("Weather Advisory"),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFE1F5FE), child: Icon(Icons.local_shipping, color: Colors.blue)),
                title: const Text("Order #ORD12345 Confirmed"),
                subtitle: const Text("Seller Ramesh Kumar accepted your order"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFarmExpertsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Agricultural Experts & Agronomists",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80"),
                ),
                title: const Text("Dr. Anita Verma (Crop Specialist)"),
                subtitle: const Text("KVK Scientist • 14 yrs exp"),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.call, size: 14),
                  label: const Text("Call"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E6F3D), foregroundColor: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Calling Dr. Anita Verma...")));
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80"),
                ),
                title: const Text("Dr. Subhash Singh (Soil Expert)"),
                subtitle: const Text("ICAR Agronomist • 18 yrs exp"),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.call, size: 14),
                  label: const Text("Call"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E6F3D), foregroundColor: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Calling Dr. Subhash Singh...")));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreServicesMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("More Services & Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calculate, color: Color(0xFF1E6F3D)),
                title: const Text("Fertilizer Calculator"),
                onTap: () {
                  Navigator.pop(context);
                  MainNavigationScreen.of(context)?.switchTab(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop, color: Colors.blue),
                title: const Text("Irrigation Advisory"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.purple),
                title: const Text("Past Yield Analytics"),
                onTap: () {
                  Navigator.pop(context);
                  MainNavigationScreen.of(context)?.switchTab(3);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row (Greeting, Location Selector, Notification, Profile Avatar)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Hello, Ramesh!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text("👋", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _showLocationPicker,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Color(0xFF1E6F3D),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                appState.currentCity,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1E6F3D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Color(0xFF1E6F3D),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Bell Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, size: 20, color: Color(0xFF424242)),
                      onPressed: _showNotifications,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Farmer Profile Avatar
                  GestureDetector(
                    onTap: () {
                      MainNavigationScreen.of(context)?.switchTab(4);
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE8F5E9),
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
                      ),
                      child: Icon(Icons.person, color: Color(0xFF1E6F3D), size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Weather Card Container (Clickable to open WeatherScreen)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeatherScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D5D5B), Color(0xFF2E7A5D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1D5D5B).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "28°C",
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Partly Cloudy",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.wb_cloudy_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Humidity & Wind Row
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Humidity",
                            style: TextStyle(color: Color(0xFFB2DFDB), fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "65%",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 24),
                          Text(
                            "Wind",
                            style: TextStyle(color: Color(0xFFB2DFDB), fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "12 km/h",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Good Morning Strip Banner Inside Weather Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Good Morning! ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "🌾 Let's make your farm better today.",
                              style: TextStyle(
                                color: Color(0xFFE0F2F1),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick Access Section Header
              const Text(
                "Quick Access",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),

              // 4x2 Grid of Feature Buttons
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _QuickAccessItem(
                    icon: Icons.bar_chart,
                    iconColor: const Color(0xFF2E7D32),
                    bgColor: const Color(0xFFE8F5E9),
                    label: "Mandi Prices",
                    onTap: () {
                      MainNavigationScreen.of(context)?.switchTab(1);
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.smart_toy_outlined,
                    iconColor: const Color(0xFF0288D1),
                    bgColor: const Color(0xFFE1F5FE),
                    label: "AI Assistant",
                    onTap: () {
                      MainNavigationScreen.of(context)?.switchTab(2);
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.shopping_bag_outlined,
                    iconColor: const Color(0xFFE65100),
                    bgColor: const Color(0xFFFFF3E0),
                    label: "Marketplace",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
                      );
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.wb_sunny_outlined,
                    iconColor: const Color(0xFF0097A7),
                    bgColor: const Color(0xFFE0F7FA),
                    label: "Weather",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherScreen()),
                      );
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.local_hospital_outlined,
                    iconColor: const Color(0xFF673AB7),
                    bgColor: const Color(0xFFEDE7F6),
                    label: "Crop Doctor",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
                      );
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.science_outlined,
                    iconColor: const Color(0xFF8E24AA),
                    bgColor: const Color(0xFFF3E5F5),
                    label: "Soil Test",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CropRecommendationScreen()),
                      );
                    },
                  ),
                  _QuickAccessItem(
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFFD81B60),
                    bgColor: const Color(0xFFFCE4EC),
                    label: "Farm Experts",
                    onTap: _showFarmExpertsSheet,
                  ),
                  _QuickAccessItem(
                    icon: Icons.grid_view,
                    iconColor: const Color(0xFF455A64),
                    bgColor: const Color(0xFFECEFF1),
                    label: "More",
                    onTap: _showMoreServicesMenu,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Market Update Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Market Update",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      MainNavigationScreen.of(context)?.switchTab(1);
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E6F3D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mini Crop Cards with Sparkline Charts (Clickable to Crop Details)
              _MarketCropCard(
                cropName: "Wheat",
                price: "₹2,125",
                unit: "/ Quintal",
                trend: "+2.35%",
                isPositive: true,
                data: const [2000, 2040, 2080, 2060, 2100, 2125],
                imageUrl: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=150&auto=format&fit=crop&q=80",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CropDetailsScreen(
                        cropName: "Wheat",
                        price: "₹2,125 / Quintal",
                        quantity: "20 Quintal",
                        farmerName: "Ramesh Kumar",
                        location: "Ghaziabad, UP",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              _MarketCropCard(
                cropName: "Rice",
                price: "₹2,980",
                unit: "/ Quintal",
                trend: "-1.25%",
                isPositive: false,
                data: const [3050, 3020, 3010, 2990, 2980],
                imageUrl: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=150&auto=format&fit=crop&q=80",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CropDetailsScreen(
                        cropName: "Rice (Paddy)",
                        price: "₹2,980 / Quintal",
                        quantity: "15 Quintal",
                        farmerName: "Suresh Yadav",
                        location: "Meerut, UP",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              _MarketCropCard(
                cropName: "Maize",
                price: "₹1,870",
                unit: "/ Quintal",
                trend: "+0.85%",
                isPositive: true,
                data: const [1840, 1850, 1845, 1860, 1870],
                imageUrl: "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=150&auto=format&fit=crop&q=80",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CropDetailsScreen(
                        cropName: "Maize",
                        price: "₹1,870 / Quintal",
                        quantity: "25 Quintal",
                        farmerName: "Vikram Singh",
                        location: "Bulandshahr, UP",
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MarketCropCard extends StatelessWidget {
  final String cropName;
  final String price;
  final String unit;
  final String trend;
  final bool isPositive;
  final List<double> data;
  final String imageUrl;
  final VoidCallback onTap;

  const _MarketCropCard({
    required this.cropName,
    required this.price,
    required this.unit,
    required this.trend,
    required this.isPositive,
    required this.data,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = isPositive ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFECEFF1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 44,
                  height: 44,
                  color: const Color(0xFFE8F5E9),
                  child: const Icon(Icons.agriculture, color: Color(0xFF1E6F3D)),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Crop info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242),
                        ),
                      ),
                      Text(
                        " $unit",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    trend,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ),

            // Sparkline chart
            SparklineWidget(
              data: data,
              isPositive: isPositive,
              width: 70,
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}