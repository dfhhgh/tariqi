import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Donation/presentation/payment_details_screen.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                /// HEADER
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF55B3E6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'اتبرع لمنطقتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// LIST OF PAYMENT METHODS
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildPaymentCard(
                        context: context,
                        imagePath: 'assets/images/vodafone.png',
                        methodName: 'فودافون كاش',
                        brandColor: const Color(0xFFE60000),
                      ),
                      _buildPaymentCard(
                        context: context,
                        imagePath: 'assets/images/etisalat.png',
                        methodName: 'اتصالات كاش',
                        brandColor: const Color(0xFF006A4D),
                      ),
                      _buildPaymentCard(
                        context: context,
                        imagePath: 'assets/images/fawry.png',
                        methodName: 'فوري',
                        brandColor: const Color(0xFFFCCC0A),
                      ),
                      _buildPaymentCard(
                        context: context,
                        imagePath: 'assets/images/instapay.png',
                        methodName: 'إنستاباي',
                        brandColor: const Color(0xFF711A75),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// PAYMENT CARD
  Widget _buildPaymentCard({
    required BuildContext context,
    required String imagePath,
    required String methodName,
    required Color brandColor,
  }) {
    return InkWell(
      onTap: () {
        /// الانتقال لشاشة إدخال المبلغ

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentDetailsScreen(
              imagePath: imagePath,
              methodName: methodName,
              brandColor: brandColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFBCE0F3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
