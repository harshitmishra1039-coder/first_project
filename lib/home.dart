import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, Farmer", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Toggle Buttons (Home / Markets)
            Row(
              children: [
                _pillButton("Home", true),
                const SizedBox(width: 10),
                _pillButton("Markets", false),
              ],
            ),
            const SizedBox(height: 30),

            // Content changes based on Nav selection
            _selectedIndex == 0 ? _buildDashboard() : _buildPredictionList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF3D643E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: "Prices"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Predict"),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    var hd = Icons.hd;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Crop Prices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _cropCard("Wheat", "₹ 1900", Icons)),
            const SizedBox(width: 15),
            Expanded(child: _cropCard("Rice", "₹ 1500", hd)),
          ],
        ),
      ],
    );
  }

  Widget _buildPredictionList() {
    return Column(
      children: [
        _predictionTile("Wheat", "₹ 2100", true),
        _predictionTile("Rice", "₹ 1700", false),
        _predictionTile("Cotton", "₹ 3600", true),
      ],
    );
  }

  // --- Helper UI Components ---
  Widget _pillButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3D643E) : const Color(0xFFE8E4D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }

  Widget _cropCard(String name, String price, dynamic icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(name),
          const SizedBox(height: 10),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _predictionTile(String name, String price, bool isUp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: Icon(
          isUp ? Icons.trending_up : Icons.trending_down,
          color: isUp ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   // List of pages for the Navbar
//   final List<Widget> _pages = [
//     const Center(child: Text("Dashboard: Welcome Farmer", style: TextStyle(fontSize: 20))),
//     const Center(child: Text("Current Mandi Price: Wheat - ₹2300", style: TextStyle(fontSize: 20))),
//     const Center(child: Text("Predict Section: AI Price Analysis", style: TextStyle(fontSize: 20))),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Farmer Assistant"),
//         backgroundColor: const Color(0xFF3B62FF),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => Navigator.pushReplacementNamed(context, '/'), 
//           )
//         ],
//       ),
//       body: Container(
//         alignment: Alignment.center,
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 800), // Better for Web
//           child: _pages[_selectedIndex],
//         ),
//       ),
//       // --- THE NAVBAR SECTION ---
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: const Color(0xFF3B62FF),
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.currency_rupee),
//             label: 'Mandi Price',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.online_prediction),
//             label: 'Predict',
//           ),
//         ],
//       ),
//     );
//   }
//  }
/// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Dropdown values
//   String selectedCrop = 'Wheat';
//   String selectedRegion = 'North';
//   String predictedPrice = "--";

//   // Mock function for prediction logic
//   void _calculatePrice() {
//     setState(() {
//       // In a real app, you'd call an ML API here
//       predictedPrice = "₹2,150 / Quintal"; 
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text('Farmer Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle, color: Colors.black)),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 800), // Better for Web/Chrome
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 30),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left Side: Inputs
//                     Expanded(flex: 2, child: _buildPredictionForm()),
//                     const SizedBox(width: 24),
//                     // Right Side: Results/Insights
//                     Expanded(flex: 1, child: _buildResultCard()),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Crop Price Prediction",
//           style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C)),
//         ),
//         Text(
//           "Select your crop and region to see future market trends.",
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Widget _buildPredictionForm() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             _buildDropdown("Select Crop", ['Wheat', 'Rice', 'Corn', 'Cotton'], (val) => setState(() => selectedCrop = val!)),
//             const SizedBox(height: 20),
//             _buildDropdown("Region", ['North', 'South', 'East', 'West'], (val) => setState(() => selectedRegion = val!)),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _calculatePrice,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3B62FF),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text("Predict Price", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: items[0],
//           decoration: const InputDecoration(border: OutlineInputBorder()),
//           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }

//   Widget _buildResultCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 24, 128, 47),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.trending_up, color: Colors.white, size: 40),
//           const SizedBox(height: 16),
//           const Text("Estimated Price", style: TextStyle(color: Colors.white70, fontSize: 14)),
//           const SizedBox(height: 8),
//           Text(
//             predictedPrice,
//             style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           const Divider(color: Colors.white24),
//           const Text(
//             "Based on historical data and current weather patterns.",
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }