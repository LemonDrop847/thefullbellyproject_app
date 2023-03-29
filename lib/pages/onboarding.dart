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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(240.0),
          child: AppBar(
            toolbarHeight: 200,
            title: const Text(
              'Full Belly Project',
              style: TextStyle(
                fontFamily: 'Satisfy',
                color: Colors.black,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(0))),
            elevation: 0,
          ),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              const Text(
                'Join us and help the needy',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'NGO Agent',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => _handleRoleSelection('ngo_agent'),
                        child: Image.asset(
                          'assets/images/delivery.png',
                          scale: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Donor',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => _handleRoleSelection('donor'),
                        child: Image.asset(
                          'assets/images/profile.png',
                          scale: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: InkWell(
            onTap: () => {Navigator.pushNamed(context, SignInPage.id)},
            child: Container(
              color: Colors.amber,
              height: 100,
              width: 100,
              child: const Align(
                child: Text(
                  'I am already a user',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           const SizedBox(
//             height: 100,
//           ),
//           Column(
//             children: [
//               const Text(
//                 'Select your role:',
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: FloatingActionButton(
//                       onPressed: () => _handleRoleSelection('donor'),
//                       child: const Text('Donor'),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: FloatingActionButton(
//                       onPressed: () => _handleRoleSelection('ngo_agent'),
//                       child: const Text('NGO Agent'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 100),
//           TextButton(
//             onPressed: () => {Navigator.pushNamed(context, SignInPage.id)},
//             child: const Text('Already an user? Sign In'),
//           ),
//         ],
//       ),
//     );
//   }
// }
