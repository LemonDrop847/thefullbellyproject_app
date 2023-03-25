import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editprofile.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'Profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late User _currentUser;
  late Map<String, dynamic> _userData;

  void _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    setState(() {
      _currentUser = user!;
      _userData = userData.data()!;
      print(_userData);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _handleEditProfilePressed() {
    Navigator.pushNamed(context, EditProfilePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEditProfilePressed,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(_userData['photoUrl'] ??
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              _userData['name'],
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              _userData['location'],
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              _userData['type'] == 'ngo' ? 'NGO Agent' : 'Donor',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(_currentUser.email!),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(_userData['phone']!),
            ),
          ],
        ),
      ),
    );
  }
}
