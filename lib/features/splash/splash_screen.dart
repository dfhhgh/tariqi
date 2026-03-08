import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/admin_main_screen.dart';
import 'package:flutter_application_1/features/admin/control_panel_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/home/pages/home_screen.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_page.dart';
import 'package:flutter_application_1/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    _navigate();
  }

  Future<void> _navigate() async {
    /// انتظار ظهور splash
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    /// أول مرة
    bool isFirstTime = prefs.getBool("first_time") ?? true;

    if (isFirstTime) {
      await prefs.setBool("first_time", false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
        ),
      );

      return;
    }

    /// هل المستخدم مسجل دخول
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );

      return;
    }

    try {
      /// قراءة role
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final role = doc.data()?["role"] ?? "user";

      print("USER UID: ${user.uid}");
      print("ROLE: $role");

      /// ADMIN
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminMainScreen(),
          ),
        );
      } else {
        /// USER
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      }
    } catch (e) {
      /// fallback لو حدث خطأ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
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
