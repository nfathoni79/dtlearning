import 'dart:developer';
import 'package:dtlearning/pages/register.dart';
import 'package:dtlearning/pages/verifyotp.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  State<MobileLogin> createState() => MobileLoginState();
}

class MobileLoginState extends State<MobileLogin> {
  Constant constant = Constant();
  TextEditingController numberController = TextEditingController();
  String? mobileNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [uppercolorintro, lowercolorintro])),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 100),
                  mobileloginText(),
                  const SizedBox(height: 70),
                  mobileloginchildText(),
                  const SizedBox(height: 70),
                  enterNumber(),
                  const SizedBox(height: 20),
                  const Spacer(),
                  sendOTP(),
                  registerText(),
                  const Spacer(),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    children: [
                      MySvg(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.width * 0.55,
                        color: colorAccent,
                        imagePath: "ic_corner.svg",
                      ),
                      Positioned.fill(
                        top: 50,
                        left: 20,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                              child: MySvg(
                                width: 18,
                                height: 18,
                                imagePath: "ic_back.svg",
                                color: white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Enter Mobile number UI
  Widget mobileloginText() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: MyText(
          color: white,
          text: constant.enteryourmobile,
          fontsize: 18,
          fontwaight: FontWeight.w600,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget mobileloginchildText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: MyText(
          color: pink,
          text: constant.youwillreceive6digitcode,
          fontsize: 14,
          fontwaight: FontWeight.w400,
          maxline: 2,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget enterNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: IntlPhoneField(
        disableLengthCheck: true,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.disabled,
        showCountryFlag: false,
        showDropdownIcon: false,
        initialCountryCode: 'IN',
        dropdownTextStyle: GoogleFonts.inter(
          color: colorAccent,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        obscureText: false,
        keyboardType: TextInputType.number,
        controller: numberController,
        textInputAction: TextInputAction.done,
        cursorColor: white,
        onChanged: (phone) {
          mobileNumber = phone.completeNumber;
          log('===>mobileNumber $mobileNumber');
        },
        onCountryChanged: (country) {
          log('===> ${country.name}');
          log('===> ${country.code}');
        },
        style: GoogleFonts.montserrat(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: white,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: white),
          ),
          enabledBorder:
              const UnderlineInputBorder(borderSide: BorderSide(color: black)),
          hintText: constant.mobileno,
          hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              color: colorAccent,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget sendOTP() {
    return InkWell(
      onTap: () {
        if (numberController.text.isEmpty) {
          Utils().showToast("Please Enter Your Mobile Number");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VerifyOtp(
                  onlynumber: numberController.text.toString(),
                  mobile: mobileNumber.toString(),
                );
              },
            ),
          );
        }
      },
      child: Container(
        width: 150,
        height: 50,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10)),
        child: MyText(
            color: white,
            text: constant.sendotp,
            fontsize: 14,
            fontwaight: FontWeight.w500,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
      ),
    );
  }

  Widget registerText() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Register();
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
                color: pink,
                text: constant.donthaveanaccount,
                fontsize: 14,
                fontwaight: FontWeight.w400,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
            const SizedBox(
              width: 5,
            ),
            MyText(
                color: white,
                text: constant.register,
                fontsize: 14,
                fontwaight: FontWeight.w400,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ],
        ),
      ),
    );
  }
}
