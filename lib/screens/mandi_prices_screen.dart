import 'package:flutter/material.dart';
import '../widgets/sparkline_widget.dart';
import '../services/app_state.dart';
import 'crop_details_screen.dart';

class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  final AppState appState = AppState.instance;
  String selectedCategory = "All";
  final TextEditingController searchController = TextEditingController();

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

  void _showMandiSelector() {
    final mandis = ["Ghaziabad Mandi", "Meerut Mandi", "Delhi Mandi"];
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
                "Select Mandi Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...mandis.map((mandi) {
                final isSelected = appState.currentMandi == mandi;
                return ListTile(
                  leading: Icon(Icons.storefront, color: isSelected ? const Color(0xFF1E6F3D) : Colors.grey),
                  title: Text(
                    mandi,
                    style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1E6F3D)) : null,
                  onTap: () {
                    appState.setMandi(mandi);
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

  void _showPriceAnalysisDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item["isPositive"] ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item["change"],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: item["isPositive"] ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Mandi Price: ${item["price"]} ${item["unit"]}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E6F3D))),
            const SizedBox(height: 10),
            Text("Location: ${appState.currentMandi}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 14),
            const Text("Weekly Price Graph:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Center(
              child: SparklineWidget(
                data: List<double>.from(item["chartData"]),
                isPositive: item["isPositive"],
                width: 200,
                height: 60,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E6F3D), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CropDetailsScreen(
                    cropName: item["name"],
                    price: "${item["price"]} ${item["unit"]}",
                    quantity: "20 Quintal",
                  ),
                ),
              );
            },
            child: const Text("View in Marketplace"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crops = appState.currentMandiPrices;
    final query = searchController.text.toLowerCase();

    final filteredCrops = crops.where((c) {
      final matchesCat = selectedCategory == "All" || c["category"] == selectedCategory;
      final matchesSearch = c["name"].toString().toLowerCase().contains(query);
      return matchesCat && matchesSearch;
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
        title: Column(
          children: [
            const Text(
              "Mandi Prices",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: _showMandiSelector,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    appState.currentMandi,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1E6F3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF1E6F3D)),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Category Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Search any crop...",
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

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["All", "Cereals", "Pulses", "Oilseeds"].map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
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
                              selectedCategory = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Crop Cards List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredCrops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filteredCrops[index];
                final isPositive = item["isPositive"] as bool;
                final changeColor = isPositive ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F);
                final changeBg = isPositive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

                return InkWell(
                  onTap: () => _showPriceAnalysisDialog(item),
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
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 52,
                              height: 52,
                              color: const Color(0xFFE8F5E9),
                              child: const Icon(Icons.agriculture, color: Color(0xFF1E6F3D)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name and Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    item["price"],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  Text(
                                    " ${item["unit"]}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: changeBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item["change"],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: changeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Sparkline Chart
                        SparklineWidget(
                          data: List<double>.from(item["chartData"]),
                          isPositive: isPositive,
                          width: 76,
                          height: 36,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Footer Notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFF1F3F1),
            child: const Column(
              children: [
                Text(
                  "Prices updated today at 08:30 AM",
                  style: TextStyle(fontSize: 12, color: Color(0xFF616161), fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  "Source: Agmarknet",
                  style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}