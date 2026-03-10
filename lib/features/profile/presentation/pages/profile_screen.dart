import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Donation/presentation/donation_screen.dart';
import 'package:flutter_application_1/features/auth/data/reposrity/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/signout_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    final repository = AuthRepositoryImpl(FirebaseAuth.instance);
    final usecase = SignOutUseCase(repository);

    await usecase();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection("users").doc(userId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            final name = data?["name"] ?? "User";
            final email = data?["email"] ?? "";

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  children: [
                    /// صورة البروفايل
                    Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3E5FC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 90,
                        color: Color(0xFF55B3D9),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// الاسم (ديناميكي)
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2B3C),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// الإيميل (ديناميكي)
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// زر تسجيل الخروج
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF55B3D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => signOut(context),
                        child: const Text(
                          'تسجيل خروج',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// كروت الإعدادات
                    _buildSettingsOption(
                      title: 'مركز المساعدة',
                      icon: Icons.help,
                    ),

                    _buildSettingsOption(
                      title: 'عن التطبيق',
                      icon: Icons.info,
                    ),

                    _buildSettingsOption(
                      title: 'اتبرع لمنطقتك',
                      icon: Icons.account_balance_wallet,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DonationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// كارت الإعدادات
  Widget _buildSettingsOption({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              icon,
              color: Colors.grey,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
