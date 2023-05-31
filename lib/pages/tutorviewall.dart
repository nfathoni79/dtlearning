import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/pages/tutorprofilepage.dart';
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

class TutorViewall extends StatefulWidget {
  final String currencycode;
  const TutorViewall({super.key, required this.currencycode});

  @override
  State<TutorViewall> createState() => _TutorViewallState();
}

class _TutorViewallState extends State<TutorViewall> {
  Constant constant = Constant();

  @override
  void initState() {
    super.initState();
    _getapi();
  }

  _getapi() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.gettutor();
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
          startImg: "ic_back.svg",
          text: constant.alltutor,
          startImgcolor: white,
          textcolor: white,
          type: 1,
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, tutorItem, child) {
          if (tutorItem.loading) {
            return tutorlistshimmer();
          } else {
            if (tutorItem.tutorModel.status == 200 &&
                tutorItem.tutorModel.result!.isNotEmpty) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.all(15),
                color: white,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: tutorItem.tutorModel.result!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return TutorProfilePage(
                                currencycode: widget.currencycode,
                                avgrating: tutorItem
                                        .tutorModel.result?[index].avgRating
                                        .toString() ??
                                    "",
                                tutorid: tutorItem.tutorModel.result?[index].id
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
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: MyText(
                                  color: colorprimaryDark,
                                  text: tutorItem
                                          .tutorModel.result?[index].fullname
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
                                    0.0070),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: MyText(
                                  color: colorPrimary,
                                  text:
                                      "${tutorItem.tutorModel.result?[index].totalTutorCount.toString() ?? ""} Courses",
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
              );
            } else {
              return const NoData();
            }
          }
        },
      ),
    );
  }

  Widget tutorlistshimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.all(15),
      color: white,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, index) {
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
                    height: 7, width: MediaQuery.of(context).size.width * 0.40),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0070),
                CustomWidget.roundcorner(
                    height: 7, width: MediaQuery.of(context).size.width * 0.20),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0070),
                RatingBar(
                  initialRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 10,
                  ratingWidget: RatingWidget(
                    full: const CustomWidget.circular(height: 15, width: 15),
                    half: const CustomWidget.circular(height: 15, width: 15),
                    empty: const CustomWidget.circular(height: 15, width: 15),
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
    );
  }
}
