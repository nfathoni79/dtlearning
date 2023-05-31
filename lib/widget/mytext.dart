// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String text;
  double? fontsize;
  var maxline, fontstyle, fontwaight, textalign;
  Color color;
  TextDecoration? decoration;
  var overflow;

  MyText(
      {Key? key,
      required this.color,
      required this.text,
      this.fontsize,
      this.maxline,
      this.decoration,
      this.overflow,
      required this.textalign,
      this.fontwaight,
      required this.fontstyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textalign,
      overflow: overflow,
      maxLines: maxline,
      style: GoogleFonts.montserrat(
          fontSize: fontsize,
          fontStyle: fontstyle,
          decoration: decoration,
          color: color,
          fontWeight: fontwaight),
    );
  }
}
