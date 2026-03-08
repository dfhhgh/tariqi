import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/reposrity/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/role_gate.dart';
import 'package:flutter_application_1/features/home/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/splash/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // ⚠️ يفضل استخدام Dependency Injection (مثل get_it) بدل هذا
  final loginUseCase = LoginUseCase(
    AuthRepositoryImpl(FirebaseAuth.instance),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. التحقق من صحة الحقول أولاً
    if (!_formKey.currentState!.validate()) return;

    // 2. تفعيل حالة التحميل
    setState(() => _isLoading = true);

    try {
      await loginUseCase(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 3. التأكد من أن الـ widget لا يزال موجوداً بعد العملية الـ async
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const RoleGate(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // 4. تمييز أنواع الأخطاء وإظهار رسائل واضحة للمستخدم
      final msg = switch (e.code) {
        'user-not-found' => 'البريد الإلكتروني غير مسجل',
        'wrong-password' => 'كلمة المرور غير صحيحة',
        'invalid-email' => 'صيغة البريد الإلكتروني غير صحيحة',
        'user-disabled' => 'هذا الحساب موقوف، تواصل مع الدعم',
        'too-many-requests' => 'تم تجاوز عدد المحاولات، حاول لاحقاً',
        'network-request-failed' => 'تحقق من اتصالك بالإنترنت',
        _ => 'حدث خطأ غير متوقع، حاول مرة أخرى',
      };

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, textDirection: TextDirection.rtl),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      // 5. إيقاف حالة التحميل دائماً سواء نجحت العملية أو فشلت
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF53B4E7);
    const backgroundColor = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ────────────────────────────────────────────
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: const [
                        SizedBox(width: 20),
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── Email field ───────────────────────────────────────
                  _buildTextField(
                    controller: _emailController,
                    hint: 'البريد الإلكتروني',
                    icon: Icons.email_outlined,
                    primaryColor: primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'البريد الإلكتروني مطلوب';
                      }
                      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'صيغة البريد الإلكتروني غير صحيحة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Password field ────────────────────────────────────
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'كلمة المرور',
                    icon: Icons.lock_outline,
                    obscure: _obscurePassword,
                    primaryColor: primaryColor,
                    suffixWidget: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمة المرور مطلوبة';
                      }
                      if (value.length < 8) {
                        return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Forgot password ───────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetScreen(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'هل نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Login button ──────────────────────────────────────
                  ElevatedButton(
                    // تعطيل الزر أثناء التحميل لمنع الضغط المتكرر
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1.5,
                      shadowColor: primaryColor.withOpacity(0.4),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // ── Register link ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟  ',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: const Text(
                          'سجل الآن',
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Widget? suffixWidget,
    bool obscure = false,
    required Color primaryColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        suffixIcon: suffixWidget,
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
          borderSide: BorderSide(color: primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }
}
