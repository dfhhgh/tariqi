import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Pagewithimageandtext extends StatelessWidget {
  const Pagewithimageandtext({
    super.key,
    required this.Imagurl,
    required this.txt,
  });
  final String Imagurl;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset(Imagurl)),

        Text(
          txt,
          style: TextStyle(fontFamily: "Almarai-Regular", fontSize: 16.sp),
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
}
