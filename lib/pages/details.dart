import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback.dart';

class DetailPage extends StatelessWidget {
  static const String id = 'DetailPage';

  final String documentId;

  DetailPage({super.key, required this.documentId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('transactions').doc(documentId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactionData = snapshot.data!.data() as Map<String, dynamic>;
          final images = transactionData['imageUrls'] as List<dynamic>;
          final name = transactionData['name'] as String;
          final location = transactionData['location'] as String;
          final time = transactionData['timestamp'] as Timestamp;
          // final donorName = transactionData['donorName'] as String;
          // final donorPhone = transactionData['donorPhone'] as String;

          return ListView(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  onPageChanged: (index, _) {},
                  scrollDirection: Axis.horizontal,
                ),
                items: images.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(url),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(name),
                subtitle: Text(location),
                trailing: Text(time.toDate().toString()),
              ),
              const Divider(),
              ListTile(
                title: const Text('Donor Information'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Name: $donorName'),
                    // Text('Phone: $donorPhone'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _firestore
                        .collection('transactions')
                        .doc(documentId)
                        .update({'completed': true});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(
                          documentId: documentId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Mark as Completed'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
