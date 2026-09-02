import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'main_navigation_screen.dart';

class CropDetailsScreen extends StatelessWidget {
  final String cropName;
  final String price;
  final String quantity;
  final String quality;
  final String location;
  final String farmerName;
  final String rating;
  final String postedOn;
  final String imageUrl;
  final String description;

  const CropDetailsScreen({
    super.key,
    this.cropName = "Wheat",
    this.price = "₹2,100 / Quintal",
    this.quantity = "20 Quintal",
    this.quality = "A Grade",
    this.location = "Ghaziabad, UP",
    this.farmerName = "Ramesh Kumar",
    this.rating = "4.8 ★ (120)",
    this.postedOn = "20 May 2024",
    this.imageUrl = "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80",
    this.description = "This wheat is A grade quality. Well cleaned and properly dried.",
  });

  void _openFarmerChat(BuildContext context) {
    final msgCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Chat with $farmerName", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text("Online • Usually responds in 10 mins", style: TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF1F3F1), borderRadius: BorderRadius.circular(12)),
                child: Text("Hello! Interested in your $cropName listing ($quantity at $price). Is it available for delivery?", style: const TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgCtrl,
                decoration: InputDecoration(
                  hintText: "Type your message to $farmerName...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF1E6F3D)),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Message sent to $farmerName!")),
                      );
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleBuyNow(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Order Purchase", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Crop: $cropName", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text("Quantity: $quantity"),
            Text("Farmer: $farmerName"),
            Text("Location: $location"),
            const SizedBox(height: 12),
            Text("Total Amount: $price", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E6F3D))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F3D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final newOrderId = "#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
              AppState.instance.addOrder({
                "id": "ord_${DateTime.now().millisecondsSinceEpoch}",
                "crop": cropName,
                "quantity": quantity,
                "status": "Confirmed",
                "price": price.contains("Quintal") ? "₹42,000" : price,
                "orderId": newOrderId,
                "date": "Today",
                "farmer": farmerName,
                "location": location,
                "image": imageUrl,
                "steps": [
                  {"title": "Order Placed", "time": "Just now", "done": true},
                  {"title": "Confirmed by Seller", "time": "Just now", "done": true},
                  {"title": "Packed & Quality Checked", "time": "In progress", "done": true},
                  {"title": "In Transit", "time": "Expected tomorrow", "done": false},
                  {"title": "Delivered", "time": "Expected 2 days", "done": false},
                ]
              });

              Navigator.pop(context); // Close dialog

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Order $newOrderId Placed Successfully!"),
                  backgroundColor: const Color(0xFF1E6F3D),
                  action: SnackBarAction(
                    label: "VIEW ORDERS",
                    textColor: Colors.white,
                    onPressed: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                      MainNavigationScreen.of(context)?.switchTab(3);
                    },
                  ),
                ),
              );
            },
            child: const Text("Confirm Order", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Crop Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF616161)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Crop listing link copied to clipboard")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header Image
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: const Color(0xFFE8F5E9),
                      child: const Center(
                        child: Icon(Icons.agriculture, size: 80, color: Color(0xFF1E6F3D)),
                      ),
                    ),
                  ),

                  // Info Container
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Availability Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cropName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Available",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Price
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E6F3D),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Specs Table / Grid
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Column(
                            children: [
                              _SpecRow(icon: Icons.shopping_bag_outlined, label: "Quantity", value: quantity),
                              const Divider(height: 18, color: Color(0xFFF1F3F1)),
                              _SpecRow(icon: Icons.verified_outlined, label: "Quality", value: quality),
                              const Divider(height: 18, color: Color(0xFFF1F3F1)),
                              _SpecRow(icon: Icons.location_on_outlined, label: "Location", value: location),
                              const Divider(height: 18, color: Color(0xFFF1F3F1)),
                              _SpecRow(icon: Icons.person_outline, label: "Farmer", value: farmerName, subtitle: rating),
                              const Divider(height: 18, color: Color(0xFFF1F3F1)),
                              _SpecRow(icon: Icons.calendar_today_outlined, label: "Posted On", value: postedOn),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // About Crop Section
                        const Text(
                          "About Crop",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF616161),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Action Bar (Chat with Farmer | Buy Now)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: Row(
              children: [
                // Chat with Farmer (Outlined Green)
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text("Chat with Farmer"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E6F3D),
                        side: const BorderSide(color: Color(0xFF1E6F3D), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onPressed: () => _openFarmerChat(context),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Buy Now (Filled Green)
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6F3D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _handleBuyNow(context),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF757575)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: const TextStyle(fontSize: 12, color: Color(0xFFFFB300), fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ],
    );
  }
}
