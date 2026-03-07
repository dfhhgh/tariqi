import 'package:flutter/material.dart';
import 'package:tariqi/features/auth/presentation/pages/register_page.dart';
import 'package:tariqi/features/auth/presentation/pages/reset_password_page_2.dart';

/// صفحة إنشاء حساب جديد
class ResetScreen_1 extends StatelessWidget {
  const ResetScreen_1({super.key});

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
              // شريط العنوان وزر الرجوع
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
                      'إعادة تعيين كلمة المرور',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // نص توضيحي
              Text(
                "أدخل رمز التحقق الذي تم إرساله إلى\nبريدك الإلكتروني لإعادة تعيين كلمة المرور",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),

              // حقل البريد الإلكتروني
              _buildTextField(
                hintText: 'أدخل الكود',
                prefixIcon: Icons.email_outlined,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور

              // حقل تأكيد كلمة المرور

              // زر التسجيل
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ResetScreen_2(), // الشاشة الجديدة
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: RegisterScreen.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: RegisterScreen.primaryColor.withOpacity(0.5),
                ),
                child: const Text(
                  'إرسال',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),

              // رابط تسجيل الدخول (فارغ حسب طلبك)
              Row(mainAxisAlignment: MainAxisAlignment.center),
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
        textDirection: TextDirection.rtl,
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
