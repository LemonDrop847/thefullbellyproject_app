import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  static const String id = 'Feedback';
  final String documentId;

  FeedbackPage({super.key, required this.documentId});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      final ref = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      final task = ref.putFile(File(pickedFile.path));
      task.snapshotEvents.listen((event) {
        final progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        print('Upload progress: $progress');
      });
      final snapshot = await task.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrls.add(url);
        _isUploading = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isUploading = true;
    });
    final docRef = _firestore.collection('transactions').doc(widget.documentId);
    await docRef.update({
      'completed': true,
      'description': _descriptionController.text,
      'feedbackimageUrls': _imageUrls,
    });
    setState(() {
      _isUploading = false;
    });
    Navigator.popUntil(context, ModalRoute.withName('Dashboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _uploadImage,
                      child: _isUploading
                          ? const CircularProgressIndicator()
                          : const Text('Upload Image'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submit,
                      child: _isUploading
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
            if (_imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = _imageUrls[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(imageUrl),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
