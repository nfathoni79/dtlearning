import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/provider/courselistbytutoridprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TutorProfilePage extends StatefulWidget {
  final String tutorid, avgrating,currencycode;
  const TutorProfilePage({
    super.key,
    required this.tutorid,
    required this.currencycode,
    required this.avgrating,
  });

  @override
  State<TutorProfilePage> createState() => TutorProfilePageState();
}

class TutorProfilePageState extends State<TutorProfilePage> {
  double? height;
  double? width;
  Constant constant = Constant();

  @override
  initState() {
    super.initState();
    callapi();
  }

  void callapi() async {
    final tutorProvider =
        Provider.of<CourselistByTutoridProvider>(context, listen: false);
    await tutorProvider.getcourselistBytutorid(widget.tutorid.toString());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: darkblue,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: darkblue,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              child: MySvg(width: 18, height: 18, imagePath: "ic_back.svg")),
        ),
        title: MyText(
            color: white,
            text: constant.tutorprofile,
            maxline: 1,
            fontwaight: FontWeight.w600,
            fontsize: 16,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Consumer<CourselistByTutoridProvider>(
                  builder: (context, tutoritem, child) {
                if (tutoritem.loading) {
                  return tutorprofileshimmer();
                } else {
                  if (tutoritem.courselistbytutoridModel.status == 200 &&
                      tutoritem.courselistbytutoridModel.result!.isNotEmpty) {
                    return Container(
                      height: height! * 0.27,
                      color: darkblue,
                      child: Column(
                        children: [
                          Container(
                            height: height! * 0.13,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: orange, width: 1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MyNetworkImage(
                                        imageUrl: tutoritem
                                                .courselistbytutoridModel
                                                .result?[0]
                                                .tutorImage
                                                .toString() ??
                                            "",
                                        fit: BoxFit.fill,
                                        imgHeight: 75,
                                        imgWidth: 75),
                                  ),
                                ),
                                SizedBox(width: width! * 0.04),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MyText(
                                            color: white,
                                            text: tutoritem
                                                    .courselistbytutoridModel
                                                    .result?[0]
                                                    .tutorName
                                                    .toString() ??
                                                "",
                                            maxline: 1,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        SizedBox(width: width! * 0.009),
                                        MyText(
                                            color: white,
                                            text:
                                                "(${tutoritem.courselistbytutoridModel.result?[0].totalRating.toString() ?? ""} Ratings)",
                                            maxline: 2,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                    SizedBox(height: height! * 0.011),
                                    MyRating(
                                      rating: double.parse(
                                          widget.avgrating.toString()),
                                      spacing: 3,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: height! * 0.14,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_review.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      // width: width! * 0.25,
                                      child: MyText(
                                          color: white,
                                          text:
                                              "${tutoritem.courselistbytutoridModel.result?[0].totalRating.toString() ?? ""} Reviews",
                                          maxline: 1,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                                // SizedBox(width: width! * 0.02),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_course.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      // width: width! * 0.16,
                                      child: MyText(
                                          color: white,
                                          text:
                                              "${tutoritem.courselistbytutoridModel.result?[0].totalCourse.toString() ?? ""} Courses",
                                          maxline: 1,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                                // SizedBox(width: width! * 0.03),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_student.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      // width: width! * 0.22,
                                      child: MyText(
                                          color: white,
                                          text: "${Utils.kmbGenerator(
                                            double.parse(tutoritem
                                                    .courselistbytutoridModel
                                                    .result?[0]
                                                    .view
                                                    .toString() ??
                                                ""),
                                          )} Students",
                                          maxline: 1,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: height! * 0.30,
                      color: darkblue,
                      child: Column(
                        children: [
                          Container(
                            height: height! * 0.14,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(color: orange, width: 1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MyImage(
                                        imagePath: "ic_user.png",
                                        fit: BoxFit.fill,
                                        height: 70,
                                        width: 70),
                                  ),
                                ),
                                SizedBox(width: width! * 0.04),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MyText(
                                            color: white,
                                            text: "Tutor name",
                                            maxline: 1,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        SizedBox(width: width! * 0.009),
                                        MyText(
                                            color: white,
                                            text: "(0 Rating)",
                                            maxline: 2,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                    SizedBox(height: height! * 0.011),
                                    RatingBar(
                                      initialRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 17,
                                      ratingWidget: RatingWidget(
                                        full: MySvg(
                                            width: 5,
                                            height: 5,
                                            imagePath: "ic_rating.svg"),
                                        half: MySvg(
                                            width: 5,
                                            height: 5,
                                            imagePath: "ic_rating.svg"),
                                        empty: MySvg(
                                            width: 5,
                                            height: 5,
                                            imagePath: "ic_notRating.svg"),
                                      ),
                                      itemPadding:
                                          const EdgeInsets.fromLTRB(3, 0, 3, 0),
                                      onRatingUpdate: (rating) {
                                        debugPrint("$rating");
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: height! * 0.16,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_review.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      width: width! * 0.20,
                                      child: MyText(
                                          color: white,
                                          text: "0 Reviews",
                                          maxline: 2,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width! * 0.02),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_course.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      width: width! * 0.20,
                                      child: MyText(
                                          color: white,
                                          text: "0 Courses",
                                          maxline: 2,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width! * 0.02),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lowercolorintro,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_student.png",
                                      ),
                                    ),
                                    SizedBox(height: height! * 0.009),
                                    SizedBox(
                                      width: width! * 0.25,
                                      child: MyText(
                                          color: white,
                                          text: "0 Students",
                                          maxline: 1,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }),
              allcourse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget allcourse() {
    return Consumer<CourselistByTutoridProvider>(
        builder: (context, tutoritem, child) {
      if (tutoritem.loading) {
        return allcourseshimmer();
      } else {
        if (tutoritem.courselistbytutoridModel.status == 200 &&
            tutoritem.courselistbytutoridModel.result!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height! * 0.03),
                MyText(
                    color: black,
                    text:
                        "${tutoritem.courselistbytutoridModel.result?[0].tutorName.toString() ?? ""}'s Courses",
                    maxline: 1,
                    fontwaight: FontWeight.w500,
                    fontsize: 16,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
                SizedBox(height: height! * 0.009),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          tutoritem.courselistbytutoridModel.result?.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    currencycode: widget.currencycode,
                                      id: tutoritem.courselistbytutoridModel
                                              .result?[index].id
                                              .toString() ??
                                          "");
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                  imgWidth: 100,
                                  imgHeight: MediaQuery.of(context).size.height,
                                  imageUrl: tutoritem.courselistbytutoridModel
                                          .result?[index].image
                                          .toString() ??
                                      "",
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: width! * 0.04),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width! * 0.50,
                                      child: MyText(
                                          color: lowercolorintro,
                                          text: tutoritem
                                                  .courselistbytutoridModel
                                                  .result?[index]
                                                  .name
                                                  .toString() ??
                                              "",
                                          maxline: 2,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ),
                                    SizedBox(height: height! * 0.013),
                                    SizedBox(
                                      width: width! * 0.50,
                                      child: MyText(
                                          color: verydarkblue,
                                          text:
                                              "${tutoritem.courselistbytutoridModel.result?[index].duration.toString() ?? ""} mins",
                                          maxline: 1,
                                          fontwaight: FontWeight.w500,
                                          fontsize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: width! * 0.50,
                                      child: MyText(
                                          color: verydarkblue,
                                          text:
                                              "${widget.currencycode} ${tutoritem.courselistbytutoridModel.result?[index].price.toString() ?? ""}",
                                          fontsize: 12,
                                          fontwaight: FontWeight.w500,
                                          maxline: 2,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        } else {
          return noData();
        }
      }
    });
  }

  Widget allcourseshimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height! * 0.03),
          CustomWidget.roundrectborder(
            height: height! * 0.03,
            width: width! * 0.35,
          ),
          SizedBox(height: height! * 0.009),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                      CustomWidget.rectangular(
                        height: height!,
                        width: 100,
                      ),
                      SizedBox(width: width! * 0.04),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.roundrectborder(
                            height: height! * 0.015,
                            width: width! * 0.40,
                          ),
                          SizedBox(height: height! * 0.013),
                          CustomWidget.roundrectborder(
                            height: height! * 0.015,
                            width: width! * 0.30,
                          ),
                          const SizedBox(height: 8),
                          CustomWidget.roundrectborder(
                            height: height! * 0.015,
                            width: width! * 0.20,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tutorprofileshimmer() {
    return Container(
      height: height! * 0.30,
      color: darkblue,
      child: Column(
        children: [
          Container(
            height: height! * 0.14,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                const CustomWidget.circular(
                  height: 70,
                  width: 70,
                ),
                SizedBox(width: width! * 0.04),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomWidget.roundrectborder(
                          height: height! * 0.02,
                          width: width! * 0.30,
                        ),
                        SizedBox(width: width! * 0.009),
                        CustomWidget.roundrectborder(
                          height: height! * 0.02,
                          width: width! * 0.15,
                        ),
                      ],
                    ),
                    SizedBox(height: height! * 0.011),
                    RatingBar(
                      initialRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      ratingWidget: RatingWidget(
                        full: const CustomWidget.circular(
                          height: 15,
                          width: 15,
                        ),
                        half: const CustomWidget.circular(
                          height: 15,
                          width: 15,
                        ),
                        empty: const CustomWidget.circular(
                          height: 15,
                          width: 15,
                        ),
                      ),
                      itemPadding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      onRatingUpdate: (rating) {
                        debugPrint("$rating");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: height! * 0.16,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomWidget.circular(
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(height: height! * 0.009),
                    CustomWidget.rectangular(
                      height: height! * 0.01,
                      width: width! * 0.20,
                    ),
                  ],
                ),
                SizedBox(width: width! * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomWidget.circular(
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(height: height! * 0.009),
                    CustomWidget.rectangular(
                      height: height! * 0.01,
                      width: width! * 0.20,
                    ),
                  ],
                ),
                SizedBox(width: width! * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomWidget.circular(
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(height: height! * 0.009),
                    CustomWidget.rectangular(
                      height: height! * 0.01,
                      width: width! * 0.20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noData() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
      ),
      constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
      child: Center(
        child: MyImage(
          height: height! * 0.50,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
          imagePath: "nodata.png",
        ),
      ),
    );
  }
}
