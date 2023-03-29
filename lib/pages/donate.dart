import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonatePage extends StatefulWidget {
  static const String id = 'Donate';

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _picker = ImagePicker();
  final List<File> _imageFiles = [];
  final List<String> _imageUrls = [];

  Future<void> _uploadImages() async {
    for (var imageFile in _imageFiles) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('donation_images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _imageUrls.add(downloadUrl);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _uploadImages();

      // Retrieve the currently signed-in user's information
      final User? user = FirebaseAuth.instance.currentUser;
      final DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // Save the donor's information
      FirebaseFirestore.instance.collection('transactions').add({
        'name': _nameController.text,
        'description': _descController.text,
        'quantity': _quantityController.text,
        'location': _locationController.text,
        'imageUrls': _imageUrls,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
        'donorName': userData['name'],
        'donorEmail': userData['email'],
        'donorPhone': userData['phone'],
      });

      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
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
              'Donate',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 4,
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Servings',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of Servings';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Pickup Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Pickup Location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  fixedSize: const Size(300, 50),
                ),
                child: const Text('Choose Images'),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: [
                  ..._imageFiles.map((imageFile) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(imageFile),
                    );
                  }),
                  ..._imageUrls.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(imageUrl),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  fixedSize: const Size(300, 50),
                ),
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
