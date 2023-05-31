import 'dart:developer';

import 'package:dtlearning/pages/cart.dart';
import 'package:dtlearning/pages/detail.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/nodata.dart';
import 'package:dtlearning/provider/deletewishlistprovider.dart';
import 'package:dtlearning/provider/wishlistprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => WishListState();
}

class WishListState extends State<WishList> {
  Constant constant = Constant();
  late ProgressDialog prDialog;
  double? width;
  double? height;
  SharedPre sharedpre = SharedPre();
  String? userid, currencycode;

  @override
  initState() {
    super.initState();
    getdata();

    prDialog = ProgressDialog(context);
  }

  getdata() async {
    userid = await sharedpre.read("userid") ?? "";
    currencycode = await sharedpre.read("currency") ?? "";
    log("userid ==>$userid");
    callapi();
  }

  void callapi() async {
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    await wishlistProvider.wishlist(userid!);
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
                  text: constant.wishlist,
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
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.loading) {
            return wishlistshimmer();
          } else {
            if (wishlistProvider.wishlistmodel.status == 200 &&
                wishlistProvider.wishlistmodel.result!.isNotEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            wishlistProvider.wishlistmodel.result?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Detail(
                                        currencycode: currencycode,
                                        id: wishlistProvider
                                                .wishlistmodel.result?[index].id
                                                .toString() ??
                                            "");
                                  },
                                ),
                              );
                            },
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: const ActionPane(
                                motion: ScrollMotion(),
                                children: [],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  // delete Button
                                  SlidableAction(
                                    onPressed: (BuildContext context) async {
                                      final deletewishlistProvider =
                                          // ignore: use_build_context_synchronously
                                          Provider.of<DeletewishlistProvider>(
                                              context,
                                              listen: false);
                                      Utils.showProgress(context, prDialog);
                                      await deletewishlistProvider
                                          .deletewishlist(
                                              userid!,
                                              wishlistProvider.wishlistmodel
                                                      .result?[index].id
                                                      .toString() ??
                                                  "");

                                      if (deletewishlistProvider.loading) {
                                        Utils.pageLoader();
                                      } else {
                                        if (deletewishlistProvider
                                                .deletewishlistmodel.status ==
                                            200) {
                                          Utils().showToast(
                                              "${deletewishlistProvider.deletewishlistmodel.message}");
                                          prDialog.hide();
                                          // ReCall Wishlist Api
                                          setState(() {});
                                          callapi();
                                        } else {
                                          Utils().showToast(
                                              "${deletewishlistProvider.deletewishlistmodel.message}");
                                        }
                                      }
                                    },
                                    autoClose: true,
                                    backgroundColor: white,
                                    icon: Icons.delete,
                                    foregroundColor: colorprimaryDark,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                  color: black,
                                                  text: wishlistProvider
                                                          .wishlistmodel
                                                          .result?[index]
                                                          .name
                                                          .toString() ??
                                                      "",
                                                  maxline: 2,
                                                  fontwaight: FontWeight.w600,
                                                  fontsize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal),
                                              const SizedBox(height: 8),
                                              SizedBox(
                                                width: 200,
                                                child: MyText(
                                                    color: colorAccent,
                                                    text: wishlistProvider
                                                            .wishlistmodel
                                                            .result?[index]
                                                            .description
                                                            .toString() ??
                                                        "",
                                                    maxline: 2,
                                                    fontwaight: FontWeight.w500,
                                                    fontsize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textalign: TextAlign.left,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  MyText(
                                                      color: black,
                                                      text:
                                                          "$currencycode ${wishlistProvider.wishlistmodel.result?[index].price.toString() ?? ""}",
                                                      fontsize: 12,
                                                      fontwaight:
                                                          FontWeight.w600,
                                                      maxline: 2,
                                                      textalign: TextAlign.left,
                                                      fontstyle:
                                                          FontStyle.normal),
                                                  const SizedBox(width: 8),
                                                  MyRating(
                                                    size: 15,
                                                    rating: double.parse(
                                                      wishlistProvider
                                                              .wishlistmodel
                                                              .result?[index]
                                                              .avgRating
                                                              .toString() ??
                                                          "",
                                                    ),
                                                    spacing: 1,
                                                  ),
                                                  // RatingBar(
                                                  //   initialRating: 5,
                                                  //   direction: Axis.horizontal,
                                                  //   allowHalfRating: true,
                                                  //   itemCount: 5,
                                                  //   itemSize: 15,
                                                  //   ratingWidget: RatingWidget(
                                                  //     full: MySvg(
                                                  //         width: 5,
                                                  //         height: 5,
                                                  //         imagePath:
                                                  //             "ic_rating.svg"),
                                                  //     half: MySvg(
                                                  //         width: 5,
                                                  //         height: 5,
                                                  //         imagePath:
                                                  //             "ic_rating.svg"),
                                                  //     empty: MySvg(
                                                  //         width: 5,
                                                  //         height: 5,
                                                  //         color: orange,
                                                  //         imagePath:
                                                  //             "ic_norating.svg"),
                                                  //   ),
                                                  //   itemPadding:
                                                  //       const EdgeInsets.fromLTRB(
                                                  //           1, 0, 1, 0),
                                                  //   onRatingUpdate: (rating) {
                                                  //     debugPrint("$rating");
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        MyNetworkImage(
                                          imgWidth: 100,
                                          imgHeight: MediaQuery.of(context)
                                              .size
                                              .height,
                                          imageUrl: wishlistProvider
                                                  .wishlistmodel
                                                  .result?[index]
                                                  .image
                                                  .toString() ??
                                              "",
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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

  Widget wishlistshimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                              width: width! * 0.25,
                              height: height! * 0.01,
                            ),
                            const SizedBox(height: 8),
                            CustomWidget.roundrectborder(
                              width: width! * 0.30,
                              height: height! * 0.01,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                CustomWidget.roundrectborder(
                                  width: width! * 0.20,
                                  height: height! * 0.01,
                                ),
                                const SizedBox(width: 8),
                                RatingBar(
                                  initialRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 15,
                                  ratingWidget: RatingWidget(
                                    full: const CustomWidget.circular(
                                        height: 17, width: 17),
                                    half: const CustomWidget.circular(
                                        height: 17, width: 17),
                                    empty: const CustomWidget.circular(
                                        height: 17, width: 17),
                                  ),
                                  itemPadding:
                                      const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  onRatingUpdate: (rating) {
                                    debugPrint("$rating");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomWidget.rectangular(
                        width: 100,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
