import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'mandi_prices_screen.dart';
import 'chatbot_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import '../widgets/agri_bottom_nav_bar.dart';
import '../services/notification_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  static dynamic of(BuildContext context) {
    return context.findAncestorStateOfType<State<MainNavigationScreen>>();
  }

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int currentIndex;
  StreamSubscription<String>? _notificationSubscription;

  final List<Widget> screens = [
    const DashboardScreen(),
    const MandiPricesScreen(),
    const ChatbotScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

    _notificationSubscription = NotificationService()
        .notificationStream
        .listen((message) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF1E6F3D),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });
  }

  void switchTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AgriBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}