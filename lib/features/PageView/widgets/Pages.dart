import 'package:flutter/material.dart';
import 'package:tariqi/features/PageView/widgets/pagewothimgandtxt.dart';

class PagesView extends StatelessWidget {
  PagesView({super.key});
  List<Pagewithimageandtext> pages = [
    Pagewithimageandtext(
      Imagurl: 'assets/images/Balloons-cuate 1.png',
      txt:
          'تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام.',
    ),
    Pagewithimageandtext(
      Imagurl: 'assets/images/Business merger-pana 1.png',
      txt:
          'تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام.',
    ),
    Pagewithimageandtext(
      Imagurl: 'assets/images/Navigation-pana 1.png',
      txt:
          'تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double w = constraints.maxWidth;
          double h = constraints.maxHeight;
          return Column(
            children: [
              PageView.builder(
                itemBuilder: (context, index) {
                  return pages[index];
                },
                itemCount: pages.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
