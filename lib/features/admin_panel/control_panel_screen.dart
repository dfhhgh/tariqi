import 'package:flutter/material.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية الأوف وايت عشان الكروت تبرز
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 10),

            // الكارت الأول (فيه زرارين بس: صح وخطأ)
            _buildAdminCard(
              title: 'قيد المراجعة',
              titleColor: const Color(0xFFFFD03A), // اللون الأصفر
              imagePath: 'assets/images/road_image.png',
              showClockButton: false, // مش هنظهر زرار الساعة هنا بناء على صورتك
              onApprove: () {
                // الكود اللي هيتنفذ لما الأدمن يدوس صح
                print('تم قبول البلاغ الأول');
              },
              onReject: () {
                // الكود اللي هيتنفذ لما الأدمن يدوس خطأ
                print('تم رفض البلاغ الأول');
              },
            ),

            const SizedBox(height: 24), // مسافة بين الكروت

            // الكارت التاني (فيه التلات زراير: صح وخطأ وساعة)
            _buildAdminCard(
              title: 'قيد المراجعة',
              titleColor: const Color(0xFFFFD03A),
              imagePath: 'assets/images/road_image.png',
              showClockButton: true, // هنظهر زرار الساعة هنا
              onApprove: () {
                print('تم قبول البلاغ الثاني');
              },
              onReject: () {
                print('تم رفض البلاغ الثاني');
              },
              onPending: () {
                // الكود اللي هيتنفذ لما الأدمن يدوس على الساعة
                print('تم تعليق البلاغ الثاني');
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= Widgets =================

  // 1. الكارت الرئيسي بتاع الأدمن
  Widget _buildAdminCard({
    required String title,
    required Color titleColor,
    required String imagePath,
    required bool showClockButton,
    required VoidCallback onApprove,
    required VoidCallback onReject,
    VoidCallback? onPending,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // عنوان الكارت (حالة البلاغ)
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // صورة البلاغ
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          
          const SizedBox(height: 20),

          // صف الزراير (صح - خطأ - ساعة)
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // توسيط الزراير
            children: [
              // زرار الصح (قبول)
              _buildActionButton(
                icon: Icons.check,
                iconColor: const Color(0xFF4CAF50), // أخضر غامق
                backgroundColor: const Color(0xFFC8E6C9), // أخضر فاتح جداً للخلفية
                onTap: onApprove,
              ),
              
              const SizedBox(width: 16), // مسافة بين الزراير
              
              // زرار الخطأ (رفض)
              _buildActionButton(
                icon: Icons.close,
                iconColor: const Color(0xFFF44336), // أحمر غامق
                backgroundColor: const Color(0xFFFFCDD2), // أحمر فاتح جداً للخلفية
                onTap: onReject,
              ),

              // زرار الساعة (قيد الانتظار) - بيظهر بس لو الكارت محتاجه
              if (showClockButton) ...[
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.access_time_filled, // أيقونة الساعة المصمتة
                  iconColor: const Color(0xFFFFB300), // أصفر غامق
                  backgroundColor: const Color(0xFFFFF9C4), // أصفر فاتح للخلفية
                  onTap: onPending ?? () {},
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // 2. ويدجت زرار الأكشن المخصص (عشان يبان إنه زرار حقيقي)
  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent, // عشان تأثير الضغطة يظهر صح
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8), // نفس درجة دوران المربع
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // حجم الزرار
          decoration: BoxDecoration(
            color: backgroundColor, // لون الخلفية الفاتح
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor, // لون الأيقونة
            size: 28,
          ),
        ),
      ),
    );
  }
}