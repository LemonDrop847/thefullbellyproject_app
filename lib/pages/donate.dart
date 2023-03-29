import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      FirebaseFirestore.instance.collection('transactions').add({
        'name': _nameController.text,
        'quantity': _quantityController.text,
        'location': _locationController.text,
        'imageUrls': _imageUrls,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
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
        title: const Text('Donate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 4,
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
                decoration: const InputDecoration(
                  labelText: 'Servings',
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
                decoration: const InputDecoration(
                  labelText: 'Pickup Location',
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
