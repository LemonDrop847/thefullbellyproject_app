import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signupngo.dart';
import 'signupdonor.dart';
import 'signin.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 100,
          ),
          Column(
            children: [
              const Text(
                'Select your role:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: FloatingActionButton(
                      onPressed: () => _handleRoleSelection('donor'),
                      child: const Text('Donor'),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: FloatingActionButton(
                      onPressed: () => _handleRoleSelection('ngo_agent'),
                      child: const Text('NGO Agent'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 100),
          TextButton(
            onPressed: () => {Navigator.pushNamed(context, SignInPage.id)},
            child: const Text('Already an user? Sign In'),
          ),
        ],
      ),
    );
  }
}
