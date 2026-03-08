import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Report/presentation/Reportinfo.dart';

class PhotoConfirmScreen extends StatelessWidget {
  final String imagePath;

  const PhotoConfirmScreen({super.key, required this.imagePath});

  static const Color primaryColor = Color(0xFF53B4E7);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return SafeArea(
              child: Column(
                children: [
                  // ── العنوان ────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06,
                      vertical: h * 0.025,
                    ),
                    child: Text(
                      'هل الصورة مناسبة؟',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Text(
                    'تأكد من وضوح المشكلة في الصورة قبل المتابعة',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: w * 0.037,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.04),

                  // ── الصورة في المنتصف ──────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.05),
                        child: Image.file(
                          File(imagePath),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.045),

                  // ── الزران ────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: Row(
                      children: [
                        // زر الرجوع — أحمر
                        Expanded(
                          child: _ActionButton(
                            label: 'إعادة التصوير',
                            icon: Icons.replay_rounded,
                            color: const Color(0xFFE53935),
                            w: w,
                            h: h,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),

                        SizedBox(width: w * 0.04),

                        // زر المتابعة — أخضر
                        Expanded(
                          child: _ActionButton(
                            label: 'متابعة',
                            icon: Icons.check_circle_rounded,
                            color: const Color(0xFF43A047),
                            w: w,
                            h: h,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProblemInfoScreen(imagePath: imagePath),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── زر الإجراء ───────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double w;
  final double h;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.w,
    required this.h,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h * 0.075,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: w * 0.055),
            SizedBox(width: w * 0.02),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.042,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
