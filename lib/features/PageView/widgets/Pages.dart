import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tariqi/core/them_light/App_color_light.dart';
import 'package:tariqi/features/PageView/widgets/pagewothimgandtxt.dart';

class PagesView extends StatefulWidget {
  PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  PageController controller = PageController();
  int currentPage = 0;

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
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page?.round() ?? 0; // ← تحديث عند التغيير
      });
    });
  }

  @override
  void dispose() {
    controller.dispose(); // ← مهم لتجنب memory leak
    super.dispose();
  }

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
                spacing: h * 0.06,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(
                        width: w * 0.9, // ← زد العرض
                        height: h * 0.7,

                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            return pages[index];
                          },
                          controller: controller,
                          itemCount: pages.length,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: w * 0.15,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        onTap: () {
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: w * 0.15,
                          height: w * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorsLight.accent,
                          ),
                          child: Icon(
                            Icons.arrow_back_sharp,
                            color: AppColorsLight.background,
                            size: w * 0.07,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "تخطي",
                          style: TextStyle(
                            fontFamily: "Almarai-ExtraBold",
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: currentPage > 0,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(100)),

                          onTap: () {
                            controller.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: w * 0.15,
                            height: w * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColorsLight.accent,
                            ),
                            child: Icon(
                              Icons.arrow_forward_sharp,
                              color: AppColorsLight.background,
                              size: w * 0.07,
                            ),
                          ),
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
