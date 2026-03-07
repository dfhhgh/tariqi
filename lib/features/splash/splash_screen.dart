import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateNext();
  }

  void navigateNext() async {
    // ننتظر 3 ثواني
    await Future.delayed(const Duration(seconds: 3));

    // نتحقق إذا كانت أول مرة
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool("first_time") ?? true;

    if (isFirstTime) {
      await prefs.setBool("first_time", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/splash.svg',
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
