import 'package:flutter/material.dart';

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
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Imagurl)),
          ),
        ),
        Text(
          txt,
          style: TextStyle(fontFamily: "Almarai-Regular"),
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
}
