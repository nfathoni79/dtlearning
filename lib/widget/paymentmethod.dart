import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/widgets.dart';

class PaymentMethod extends StatelessWidget {
  final String paymenticon, methodname;
  const PaymentMethod(
      {super.key, required this.paymenticon, required this.methodname});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: lightgray,
            blurRadius: 5,
            offset: Offset(0.1, 0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          MySvg(width: 100, height: 100, imagePath: paymenticon),
          const Spacer(),
          MyText(
            color: colorprimaryDark,
            text: methodname,
            maxline: 1,
            fontwaight: FontWeight.w500,
            fontsize: 14,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(
            width: 20,
          ),
          MySvg(width: 15, height: 15, imagePath: "ic_next.svg"),
        ],
      ),
    );
  }
}
