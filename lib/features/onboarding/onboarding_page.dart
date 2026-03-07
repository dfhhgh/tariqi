import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:svg_flutter/svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/icons/Onboarding_1.svg",
      "text":
          "تطبيق طريقي منصة مصرية ذكية لتعزيز أمن وسلامة الطرق، تهدف إلى رصد وتطوير البنية التحتية باستخدام تقنيات متطورة لضمان تنقل آمن ومستدام",
    },
    {
      "image": "assets/icons/Onboarding_2.svg",
      "text":
          "يعد تطبيق طريقي المنصة الذكية الأبرز لتعزيز سلامة الطرق، حيث يمكن المواطنين من الإسهام الفعال في صيانة الشوارع وتطويرها مباشرة عبر هواتفهم الذكية، من خلال رصد التلفيات وإرسال البلاغات ومتابعة مراحل الإصلاح حتى اكتمالها. كما يوفر نظام متابعة لحظي يعرض تطورات البلاغ ونتائجه النهائية، بما يضمن تطبيق أعلى معايير الجودة والسلامة في شوارع الجمهورية وفق أحدث التقنيات العالمية ",
    },
    {
      "image": "assets/icons/Onboarding_3.svg",
      "text":
          "وبذلك يسهم التطبيق في بناء منظومة طرق أكثر أمانًا واستدامة ويعزز الشراكة الفعالة بين المواطن والجهات المختصة لخدمة الوطن ودعم مسيرة التنمية",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(pages[index]["image"]!, width: 280),

                    const SizedBox(height: 40),

                    Text(
                      pages[index]["text"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (currentIndex == pages.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF4EB3E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
