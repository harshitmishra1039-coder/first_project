import 'package:flutter/material.dart';

class MobileAppFrame extends StatelessWidget {
  final Widget child;

  const MobileAppFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If viewing on wide web screen (desktop width > 500), wrap in a sleek mobile frame
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFF1B3B2B), // Dark green elegant backdrop
            body: Center(
              child: Container(
                width: 420,
                height: constraints.maxHeight * 0.96,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF8),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFF2E5B42), width: 6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: child,
                ),
              ),
            ),
          );
        }

        // On mobile devices, take full native width
        return child;
      },
    );
  }
}
