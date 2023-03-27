import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thefullbellyproject_app/pages/dashboard.dart';
import 'package:thefullbellyproject_app/pages/donate.dart';
import 'package:thefullbellyproject_app/pages/editprofile.dart';
import 'package:thefullbellyproject_app/pages/onboarding.dart';
import 'package:thefullbellyproject_app/pages/profile.dart';
import 'package:thefullbellyproject_app/pages/signupngo.dart';
import 'package:thefullbellyproject_app/pages/signupdonor.dart';
import 'package:thefullbellyproject_app/pages/signin.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const OnboardingPage(),
      initialRoute: OnboardingPage.id,
      routes: {
        OnboardingPage.id: (context) => const OnboardingPage(),
        SignUpNGOPage.id: (context) => SignUpNGOPage(),
        SignUpDonorPage.id: (context) => SignUpDonorPage(),
        SignInPage.id: (context) => SignInPage(),
        ProfilePage.id: (context) => ProfilePage(),
        EditProfilePage.id: (context) => EditProfilePage(),
        DonatePage.id: (context) => DonatePage(),
        DashboardPage.id: (context) => DashboardPage(),
      },
    );
  }
}
