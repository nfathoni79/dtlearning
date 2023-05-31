import 'dart:developer';
import 'package:dtlearning/pages/aboutus.dart';
import 'package:dtlearning/pages/editprofile.dart';
import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/pages/privacypolicy.dart';
import 'package:dtlearning/pages/refundpolicy.dart';
import 'package:dtlearning/pages/termscondition.dart';
import 'package:dtlearning/provider/profileprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/customwidget.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => AccountState();
}

class AccountState extends State<Account> {
  SharedPre sharedpre = SharedPre();
  Constant constant = Constant();
  bool isSwitchOn = false;
  String? userid = "", currencycode;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    userid = await sharedpre.read("userid") ?? "";
    currencycode = await sharedpre.read("currency") ?? "";
    log("userid ==>$userid");
    callapi();
  }

  void callapi() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getProfile(userid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorprimaryDark,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      MyImage(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.32,
                          fit: BoxFit.cover,
                          imagePath: "ic_profilebg.png"),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.06,
                        color: colorprimaryDark,
                      ),
                    ],
                  ),
                  // Profile Text With Edit Icon
                  Positioned.fill(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            color: white,
                            text: constant.profile,
                            maxline: 1,
                            fontwaight: FontWeight.w600,
                            fontsize: 16,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal,
                          ),
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
                                      return EditProfile(
                                        userid: userid!,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            child: MySvg(
                              width: 20,
                              height: 20,
                              imagePath: "ic_edit.svg",
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                // color: pink,
                                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                color: colorAccent,
                              ),
                            ],
                          ),
                          // UserImage and Username (Profile Item)
                          Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                            if (profileProvider.loading) {
                              if (userid!.isEmpty) {
                                return Positioned.fill(
                                  bottom: 20,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: MyImage(
                                              width: 100,
                                              height: 100,
                                              imagePath: "ic_user.png"),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyText(
                                            color: white,
                                            text: "Guest User",
                                            fontsize: 14,
                                            maxline: 1,
                                            fontwaight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.center,
                                            fontstyle: FontStyle.normal)
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return profileshimmer();
                              }
                            } else {
                              log("item");
                              return Positioned.fill(
                                bottom: 20,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: (profileProvider
                                                        .profileModel.status ==
                                                    200 &&
                                                ((profileProvider
                                                            .profileModel
                                                            .result?[0]
                                                            .image
                                                            ?.length ??
                                                        0) !=
                                                    0))
                                            ? MyNetworkImage(
                                                imgWidth: 100,
                                                imgHeight: 100,
                                                fit: BoxFit.fill,
                                                imageUrl: profileProvider
                                                        .profileModel
                                                        .result?[0]
                                                        .image
                                                        .toString() ??
                                                    "",
                                              )
                                            : MyImage(
                                                width: 100,
                                                height: 100,
                                                imagePath: "ic_user.png"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MyText(
                                          color: white,
                                          text: (profileProvider.profileModel
                                                          .status ==
                                                      200 &&
                                                  (profileProvider
                                                              .profileModel
                                                              .result?[0]
                                                              .fullname
                                                              .toString() ??
                                                          "")
                                                      .isEmpty)
                                              ? (profileProvider.profileModel
                                                      .result?[0].email
                                                      .toString() ??
                                                  "Guest User")
                                              : profileProvider.profileModel
                                                          .status ==
                                                      200
                                                  ? (profileProvider
                                                          .profileModel
                                                          .result?[0]
                                                          .fullname
                                                          .toString() ??
                                                      "Guest User")
                                                  : "",
                                          fontsize: 14,
                                          maxline: 1,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.center,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              // Account All Item
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: colorprimaryDark,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(50)),
                            child: MySvg(
                              width: 25,
                              height: 25,
                              imagePath: "ic_notification.svg",
                              color: colorprimaryDark,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          MyText(
                            color: white,
                            text: constant.pushnotification,
                            maxline: 1,
                            fontwaight: FontWeight.w500,
                            fontsize: 14,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal,
                          ),
                          const Spacer(),
                          // Switch Button Account Page
                          FlutterSwitch(
                            width: 50,
                            height: 25,
                            value: isSwitchOn,
                            onToggle: (value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                              if (isSwitchOn == true) {
                                Utils().showToast("Notification On");
                              } else {
                                Utils().showToast("Notification Off");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
                                return EditProfile(
                                  userid: userid!,
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MySvg(
                                width: 25,
                                height: 25,
                                imagePath: "ic_editprofile.svg",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.editprofile,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AboutUs();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MySvg(
                                width: 25,
                                height: 25,
                                imagePath: "ic_aboutus.svg",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.aboutus,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const PrivacyPolicy();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MySvg(
                                width: 25,
                                height: 25,
                                imagePath: "ic_privacypolicy.svg",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.privacypolicy,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TermsCondition();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MyImage(
                                width: 25,
                                height: 25,
                                imagePath: "ic_tc.png",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.termscondition,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const RefundPolicy();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MySvg(
                                width: 25,
                                height: 25,
                                imagePath: "ic_privacypolicy.svg",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.refandpolicy,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) {
                    //           return const ContactUs();
                    //         },
                    //       ),
                    //     );
                    //   },
                    //   child: Container(
                    //     height: 50,
                    //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //     color: colorprimaryDark,
                    //     alignment: Alignment.center,
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           width: 35,
                    //           height: 35,
                    //           alignment: Alignment.center,
                    //           decoration: BoxDecoration(
                    //               color: white,
                    //               borderRadius: BorderRadius.circular(50)),
                    //           child: MyImage(
                    //             width: 25,
                    //             height: 25,
                    //             imagePath: "ic_call.png",
                    //             color: colorprimaryDark,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 15,
                    //         ),
                    //         MyText(
                    //           color: white,
                    //           text: constant.contactus,
                    //           maxline: 1,
                    //           fontwaight: FontWeight.w500,
                    //           fontsize: 14,
                    //           overflow: TextOverflow.ellipsis,
                    //           textalign: TextAlign.center,
                    //           fontstyle: FontStyle.normal,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        if (userid == "" && userid!.isEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Login();
                              },
                            ),
                          );
                        } else {
                          showDialog(
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
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            text: constant
                                                .areyousurewanttodeleteaccount,
                                            maxline: 2,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.center,
                                            fontstyle: FontStyle.normal,
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  clearStorage();
                                                  Navigator.pop(context);
                                                  Utils().showToast(
                                                      "Account Delete Successfully");

                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return const Login();
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: colorprimaryDark,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: MyText(
                                                    color: white,
                                                    text: constant.yes,
                                                    maxline: 1,
                                                    fontwaight: FontWeight.w500,
                                                    fontsize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: MyText(
                                                    color: white,
                                                    text: constant.cancel,
                                                    maxline: 1,
                                                    fontwaight: FontWeight.w500,
                                                    fontsize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MyImage(
                                width: 25,
                                height: 25,
                                imagePath: "ic_delete.png",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MyText(
                              color: white,
                              text: constant.deleteaccount,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsize: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (userid == "" || userid!.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Login();
                              },
                            ),
                          );
                        } else {
                          showDialog(
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
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            text:
                                                constant.areyousurewanttologout,
                                            maxline: 1,
                                            fontwaight: FontWeight.w500,
                                            fontsize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.center,
                                            fontstyle: FontStyle.normal,
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  clearStorage();
                                                  Navigator.pop(context);
                                                  Utils().showToast(
                                                      "Logout Successfully");

                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const Login()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: colorprimaryDark,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: MyText(
                                                    color: white,
                                                    text: constant.yes,
                                                    maxline: 1,
                                                    fontwaight: FontWeight.w500,
                                                    fontsize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: MyText(
                                                    color: white,
                                                    text: constant.cancel,
                                                    maxline: 1,
                                                    fontwaight: FontWeight.w500,
                                                    fontsize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        color: colorprimaryDark,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MySvg(
                                width: 25,
                                height: 25,
                                imagePath: "ic_logout.svg",
                                color: colorprimaryDark,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            (userid!.isEmpty || userid == "")
                                ? MyText(
                                    color: white,
                                    text: constant.login,
                                    maxline: 1,
                                    fontwaight: FontWeight.w500,
                                    fontsize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal,
                                  )
                                : MyText(
                                    color: white,
                                    text: constant.logout,
                                    maxline: 1,
                                    fontwaight: FontWeight.w500,
                                    fontsize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileshimmer() {
    return Positioned.fill(
      bottom: 20,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            // UserImage and Username
            CustomWidget.circular(
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 10,
            ),
            CustomWidget.roundrectborder(
              height: 10,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  clearStorage() async {
    await sharedpre.clear();
  }
}
