import 'dart:developer';
import 'dart:io';
import 'package:dtlearning/pages/cart.dart';
import 'package:dtlearning/pages/categoryviewall.dart';
import 'package:dtlearning/pages/courselistbycategoryid.dart';
import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/squareviewall.dart';
import 'package:dtlearning/pages/tutorprofilepage.dart';
import 'package:dtlearning/pages/tutorviewall.dart';
import 'package:dtlearning/provider/homeprovider.dart';
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Featured extends StatefulWidget {
  const Featured({Key? key}) : super(key: key);

  @override
  State<Featured> createState() => FeaturedState();
}

class FeaturedState extends State<Featured> {
  SharedPre sharedpre = SharedPre();
  Constant constant = Constant();
  String? userid, currencycode;
  double? width;
  double? height;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    userid = await sharedpre.read("userid") ?? "";
    currencycode = await sharedpre.read("currency") ?? "";
    log("userid ==>$userid");
    _getapi();
  }

  void _getapi() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.getBanner();
    await homeProvider.getCategory();
    await homeProvider.gettopcourse();
    // await homeProvider.getCourse();
    await homeProvider.gettutor();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => alertdilog(context),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorprimaryDark,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                  color: white,
                  text: "Online Learning App",
                  maxline: 1,
                  fontwaight: FontWeight.w500,
                  fontsize: 16,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
              const Spacer(),
              InkWell(
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
                            userid: userid!,
                          );
                        },
                      ),
                    );
                  }
                },
                child: Container(
                  width: 25,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: MySvg(
                    width: 20,
                    height: 20,
                    imagePath: "ic_cart.svg",
                    color: white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                homeBanner(),
                category(),
                courseSuqare(),
                tutorlist(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Featured Banner
  Widget homeBanner() {
    return Stack(
      children: [
        Consumer<HomeProvider>(
          builder: (context, bannerdataProvider, child) {
            if (bannerdataProvider.loading) {
              return homebannerShimmer();
            } else {
              if (bannerdataProvider.bannerModel.status == 200 &&
                  bannerdataProvider.bannerModel.result!.isNotEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.26,
                      child: PageView.builder(
                          itemCount:
                              bannerdataProvider.bannerModel.result?.length,
                          controller: pageController,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Detail(
                                          currencycode: currencycode.toString(),
                                          id: bannerdataProvider.bannerModel
                                                  .result?[index].courseId
                                                  .toString() ??
                                              "");
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 15, 20, 15),
                                    decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: MyNetworkImage(
                                          imgWidth:
                                              MediaQuery.of(context).size.width,
                                          imgHeight: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.cover,
                                          imageUrl: bannerdataProvider
                                                  .bannerModel
                                                  .result?[index]
                                                  .image
                                                  ?.toString() ??
                                              ""),
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 50,
                                    left: 30,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: MyText(
                                            color: white,
                                            text: bannerdataProvider.bannerModel
                                                    .result?[index].name
                                                    ?.toString() ??
                                                "",
                                            fontsize: 14,
                                            fontwaight: FontWeight.w500,
                                            maxline: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 30, left: 30),
                                        child: MyText(
                                            color: white,
                                            text: Utils.formateDate(
                                                bannerdataProvider.bannerModel
                                                        .result?[index].date
                                                        ?.toString() ??
                                                    "",
                                                "d MMMM y"),
                                            fontsize: 10,
                                            fontwaight: FontWeight.w500,
                                            maxline: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.center,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      alignment: Alignment.topCenter,
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: bannerdataProvider.bannerModel.result!.length,
                        axisDirection: Axis.horizontal,
                        effect: const ExpandingDotsEffect(
                            spacing: 5,
                            radius: 50,
                            dotWidth: 5,
                            expansionFactor: 7,
                            dotColor: colorprimaryDark,
                            dotHeight: 5,
                            activeDotColor: orange),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        ),
      ],
    );
  }

  Widget homebannerShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.26,
          child: PageView.builder(
            itemCount: 3,
            controller: pageController,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomWidget.roundcorner(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 20,
          alignment: Alignment.topCenter,
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
                spacing: 5,
                radius: 50,
                dotWidth: 5,
                expansionFactor: 7,
                dotColor: gray.withOpacity(0.40),
                dotHeight: 5,
                activeDotColor: gray),
          ),
        ),
      ],
    );
  }

// Category
  Widget category() {
    return Consumer<HomeProvider>(
      builder: (context, categoryDataProvider, child) {
        if (categoryDataProvider.loading) {
          return categoryshimmer();
        } else {
          if (categoryDataProvider.categoryModel.status == 200 &&
              categoryDataProvider.categoryModel.result!.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(
                            color: colorprimaryDark,
                            text: constant.category,
                            fontsize: 14,
                            fontwaight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CategoryViewall(
                                        currencycode: currencycode!,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 4, 14, 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(width: 1, color: lightgray)),
                                child: MyText(
                                    color: colorprimaryDark,
                                    text: constant.viewall,
                                    fontsize: 10,
                                    fontwaight: FontWeight.w600,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.15,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        itemCount:
                            categoryDataProvider.categoryModel.result?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CourelistByCategoryid(
                                      currencycode: currencycode!,
                                      userid: categoryDataProvider
                                              .categoryModel.result?[index].id
                                              .toString() ??
                                          "",
                                      title: categoryDataProvider
                                              .categoryModel.result?[index].name
                                              .toString() ??
                                          "",
                                    );
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: MyNetworkImage(
                                    imgWidth: 60,
                                    imgHeight: 60,
                                    fit: BoxFit.fill,
                                    imageUrl: categoryDataProvider
                                            .categoryModel.result?[index].image
                                            .toString() ??
                                        "",
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: width! * 0.25,
                                  child: MyText(
                                      color: colorAccent,
                                      text: categoryDataProvider
                                              .categoryModel.result?[index].name
                                              .toString() ??
                                          "",
                                      fontsize: 12,
                                      fontwaight: FontWeight.w500,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget categoryshimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 15, width: MediaQuery.of(context).size.width * 0.30),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomWidget.roundrectborder(
                      height: 15,
                      width: MediaQuery.of(context).size.width * 0.20),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          padding: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerLeft,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CustomWidget.circular(height: 60, width: 60),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomWidget.roundrectborder(
                          height: 15,
                          width: MediaQuery.of(context).size.width * 0.15),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

// top Course (Square)
  Widget courseSuqare() {
    return Consumer<HomeProvider>(
      builder: (context, courceDataProvider, child) {
        if (courceDataProvider.loading) {
          return courseSquareShimmer();
        } else {
          if (courceDataProvider.topcourseModel.status == 200 &&
              courceDataProvider.topcourseModel.result!.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 330,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(
                            color: colorprimaryDark,
                            text: constant.topcourseindesign,
                            fontsize: 14,
                            fontwaight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SuqareViewall(
                                        currencycode: currencycode!,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 4, 14, 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(width: 1, color: lightgray)),
                                child: MyText(
                                    color: colorprimaryDark,
                                    text: constant.viewall,
                                    fontsize: 10,
                                    fontwaight: FontWeight.w600,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          courceDataProvider.topcourseModel.result?.length,
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
                                              .topcourseModel.result?[index].id
                                              .toString() ??
                                          "");
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 220,
                            height: 220,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(width: 1, color: orange),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  child: MyNetworkImage(
                                      imgWidth:
                                          MediaQuery.of(context).size.width,
                                      imgHeight:
                                          MediaQuery.of(context).size.height,
                                      fit: BoxFit.fill,
                                      imageUrl: courceDataProvider
                                              .topcourseModel
                                              .result?[index]
                                              .image
                                              .toString() ??
                                          ""),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: MyText(
                                                color: black,
                                                text:
                                                    "${currencycode.toString()} ${courceDataProvider.topcourseModel.result?[index].price}",
                                                fontsize: 16,
                                                fontwaight: FontWeight.w500,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.center,
                                                fontstyle: FontStyle.normal),
                                          ),
                                          SizedBox(
                                            width: width! * 0.009,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: MyText(
                                                color: black,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                text:
                                                    "${currencycode.toString()}${courceDataProvider.topcourseModel.result?[index].oldPrice}",
                                                fontsize: 12,
                                                fontwaight: FontWeight.w500,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.center,
                                                fontstyle: FontStyle.normal),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: MyText(
                                            color: colorAccent,
                                            text:
                                                "${courceDataProvider.topcourseModel.result?[index].name}",
                                            fontsize: 14,
                                            fontwaight: FontWeight.w500,
                                            maxline: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          MyRating(
                                            size: 15,
                                            rating: double.parse(
                                                (courceDataProvider
                                                        .topcourseModel
                                                        .result?[0]
                                                        .avgRating
                                                        .toString() ??
                                                    "")),
                                            spacing: 3,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            child: MyText(
                                                color: colorAccent,
                                                text: courceDataProvider
                                                        .topcourseModel
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
                                              color: colorAccent,
                                              text:
                                                  "(${courceDataProvider.topcourseModel.result?[index].totalRating.toString() ?? ""})",
                                              fontsize: 12,
                                              fontwaight: FontWeight.w500,
                                              maxline: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget courseSquareShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 15, width: MediaQuery.of(context).size.width * 0.30),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomWidget.roundrectborder(
                      height: 15,
                      width: MediaQuery.of(context).size.width * 0.20),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: orange),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CustomWidget.roundrectborder(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.20),
                            const SizedBox(height: 10),
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBar(
                                  initialRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 10,
                                  ratingWidget: RatingWidget(
                                    full: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    half: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    empty: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                  ),
                                  itemPadding:
                                      const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  onRatingUpdate: (rating) {
                                    debugPrint("$rating");
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomWidget.roundrectborder(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.30),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// Top TutorList
  Widget tutorlist() {
    return Consumer<HomeProvider>(
      builder: (context, tutorItem, child) {
        if (tutorItem.loading) {
          return tutorlistshimmer();
        } else {
          if (tutorItem.tutorModel.status == 200 &&
              tutorItem.tutorModel.result!.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(
                            color: colorprimaryDark,
                            text: constant.toptutor,
                            fontsize: 14,
                            fontwaight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TutorViewall(
                                        currencycode: currencycode.toString(),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 4, 14, 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(width: 1, color: lightgray)),
                                child: MyText(
                                    color: colorprimaryDark,
                                    text: constant.viewall,
                                    fontsize: 10,
                                    fontwaight: FontWeight.w600,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 70,
                              height: 1,
                              color: lightgray,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.21,
                    margin: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: tutorItem.tutorModel.result?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TutorProfilePage(
                                    currencycode: currencycode!,
                                    avgrating: tutorItem
                                            .tutorModel.result?[index].avgRating
                                            .toString() ??
                                        "",
                                    tutorid: tutorItem
                                            .tutorModel.result?[index].id
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: lightgray.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: MyNetworkImage(
                                      imgWidth: 70,
                                      imgHeight: 70,
                                      fit: BoxFit.fill,
                                      imageUrl: tutorItem
                                              .tutorModel.result?[index].image
                                              .toString() ??
                                          ""),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  child: MyText(
                                      color: colorprimaryDark,
                                      text: tutorItem.tutorModel.result?[index]
                                              .fullname
                                              .toString() ??
                                          "",
                                      fontsize: 14,
                                      fontwaight: FontWeight.w600,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.0050),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  child: MyText(
                                      color: colorPrimary,
                                      text:
                                          "${tutorItem.tutorModel.result?[index].totalCount.toString() ?? ""} Students",
                                      fontsize: 12,
                                      fontwaight: FontWeight.w400,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.0070),
                                MyRating(
                                  size: 15,
                                  rating: double.parse(tutorItem
                                          .tutorModel.result?[index].avgRating
                                          .toString() ??
                                      ""),
                                  spacing: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget tutorlistshimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.13,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                    height: 15,
                    width: MediaQuery.of(context).size.width * 0.30),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 1,
                      color: gray,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomWidget.roundrectborder(
                        height: 15,
                        width: MediaQuery.of(context).size.width * 0.20),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 70,
                      height: 1,
                      color: gray,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.21,
            margin: const EdgeInsets.fromLTRB(13, 0, 13, 0),
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: lightgray.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      const CustomWidget.circular(height: 70, width: 70),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      CustomWidget.roundcorner(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.40),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0050),
                      CustomWidget.roundcorner(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.20),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0050),
                      RatingBar(
                        initialRating: 5,
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

  alertdilog(BuildContext buildContext) {
    return showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Dialog(
              elevation: 16,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    MyText(
                      color: colorprimaryDark,
                      text: constant.onlinelearningapp,
                      maxline: 1,
                      fontwaight: FontWeight.w600,
                      fontsize: 16,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 15),
                    MyText(
                      color: pink,
                      text: constant.areyousureexit,
                      maxline: 1,
                      fontwaight: FontWeight.w500,
                      fontsize: 14,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            exit(0);
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colorprimaryDark,
                                borderRadius: BorderRadius.circular(5)),
                            child: MyText(
                              color: white,
                              text: constant.yes,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colorprimaryDark,
                                borderRadius: BorderRadius.circular(5)),
                            child: MyText(
                              color: white,
                              text: constant.cancel,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              bottom: 200,
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: MyImage(
                    width: 70,
                    height: 70,
                    imagePath: "ic_appicon.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// All Course (Landscap)
  // Widget courseLandscap() {
  //   return Consumer<HomeProvider>(
  //       builder: (context, courceDataProvider, child) {
  //     if (courceDataProvider.loading) {
  //       return courseLandscapShimmer();
  //     } else {
  //       if (courceDataProvider.courseModel.status == 200 &&
  //           courceDataProvider.courseModel.result!.isNotEmpty) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             MyText(
  //                 color: colorprimaryDark,
  //                 text: "All Course",
  //                 fontsize: 14,
  //                 fontwaight: FontWeight.w600,
  //                 maxline: 1,
  //                 overflow: TextOverflow.ellipsis,
  //                 textalign: TextAlign.center,
  //                 fontstyle: FontStyle.normal),
  //             const SizedBox(height: 10),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   width: 70,
  //                   height: 1,
  //                   color: lightgray,
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) {
  //                           return const LandscapViewall();
  //                         },
  //                       ),
  //                     );
  //                   },
  //                   child: Container(
  //                     width: 70,
  //                     height: 25,
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20),
  //                         border: Border.all(width: 1, color: lightgray)),
  //                     child: MyText(
  //                         color: colorAccent,
  //                         text: "View All",
  //                         fontsize: 10,
  //                         fontwaight: FontWeight.w500,
  //                         maxline: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         textalign: TextAlign.center,
  //                         fontstyle: FontStyle.normal),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Container(
  //                   width: 70,
  //                   height: 1,
  //                   color: lightgray,
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 10),
  //             Container(
  //               width: MediaQuery.of(context).size.width,
  //               alignment: Alignment.centerLeft,
  //               child: ListView.builder(
  //                 scrollDirection: Axis.vertical,
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemCount: courceDataProvider.courseModel.result?.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return InkWell(
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) {
  //                             return Detail(
  //                                 id: courceDataProvider
  //                                         .courseModel.result?[index].id
  //                                         .toString() ??
  //                                     "");
  //                           },
  //                         ),
  //                       );
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(
  //                           bottom: 20, left: 20, right: 20),
  //                       child: Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 140,
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                           color: white,
  //                           border: Border.all(width: 1, color: orange),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               width: MediaQuery.of(context).size.width,
  //                               height: 30,
  //                               alignment: Alignment.centerLeft,
  //                               child: Container(
  //                                 width: 100,
  //                                 height: MediaQuery.of(context).size.height,
  //                                 color: orange,
  //                                 alignment: Alignment.center,
  //                                 child: MyText(
  //                                     color: white,
  //                                     text: "BEST SELLER",
  //                                     fontsize: 10,
  //                                     fontwaight: FontWeight.w400,
  //                                     maxline: 2,
  //                                     textalign: TextAlign.left,
  //                                     fontstyle: FontStyle.normal),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               child: Container(
  //                                 width: MediaQuery.of(context).size.width,
  //                                 margin:
  //                                     const EdgeInsets.fromLTRB(10, 5, 5, 0),
  //                                 child: Row(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     const SizedBox(width: 10),
  //                                     SizedBox(
  //                                       width: 60,
  //                                       height: 60,
  //                                       child: ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(50),
  //                                         child: MyNetworkImage(
  //                                             imgWidth: MediaQuery.of(context)
  //                                                 .size
  //                                                 .width,
  //                                             imgHeight: MediaQuery.of(context)
  //                                                 .size
  //                                                 .height,
  //                                             fit: BoxFit.fill,
  //                                             imageUrl: courceDataProvider
  //                                                     .courseModel
  //                                                     .result?[index]
  //                                                     .image
  //                                                     .toString() ??
  //                                                 ""),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 25),
  //                                     Column(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         MyText(
  //                                             color: black,
  //                                             text: courceDataProvider
  //                                                     .courseModel
  //                                                     .result?[index]
  //                                                     .name
  //                                                     .toString() ??
  //                                                 "",
  //                                             fontsize: 14,
  //                                             fontwaight: FontWeight.w500,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             maxline: 2,
  //                                             textalign: TextAlign.left,
  //                                             fontstyle: FontStyle.normal),
  //                                         const SizedBox(height: 5),
  //                                         MyText(
  //                                             color: colorAccent,
  //                                             text: "365 Careers",
  //                                             fontsize: 12,
  //                                             fontwaight: FontWeight.w400,
  //                                             maxline: 2,
  //                                             textalign: TextAlign.left,
  //                                             fontstyle: FontStyle.normal),
  //                                         const SizedBox(height: 5),
  //                                         Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.start,
  //                                           children: [
  //                                             RatingBar(
  //                                               initialRating: 5,
  //                                               direction: Axis.horizontal,
  //                                               allowHalfRating: true,
  //                                               itemCount: 5,
  //                                               itemSize: 10,
  //                                               ratingWidget: RatingWidget(
  //                                                 full: MySvg(
  //                                                     width: 5,
  //                                                     height: 5,
  //                                                     imagePath:
  //                                                         "ic_rating.svg"),
  //                                                 half: MySvg(
  //                                                     width: 5,
  //                                                     height: 5,
  //                                                     imagePath:
  //                                                         "ic_rating.svg"),
  //                                                 empty: MySvg(
  //                                                     width: 5,
  //                                                     height: 5,
  //                                                     imagePath:
  //                                                         "ic_rating.svg"),
  //                                               ),
  //                                               itemPadding:
  //                                                   const EdgeInsets.fromLTRB(
  //                                                       1, 0, 1, 0),
  //                                               onRatingUpdate: (rating) {
  //                                                 debugPrint("$rating");
  //                                               },
  //                                             ),
  //                                             const SizedBox(width: 10),
  //                                             MyText(
  //                                                 color: black,
  //                                                 text: "4.7(40,213)",
  //                                                 fontsize: 12,
  //                                                 fontwaight: FontWeight.w600,
  //                                                 maxline: 2,
  //                                                 textalign: TextAlign.left,
  //                                                 fontstyle: FontStyle.normal),
  //                                           ],
  //                                         ),
  //                                         const SizedBox(height: 5),
  //                                         MyText(
  //                                             color: black,
  //                                             text: courceDataProvider
  //                                                 .courseModel
  //                                                 .result![index]
  //                                                 .price
  //                                                 .toString(),
  //                                             fontsize: 12,
  //                                             fontwaight: FontWeight.w600,
  //                                             maxline: 2,
  //                                             textalign: TextAlign.left,
  //                                             fontstyle: FontStyle.normal),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     }
  //   });
  // }

  // Widget courseLandscapShimmer() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       CustomWidget.roundrectborder(
  //           height: 15, width: MediaQuery.of(context).size.width * 0.30),
  //       const SizedBox(height: 10),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             width: 70,
  //             height: 1,
  //             color: pink,
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           CustomWidget.roundrectborder(
  //               height: 15, width: MediaQuery.of(context).size.width * 0.20),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           Container(
  //             width: 70,
  //             height: 1,
  //             color: pink,
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //       Container(
  //         width: MediaQuery.of(context).size.width,
  //         alignment: Alignment.centerLeft,
  //         child: ListView.builder(
  //           scrollDirection: Axis.vertical,
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: 3,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: 140,
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                   color: white,
  //                   border: Border.all(width: 1, color: orange),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: CustomWidget.rectangular(
  //                           height: 20,
  //                           width: MediaQuery.of(context).size.width * 0.25),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         margin: const EdgeInsets.fromLTRB(10, 5, 5, 0),
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             const SizedBox(width: 10),
  //                             SizedBox(
  //                               width: 60,
  //                               height: 60,
  //                               child: CustomWidget.circular(
  //                                   height: MediaQuery.of(context).size.height,
  //                                   width: MediaQuery.of(context).size.width),
  //                             ),
  //                             const SizedBox(width: 25),
  //                             Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 CustomWidget.roundrectborder(
  //                                     height: 10,
  //                                     width: MediaQuery.of(context).size.width *
  //                                         0.30),
  //                                 const SizedBox(height: 5),
  //                                 CustomWidget.roundrectborder(
  //                                     height: 10,
  //                                     width: MediaQuery.of(context).size.width *
  //                                         0.25),
  //                                 const SizedBox(height: 5),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     RatingBar(
  //                                       initialRating: 5,
  //                                       direction: Axis.horizontal,
  //                                       allowHalfRating: true,
  //                                       itemCount: 5,
  //                                       itemSize: 10,
  //                                       ratingWidget: RatingWidget(
  //                                         full: const CustomWidget
  //                                                 .roundrectborder(
  //                                             height: 15, width: 15),
  //                                         half: const CustomWidget
  //                                                 .roundrectborder(
  //                                             height: 15, width: 15),
  //                                         empty: const CustomWidget
  //                                                 .roundrectborder(
  //                                             height: 15, width: 15),
  //                                       ),
  //                                       itemPadding: const EdgeInsets.fromLTRB(
  //                                           1, 0, 1, 0),
  //                                       onRatingUpdate: (rating) {
  //                                         debugPrint("$rating");
  //                                       },
  //                                     ),
  //                                     const SizedBox(width: 10),
  //                                     CustomWidget.roundrectborder(
  //                                         height: 10,
  //                                         width: MediaQuery.of(context)
  //                                                 .size
  //                                                 .width *
  //                                             0.20),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 5),
  //                                 CustomWidget.roundrectborder(
  //                                     height: 10,
  //                                     width: MediaQuery.of(context).size.width *
  //                                         0.20),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
