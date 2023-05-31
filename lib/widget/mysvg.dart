import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MySvg extends StatelessWidget {
  double width;
  double height;
  String imagePath;
  Color? color;

  MySvg(
      {Key? key,
      required this.width,
      required this.height,
      required this.imagePath,
      this.color,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/$imagePath",
      width: width,
      height: height,
      allowDrawingOutsideViewBox: true,
      color: color,
    );
  }
}
