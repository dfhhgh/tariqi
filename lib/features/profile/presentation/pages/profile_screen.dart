import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Donation/donation_screen.dart';
import 'package:flutter_application_1/features/auth/data/reposrity/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/signout_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';

// ⚠️ متنساش تعدل المسار ده على حسب مكان شاشة التبرع عندك
// import 'مسار_شاشة_التبرع/donation_screen.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // لون خلفية مريح للعين
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                // 1. صورة البروفايل
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(
                        0xFFB3E5FC), // لون الدائرة الأزرق الفاتح اللي في الديزاين
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 90,
                    color: Color(0xFF55B3D9), // لون الأيقونة
                  ),
                ),
                const SizedBox(height: 20),

                // 2. الاسم والإيميل
                const Text(
                  'عمر مدني',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2B3C), // كحلي غامق
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'omar@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // 3. زرار تسجيل خروج
                SizedBox(
                  width: 220, // عرض الزرار
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF55B3D9), // درجة الأزرق بتاعت الديزاين
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // حواف دائرية
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

                // 4. كروت الخيارات
                _buildSettingsOption(
                  title: 'مركز المساعدة',
                  icon: Icons.help,
                ),
                _buildSettingsOption(
                  title: 'عن التطبيق',
                  icon: Icons.info,
                ),

                // ==========================================
                // ✨ التعديل هنا: ضفنا أمر الانتقال لشاشة التبرع
                // ==========================================
                _buildSettingsOption(
                  title: 'اتبرع لمنطقتك',
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    // بينقلك لشاشة الدفع
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DonationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= Widgets =================

  // ويدجت الكارت بتاع الإعدادات (ضفنا ليها onTap بس عشان تدعم الضغط من غير ما نغير شكلها)
  Widget _buildSettingsOption(
      {required String title, required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap, // خليناها تقبل الضغط
      borderRadius: BorderRadius.circular(
          15), // عشان تأثير الضغطة (Ripple) يبقى ماشي مع حواف المربع
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // عشان نجيب المحتوى يمين (RTL)
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
              color: Colors.grey.shade600, // لون الأيقونات الرمادي زي الديزاين
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
