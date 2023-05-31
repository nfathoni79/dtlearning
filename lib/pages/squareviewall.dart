import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/homeprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SuqareViewall extends StatefulWidget {
  final String currencycode;
  const SuqareViewall({super.key, required this.currencycode});

  @override
  State<SuqareViewall> createState() => _SuqareViewallState();
}

class _SuqareViewallState extends State<SuqareViewall> {
  Constant constant = Constant();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.getCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: colorprimaryDark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: MyAppbar(
          backTap: () {
            Navigator.of(context).pop(false);
          },
          text: "Top Course in Design",
          startImg: "ic_back.svg",
          startImgcolor: white,
          textcolor: white,
          type: 1,
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, courceDataProvider, child) {
          if (courceDataProvider.loading) {
            return shimmer();
          } else {
            if (courceDataProvider.courseModel.status == 200 &&
                courceDataProvider.courseModel.result!.isNotEmpty) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                color: white,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 7 / 9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: courceDataProvider.courseModel.result?.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Detail(
                                currencycode: widget.currencycode,
                                  id: courceDataProvider
                                          .courseModel.result?[index].id
                                          .toString() ??
                                      "");
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(width: 1, color: orange),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: MyNetworkImage(
                                    imgWidth: MediaQuery.of(context).size.width,
                                    imgHeight:
                                        MediaQuery.of(context).size.height,
                                    fit: BoxFit.fill,
                                    imageUrl: courceDataProvider
                                            .courseModel.result?[index].image
                                            .toString() ??
                                        ""),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 90,
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 7),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MyText(
                                          color: black,
                                          text:
                                              "${widget.currencycode} ${courceDataProvider.courseModel.result?[index].price.toString() ?? ""}",
                                          fontsize: 14,
                                          fontwaight: FontWeight.w500,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                      const SizedBox(width: 4),
                                      MyText(
                                          color: black,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          text:
                                              "${widget.currencycode} ${courceDataProvider.courseModel.result?[index].oldPrice.toString() ?? ""}",
                                          fontsize: 10,
                                          fontwaight: FontWeight.w500,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  MyText(
                                      color: colorAccent,
                                      text: courceDataProvider
                                              .courseModel.result?[index].name
                                              .toString() ??
                                          "",
                                      fontsize: 12,
                                      fontwaight: FontWeight.w500,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      MyRating(
                                          rating: double.parse(
                                            courceDataProvider.courseModel
                                                    .result?[index].avgRating
                                                    .toString() ??
                                                "",
                                          ),
                                          spacing: 1,
                                          size: 10),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.070,
                                        child: MyText(
                                            color: colorAccent,
                                            text: courceDataProvider.courseModel
                                                    .result?[index].avgRating
                                                    .toString() ??
                                                "",
                                            fontsize: 10,
                                            fontwaight: FontWeight.w500,
                                            maxline: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ),
                                      MyText(
                                          color: colorAccent,
                                          text:
                                              "(${courceDataProvider.courseModel.result?[index].totalRating.toString() ?? ""})",
                                          fontsize: 10,
                                          fontwaight: FontWeight.w500,
                                          maxline: 1,
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
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

  Widget shimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      color: white,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 7 / 9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: white,
              border: Border.all(width: 1, color: orange),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CustomWidget.rectangular(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 7),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const SizedBox(height: 7),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.20,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
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
                          const SizedBox(width: 5),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.10,
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
