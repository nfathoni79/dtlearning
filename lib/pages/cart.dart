import 'dart:convert';
import 'dart:developer';
import 'package:dtlearning/model/courseidmodel.dart';
import 'package:dtlearning/pages/checkout.dart';
import 'package:dtlearning/provider/cartprovider.dart';
import 'package:dtlearning/provider/deletecartprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/myrating.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  final String userid;
  const Cart({Key? key, required this.userid}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late ProgressDialog prDialog;
  var sum = [];
  dynamic amount = 0.0;
  double? finalprice;
  String? couponid;
  bool isapply = false;

  @override
  initState() {
    super.initState();
    callapi();
    log("userid=>${widget.userid}");
    prDialog = ProgressDialog(context);
  }

  callapi() async {
    final cartItem = Provider.of<CartlistProvider>(context, listen: false);
    await cartItem.getcartbyuser(widget.userid);

    await cartItem.getcouponlit();

    for (int i = 0; i < cartItem.cartbyuserModel.result!.length; i++) {
      sum.add(int.parse(cartItem.cartbyuserModel.result![i].price.toString()));
    }

    amount = sum.reduce((value, element) => value + element);
    debugPrint(amount.toString());
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    log("close");
    sum.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorprimaryDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: MyAppbar(
          type: 1,
          startImg: "ic_back.svg",
          startImgcolor: white,
          backTap: () {
            Navigator.of(context).pop(false);
          },
          text: "Cart",
          textcolor: white,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  cartList(),
                  const SizedBox(height: 10),
                  couponList(),
                ],
              ),
            ),
          ),
          Consumer<CartlistProvider>(builder: (context, cartItem, child) {
            return Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          log("cart lenght=${cartItem.cartbyuserModel.result!.length}");
                          if (cartItem.cartbyuserModel.result!.isNotEmpty) {
                            List<String>? coursedetailArray = <String>[];

                            for (int i = 0;
                                i < cartItem.cartbyuserModel.result!.length;
                                i++) {
                              CourseidModel courseidModel = CourseidModel();
                              courseidModel.courseId = cartItem
                                      .cartbyuserModel.result?[i].id
                                      .toString() ??
                                  "";
                              courseidModel.price = cartItem
                                      .cartbyuserModel.result?[i].price
                                      .toString() ??
                                  "";

                              Map<String, dynamic> map = {
                                'course_id': courseidModel.courseId,
                                'price': courseidModel.price
                              };

                              String rawJson = jsonEncode(map);
                              coursedetailArray.add(rawJson);
                            }

                            log('===> jsonarray $coursedetailArray');
                            log('===> userid ${widget.userid}');
                            log('===> paymenttype $couponid');
                            log('===> paymenttype $amount');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Checkout(
                                    couponid: couponid.toString(),
                                    coursedetail: coursedetailArray.toString(),
                                    discountamount: amount.toString(),
                                    userid: widget.userid.toString(),
                                  );
                                },
                              ),
                            );
                          } else {
                            Utils().showToast(
                                "Cart is Empty Please Add Some Course in Cart");
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: colorprimaryDark,
                          alignment: Alignment.center,
                          child: MyText(
                              color: white,
                              text: "CHECKOUT",
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: colorAccent,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (((cartItem.cartbyuserModel.result?.length ?? 0) !=
                                    0))
                                ? MyText(
                                    color: white,
                                    text: "\$ ${amount.toString()}",
                                    maxline: 1,
                                    fontwaight: FontWeight.w600,
                                    fontsize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal)
                                : MyText(
                                    color: white,
                                    text: "\$ 0.0",
                                    maxline: 1,
                                    fontwaight: FontWeight.w600,
                                    fontsize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                            const SizedBox(
                              height: 5,
                            ),
                            MyText(
                                color: white,
                                text: "TOTAL AMOUNT",
                                maxline: 1,
                                fontwaight: FontWeight.w400,
                                fontsize: 10,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

// Cart List
  Widget cartList() {
    return Consumer<CartlistProvider>(builder: (context, cartItem, child) {
      if (cartItem.loading) {
        return cartListShimmer();
      } else {
        if (cartItem.cartbyuserModel.status == 200 &&
            cartItem.cartbyuserModel.result!.isNotEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItem.cartbyuserModel.result?.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  key: const ValueKey(0),
                  direction: Axis.horizontal,
                  closeOnScroll: true,
                  startActionPane: const ActionPane(
                    motion: ScrollMotion(),
                    // dismissible: DismissiblePane(onDismissed: () async {
                    //   final deletecartItem = Provider.of<DeleteCartProvider>(
                    //       context,
                    //       listen: false);

                    //   deletecartItem.getcartdelete(
                    //       widget.userid,
                    //       cartItem.cartbyuserModel.result?[index].id
                    //               .toString() ??
                    //           "");
                    //   sum.clear();
                    //   final cartlist =
                    //       Provider.of<CartlistProvider>(context, listen: false);

                    //   await cartlist.getcartbyuser(widget.userid);

                    //   for (int i = 0;
                    //       i < cartItem.cartbyuserModel.result!.length;
                    //       i++) {
                    //     sum.add(int.parse(cartItem
                    //         .cartbyuserModel.result![i].price
                    //         .toString()));
                    //   }

                    //   amount = sum.reduce((value, element) => value + element);
                    //   debugPrint(amount.toString());

                    //   if (isapply == true) {
                    //     double listprice = double.parse(amount.toString());
                    //     double discout = 20;
                    //     double discoutprice = (discout / 100) * listprice;
                    //     finalprice = listprice - discoutprice;
                    //     amount = finalprice;
                    //   }
                    //   setState(() {});
                    // }),

                    dragDismissible: true,
                    children: [],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      // delete Button
                      SlidableAction(
                        onPressed: (BuildContext context) async {
                          final deletecartItem =
                              Provider.of<DeleteCartProvider>(context,
                                  listen: false);

                          deletecartItem.getcartdelete(
                              widget.userid,
                              cartItem.cartbyuserModel.result?[index].id
                                      .toString() ??
                                  "");
                          sum.clear();
                          final cartlist = Provider.of<CartlistProvider>(
                              context,
                              listen: false);

                          await cartlist.getcartbyuser(widget.userid);

                          for (int i = 0;
                              i < cartItem.cartbyuserModel.result!.length;
                              i++) {
                            sum.add(int.parse(cartItem
                                .cartbyuserModel.result![i].price
                                .toString()));
                          }

                          amount =
                              sum.reduce((value, element) => value + element);
                          debugPrint(amount.toString());

                          if (isapply == true) {
                            double listprice = double.parse(amount.toString());
                            double discout = 20;
                            double discoutprice = (discout / 100) * listprice;
                            finalprice = listprice - discoutprice;
                            amount = finalprice;
                          }
                          setState(() {});
                        },
                        backgroundColor: black,
                        icon: Icons.delete,
                        autoClose: true,
                        foregroundColor: colorprimaryDark,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyNetworkImage(
                              imgWidth: 120,
                              imgHeight: MediaQuery.of(context).size.height,
                              imageUrl: cartItem
                                      .cartbyuserModel.result?[index].image
                                      .toString() ??
                                  "",
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: MyText(
                                            color: colorprimaryDark,
                                            text:
                                                "\$ ${cartItem.cartbyuserModel.result?[index].price.toString() ?? ""}",
                                            maxline: 1,
                                            fontwaight: FontWeight.w600,
                                            fontsize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.center,
                                            fontstyle: FontStyle.normal),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: MyText(
                                            color: colorAccent,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            text:
                                                "\$ ${cartItem.cartbyuserModel.result?[index].oldPrice.toString() ?? ""}",
                                            maxline: 1,
                                            fontwaight: FontWeight.w400,
                                            fontsize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.end,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  SizedBox(
                                    width: 150,
                                    child: MyText(
                                        color: colorAccent,
                                        text: cartItem.cartbyuserModel
                                                .result?[index].name
                                                .toString() ??
                                            "",
                                        maxline: 1,
                                        fontwaight: FontWeight.w500,
                                        fontsize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      MyRating(
                                          rating: double.parse((cartItem
                                                  .cartbyuserModel
                                                  .result?[index]
                                                  .avgRating
                                                  .toString() ??
                                              "")),
                                          spacing: 1,
                                          size: 10),
                                      const SizedBox(width: 7),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: MyText(
                                                color: black,
                                                text: cartItem
                                                        .cartbyuserModel
                                                        .result?[index]
                                                        .avgRating
                                                        .toString() ??
                                                    "",
                                                fontsize: 10,
                                                fontwaight: FontWeight.w600,
                                                maxline: 1,
                                                textalign: TextAlign.left,
                                                fontstyle: FontStyle.normal),
                                          ),
                                          MyText(
                                              color: black,
                                              text:
                                                  "(${cartItem.cartbyuserModel.result?[index].totalRating.toString() ?? ""})",
                                              fontsize: 10,
                                              fontwaight: FontWeight.w600,
                                              maxline: 1,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: MyText(
                color: black,
                text: "Cart is Empty",
                maxline: 1,
                fontwaight: FontWeight.w600,
                fontsize: 14,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          );
        }
      }
    });
  }

  cartListShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomWidget.rectangular(
                        width: 100,
                        height: MediaQuery.of(context).size.height,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                          ],
                        ),
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

// couponcode List
  Widget couponList() {
    return Consumer<CartlistProvider>(builder: (context, cartItem, child) {
      if (cartItem.loading) {
        return couponlistshimmer();
      } else {
        if (cartItem.couponlistModel.status == 200 &&
            cartItem.couponlistModel.result!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                color: lightgray,
                alignment: Alignment.centerLeft,
                child: MyText(
                    color: black,
                    text: "Coupon Code",
                    maxline: 1,
                    fontwaight: FontWeight.w600,
                    fontsize: 14,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: cartItem.couponlistModel.result?.length ?? 0,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    itemBuilder: (BuildContext ctx, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                      color: colorAccent,
                                      text: cartItem.couponlistModel
                                              .result?[index].couponCode
                                              .toString() ??
                                          "",
                                      maxline: 1,
                                      fontwaight: FontWeight.w500,
                                      fontsize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                  const SizedBox(height: 5),
                                  MyText(
                                      color: colorAccent,
                                      text: "Discount if You apply coupon code",
                                      maxline: 1,
                                      fontwaight: FontWeight.w400,
                                      fontsize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                ],
                              ),
                              Container(
                                width: 35,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.circular(5)),
                                child: MyText(
                                    color: black,
                                    text: "20%",
                                    maxline: 1,
                                    fontwaight: FontWeight.w500,
                                    fontsize: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              if (isapply == false) {
                                double listprice =
                                    double.parse(amount.toString());

                                //this is percentage
                                double discout = 20;

                                double discoutprice =
                                    (discout / 100) * listprice;

                                finalprice = listprice - discoutprice;

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        elevation: 16,
                                        child: Container(
                                          width: 450,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 15, 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MyText(
                                                        color: colorAccent,
                                                        text:
                                                            "Apply Coupon Code",
                                                        maxline: 1,
                                                        fontwaight:
                                                            FontWeight.w500,
                                                        fontsize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textalign:
                                                            TextAlign.center,
                                                        fontstyle:
                                                            FontStyle.normal),
                                                    MyImage(
                                                        width: 20,
                                                        height: 20,
                                                        color: colorAccent,
                                                        imagePath: "ic_eye.png")
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                child: Container(
                                                  width: 35,
                                                  height: 20,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: MyText(
                                                      color: black,
                                                      text: "20%",
                                                      maxline: 1,
                                                      fontwaight:
                                                          FontWeight.w500,
                                                      fontsize: 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textalign:
                                                          TextAlign.center,
                                                      fontstyle:
                                                          FontStyle.normal),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MyText(
                                                            color: gray,
                                                            text:
                                                                "Your Coupon Code",
                                                            maxline: 1,
                                                            fontwaight:
                                                                FontWeight.w500,
                                                            fontsize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textalign: TextAlign
                                                                .center,
                                                            fontstyle: FontStyle
                                                                .normal),
                                                        const SizedBox(
                                                            height: 10),
                                                        MyText(
                                                            color: black,
                                                            text: cartItem
                                                                    .couponlistModel
                                                                    .result?[
                                                                        index]
                                                                    .couponCode
                                                                    .toString() ??
                                                                "",
                                                            maxline: 1,
                                                            fontwaight:
                                                                FontWeight.w600,
                                                            fontsize: 14,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textalign: TextAlign
                                                                .center,
                                                            fontstyle: FontStyle
                                                                .normal),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MyText(
                                                            color: gray,
                                                            text:
                                                                "Total Amount",
                                                            maxline: 1,
                                                            fontwaight:
                                                                FontWeight.w500,
                                                            fontsize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textalign: TextAlign
                                                                .center,
                                                            fontstyle: FontStyle
                                                                .normal),
                                                        const SizedBox(
                                                            height: 10),
                                                        MyText(
                                                            color: colorAccent,
                                                            text:
                                                                "\$ $finalprice",
                                                            maxline: 1,
                                                            fontwaight:
                                                                FontWeight.w600,
                                                            fontsize: 14,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textalign: TextAlign
                                                                .center,
                                                            fontstyle: FontStyle
                                                                .normal),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Divider(
                                                        color: lightgray,
                                                        thickness: 1,
                                                        height: 1,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              height: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: MyText(
                                                                  color: gray,
                                                                  text:
                                                                      "CANCEL",
                                                                  maxline: 1,
                                                                  fontwaight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontsize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textalign:
                                                                      TextAlign
                                                                          .center,
                                                                  fontstyle:
                                                                      FontStyle
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 50,
                                                            width: 1,
                                                            color: lightgray,
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              isapply = true;
                                                              setState(() {
                                                                amount =
                                                                    finalprice;
                                                              });
                                                              Utils
                                                                  .showProgress(
                                                                      context,
                                                                      prDialog);
                                                              await cartItem.getapplycoupon(
                                                                  widget.userid
                                                                      .toString(),
                                                                  cartItem
                                                                          .couponlistModel
                                                                          .result?[
                                                                              index]
                                                                          .couponCode
                                                                          .toString() ??
                                                                      "");

                                                              if (cartItem
                                                                  .loading) {
                                                                // ignore: use_build_context_synchronously
                                                                Utils.showProgress(
                                                                    context,
                                                                    prDialog);
                                                              } else {
                                                                if (cartItem
                                                                        .applycouponModel
                                                                        .status ==
                                                                    200) {
                                                                  Utils().showToast(
                                                                      "${cartItem.applycouponModel.message}");
                                                                  prDialog
                                                                      .hide();
                                                                } else {
                                                                  Utils().showToast(
                                                                      "${cartItem.applycouponModel.message}");
                                                                  prDialog
                                                                      .hide();
                                                                }
                                                              }

                                                              couponid = cartItem
                                                                      .couponlistModel
                                                                      .result?[
                                                                          index]
                                                                      .id
                                                                      .toString() ??
                                                                  "";

                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              height: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: MyText(
                                                                  color: black,
                                                                  text:
                                                                      "CHECKOUT",
                                                                  maxline: 1,
                                                                  fontwaight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textalign:
                                                                      TextAlign
                                                                          .center,
                                                                  fontstyle:
                                                                      FontStyle
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                Utils()
                                    .showToast("Apply Coupon Only First Time");
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: colorAccent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: MyText(
                                  color: white,
                                  text: "APPLY CODE",
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  fontsize: 10,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.center,
                                  fontstyle: FontStyle.normal),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: gray,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                        ],
                      );
                    }),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          );
        } else {
          return Column(
            children: [
              MyImage(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.50,
                fit: BoxFit.contain,
                imagePath: "nodata.png",
              ),
              MyText(
                  color: black,
                  text: "Coupon is Empty",
                  maxline: 1,
                  fontwaight: FontWeight.w600,
                  fontsize: 14,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
            ],
          );
        }
      }
    });
  }

  Widget couponlistshimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.rectangular(
          height: 40,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 4,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              itemBuilder: (BuildContext ctx, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomWidget.roundrectborder(
                              height:
                                  MediaQuery.of(context).size.height * 0.0150,
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                            const SizedBox(height: 5),
                            CustomWidget.roundrectborder(
                              height:
                                  MediaQuery.of(context).size.height * 0.0150,
                              width: MediaQuery.of(context).size.width * 0.50,
                            ),
                          ],
                        ),
                        const CustomWidget.roundcorner(
                          height: 20,
                          width: 35,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomWidget.roundrectborder(
                      width: MediaQuery.of(context).size.height * 0.14,
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: gray,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                );
              }),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.09),
      ],
    );
  }
}
