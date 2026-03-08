import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/services/cloudinary_service.dart';
import 'package:flutter_application_1/features/Donation/data/reposity/donation_repository_impl.dart';
import 'package:flutter_application_1/features/Donation/domain/entities/donation_entity.dart';
import 'package:flutter_application_1/features/Donation/domain/usecases/submit_donation_usecase.dart';

import 'package:image_picker/image_picker.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final String imagePath;
  final String methodName;
  final Color brandColor;

  const PaymentDetailsScreen({
    super.key,
    required this.imagePath,
    required this.methodName,
    required this.brandColor,
  });

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _receiptImage;

  final TextEditingController _amountController = TextEditingController();

  /// اختيار صورة الإيصال
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  /// تعليمات الدفع
  String _getPaymentInstructions() {
    if (widget.methodName == 'إنستاباي') {
      return 'برجاء تحويل المبلغ إلى حساب إنستاباي التالي:\n'
          'tareeqi@instapay\n'
          'ثم قم برفع سكرين شوت لعملية التحويل.';
    }

    if (widget.methodName == 'فوري') {
      return 'برجاء الدفع عبر ماكينة فوري على كود الخدمة:\n'
          '74895\n'
          'ثم قم بتصوير إيصال الدفع ورفعه هنا.';
    }

    return 'برجاء تحويل المبلغ إلى الرقم التالي:\n'
        '01027557693\n'
        'ثم قم برفع سكرين شوت لرسالة التأكيد.';
  }

  /// إرسال التبرع
  Future<void> _confirmPayment() async {
    final amount = _amountController.text.trim();

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("أدخل المبلغ")),
      );
      return;
    }

    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ارفع صورة الإيصال")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("المستخدم غير مسجل الدخول");
      }

      final repository = DonationRepositoryImpl(
        firestore: FirebaseFirestore.instance,
        cloudinary: CloudinaryService(),
      );

      final usecase = SubmitDonationUseCase(repository);

      final donation = DonationEntity(
        userId: user.uid,
        method: widget.methodName,
        amount: amount,
        receiptImage: _receiptImage!.path,
        createdAt: DateTime.now(),
      );

      await usecase(donation);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال التبرع بنجاح"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حدث خطأ أثناء إرسال التبرع"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'الدفع عبر ${widget.methodName}',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LOGO
              Center(
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.brandColor.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 60,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// INSTRUCTIONS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  _getPaymentInstructions(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// AMOUNT
              const Text(
                'المبلغ المتبرع به (جنيه)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildTextField(),

              const SizedBox(height: 30),

              /// RECEIPT IMAGE
              const Text(
                'إيصال الدفع / سكرين شوت',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: _receiptImage == null ? 120 : 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _receiptImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: widget.brandColor,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'اضغط هنا لاختيار صورة الإيصال',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _receiptImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              /// CONFIRM BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.brandColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _confirmPayment,
                  child: const Text(
                    'تأكيد الدفع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'أدخل المبلغ هنا',
          prefixIcon: Icon(Icons.attach_money),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
