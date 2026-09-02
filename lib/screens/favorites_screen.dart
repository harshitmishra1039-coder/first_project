import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../services/translation_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId =
        FirebaseAuth.instance.currentUser!.uid;

    return ValueListenableBuilder<String>(
      valueListenable: TranslationService.localeNotifier,
      builder: (context, locale, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(TranslationService.translate('favorites')),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getFavorites(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    TranslationService.translate('no_favorites'),
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }

              final favorites = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final data = favorites[index].data()
                      as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      title: Text(
                        data['cropName'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}