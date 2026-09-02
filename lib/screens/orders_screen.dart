import 'package:flutter/material.dart';
import '../services/app_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AppState appState = AppState.instance;
  String selectedFilter = "All";

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

  void _showOrderTrackingDetails(Map<String, dynamic> item) {
    final steps = item["steps"] as List<dynamic>? ?? [
      {"title": "Order Placed", "time": item["date"], "done": true},
      {"title": "Confirmed by Seller", "time": item["date"], "done": true},
      {"title": "Packed & Quality Checked", "time": "In Progress", "done": item["status"] == "Confirmed" || item["status"] == "Completed"},
      {"title": "In Transit", "time": "On the way", "done": item["status"] == "Completed"},
      {"title": "Delivered", "time": item["status"] == "Completed" ? item["date"] : "Expected soon", "done": item["status"] == "Completed"},
    ];

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Details ${item["orderId"]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item["image"], width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["crop"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Quantity: ${item["quantity"]} • ${item["price"]}", style: const TextStyle(fontSize: 13, color: Color(0xFF1E6F3D), fontWeight: FontWeight.bold)),
                      Text("Seller: ${item["farmer"]} (${item["location"]})", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Delivery Status Timeline:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...List.generate(steps.length, (index) {
                final step = steps[index];
                final isDone = step["done"] as bool;
                final isLast = index == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isDone ? const Color(0xFF1E6F3D) : const Color(0xFFE0E0E0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDone ? Icons.check : Icons.circle,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 32,
                            color: isDone ? const Color(0xFF1E6F3D) : const Color(0xFFE0E0E0),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["title"].toString(),
                            style: TextStyle(
                              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                              color: isDone ? const Color(0xFF212121) : const Color(0xFF757575),
                            ),
                          ),
                          Text(
                            step["time"].toString(),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = appState.orders.where((o) {
      if (selectedFilter == "All") return true;
      return o["status"] == selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Pending", "Confirmed", "Completed"].map((status) {
                  final isSelected = selectedFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E6F3D),
                      backgroundColor: const Color(0xFFF1F3F1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF616161),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = status;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Orders Cards List
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text("No orders found", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredOrders[index];
                      final status = item["status"].toString();

                      Color badgeBg;
                      Color badgeText;

                      if (status == "Confirmed") {
                        badgeBg = const Color(0xFFE8F5E9);
                        badgeText = const Color(0xFF2E7D32);
                      } else if (status == "Pending") {
                        badgeBg = const Color(0xFFFFF3E0);
                        badgeText = const Color(0xFFE65100);
                      } else {
                        badgeBg = const Color(0xFFE8F5E9);
                        badgeText = const Color(0xFF2E7D32);
                      }

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Top Row (Thumbnail, Title, Status Badge)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item["image"],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: const Color(0xFFE8F5E9),
                                      child: const Icon(Icons.agriculture, color: Color(0xFF1E6F3D)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["crop"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["quantity"],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status Pill Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: badgeText,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F3F1)),
                            const SizedBox(height: 10),

                            // Order Details Row (Order ID, Date, Total Price, View Details)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Order ID: ",
                                          style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                                        ),
                                        Text(
                                          item["orderId"],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF616161),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Text(
                                          "Date: ",
                                          style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                                        ),
                                        Text(
                                          item["date"],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF616161),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item["price"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      height: 30,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF1E6F3D),
                                          side: const BorderSide(color: Color(0xFF1E6F3D)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () => _showOrderTrackingDetails(item),
                                        child: const Text(
                                          "View Details",
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}