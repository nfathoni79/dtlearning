import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  final String? startImg, endImg, text;
  final Color? endImgcolor, startImgcolor;
  final Color? textcolor;
  final dynamic endimgTap;
  final dynamic backTap;

  // type Pass Compalsarry
  // Only Enter type 0 and 1
  // type 0 Means Only show Text and End Image
  // type 1 Means Show startImage,Text,EndImage
  final int type;

  const MyAppbar(
      {super.key,
      this.startImg,
      this.endImg,
      this.backTap,
      this.text,
      this.endImgcolor,
      this.startImgcolor,
      this.textcolor,
      required this.type,
      this.endimgTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        type == 1
            ? InkWell(
                focusColor: colorprimaryDark,
                highlightColor: colorprimaryDark,
                hoverColor: colorprimaryDark,
                onTap: backTap,
                // () {
                //   Navigator.of(context).pop(false);
                // },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: MySvg(
                    width: 15,
                    height: 15,
                    imagePath: startImg ?? "",
                    color: startImgcolor ?? black,
                  ),
                ),
              )
            : Container(),
        type == 1 ? const Spacer() : Container(),
        MyText(
            color: textcolor ?? black,
            text: text ?? "",
            maxline: 1,
            fontwaight: FontWeight.w500,
            fontsize: 16,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
        type == 0 ? const Spacer() : const Spacer(),
        InkWell(
          onTap: endimgTap,
          child: Container(
            width: 25,
            height: 40,
            alignment: Alignment.centerRight,
            child: MySvg(
              width: 20,
              height: 20,
              imagePath: endImg ?? "",
              color: endImgcolor ?? black,
            ),
          ),
        ),
      ],
    );
  }
}
