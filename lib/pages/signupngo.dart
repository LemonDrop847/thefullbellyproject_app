import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';

class SignUpNGOPage extends StatefulWidget {
  static const String id = 'signUpNgo';
  @override
  SignUpNGOPageState createState() => SignUpNGOPageState();
}

class SignUpNGOPageState extends State<SignUpNGOPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'type': 'ngo',
      });
      await FirebaseFirestore.instance.collection('ngos').doc(user.uid).set({
        'user': userCredential.user!.uid,
        'compWorks': [],
      });
      _handleSignUpSuccess();
    } catch (e) {
      print(e);
    }
  }

  void _handleSignUp() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'location': _locationController.text,
        'phone': _phoneController.text,
        'type': 'ngo',
      });
      await FirebaseFirestore.instance
          .collection('ngos')
          .doc(userCredential.user!.uid)
          .set({
        'user': userCredential.user!.uid,
        'compWorks': [],
      });
      _handleSignUpSuccess();
    } catch (e) {
      print(e);
    }
  }

  void _handleSignUpSuccess() {
    Navigator.pushNamed(context, ProfilePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Sign Up as a NGO Agent'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name of NGO',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
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
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: _handleSignUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Or Sign Up With: '),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 226, 225, 225),
                          elevation: 0.5,
                          onPressed: _handleGoogleSignIn,
                          child: Image.asset('assets/images/googlelogo.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
