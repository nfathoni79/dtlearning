import 'dart:developer';
import 'package:dtlearning/pages/bottombar.dart';
import 'package:dtlearning/pages/mobilelogin.dart';
import 'package:dtlearning/pages/register.dart';
import 'package:dtlearning/provider/generalprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/myedittext.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  SharedPre sharedPre = SharedPre();
  Constant constant = Constant();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPassword = true;
  String email = "", password = "";
  late ProgressDialog prDialog;

  @override
  initState() {
    super.initState();
    prDialog = ProgressDialog(context);
  }

  void goback(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: colorprimaryDark,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [uppercolorintro, lowercolorintro],
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    loginUi(),
                    emailAndpassword(),
                    forgotPassword(),
                    loginBtn(),
                    goingRegister(),
                    const Spacer(),
                    mobileLogin(),
                    loginGoogleFacebook(),
                    const SizedBox(height: 20),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: MyText(
          color: white,
          text: constant.login,
          fontsize: 20,
          fontwaight: FontWeight.w600,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget emailAndpassword() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyEdittext(
              hintcolor: pink,
              hinttext: constant.email,
              keyboardType: TextInputType.text,
              controller: emailController,
              size: 14,
              textcolor: white,
              textInputAction: TextInputAction.next,
              obscureText: false),
          TextFormField(
            obscureText: obscureTextPassword,
            keyboardType: TextInputType.number,
            controller: passwordController,
            textInputAction: TextInputAction.done,
            cursorColor: white,
            style: GoogleFonts.montserrat(
                fontSize: 14,
                fontStyle: FontStyle.normal,
                color: white,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: white),
              ),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: black)),
              prefixIcon: Container(
                width: 5,
                height: 5,
                alignment: Alignment.center,
                child: MyImage(
                  height: 20,
                  imagePath: "ic_password.png",
                  width: 20,
                ),
              ),
              suffixIcon: Container(
                width: 5,
                height: 5,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      obscureTextPassword = !obscureTextPassword;
                    });
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    child: MySvg(
                      height: 20,
                      imagePath: obscureTextPassword
                          ? "ic_notvisible.svg"
                          : "ic_visible.svg",
                      width: 20,
                      color: pink,
                    ),
                  ),
                ),
              ),
              hintText: constant.password,
              hintStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: pink,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: MyText(
          color: pink,
          text: constant.forgotpassword,
          fontsize: 12,
          maxline: 1,
          fontwaight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget loginBtn() {
    return InkWell(
      onTap: () async {
        email = emailController.text.toString();
        password = passwordController.text.toString();
        bool emailValidation = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);

        if (email.isEmpty) {
          Utils().showToast("Please Enter Yout Email");
        } else if (password.isEmpty) {
          Utils().showToast("Please Enter Yout Password");
        } else if (password.length != 6) {
          Utils().showToast("Please Enter only 6 Digit");
        } else if (!emailValidation) {
          Utils().showToast("Invalid Email Address");
        } else {
          loginApi(email, password, "3");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          decoration: BoxDecoration(
            color: pink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyText(
              color: white,
              text: constant.signin,
              fontsize: 16,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal),
        ),
      ),
    );
  }

  Widget goingRegister() {
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
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const Register()),
        //     (Route route) => false);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
                color: pink,
                text: constant.donthaveanaccount,
                fontsize: 13,
                maxline: 1,
                fontwaight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
            const SizedBox(
              width: 5,
            ),
            MyText(
                color: white,
                text: constant.register,
                fontsize: 13,
                maxline: 1,
                fontwaight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ],
        ),
      ),
    );
  }

  Widget mobileLogin() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MobileLogin();
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        decoration: BoxDecoration(
          color: colorprimaryDark,
          borderRadius: BorderRadius.circular(5),
        ),
        child: MyText(
            color: white,
            text: constant.signinwithmobileno,
            fontsize: 16,
            fontwaight: FontWeight.w600,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
      ),
    );
  }

  Widget loginGoogleFacebook() {
    return InkWell(
      onTap: (() {
        signInWithGoogle(email).then((UserCredential user) async {
          log('${user.user?.displayName.toString()}');
          var email = user.user?.email;
          log('${user.user?.email}');
          log('${user.user?.photoURL}');
          log('${user.user?.uid}');

          if (user.user!.email.toString().isNotEmpty) {
            // Pass Email Address and Type in Login Api
            loginApi(email.toString(), "", "2");
          }
        });
      }),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage(width: 20, height: 20, imagePath: "ic_gmail.png"),
            const SizedBox(
              width: 5,
            ),
            MyText(
                color: colorprimaryDark,
                text: constant.google,
                fontsize: 14,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ],
        ),
      ),
    );
  }

  loginApi(String email, String password, String type) async {
    final loginItem = Provider.of<GeneralProvider>(context, listen: false);
    Utils.showProgress(context, prDialog);
    await loginItem.loginWithSocial(email, password, type);

    if (loginItem.loading) {
      // ignore: use_build_context_synchronously
      Utils.showProgress(context, prDialog);
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
        // ignore: use_build_context_synchronously
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

  // Signin With Google For Android Device
  Future<UserCredential> signInWithGoogle(email) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    email = googleUser!.email;
    String userid = googleUser.id;
    debugPrint("Google Email:===>$email");
    debugPrint("Google id:===>$userid");

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
