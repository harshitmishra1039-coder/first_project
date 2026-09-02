import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Listings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getMyListings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Listings Found",
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final crop =
                  docs[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(
                    crop['cropName'],
                  ),
                  subtitle: Text(
                    "₹${crop['price']} | ${crop['quantity']} Quintals",
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await FirestoreService()
                          .deleteCropListing(
                        docs[index].id,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}