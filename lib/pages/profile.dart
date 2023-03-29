import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thefullbellyproject_app/pages/dashboard.dart';
import 'package:thefullbellyproject_app/pages/donate.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void _pageNav() {
    (_userData['type'] == 'donor')
        ? Navigator.pushNamed(context, DonatePage.id)
        : Navigator.pushNamed(context, DashboardPage.id);
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _handleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'Signed out successfully');
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out');
      print('Error signing out: $e');
    }
  }

  void _handleEditProfilePressed() {
    Navigator.pushNamed(context, EditProfilePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Itim'),
        ),
        actions: [
          IconButton(
              onPressed: () => _handleSignOut(context),
              icon: const Icon(Icons.logout)),
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
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: Image(
                        fit: BoxFit.contain,
                        image: NetworkImage(_userData['photoUrl'] ??
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _userData['name'],
                    style: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _userData['location'],
                    style:
                        const TextStyle(fontFamily: 'Avenir', fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _userData['type'] == 'ngo' ? 'NGO Agent' : 'Donor',
                    style:
                        const TextStyle(fontFamily: 'Avenir', fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                _currentUser.email!,
                style:
                    const TextStyle(fontFamily: 'Product Sans', fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                _userData['phone']!,
                style:
                    const TextStyle(fontFamily: 'Product Sans', fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: _pageNav,
                child: (_userData['type'] == 'donor')
                    ? const Icon(Icons.add)
                    : const Icon(Icons.description),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
