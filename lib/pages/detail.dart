import 'dart:convert';
import 'dart:developer';
import 'package:dtlearning/model/courseidmodel.dart';
import 'package:dtlearning/pages/cart.dart';
import 'package:dtlearning/pages/checkout.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/pages/player_pod.dart';
import 'package:dtlearning/pages/tutorprofilepage.dart';
import 'package:dtlearning/provider/coursedetailsprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class Detail extends StatefulWidget {
  final String? id, currencycode;
  const Detail({Key? key, required this.id, required this.currencycode})
      : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  SharedPre sharedpre = SharedPre();
  late ProgressDialog prDialog;
  String userid = "";
  Constant constant = Constant();
  late CourseDetailsProvider detailProvider;

  @override
  void initState() {
    super.initState();
    detailProvider = Provider.of<CourseDetailsProvider>(context, listen: false);
    getapicalling();
    prDialog = ProgressDialog(context);
  }

  @override
  void dispose() {
    super.dispose();
    detailProvider.clearProvider();
  }

  getapicalling() async {
    log("courseid ==> ${widget.id}");
    log("userid ==> $userid");
    await detailProvider.getCourseDetails(widget.id.toString());
    await detailProvider.getrelatedcourse(
        detailProvider.courseDetailsModel.result?[0].categoryId.toString() ??
            "",
        widget.id.toString());

    userid = await sharedpre.read("userid") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: colorAccent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: colorAccent,
        // actions: [MySvg(width: 18, height: 18, imagePath: "ic_cart.svg")],
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (userid.isEmpty || userid == "") {
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
                        userid: userid,
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
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
            text: constant.coursedetail,
            maxline: 1,
            fontwaight: FontWeight.w600,
            fontsize: 16,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              parentConainer(),
              childContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget parentConainer() {
    return Consumer<CourseDetailsProvider>(
      builder: (context, courseDetailsData, child) {
        log("student =>${courseDetailsData.courseDetailsModel.result?[0].studentFeedback.toString()}");
        if (courseDetailsData.loading) {
          return parentShimmer();
        } else {
          if (courseDetailsData.courseDetailsModel.status == 200) {
            return Container(
              width: MediaQuery.of(context).size.width,
              color: colorAccent,
              child: Column(
                children: [
                  Container(
                    color: colorAccent,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // videoImage
                          Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: MyNetworkImage(
                                    imgWidth: 250,
                                    imgHeight: 130,
                                    fit: BoxFit.fill,
                                    imageUrl: courseDetailsData
                                            .courseDetailsModel.result?[0].image
                                            .toString() ??
                                        ""),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (userid.isEmpty || userid == "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Login();
                                        },
                                      ),
                                    );
                                  } else {
                                    if ((courseDetailsData
                                                    .courseDetailsModel
                                                    .result?[0]
                                                    .courseVideo
                                                    ?.length ??
                                                0) <
                                            0 &&
                                        courseDetailsData.courseDetailsModel
                                            .result![0].courseVideo!.isEmpty) {
                                      Utils()
                                          .showToast("Course Video is Empty");
                                    } else {
                                      log("videotype=>${courseDetailsData.courseDetailsModel.result?[0].courseVideo?[0].videoType.toString() ?? ""}");

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return PlayerPod(
                                              courseDetailsData
                                                      .courseDetailsModel
                                                      .result?[0]
                                                      .courseVideo?[0]
                                                      .videoType
                                                      .toString() ??
                                                  "",
                                              courseDetailsData
                                                      .courseDetailsModel
                                                      .result?[0]
                                                      .courseVideo?[0]
                                                      .videoUrl
                                                      .toString() ??
                                                  "",
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: MyImage(
                                      width: 30,
                                      height: 30,
                                      color: white,
                                      imagePath: "ic_play.png",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: MyText(
                                        color: white,
                                        text: "Preview this course",
                                        fontsize: 14,
                                        fontwaight: FontWeight.w600,
                                        maxline: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textalign: TextAlign.center,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          // DetailVideo Title Text
                          MyText(
                              color: white,
                              text: courseDetailsData
                                      .courseDetailsModel.result?[0].name
                                      .toString() ??
                                  "",
                              fontsize: 18,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                          const SizedBox(height: 15),
                          // video Discription
                          ReadMoreText(
                            "${courseDetailsData.courseDetailsModel.result?[0].description.toString() ?? ""}  ",
                            trimLines: 2,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: white),
                            trimCollapsedText: 'Show more',
                            colorClickableText: white,
                            trimMode: TrimMode.Line,
                            trimExpandedText: 'Show less',
                            lessStyle: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: orange),
                            moreStyle: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: orange),
                          ),

                          const SizedBox(height: 15),
                          //  Video Rating with Rating Count
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 20,
                                color: orange,
                                alignment: Alignment.center,
                                child: MyText(
                                    color: black,
                                    text: "BESTSELLER",
                                    fontsize: 10,
                                    fontwaight: FontWeight.w400,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              Container(
                                width: 100,
                                height: 20,
                                alignment: Alignment.center,
                                child: MyRating(
                                    rating: double.parse(
                                      courseDetailsData.courseDetailsModel
                                              .result?[0].avgRating
                                              .toString() ??
                                          "",
                                    ),
                                    spacing: 1,
                                    size: 15),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: MyText(
                                    color: white,
                                    text: courseDetailsData.courseDetailsModel
                                            .result?[0].avgRating
                                            .toString() ??
                                        "",
                                    fontsize: 12,
                                    fontwaight: FontWeight.w400,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              MyText(
                                  color: white,
                                  text:
                                      "(${courseDetailsData.courseDetailsModel.result?[0].totalRating.toString() ?? ""} Ratings)",
                                  fontsize: 12,
                                  fontwaight: FontWeight.w400,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // View  Count With Student
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                MyImage(
                                  width: 15,
                                  height: 15,
                                  imagePath: "ic_eye.png",
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                MyText(
                                    color: white,
                                    text: Utils.kmbGenerator(double.parse(
                                        courseDetailsData
                                            .courseDetailsModel.result![0].view
                                            .toString())),
                                    fontsize: 12,
                                    fontwaight: FontWeight.w400,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                const SizedBox(
                                  width: 5,
                                ),
                                MyText(
                                    color: white,
                                    text: "Students",
                                    fontsize: 12,
                                    fontwaight: FontWeight.w400,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ],
                            ),
                          ),
                          // Created By List
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    color: white,
                                    text: "Created by : ",
                                    fontsize: 12,
                                    fontwaight: FontWeight.w600,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                Expanded(
                                  child: SizedBox(
                                    child: MyText(
                                        color: white,
                                        text: courseDetailsData
                                            .courseDetailsModel
                                            .result![0]
                                            .tutorName
                                            .toString(),
                                        fontsize: 12,
                                        fontwaight: FontWeight.w400,
                                        maxline: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Total Hour , updatedat and language Btn
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                decoration: BoxDecoration(
                                  color: colorprimaryDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: MyText(
                                    color: gray,
                                    text:
                                        "Total Hours : ${courseDetailsData.courseDetailsModel.result![0].duration.toString()} Hours",
                                    fontsize: 11,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                decoration: BoxDecoration(
                                  color: colorprimaryDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: MyText(
                                    color: gray,
                                    text:
                                        "Update:  ${Utils.formateDate(courseDetailsData.courseDetailsModel.result![0].updatedAt.toString(), "d MMM yy")}",
                                    fontsize: 11,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.06,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorprimaryDark,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: MyText(
                                color: gray,
                                text: courseDetailsData
                                    .courseDetailsModel.result![0].languageName
                                    .toString(),
                                fontsize: 14,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            color: colorAccent,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            color: white,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.30,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                              color: colorprimaryDark,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MyText(
                                      color: white,
                                      text:
                                          "${widget.currencycode} ${courseDetailsData.courseDetailsModel.result?[0].price.toString() ?? ""}",
                                      fontsize: 22,
                                      fontwaight: FontWeight.w600,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.030),
                                  MyText(
                                      color: gray,
                                      decoration: TextDecoration.lineThrough,
                                      text:
                                          "${widget.currencycode} ${courseDetailsData.courseDetailsModel.result?[0].oldPrice.toString() ?? ""}",
                                      fontsize: 12,
                                      fontwaight: FontWeight.w400,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  if (userid.isEmpty || userid == "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Login();
                                        },
                                      ),
                                    );
                                  } else {
                                    if (courseDetailsData.courseDetailsModel
                                        .result!.isNotEmpty) {
                                      List<String>? coursedetailArray =
                                          <String>[];

                                      CourseidModel courseidModel =
                                          CourseidModel();

                                      courseidModel.courseId = courseDetailsData
                                              .courseDetailsModel.result?[0].id
                                              .toString() ??
                                          "";
                                      courseidModel.price = courseDetailsData
                                              .courseDetailsModel
                                              .result?[0]
                                              .price
                                              .toString() ??
                                          "";

                                      Map<String, dynamic> map = {
                                        'course_id': courseidModel.courseId,
                                        'price': courseidModel.price
                                      };

                                      String rawJson = jsonEncode(map);
                                      coursedetailArray.add(rawJson);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return Checkout(
                                                couponid: "",
                                                coursedetail: coursedetailArray
                                                    .toString(),
                                                discountamount:
                                                    courseDetailsData
                                                            .courseDetailsModel
                                                            .result?[0]
                                                            .price
                                                            .toString() ??
                                                        "",
                                                userid: userid.toString());
                                          },
                                        ),
                                      );
                                    } else {
                                      Utils().showToast("Detail Item is Empty");
                                    }
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: colorAccent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: MyText(
                                    color: white,
                                    text: "BUY NOW",
                                    textalign: TextAlign.center,
                                    fontsize: 14,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w500,
                                    fontstyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (userid.isEmpty || userid == "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Login();
                                        },
                                      ),
                                    );
                                  } else {
                                    final addtocartItem =
                                        Provider.of<CourseDetailsProvider>(
                                            context,
                                            listen: false);

                                    Utils.showProgress(context, prDialog);

                                    await addtocartItem.getaddtocart(
                                        courseDetailsData
                                            .courseDetailsModel.result![0].id
                                            .toString(),
                                        userid);

                                    if (addtocartItem.loading) {
                                      // ignore: use_build_context_synchronously
                                      Utils.showProgress(context, prDialog);
                                    } else {
                                      if (addtocartItem.addtocartModel.status ==
                                          200) {
                                        Utils().showToast(
                                            "${addtocartItem.addtocartModel.message} Succsessfully");
                                        prDialog.hide();
                                      } else {
                                        Utils().showToast(
                                            "${addtocartItem.addtocartModel.message}");
                                        prDialog.hide();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: MyText(
                                    color: colorprimaryDark,
                                    text: "ADD TO CART",
                                    textalign: TextAlign.center,
                                    fontsize: 14,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w500,
                                    fontstyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (userid.isEmpty || userid == "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Login();
                                        },
                                      ),
                                    );
                                  } else {
                                    final addwishlistItem =
                                        Provider.of<CourseDetailsProvider>(
                                            context,
                                            listen: false);
                                    Utils.showProgress(context, prDialog);
                                    await addwishlistItem.getaddwishlist(
                                        userid,
                                        courseDetailsData.courseDetailsModel
                                                .result?[0].id
                                                .toString() ??
                                            "");

                                    if (addwishlistItem.loading) {
                                      // ignore: use_build_context_synchronously
                                      Utils.showProgress(context, prDialog);
                                    } else {
                                      if (addwishlistItem
                                              .addwishlistmodel.status ==
                                          200) {
                                        Utils().showToast(
                                            "${addwishlistItem.addwishlistmodel.message} Succsessfully");
                                        prDialog.hide();

                                        await courseDetailsData
                                            .getCourseDetails(
                                          courseDetailsData.courseDetailsModel
                                                  .result?[0].id
                                                  .toString() ??
                                              "",
                                        );
                                        // setState(() {});
                                      } else {
                                        Utils().showToast(
                                            "${addwishlistItem.addwishlistmodel.message}");
                                        prDialog.hide();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Consumer<CourseDetailsProvider>(
                                      builder:
                                          (context, courseDetailsData, child) {
                                    log("iswishlist=>${courseDetailsData.courseDetailsModel.result?[0].isWishlist}");
                                    return MyText(
                                      color: colorprimaryDark,
                                      text: courseDetailsData.courseDetailsModel
                                                  .result?[0].isWishlist ==
                                              0
                                          ? "Add to WISHLIST"
                                          : "Remove TO WISHLIST",
                                      textalign: TextAlign.center,
                                      fontsize: 14,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w500,
                                      fontstyle: FontStyle.normal,
                                    );
                                  }),
                                ),
                                //  Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 40,
                                //   alignment: Alignment.center,
                                //   margin:
                                //       const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                //   decoration: BoxDecoration(
                                //     color: white,
                                //     borderRadius: BorderRadius.circular(5),
                                //   ),
                                //   child: courseDetailsData.courseDetailsModel
                                //                   .result?[0].isWishlist
                                //                   .toString() ==
                                //               "0" ||
                                //           courseDetailsData.courseDetailsModel
                                //                   .result![0].isWishlist ==
                                //               0
                                //       ? MyText(
                                //           color: colorprimaryDark,
                                //           text: "Add to WISHLIST",
                                //           textalign: TextAlign.center,
                                //           fontsize: 14,
                                //           maxline: 1,
                                //           overflow: TextOverflow.ellipsis,
                                //           fontwaight: FontWeight.w500,
                                //           fontstyle: FontStyle.normal,
                                //         )
                                //       : MyText(
                                //           color: colorprimaryDark,
                                //           text: "Remove TO WISHLIST",
                                //           textalign: TextAlign.center,
                                //           fontsize: 14,
                                //           maxline: 1,
                                //           overflow: TextOverflow.ellipsis,
                                //           fontwaight: FontWeight.w500,
                                //           fontstyle: FontStyle.normal,
                                //         ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget parentShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Column(
        children: [
          Container(
            color: colorAccent,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // videoImage
                Align(
                  alignment: Alignment.center,
                  child: CustomWidget.rectangular(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.65,
                  ),
                ),
                const SizedBox(height: 20),
                // DetailVideo Title Text
                const CustomWidget.roundrectborder(
                  height: 20,
                  width: 200,
                ),
                const SizedBox(height: 15),
                // video Discription
                const CustomWidget.roundrectborder(
                  height: 20,
                  width: 150,
                ),
                const SizedBox(height: 15),
                //  Video Rating with Rating Count
                Row(
                  children: const [
                    CustomWidget.rectangular(
                      height: 20,
                      width: 80,
                    ),
                    CustomWidget.rectangular(
                      height: 20,
                      width: 100,
                    ),
                    CustomWidget.roundrectborder(
                      height: 20,
                      width: 40,
                    ),
                    CustomWidget.roundrectborder(
                      height: 20,
                      width: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // View  Count With Student
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    children: const [
                      CustomWidget.rectangular(
                        height: 15,
                        width: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomWidget.roundrectborder(
                        height: 20,
                        width: 80,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomWidget.roundrectborder(
                        height: 20,
                        width: 100,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Created By List
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CustomWidget.roundrectborder(
                        height: 20,
                        width: 100,
                      ),
                      CustomWidget.roundrectborder(
                        height: 20,
                        width: 100,
                      ),
                    ],
                  ),
                ),
                // Total Hour , updatedat and language Btn
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: CustomWidget.roundcorner(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    ),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: CustomWidget.roundcorner(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: CustomWidget.roundcorner(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buynowShimmer(),
        ],
      ),
    );
  }

  Widget childContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Consumer<CourseDetailsProvider>(
        builder: (context, courseDetailsData, child) {
          if (courseDetailsData.loading) {
            return childshimmer();
          } else {
            if (courseDetailsData.courseDetailsModel.status == 200) {
              return Column(
                children: [
                  // Space Box Top of Child
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                  ),
                  // This Course included Box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
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
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        MyText(
                            color: colorprimaryDark,
                            fontwaight: FontWeight.w600,
                            fontsize: 16,
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            text: "This course includes",
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetailsData
                              .courseDetailsModel.result?[0].include?.length,
                          itemBuilder: (BuildContext context, int index1) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyImage(
                                    width: 7,
                                    height: 7,
                                    imagePath: "ic_dot.png",
                                    color: colorAccent,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MyText(
                                        color: gray,
                                        fontwaight: FontWeight.w500,
                                        fontsize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        maxline: 2,
                                        text: courseDetailsData
                                                .courseDetailsModel
                                                .result?[0]
                                                .include?[index1]
                                                .title
                                                .toString() ??
                                            "",
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // what you Learn Box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        MyText(
                            color: colorprimaryDark,
                            fontwaight: FontWeight.w600,
                            fontsize: 16,
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            text: "What you learn",
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetailsData
                              .courseDetailsModel.result?[0].learn?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  MySvg(
                                    width: 15,
                                    height: 15,
                                    imagePath: "ic_tick.svg",
                                    color: colorAccent,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MyText(
                                        color: gray,
                                        fontwaight: FontWeight.w500,
                                        fontsize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        maxline: 3,
                                        text: courseDetailsData
                                                .courseDetailsModel
                                                .result?[0]
                                                .learn?[index]
                                                .title
                                                .toString() ??
                                            "",
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MyText(
                            color: white,
                            text: "SHOW MORE",
                            textalign: TextAlign.center,
                            fontsize: 14,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w500,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Requirmemt Box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 10, right: 10),
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
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        MyText(
                            color: colorprimaryDark,
                            fontwaight: FontWeight.w600,
                            fontsize: 16,
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            text: "Requirments",
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 10),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetailsData.courseDetailsModel
                              .result?[0].requrirment?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      MyImage(
                                        width: 7,
                                        height: 7,
                                        imagePath: "ic_dot.png",
                                        color: colorAccent,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: MyText(
                                            color: gray,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            maxline: 3,
                                            text: courseDetailsData
                                                    .courseDetailsModel
                                                    .result?[0]
                                                    .requrirment?[index]
                                                    .title
                                                    .toString() ??
                                                "",
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Description Box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                            color: colorAccent,
                            fontwaight: FontWeight.w600,
                            fontsize: 16,
                            overflow: TextOverflow.ellipsis,
                            maxline: 1,
                            text: "Description",
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                            color: gray,
                            text: courseDetailsData
                                    .courseDetailsModel.result?[0].description
                                    .toString() ??
                                "",
                            maxline: 5,
                            fontwaight: FontWeight.w500,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MyText(
                            color: white,
                            text: "SHOW MORE",
                            textalign: TextAlign.center,
                            fontsize: 14,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w500,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Related course

                  Column(
                    children: [
                      MyText(
                          color: colorprimaryDark,
                          fontwaight: FontWeight.w600,
                          fontsize: 16,
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          text: "Reated Course",
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetailsData
                              .relatedcourseModel.result?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 20, 0),
                                  margin: const EdgeInsets.only(
                                      bottom: 10, left: 30, right: 0),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: lightgray,
                                        blurRadius: 5,
                                        offset: Offset(0.1, 0.1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                          color: colorprimaryDark,
                                          text: courseDetailsData
                                                  .relatedcourseModel
                                                  .result?[index]
                                                  .description
                                                  .toString() ??
                                              "",
                                          fontsize: 14,
                                          fontwaight: FontWeight.w600,
                                          maxline: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MyRating(
                                              rating: double.parse(
                                                  (courseDetailsData
                                                          .relatedcourseModel
                                                          .result?[index]
                                                          .avgRating
                                                          .toString() ??
                                                      "")),
                                              spacing: 1,
                                              size: 15),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.080,
                                            alignment: Alignment.centerLeft,
                                            child: MyText(
                                                color: gray,
                                                text: courseDetailsData
                                                        .relatedcourseModel
                                                        .result?[index]
                                                        .avgRating
                                                        .toString() ??
                                                    "",
                                                fontsize: 12,
                                                fontwaight: FontWeight.w400,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.left,
                                                fontstyle: FontStyle.normal),
                                          ),
                                          MyText(
                                              color: gray,
                                              text:
                                                  "(${courseDetailsData.relatedcourseModel.result?[index].totalRating.toString() ?? ""} Ratings)",
                                              fontsize: 12,
                                              fontwaight: FontWeight.w400,
                                              maxline: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                              color: colorprimaryDark,
                                              text:
                                                  "\$ ${courseDetailsData.relatedcourseModel.result?[index].price.toString() ?? ""}",
                                              fontsize: 14,
                                              fontwaight: FontWeight.w600,
                                              maxline: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          MyText(
                                              color: colorprimaryDark,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              text:
                                                  "\$ ${courseDetailsData.relatedcourseModel.result?[index].oldPrice.toString() ?? ""}",
                                              fontsize: 12,
                                              fontwaight: FontWeight.w400,
                                              maxline: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: MyNetworkImage(
                                      imgWidth: 60,
                                      imgHeight: 60,
                                      imageUrl: courseDetailsData
                                              .relatedcourseModel
                                              .result?[index]
                                              .image
                                              .toString() ??
                                          "",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // course conetent Box
                  MyText(
                      color: colorAccent,
                      text: "Course Content",
                      fontsize: 18,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(
                    height: 10,
                  ),
                  // Course video
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.09,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: colorAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: white,
                                text: "Curriculim",
                                fontsize: 16,
                                fontwaight: FontWeight.w600,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            Row(
                              children: [
                                MyText(
                                    color: white,
                                    text:
                                        "${courseDetailsData.courseDetailsModel.result?[0].courseVideo?.length.toString() ?? ""} Lecture ",
                                    fontsize: 14,
                                    fontwaight: FontWeight.w400,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                MyText(
                                    color: white,
                                    text:
                                        "| ${courseDetailsData.courseDetailsModel.result?[0].duration}Min Total Length",
                                    fontsize: 14,
                                    fontwaight: FontWeight.w400,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // episodelist
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetailsData.courseDetailsModel
                              .result?[0].courseVideo?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 60,
                              margin: const EdgeInsets.all(15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MyText(
                                            color: colorAccent,
                                            fontsize: 12,
                                            maxline: 2,
                                            fontwaight: FontWeight.w600,
                                            text:
                                                "${(index + 1)}.  ${courseDetailsData.courseDetailsModel.result?[0].courseVideo?[index].name.toString() ?? ""}",
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MySvg(
                                                width: 10,
                                                height: 10,
                                                color: orange,
                                                imagePath: "ic_videoplay.svg"),
                                            const SizedBox(width: 5),
                                            MyText(
                                                color: gray,
                                                fontsize: 10,
                                                maxline: 2,
                                                fontwaight: FontWeight.w600,
                                                text:
                                                    "Video : ${courseDetailsData.courseDetailsModel.result?[0].courseVideo?[index].videoduration.toString() ?? ""}",
                                                textalign: TextAlign.left,
                                                fontstyle: FontStyle.normal),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () async {
                                        if (userid.isEmpty || userid == "") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const Login();
                                              },
                                            ),
                                          );
                                        } else {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return PlayerPod(
                                                  courseDetailsData
                                                          .courseDetailsModel
                                                          .result?[0]
                                                          .courseVideo?[0]
                                                          .videoType
                                                          .toString() ??
                                                      "",
                                                  courseDetailsData
                                                          .courseDetailsModel
                                                          .result?[0]
                                                          .courseVideo?[0]
                                                          .videoUrl
                                                          .toString() ??
                                                      "",
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: MyText(
                                          color: colorAccent,
                                          fontsize: 12,
                                          maxline: 1,
                                          fontwaight: FontWeight.w600,
                                          text: "Preview",
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                  // 7more item Btn
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: colorAccent,
                        borderRadius: BorderRadius.circular(7)),
                    child: MyText(
                        color: white,
                        text:
                            "${courseDetailsData.courseDetailsModel.result?[0].courseVideo?.length} MORE VIDEOS",
                        fontsize: 14,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w500,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal),
                  ),
                  // created By Box (tutor Profile Show)

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    margin: const EdgeInsets.only(top: 5, right: 20, left: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        MyText(
                            color: colorAccent,
                            text: "Created By",
                            fontsize: 18,
                            fontwaight: FontWeight.w600,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 270,
                          alignment: Alignment.center,
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
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                            color: colorAccent,
                                            text: courseDetailsData
                                                    .courseDetailsModel
                                                    .result?[0]
                                                    .tutorProfile
                                                    ?.fullname
                                                    .toString() ??
                                                "",
                                            fontsize: 14,
                                            fontwaight: FontWeight.w600,
                                            maxline: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: MyText(
                                              color: gray,
                                              text: courseDetailsData
                                                      .courseDetailsModel
                                                      .result?[0]
                                                      .tutorProfile
                                                      ?.about
                                                      .toString() ??
                                                  "",
                                              fontsize: 12,
                                              fontwaight: FontWeight.w600,
                                              maxline: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return TutorProfilePage(
                                                currencycode: widget
                                                    .currencycode
                                                    .toString(),
                                                avgrating: courseDetailsData
                                                        .courseDetailsModel
                                                        .result?[0]
                                                        .tutorProfile
                                                        ?.avgRating
                                                        .toString() ??
                                                    "",
                                                tutorid: courseDetailsData
                                                        .courseDetailsModel
                                                        .result?[0]
                                                        .tutorProfile
                                                        ?.id
                                                        .toString() ??
                                                    "",
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: MyText(
                                          color: colorAccent,
                                          text: "View Profile",
                                          fontsize: 12,
                                          fontwaight: FontWeight.w600,
                                          maxline: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 210,
                                alignment: Alignment.topCenter,
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: MyNetworkImage(
                                            imgWidth: 80,
                                            imgHeight: 80,
                                            imageUrl: courseDetailsData
                                                    .courseDetailsModel
                                                    .result?[0]
                                                    .tutorProfile
                                                    ?.tutorImage
                                                    .toString() ??
                                                "",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MySvg(
                                                    width: 15,
                                                    height: 15,
                                                    color: orange,
                                                    imagePath: "ic_rating.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyText(
                                                    color: colorAccent,
                                                    text:
                                                        "${courseDetailsData.courseDetailsModel.result?[0].totalRating.toString() ?? ""} Instricter Rating",
                                                    fontsize: 12,
                                                    fontwaight: FontWeight.w600,
                                                    maxline: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textalign: TextAlign.left,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyImage(
                                                    width: 15,
                                                    height: 15,
                                                    color: orange,
                                                    imagePath: "ic_review.png"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyText(
                                                    color: colorAccent,
                                                    text:
                                                        "${courseDetailsData.courseDetailsModel.result?[0].totalCount.toString() ?? ""} Reviews",
                                                    fontsize: 12,
                                                    fontwaight: FontWeight.w600,
                                                    maxline: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textalign: TextAlign.left,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyImage(
                                                    width: 15,
                                                    height: 15,
                                                    color: orange,
                                                    imagePath: "ic_eye.png"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyText(
                                                    color: colorAccent,
                                                    text:
                                                        "${courseDetailsData.courseDetailsModel.result?[0].totalCount.toString() ?? ""} Students",
                                                    fontsize: 12,
                                                    fontwaight: FontWeight.w600,
                                                    maxline: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textalign: TextAlign.left,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MySvg(
                                                    width: 15,
                                                    height: 15,
                                                    color: orange,
                                                    imagePath:
                                                        "ic_videoplay.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MyText(
                                                    color: colorAccent,
                                                    text:
                                                        " ${courseDetailsData.courseDetailsModel.result?[0].tutorProfile?.totalCourse.toString() ?? ""} Courses",
                                                    fontsize: 12,
                                                    fontwaight: FontWeight.w600,
                                                    maxline: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textalign: TextAlign.left,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5, top: 20),
                                        decoration: BoxDecoration(
                                          color: colorAccent,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyText(
                                              color: white,
                                              text: "VIEW ALL",
                                              textalign: TextAlign.center,
                                              fontsize: 14,
                                              maxline: 1,
                                              overflow: TextOverflow.ellipsis,
                                              fontwaight: FontWeight.w500,
                                              fontstyle: FontStyle.normal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  studentAlsoView(),
                ],
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

  Widget childshimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          // Space Box Top of Child
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 80,
          ),
          // This Course included Box
          CustomWidget.roundcorner(
            height: MediaQuery.of(context).size.height * 0.10,
            width: MediaQuery.of(context).size.width,
          ),

          // // what you Learn Box
          CustomWidget.roundcorner(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
          ),
          // Requirmemt Box
          CustomWidget.roundcorner(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
          ), // Description Box
          CustomWidget.roundcorner(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 20),
          // Student also View with Text
          CustomWidget.roundrectborder(
            height: 10,
            width: MediaQuery.of(context).size.width * 0.50,
          ),
          const SizedBox(
            height: 10,
          ),
          // StudentAlso view List
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomWidget.roundrectborder(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomWidget.roundrectborder(
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // course conetent Text
          CustomWidget.roundrectborder(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.40,
          ),
          const SizedBox(
            height: 10,
          ),
          // course conetent Box
          CustomWidget.roundrectborder(
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
          // expandedList
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return CustomWidget.roundrectborder(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                );
              }),

          // created By Box
          CustomWidget.roundcorner(
            width: MediaQuery.of(context).size.width,
            height: 320,
          ),
          const SizedBox(height: 20),
          // Student Feddback Box
          CustomWidget.roundcorner(
            width: MediaQuery.of(context).size.width * 0.40,
            height: 320,
          ),
          const SizedBox(height: 20),
          CustomWidget.roundcorner(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.50,
          ),
        ],
      ),
    );
  }

  Widget buynowShimmer() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              color: colorAccent,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              color: white,
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: colorprimaryDark,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
                CustomWidget.roundrectborder(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: MediaQuery.of(context).size.width * 0.50,
                ),
                CustomWidget.roundrectborder(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                CustomWidget.roundrectborder(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                CustomWidget.roundrectborder(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget studentAlsoView() {
    return Consumer<CourseDetailsProvider>(
        builder: (context, courseDetailsData, child) {
      if (courseDetailsData
          .courseDetailsModel.result![0].studentFeedback!.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return Column(
          children: [
            MyText(
                color: colorAccent,
                text: "Student Feedback",
                fontsize: 18,
                fontwaight: FontWeight.w500,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: gray,
                    blurRadius: 5,
                    offset: Offset(0.0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Feadback UserList
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courseDetailsData
                        .courseDetailsModel.result?[0].studentFeedback?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                MyText(
                                    color: colorAccent,
                                    text: courseDetailsData
                                            .courseDetailsModel
                                            .result?[0]
                                            .studentFeedback?[index]
                                            .userName
                                            .toString() ??
                                        "",
                                    fontsize: 16,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                                const Spacer(),
                                MyRating(
                                    rating: double.parse((courseDetailsData
                                            .courseDetailsModel
                                            .result?[0]
                                            .studentFeedback?[index]
                                            .rating
                                            .toString() ??
                                        "")),
                                    spacing: 2,
                                    size: 18),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: MyText(
                                      color: gray,
                                      text: courseDetailsData
                                              .courseDetailsModel
                                              .result?[0]
                                              .studentFeedback?[index]
                                              .comment
                                              .toString() ??
                                          "",
                                      fontsize: 12,
                                      fontwaight: FontWeight.w500,
                                      maxline: 5,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            MyText(
                                color: gray,
                                text: Utils.formateDate(
                                    courseDetailsData
                                            .courseDetailsModel
                                            .result?[0]
                                            .studentFeedback?[index]
                                            .createdAt
                                            .toString() ??
                                        "",
                                    "d MMM yyyy"),
                                fontsize: 12,
                                fontwaight: FontWeight.w500,
                                maxline: 5,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}
