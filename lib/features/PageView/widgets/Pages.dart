import 'package:flutter/material.dart';
import 'package:tariqi/features/PageView/widgets/pagewothimgandtxt.dart';

class PagesView extends StatelessWidget {
  PagesView({super.key});
  List<Pagewithimageandtext> pages = [
    Pagewithimageandtext(
      Imagurl: 'assets/images/Balloons-cuate.png',
      txt:
          'تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام.',
    ),
    Pagewithimageandtext(
      Imagurl: 'assets/images/Businessmerger-pana1.png',
      txt:
          'تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام.',
    ),
    Pagewithimageandtext(
      Imagurl: 'assets/images/Navigation-pana1.png',
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
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(
                        width: w * 0.6,
                        height: w * 0.3,

                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            return pages[index];
                          },
                          itemCount: pages.length,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
