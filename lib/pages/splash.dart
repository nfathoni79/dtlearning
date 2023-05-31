import 'dart:developer';
import 'package:dtlearning/pages/bottombar.dart';
import 'package:dtlearning/pages/intro.dart';
import 'package:dtlearning/provider/generalprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  String? userID;
  SharedPre sharedPre = SharedPre();

  @override
  void initState() {
    final generalsetting = Provider.of<GeneralProvider>(context, listen: false);
    generalsetting.getGeneralsetting(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkFirstSeen();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [uppercolorintro, lowercolorintro])),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MySvg(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    imagePath: "ic_splash.svg",
                  ),
                  const SizedBox(height: 40),
                  MyText(
                    color: white,
                    text: "Learning App",
                    fontsize: 24,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontwaight: FontWeight.w800,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topLeft,
                child: MySvg(
                  width: 200,
                  height: 200,
                  color: colorAccent,
                  imagePath: "ic_corner.svg",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future checkFirstSeen() async {
    final generalsettingData = Provider.of<GeneralProvider>(context);

    if (!generalsettingData.loading) {
      log('generalSettingData status ==> ${generalsettingData.generalSettingModel.status}');
      for (var i = 0;
          i < generalsettingData.generalSettingModel.result!.length;
          i++) {
        await sharedPre.save(
          generalsettingData.generalSettingModel.result![i].key.toString(),
          generalsettingData.generalSettingModel.result![i].value.toString(),
        );
        log('${generalsettingData.generalSettingModel.result![i].key.toString()} ==> ${generalsettingData.generalSettingModel.result![i].value.toString()}');
      }

      String? seen = await sharedPre.read('seen') ?? "";
      Constant.userID = await sharedPre.read('userid') ?? "";
      log('seen ==> $seen');
      log('Constant userID ==> ${Constant.userID}');
      if (!mounted) return;
      // if (Constant.userID != "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return seen == "1" ? const Bottombar() : const Intro();
          },
        ),
      );
    }
  }
}
