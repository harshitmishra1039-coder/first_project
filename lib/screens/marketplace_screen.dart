import 'package:flutter/material.dart';
import 'crop_details_screen.dart';
import '../services/app_state.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final AppState appState = AppState.instance;
  String selectedCategory = "All Categories";
  String selectedDistance = "Nearby";
  String selectedSort = "Sort";
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> categoryIcons = [
    {"name": "All", "icon": "🌾", "bgColor": Color(0xFFE8F5E9)},
    {"name": "Cereals", "icon": "🌾", "bgColor": Color(0xFFFFF3E0)},
    {"name": "Pulses", "icon": "🌱", "bgColor": Color(0xFFE8F5E9)},
    {"name": "Oilseeds", "icon": "🫘", "bgColor": Color(0xFFFFF8E1)},
    {"name": "Fruits", "icon": "🍎", "bgColor": Color(0xFFFFEBEE)},
    {"name": "Vegetables", "icon": "🥦", "bgColor": Color(0xFFF3E5F5)},
  ];

  @override
  void initState() {
    super.initState();
    appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    appState.removeListener(_onStateChange);
    searchController.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  void _showCartModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final cartItems = appState.cartItems;
            double total = 0;
            for (var item in cartItems) {
              total += (item["price"] as num).toDouble();
            }

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shopping Cart (${cartItems.length} Items)",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text("Your cart is empty", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item["image"],
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text("Quantity: ${item["quantity"]} • Farmer: ${item["farmer"]}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "₹${item["price"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E6F3D)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () {
                                    appState.removeFromCart(index);
                                    setModalState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (cartItems.isNotEmpty) ...[
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E6F3D))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6F3D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // Place order for cart items
                          for (var item in cartItems) {
                            appState.addOrder({
                              "id": "ord_${DateTime.now().millisecondsSinceEpoch}",
                              "crop": item["name"],
                              "quantity": item["quantity"],
                              "status": "Confirmed",
                              "price": "₹${item["price"]}",
                              "orderId": "#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                              "date": "Today",
                              "farmer": item["farmer"],
                              "location": appState.currentCity,
                              "image": item["image"],
                              "steps": [
                                {"title": "Order Placed", "time": "Just now", "done": true},
                                {"title": "Confirmed by Seller", "time": "Just now", "done": true},
                                {"title": "In Transit", "time": "Expected tomorrow", "done": false},
                                {"title": "Delivered", "time": "Expected 2 days", "done": false},
                              ]
                            });
                          }
                          appState.clearCart();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed successfully! Check My Orders tab.")),
                          );
                        },
                        child: const Text("Proceed to Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddListingSheet() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final locCtrl = TextEditingController(text: appState.currentCity);
    String categoryCtrl = "Cereals";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
              const Text(
                "Add New Crop Listing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Crop Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Quantity (Quintals)", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price (₹ / Quintal)", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(labelText: "Location", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final qty = qtyCtrl.text.trim();
                    final price = priceCtrl.text.trim();

                    if (name.isEmpty || qty.isEmpty || price.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill crop name, quantity, and price")),
                      );
                      return;
                    }

                    appState.addListing({
                      "id": "l_${DateTime.now().millisecondsSinceEpoch}",
                      "title": name,
                      "category": categoryCtrl,
                      "quantity": "$qty Quintal",
                      "quality": "A Grade",
                      "price": "₹$price",
                      "unit": "/ Quintal",
                      "priceValue": double.tryParse(price) ?? 2000,
                      "farmer": "Ramesh Kumar (You)",
                      "location": locCtrl.text.isNotEmpty ? locCtrl.text : "Ghaziabad, UP",
                      "rating": "5.0 ★",
                      "ratingCount": 1,
                      "postedOn": "Today",
                      "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80",
                      "description": "Fresh harvest $name listed by Ramesh Kumar. Direct from farm.",
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Success! New listing for $name published.")),
                    );
                  },
                  child: const Text("Publish Listing", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryDropdown() {
    final categories = ["All Categories", "Cereals", "Pulses", "Oilseeds", "Fruits", "Vegetables"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Filter by Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...categories.map((cat) {
                return ListTile(
                  title: Text(cat),
                  trailing: selectedCategory == cat ? const Icon(Icons.check, color: Color(0xFF1E6F3D)) : null,
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSortDropdown() {
    final sorts = ["Default", "Price: Low to High", "Price: High to Low", "Highest Rating"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sort Listings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...sorts.map((sort) {
                return ListTile(
                  title: Text(sort),
                  trailing: selectedSort == sort ? const Icon(Icons.check, color: Color(0xFF1E6F3D)) : null,
                  onTap: () {
                    setState(() {
                      selectedSort = sort;
                    });
                    Navigator.pop(context);
                  },
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
    final query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> displayedListings = appState.listings.where((item) {
      final matchCat = selectedCategory == "All Categories" || selectedCategory == "All" || item["category"] == selectedCategory;
      final matchSearch = item["title"].toString().toLowerCase().contains(query) || item["farmer"].toString().toLowerCase().contains(query);
      return matchCat && matchSearch;
    }).toList();

    if (selectedSort == "Price: Low to High") {
      displayedListings.sort((a, b) => (a["priceValue"] as num).compareTo(b["priceValue"] as num));
    } else if (selectedSort == "Price: High to Low") {
      displayedListings.sort((a, b) => (b["priceValue"] as num).compareTo(a["priceValue"] as num));
    }

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
          "Marketplace",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
        actions: [
          // Shopping Bag / Cart Badge Button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF424242)),
                onPressed: _showCartModal,
              ),
              if (appState.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E6F3D),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${appState.cartCount}",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input & Filters Container
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search crops, vegetables...",
                      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF757575)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFF1F3F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Dropdowns Row
                  Row(
                    children: [
                      _FilterPill(
                        label: selectedCategory,
                        icon: Icons.keyboard_arrow_down,
                        onTap: _showCategoryDropdown,
                      ),
                      const SizedBox(width: 8),
                      _FilterPill(
                        label: selectedDistance,
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _FilterPill(
                        label: selectedSort,
                        icon: Icons.swap_vert,
                        onTap: _showSortDropdown,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Circles Horizontal Scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categoryIcons.map((cat) {
                        final isSelected = selectedCategory == cat["name"];
                        return Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedCategory = cat["name"] == "All" ? "All Categories" : cat["name"].toString();
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF1E6F3D) : cat["bgColor"] as Color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF1E6F3D) : const Color(0xFFE8ECE8),
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat["icon"].toString(),
                                      style: TextStyle(fontSize: isSelected ? 24 : 26),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat["name"].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF1E6F3D) : const Color(0xFF424242),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Listings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Live Listings (${displayedListings.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = "All Categories";
                            searchController.clear();
                          });
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

                  // Listings Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedListings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = displayedListings[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CropDetailsScreen(
                                cropName: item["title"],
                                price: "${item["price"]} ${item["unit"]}",
                                quantity: item["quantity"],
                                farmerName: item["farmer"],
                                location: item["location"],
                                imageUrl: item["image"],
                                description: item["description"] ?? "Quality crop harvested directly by farmer.",
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                          child: Row(
                            children: [
                              // Crop Image Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item["image"],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: const Color(0xFFE8F5E9),
                                    child: const Icon(Icons.agriculture, color: Color(0xFF1E6F3D)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Listing Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item["title"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF212121),
                                          ),
                                        ),
                                        Text(
                                          item["farmer"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF616161),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item["quantity"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item["price"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E6F3D),
                                              ),
                                            ),
                                            Text(
                                              " ${item["unit"]}",
                                              style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF757575)),
                                            Text(
                                              item["location"],
                                              style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              item["rating"].toString(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFFFFB300),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Bottom Promo Banner (Want to sell your crop?)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Want to sell your crop?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "List your crop and reach thousands of buyers.",
                          style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add New Listing"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E6F3D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _showAddListingSheet,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF424242),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 16, color: const Color(0xFF616161)),
          ],
        ),
      ),
    );
  }
}