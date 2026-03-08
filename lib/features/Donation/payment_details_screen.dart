import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // استدعاء مكتبة الصور

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
  File? _receiptImage; // المتغير اللي هيحفظ الصورة
  final ImagePicker _picker = ImagePicker();

  // دالة فتح المعرض واختيار الصورة
  Future<void> _pickImage() async {
    // بتفتح المعرض وتطلب الصلاحية أوتوماتيك
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path); // حفظ الصورة المختارة
      });
    }
  }

  // دالة بتجيب تعليمات الدفع حسب الطريقة
  String _getPaymentInstructions() {
    if (widget.methodName == 'إنستاباي') {
      return 'برجاء تحويل المبلغ إلى حساب إنستاباي التالي:\n tareeqi@instapay \nثم قم برفع سكرين شوت لعملية التحويل.';
    } else if (widget.methodName == 'فوري') {
      return 'برجاء الدفع عبر ماكينة فوري على كود الخدمة:\n 74895 \nثم قم بتصوير إيصال الدفع ورفعه هنا.';
    } else {
      return 'برجاء تحويل المبلغ إلى الرقم التالي:\n 01027557693 \nثم قم برفع سكرين شوت لرسالة التأكيد.';
    }
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
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // لوجو طريقة الدفع
              Center(
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.brandColor.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Image.asset(widget.imagePath, height: 60, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // تعليمات الدفع المخصصة
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
                  style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // حقل إدخال المبلغ
              const Text('المبلغ المتبرع به (جنيه)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(hint: 'أدخل المبلغ هنا', icon: Icons.attach_money),
              
              const SizedBox(height: 30),

              // =====================================
              // زرار رفع الإيصال (المعرض)
              // =====================================
              const Text('إيصال الدفع / سكرين شوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickImage, // استدعاء دالة فتح المعرض
                child: Container(
                  width: double.infinity,
                  height: _receiptImage == null ? 120 : 250, // بيكبر لو فيه صورة
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _receiptImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, size: 40, color: widget.brandColor),
                            const SizedBox(height: 10),
                            const Text('اضغط هنا لاختيار صورة الإيصال', style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _receiptImage!, // عرض الصورة اللي اختارها
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // زرار تأكيد الدفع
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.brandColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_receiptImage == null) {
                      // لو داس تأكيد ومرفعش صورة نطلعله تنبيه
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('برجاء إرفاق صورة الإيصال أولاً', style: TextStyle(fontFamily: 'Cairo')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // لو رفع الصورة تمام
                      print('تم تأكيد التبرع وإرفاق الصورة بنجاح');
                      // هنا ممكن نطلعله رسالة نجاح ونرجعه للصفحة الرئيسية
                    }
                  },
                  child: const Text(
                    'تأكيد الدفع',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}