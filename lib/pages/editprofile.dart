import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  static const String id = 'EditProfile';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = '';
  String _location = '';
  String _phone = '';
  String _email = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();
      setState(() {
        _name = snapshot.get('name');
        _location = snapshot.get('location');
        _phone = snapshot.get('phone');
        _email = snapshot.get('email');
      });
      _nameController.text = _name;
      _locationController.text = _location;
      _phoneController.text = _phone;
      _emailController.text = _email;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _updateUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      Map<String, dynamic> dataToUpdate = {};
      if (_nameController.text.isNotEmpty) {
        dataToUpdate['name'] = _nameController.text;
      }
      if (_locationController.text.isNotEmpty) {
        dataToUpdate['location'] = _locationController.text;
      }
      if (_phoneController.text.isNotEmpty) {
        dataToUpdate['phone'] = _phoneController.text;
      }
      if (_emailController.text.isNotEmpty) {
        dataToUpdate['email'] = _emailController.text;
      }
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(dataToUpdate);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        title: Row(
          children: const [
            SizedBox(
              width: 100,
            ),
            Text(
              'Edit Profile',
              style: TextStyle(fontFamily: 'Itim', fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                fixedSize: const Size(300, 50),
              ),
              onPressed: _updateUserData,
              child: const Text(
                'Save Changes',
                style: TextStyle(fontFamily: 'Product Sans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
