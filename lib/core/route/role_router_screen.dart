import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/admin/control_panel_screen.dart';
import 'package:flutter_application_1/features/home/pages/home_screen.dart';
import 'package:flutter_application_1/main.dart';

class RoleRouterScreen extends StatelessWidget {
  const RoleRouterScreen({super.key});

  Future<String> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return "user";
    }

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    return doc.data()?["role"] ?? "user";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;

        /// ADMIN
        if (role == "admin") {
          return const ControlPanelScreen();
        }

        /// USER
        return const MainScreen();
      },
    );
  }
}
