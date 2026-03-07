import 'package:flutter/material.dart';
import 'package:tariqi/features/auth/presentation/pages/login_page.dart';

/// صفحة إنشاء حساب جديد
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  // ألوان ثابتة مستخرجة من التصميم
  static const Color primaryColor = Color(0xFF53B4E7);
  static const Color backgroundColor = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // شريط العنوان وزر الرجوع (مع اتجاه LTR للحفاظ على مكان السهم)
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'تسجيل',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // حقل الاسم الكامل
              _buildTextField(
                hintText: 'الاسم الكامل',
                prefixIcon: Icons.person_outline,
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              // حقل البريد الإلكتروني
              _buildTextField(
                hintText: 'البريد الالكتروني',
                prefixIcon: Icons.email_outlined,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور
              _buildTextField(
                hintText: 'كلمة المرور',
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility_off_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 20), // مسافة بين الحقلين
              // حقل تأكيد كلمة المرور
              _buildTextField(
                hintText: 'تأكيد كلمة المرور',
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility_off_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // زر التسجيل الأساسي
              ElevatedButton(
                onPressed: () {
                  // TODO: تنفيذ منطق التسجيل
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: primaryColor.withOpacity(0.5),
                ),
                child: const Text(
                  'تسجيل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),

              // رابط تسجيل الدخول للمستخدمين الحاليين
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'لديك حساب؟',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// دالة مساعدة لبناء حقول الإدخال بشكل موحد
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool obscureText = false,
    TextInputType textInputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl, // ضمان اتجاه النص من اليمين
        child: TextField(
          obscureText: obscureText,
          keyboardType: textInputType,
          maxLines: 1,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey.shade500)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }
}
