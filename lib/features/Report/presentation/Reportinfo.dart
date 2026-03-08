import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Report/data/reposrity/report_repository_impl.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';
import 'package:flutter_application_1/features/Report/domain/usecases/submit_report_usecase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProblemInfoScreen extends StatefulWidget {
  final String? imagePath;

  const ProblemInfoScreen({super.key, this.imagePath});

  @override
  State<ProblemInfoScreen> createState() => _ProblemInfoScreenState();
}

class _ProblemInfoScreenState extends State<ProblemInfoScreen> {
  static const Color primaryColor = Color(0xFF53B4E7);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  final _formKey = GlobalKey<FormState>();

  final _governorateController = TextEditingController();
  final _coordinatesController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _detailsController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingLocation = false;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cloudinary = CloudinaryService();

      String imageUrl = "";

      /// رفع صورة البلاغ إلى Cloudinary
      if (widget.imagePath != null) {
        imageUrl = await cloudinary.uploadImage(
          File(widget.imagePath!),
          preset: cloudinary.reportsPreset,
        );
      }

      /// الحصول على المستخدم
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showErrorSnack("يجب تسجيل الدخول أولاً");
        return;
      }

      final userId = user.uid;

      /// حفظ البلاغ في Firestore
      await FirebaseFirestore.instance.collection("reports").add({
        "userId": userId,
        "governorate": _governorateController.text.trim(),
        "coordinates": _coordinatesController.text.trim(),
        "city": _cityController.text.trim(),
        "street": _streetController.text.trim(),
        "details": _detailsController.text.trim(),
        "image": imageUrl,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال البلاغ بنجاح"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print("ERROR: $e");

      if (!mounted) return;

      _showErrorSnack("خطأ: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _governorateController.dispose();
    _coordinatesController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _dateTimeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // ── جلب الموقع الجغرافي تلقائياً ─────────────────────────────────────────
  Future<void> _fetchLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnack('تم رفض صلاحية الوصول للموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnack('صلاحية الموقع محظورة، يرجى تفعيلها من الإعدادات');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _coordinatesController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      _showErrorSnack('تعذّر الحصول على الموقع، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  // ── اختيار التاريخ والوقت ─────────────────────────────────────────────────
  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColor),
        ),
        child: child!,
      ),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColor),
        ),
        child: child!,
      ),
    );

    if (pickedTime == null || !mounted) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _dateTimeController.text =
          DateFormat('yyyy/MM/dd - hh:mm a').format(combined);
    });
  }

  void _showErrorSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'معلومات المشكلة',
                          style: TextStyle(
                            fontSize: w * 0.062,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: w * 0.12,
                            height: w * 0.12,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: w * 0.055,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.03),

                    // ── صورة المشكلة ────────────────────────────────
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        child: widget.imagePath != null
                            ? Image.file(
                                File(widget.imagePath!),
                                width: w * 0.7,
                                height: h * 0.22,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://via.placeholder.com/400x200',
                                width: w * 0.7,
                                height: h * 0.22,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    SizedBox(height: h * 0.035),

                    // ── المحافظة ────────────────────────────────────
                    _buildField(
                      controller: _governorateController,
                      hint: 'المحافظة',
                      w: w,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'المحافظة مطلوبة'
                          : null,
                    ),
                    SizedBox(height: h * 0.018),

                    // ── الإحداثيات ───────────────────────────────────
                    _buildField(
                      controller: _coordinatesController,
                      hint: 'الإحداثيات',
                      w: w,
                      readOnly: true,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الإحداثيات مطلوبة'
                          : null,
                      prefixButton: _isLoadingLocation
                          ? SizedBox(
                              width: w * 0.05,
                              height: w * 0.05,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor,
                              ),
                            )
                          : GestureDetector(
                              onTap: _fetchLocation,
                              child: Icon(
                                Icons.my_location_rounded,
                                color: primaryColor,
                                size: w * 0.055,
                              ),
                            ),
                    ),
                    SizedBox(height: h * 0.018),

                    // ── المدينة ──────────────────────────────────────
                    _buildField(
                      controller: _cityController,
                      hint: 'المدينة',
                      w: w,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'المدينة مطلوبة'
                          : null,
                    ),
                    SizedBox(height: h * 0.018),

                    // ── اسم الشارع ───────────────────────────────────
                    _buildField(
                      controller: _streetController,
                      hint: 'اسم الشارع',
                      w: w,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'اسم الشارع مطلوب'
                          : null,
                    ),
                    SizedBox(height: h * 0.018),

                    // ── التاريخ والوقت ───────────────────────────────
                    _buildField(
                      controller: _dateTimeController,
                      hint: 'التاريخ والوقت',
                      w: w,
                      readOnly: true,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'التاريخ والوقت مطلوبان'
                          : null,
                      prefixButton: GestureDetector(
                        onTap: _pickDateTime,
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: primaryColor,
                          size: w * 0.055,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.018),

                    // ── تفاصيل إضافية ────────────────────────────────
                    _buildField(
                      controller: _detailsController,
                      hint: 'تفاصيل إضافية',
                      w: w,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'هذا الحقل مطلوب'
                          : null,
                    ),

                    SizedBox(height: h * 0.045),

                    // ── زر الإرسال ───────────────────────────────────
                    SizedBox(
                      height: h * 0.075,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              primaryColor.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.04),
                          ),
                          elevation: 0,
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
                            : Text(
                                'إرسال',
                                style: TextStyle(
                                  fontSize: w * 0.052,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required double w,
    bool readOnly = false,
    TextInputType? keyboardType,
    Widget? prefixButton,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      readOnly: readOnly,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: w * 0.04,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixButton != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: prefixButton,
              )
            : null,
        prefixIconConstraints: BoxConstraints(
          minWidth: w * 0.13,
          minHeight: 0,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: w * 0.045,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
    );
  }
}
