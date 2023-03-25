import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signupngo.dart';
import 'signupdonor.dart';

class OnboardingPage extends StatefulWidget {
  static const String id = 'onboarding';
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  late SharedPreferences _prefs;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _saveRolePreference(String role) async {
    await _prefs.setString('user_role', role);
  }

  Future<String?> _getRolePreference() async {
    return _prefs.getString('user_role');
  }

  void _handleRoleSelection(String role) async {
    await _saveRolePreference(role);
    if (role == 'ngo_agent') {
      Navigator.pushNamed(context, SignUpNGOPage.id);
    } else {
      Navigator.pushNamed(context, SignUpDonorPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your role:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleRoleSelection('donor'),
              child: const Text('Donor'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _handleRoleSelection('ngo_agent'),
              child: const Text('NGO Agent'),
            ),
          ],
        ),
      ),
    );
  }
}
