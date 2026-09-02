import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ReviewsScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;

  const ReviewsScreen({
    super.key,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _commentController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a review comment")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      final buyerName = user?.email?.split('@')[0] ?? "Buyer";

      await FirestoreService().addReview(
        sellerId: widget.sellerId,
        buyerName: buyerName,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      _commentController.clear();
      setState(() {
        _rating = 5.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review submitted successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit review: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews for ${widget.sellerName}"),
      ),
      body: Column(
        children: [
          // Average Rating Header
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getReviews(widget.sellerId),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade50,
                  alignment: Alignment.center,
                  child: const Text(
                    "No Ratings Yet. Be the first to rate!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              double sum = 0;
              for (var doc in docs) {
                sum += (doc.data() as Map<String, dynamic>)['rating'] ?? 0.0;
              }
              double avg = sum / docs.length;

              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.green.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 30),
                    const SizedBox(width: 8),
                    Text(
                      "${avg.toStringAsFixed(1)} / 5.0",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "(${docs.length} reviews)",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              );
            },
          ),

          // Add Review Input
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Your Rating: ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      ...List.generate(5, (index) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write your feedback about this seller...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitReview,
                    child: const Text("Submit Review"),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          // Reviews List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().getReviews(widget.sellerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No reviews found."));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final review = docs[index].data() as Map<String, dynamic>;
                    double rating = review['rating'] ?? 0.0;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Text(review['buyerName']?[0]?.toUpperCase() ?? "B"),
                      ),
                      title: Row(
                        children: [
                          Text(
                            review['buyerName'] ?? "Buyer",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(5, (starIdx) {
                              return Icon(
                                starIdx < rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 14,
                              );
                            }),
                          ),
                        ],
                      ),
                      subtitle: Text(review['comment'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
