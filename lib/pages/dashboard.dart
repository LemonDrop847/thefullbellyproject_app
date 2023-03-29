import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thefullbellyproject_app/pages/profile.dart';

import 'details.dart';

class DashboardPage extends StatefulWidget {
  static const String id = 'Dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Dashboard',
          style: TextStyle(fontFamily: 'Itim', fontSize: 20),
        )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('transactions')
            .where('completed', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final name = document['name'];
              final location = document['location'];
              final donorName = document['donorName'];
              final quantity = document['quantity'].toString();
              final docId = document.id;
              final image = document['imageUrls'][0].toString();
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Container(
                        height: 200,
                        width: 100,
                        margin: const EdgeInsets.all(10),
                        child: Image(
                          image: NetworkImage(image),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Donor: $donorName',
                            style: const TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Details: ",
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Item: $name',
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Location: $location',
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Servings: $quantity',
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  // trailing: Text(time.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          documentId: docId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () => Navigator.pushNamed(context, ProfilePage.id),
                child: const Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
