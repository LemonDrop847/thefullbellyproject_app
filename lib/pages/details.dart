import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback.dart';

class DetailPage extends StatelessWidget {
  static const String id = 'DetailPage';

  final String documentId;

  DetailPage({super.key, required this.documentId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool terms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 100,
      // ),
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
          final donorName = transactionData['donorName'] as String;
          final donorPhone = transactionData['donorPhone'] as String;
          final donorEmail = transactionData['donorEmail'] as String;
          final servings = transactionData['quantity'] as int;

          return Container(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              elevation: 10,
              margin: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
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
                  const Divider(),
                  ListTile(
                    title: Text(
                      'Item: $name',
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: $location',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Servings: $servings',
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    trailing: Column(
                      children: [
                        const Text('Created at: '),
                        Text(time.toDate().toString()),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Donor Information'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person),
                            Text(donorName,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            Text(donorPhone,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.email),
                            Text(donorEmail,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          checkColor: Colors.blue,
                          value: terms,
                          onChanged: (bool? value) {
                            terms = value!;
                          }),
                      const Text('I accept all Terms and Conditions'),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        fixedSize: const Size(300, 50),
                      ),
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
                      child: const Text('Accept Donation'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
