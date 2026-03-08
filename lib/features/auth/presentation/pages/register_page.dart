import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/data/reposrity/auth_repository_impl.dart';

/// صفحة إنشاء حساب جديد
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const Color primaryColor = Color(0xFF53B4E7);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final registerUseCase = RegisterUseCase(
    AuthRepositoryImpl(FirebaseAuth.instance),
  );
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await registerUseCase(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إنشاء الحساب بنجاح"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ";

      if (e.code == 'email-already-in-use') {
        message = "البريد مستخدم بالفعل";
      } else if (e.code == 'weak-password') {
        message = "كلمة المرور ضعيفة";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegisterScreen.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ────────────────────────────────────────────
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: RegisterScreen.primaryColor,
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

                // ── الاسم الكامل ──────────────────────────────────────
                _buildTextField(
                  controller: _nameController,
                  hintText: 'الاسم الكامل',
                  prefixIcon: Icons.person_outline,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الاسم الكامل مطلوب';
                    }
                    if (value.trim().length < 3) {
                      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                    }
                    if (value.trim().length > 50) {
                      return 'الاسم طويل جداً';
                    }
                    final nameRegex = RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$');
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'الاسم يجب أن يحتوي على أحرف فقط';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── البريد الإلكتروني ─────────────────────────────────
                _buildTextField(
                  controller: _emailController,
                  hintText: 'البريد الالكتروني',
                  prefixIcon: Icons.email_outlined,
                  textInputType: TextInputType.emailAddress,
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

                // ── كلمة المرور ───────────────────────────────────────
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'كلمة المرور',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
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
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'يجب أن تحتوي على حرف كبير واحد على الأقل';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'يجب أن تحتوي على رقم واحد على الأقل';
                    }
                    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'يجب أن تحتوي على رمز خاص واحد على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── تأكيد كلمة المرور ─────────────────────────────────
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'تأكيد كلمة المرور',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixWidget: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'تأكيد كلمة المرور مطلوب';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ── زر التسجيل ────────────────────────────────────────
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: تنفيذ منطق التسجيل
                    }
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
                    'تسجيل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),

                // ── رابط تسجيل الدخول ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 16,
                          color: RegisterScreen.primaryColor,
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixWidget,
    bool obscureText = false,
    TextInputType textInputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        maxLines: 1,
        textAlign: TextAlign.right,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
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
            borderSide: const BorderSide(
                color: RegisterScreen.primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}
