import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/provider/courselistbycategoryidprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourelistByCategoryid extends StatefulWidget {
  final String title, userid, currencycode;

  const CourelistByCategoryid(
      {super.key,
      required this.title,
      required this.userid,
      required this.currencycode});

  @override
  State<CourelistByCategoryid> createState() => _CourelistByCategoryidState();
}

class _CourelistByCategoryidState extends State<CourelistByCategoryid> {
  SharedPre sharedpre = SharedPre();
  double? height;
  double? width;

  @override
  initState() {
    super.initState();
    callapi();
  }

  void callapi() async {
    final courselistbycategoryItem =
        Provider.of<CourselistByCategoryidProvider>(context, listen: false);
    await courselistbycategoryItem
        .getcourselistBycategoryid(widget.userid.toString());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: colorprimaryDark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: MyAppbar(
          text: widget.title.toString(),
          startImg: "ic_back.svg",
          startImgcolor: white,
          backTap: () {
            Navigator.of(context).pop(false);
          },
          textcolor: white,
          type: 1,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(15),
        child: allcourse(),
      ),
    );
  }

  Widget allcourse() {
    return Consumer<CourselistByCategoryidProvider>(
        builder: (context, courselistbycategoryItem, child) {
      if (courselistbycategoryItem.loading) {
        return allcourseshimmer();
      } else {
        if (courselistbycategoryItem.courselistbycategoryidModel.status ==
                200 &&
            courselistbycategoryItem
                .courselistbycategoryidModel.result!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: courselistbycategoryItem
                            .courselistbycategoryidModel.result?.length ??
                        0,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Detail(
                                  currencycode: widget.currencycode,
                                    id: courselistbycategoryItem
                                            .courselistbycategoryidModel
                                            .result?[index]
                                            .id
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
                                imageUrl: courselistbycategoryItem
                                        .courselistbycategoryidModel
                                        .result?[index]
                                        .image
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
                                        text: courselistbycategoryItem
                                                .courselistbycategoryidModel
                                                .result?[index]
                                                .name
                                                .toString() ??
                                            "",
                                        maxline: 2,
                                        fontwaight: FontWeight.w500,
                                        fontsize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                  SizedBox(height: height! * 0.013),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width! * 0.15,
                                        child: MyText(
                                            color: verydarkblue,
                                            text:
                                                "${widget.currencycode.toString()} ${courselistbycategoryItem.courselistbycategoryidModel.result?[index].price.toString() ?? ""}",
                                            fontsize: 12,
                                            fontwaight: FontWeight.w500,
                                            maxline: 1,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                      MyText(
                                          color: verydarkblue,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          text:
                                              "${widget.currencycode.toString()} ${courselistbycategoryItem.courselistbycategoryidModel.result?[index].oldPrice.toString() ?? ""}",
                                          fontsize: 12,
                                          fontwaight: FontWeight.w500,
                                          maxline: 1,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      MyText(
                                          color: black,
                                          text:
                                              "(${courselistbycategoryItem.courselistbycategoryidModel.result?[index].duration.toString() ?? ""} min)",
                                          fontsize: 12,
                                          fontwaight: FontWeight.w500,
                                          maxline: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyRating(
                                        size: 15,
                                        rating: double.parse(
                                            (courselistbycategoryItem
                                                    .courselistbycategoryidModel
                                                    .result?[index]
                                                    .avgRating
                                                    .toString() ??
                                                "")),
                                        spacing: 1,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        child: MyText(
                                            color: black,
                                            text: courselistbycategoryItem
                                                    .courselistbycategoryidModel
                                                    .result?[index]
                                                    .avgRating
                                                    .toString() ??
                                                "",
                                            fontsize: 12,
                                            fontwaight: FontWeight.w500,
                                            maxline: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                      MyText(
                                          color: black,
                                          text:
                                              "(${courselistbycategoryItem.courselistbycategoryidModel.result?[index].totalRating.toString() ?? ""})",
                                          fontsize: 12,
                                          fontwaight: FontWeight.w500,
                                          maxline: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ],
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
          );
        } else {
          return noData();
        }
      }
    });
  }

  Widget allcourseshimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
