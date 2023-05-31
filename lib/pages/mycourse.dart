import 'dart:developer';

import 'package:dtlearning/pages/cart.dart';
import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/mycourseprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MyCourse extends StatefulWidget {
  const MyCourse({Key? key}) : super(key: key);

  @override
  State<MyCourse> createState() => MyCourseState();
}

class MyCourseState extends State<MyCourse> {
  Constant constant = Constant();
  double? width;
  double? height;
  SharedPre sharedpre = SharedPre();
  String? userid, currencycode;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    userid = await sharedpre.read("userid") ?? "";
    currencycode = await sharedpre.read("currency") ?? "";
    log("userid ==>$userid");
    callapi();
  }

  void callapi() async {
    final myCourseProvider =
        Provider.of<MyCourseProvider>(context, listen: false);
    await myCourseProvider.getMyCourse(userid);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: colorprimaryDark,
        elevation: 0,
        leading: Container(
          width: 10,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                if (userid!.isEmpty || userid == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Cart(
                          userid: userid.toString(),
                        );
                      },
                    ),
                  );
                }
              },
              child: MySvg(
                width: 22,
                height: 22,
                imagePath: "ic_cart.svg",
                color: white,
              ),
            ),
          ),
        ],
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                  color: white,
                  text: constant.mycourse,
                  maxline: 1,
                  fontwaight: FontWeight.w500,
                  fontsize: 16,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Consumer<MyCourseProvider>(
                builder: (context, courceDataProvider, child) {
                  if (courceDataProvider.loading) {
                    return mycourseshimmer();
                  } else {
                    if (courceDataProvider.myCourseModel.status == 200 &&
                        courceDataProvider.myCourseModel.result!.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            courceDataProvider.myCourseModel.result?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Detail(
                                        currencycode: currencycode,
                                        id: courceDataProvider
                                            .myCourseModel.result![index].id
                                            .toString());
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 110,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: lightgray,
                                    blurRadius: 5,
                                    offset: Offset(0.1, 0.1),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyNetworkImage(
                                    imgWidth: 80,
                                    imgHeight:
                                        MediaQuery.of(context).size.height,
                                    imageUrl: courceDataProvider
                                            .myCourseModel.result?[index].image
                                            .toString() ??
                                        "",
                                    fit: BoxFit.fill,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 7),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: MyText(
                                              color: colorAccent,
                                              text: courceDataProvider
                                                      .myCourseModel
                                                      .result?[index]
                                                      .name
                                                      .toString() ??
                                                  "",
                                              maxline: 1,
                                              fontwaight: FontWeight.w500,
                                              fontsize: 13,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ),
                                        const SizedBox(height: 7),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: MyText(
                                              color: colorAccent,
                                              text: courceDataProvider
                                                      .myCourseModel
                                                      .result?[index]
                                                      .description
                                                      .toString() ??
                                                  "",
                                              maxline: 2,
                                              fontwaight: FontWeight.w500,
                                              fontsize: 10,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ),
                                        const SizedBox(height: 7),
                                        MyText(
                                            color: verydarkblue,
                                            text: courceDataProvider
                                                    .myCourseModel
                                                    .result?[index]
                                                    .tutorName
                                                    .toString() ??
                                                "",
                                            fontsize: 10,
                                            fontwaight: FontWeight.w600,
                                            maxline: 1,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ),
                                  // const Spacer(),
                                  // SizedBox(
                                  //   width: 40,
                                  //   child: CircularPercentIndicator(
                                  //     radius: 30.0,
                                  //     lineWidth: 3.0,
                                  //     percent: 0.25,
                                  //     animationDuration: 3000,
                                  //     circularStrokeCap:
                                  //         CircularStrokeCap.round,
                                  //     animation: true,
                                  //     center: MyText(
                                  //         color: black,
                                  //         text: "${courceDataProvider.myCourseModel
                                  //                 .result?[index].totalCount
                                  //                 .toString() ??
                                  //             ""}%",
                                  //         fontsize: 14,
                                  //         fontwaight: FontWeight.w600,
                                  //         maxline: 2,
                                  //         textalign: TextAlign.left,
                                  //         fontstyle: FontStyle.normal),
                                  //     progressColor:
                                  //         index.isEven ? orange : pink,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const NoData();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mycourseshimmer() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: width,
          height: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: lightgray,
                blurRadius: 5,
                offset: Offset(0.1, 0.1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomWidget.rectangular(
                width: 80,
                height: MediaQuery.of(context).size.height,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),
                    CustomWidget.roundrectborder(
                      width: width! * 0.25,
                      height: height! * 0.02,
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        RatingBar(
                          initialRating: 2,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 10,
                          ratingWidget: RatingWidget(
                            full: const CustomWidget.circular(
                                height: 15, width: 15),
                            half: const CustomWidget.circular(
                                height: 15, width: 15),
                            empty: const CustomWidget.circular(
                                height: 15, width: 15),
                          ),
                          itemPadding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          onRatingUpdate: (rating) {
                            debugPrint("$rating");
                          },
                        ),
                        const SizedBox(width: 7),
                        CustomWidget.roundrectborder(
                          width: width! * 0.20,
                          height: height! * 0.01,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
