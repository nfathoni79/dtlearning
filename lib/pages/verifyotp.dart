import 'dart:developer';
import 'package:dtlearning/pages/bottombar.dart';
import 'package:dtlearning/pages/register.dart';
import 'package:dtlearning/provider/generalprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class VerifyOtp extends StatefulWidget {
  final String mobile, onlynumber;
  const VerifyOtp({super.key, required this.mobile, required this.onlynumber});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  SharedPre sharedPre = SharedPre();
  Constant constant = Constant();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController numberController = TextEditingController();
  final otpController = TextEditingController();
  late ProgressDialog prDialog;
  String? verificationId;

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    codeSend();
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
                  otptext(),
                  const SizedBox(height: 70),
                  otpdesciptionText(),
                  const SizedBox(height: 70),
                  enterOtp(),
                  const SizedBox(height: 20),
                  resendotp(),
                  const Spacer(),
                  verifyotp(),
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

  Widget otptext() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: MyText(
          color: white,
          text: constant.otpverification,
          fontsize: 18,
          fontwaight: FontWeight.w600,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget otpdesciptionText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: MyText(
          color: pink,
          text: constant.enterotpcodetosenttomobieNo,
          fontsize: 14,
          fontwaight: FontWeight.w400,
          maxline: 2,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget enterOtp() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Pinput(
        length: 6,
        keyboardType: TextInputType.number,
        controller: otpController,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        defaultPinTheme: PinTheme(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: pink,
              borderRadius: BorderRadius.circular(5),
            ),
            textStyle: GoogleFonts.inter(
              color: white,
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  Widget resendotp() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          codeSend();
        },
        child: Container(
          width: 100,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: MyText(
                color: white,
                text: constant.resend,
                fontsize: 14,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ),
        ),
      ),
    );
  }

  Widget verifyotp() {
    return InkWell(
      onTap: () {
        log("enter otp=${otpController.text}");
        if (otpController.text.toString().isEmpty) {
          Utils().showToast("Please Enter Your OTP");
        } else {
          loginApi(widget.onlynumber.toString(), "1");
        }
      },
      child: Container(
        width: 250,
        height: 50,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10)),
        child: MyText(
            color: white,
            text: constant.verifyandproceed,
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

//  Send Otp methods

  codeSend() async {
    await phoneSignIn(phoneNumber: widget.mobile.toString());
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    log("otp==>${authCredential.smsCode!}");
    setState(() {
      otpController.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential? credential =
            await user?.linkWithCredential(authCredential);
        log("_onVerificationCompleted credential =====> ${credential?.user?.phoneNumber ?? ""}");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      log("Firebase Verification Complated");
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      Utils().showToast("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    log(forceResendingToken.toString());
    log("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  loginApi(String number, String type) async {
    final loginItem = Provider.of<GeneralProvider>(context, listen: false);
    Utils.showProgress(context, prDialog);
    await loginItem.loginWithOTP(number, type);
    if (loginItem.loading) {
      // ignore: use_build_context_synchronously
    } else {
      if (loginItem.loginmodel.status == 200 &&
          loginItem.loginmodel.result!.isNotEmpty) {
        await sharedPre.save(
            "userid", loginItem.loginmodel.result?[0].id.toString());
        await sharedPre.save(
            "fullname", loginItem.loginmodel.result?[0].fullname.toString());
        await sharedPre.save(
            "email", loginItem.loginmodel.result?[0].email.toString());
        await sharedPre.save(
            "password", loginItem.loginmodel.result?[0].password.toString());
        await sharedPre.save(
            "number", loginItem.loginmodel.result?[0].mobileNumber.toString());
        await sharedPre.save(
            "userimage", loginItem.loginmodel.result?[0].image.toString());
        await sharedPre.save("userbackgroundimage",
            loginItem.loginmodel.result?[0].backgroundImage.toString());
        await sharedPre.save(
            "type", loginItem.loginmodel.result?[0].type.toString());
        await sharedPre.save(
            "status", loginItem.loginmodel.result?[0].status.toString());
        await sharedPre.save("divicetoken",
            loginItem.loginmodel.result?[0].deviceToken.toString());
        await sharedPre.save(
            "userdate", loginItem.loginmodel.result?[0].date.toString());
        await sharedPre.save("usercreatedat",
            loginItem.loginmodel.result?[0].createdAt.toString());
        await sharedPre.save("userupdatedat",
            loginItem.loginmodel.result?[0].updatedAt.toString());

        prDialog.hide();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Bottombar()),
            (Route route) => false);
      } else {
        Utils().showToast("${loginItem.loginmodel.message}");
        prDialog.hide();
      }
    }
  }
}
