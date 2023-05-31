import 'package:dtlearning/pages/login.dart';
import 'package:dtlearning/provider/generalprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/myedittext.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mysvg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:dtlearning/widget/suffixedittext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late ProgressDialog prDialog;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conpasswordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool obscureTextPassword = true;
  bool obscureTextConPassword = true;
  String email = "", password = "", conpassword = "", number = "";

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
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
                  registerUi(),
                  registerField(),
                  const Spacer(),
                  signUpBtn(),
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

  Widget registerUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      child: MyText(
          color: white,
          text: "Register",
          fontsize: 20,
          fontwaight: FontWeight.w600,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal),
    );
  }

  Widget registerField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyEdittext(
              hintcolor: pink,
              hinttext: "email",
              keyboardType: TextInputType.text,
              controller: emailController,
              size: 14,
              textcolor: white,
              textInputAction: TextInputAction.next,
              obscureText: false),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: obscureTextPassword,
            keyboardType: TextInputType.number,
            controller: passwordController,
            textInputAction: TextInputAction.next,
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
              hintText: "Password",
              hintStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: pink,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: obscureTextConPassword,
            keyboardType: TextInputType.number,
            controller: conpasswordController,
            textInputAction: TextInputAction.next,
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
                      obscureTextConPassword = !obscureTextConPassword;
                    });
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    child: MySvg(
                      height: 20,
                      imagePath: obscureTextConPassword
                          ? "ic_notvisible.svg"
                          : "ic_visible.svg",
                      width: 20,
                      color: pink,
                    ),
                  ),
                ),
              ),
              hintText: "Conform Password",
              hintStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: pink,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          SuffixEdittext(
              hintcolor: pink,
              hinttext: "Mobile No",
              prefixicon: "ic_mobile.png",
              suffixtext: "(+91)",
              keyboardType: TextInputType.number,
              controller: numberController,
              size: 14,
              textcolor: white,
              textInputAction: TextInputAction.done,
              obscureText: false),
        ],
      ),
    );
  }

  Widget signUpBtn() {
    return InkWell(
      onTap: () async {
        email = emailController.text.toString();
        password = passwordController.text.toString();
        conpassword = conpasswordController.text.toString();
        number = numberController.text.toString();
        bool emailValidation = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
        if (email.isEmpty) {
          Utils().showToast("Please Enter Email Address");
        } else if (password.isEmpty) {
          Utils().showToast("Please Enter Your Password");
        } else if (conpassword.isEmpty) {
          Utils().showToast("Please Enter Conform Password");
        } else if (number.isEmpty) {
          Utils().showToast("Please Enter Mobile Number");
        } else if (!emailValidation) {
          Utils().showToast("Invalid Email Address");
        } else if (password.length != 6 && conpassword.length != 6) {
          Utils().showToast("Please Enter Only 6 Digit Password");
        } else if (password != conpassword) {
          Utils().showToast("Invalid Password Please Enter Same Password");
        } else if (number.length != 10) {
          Utils().showToast("Please Enter Only 10 Digit Number");
        } else {
          final registerItem =
              Provider.of<GeneralProvider>(context, listen: false);
          Utils.showProgress(context, prDialog);
          await registerItem.register("3", email, password, number);

          if (registerItem.loading) {
            // ignore: use_build_context_synchronously
            Utils.showProgress(context, prDialog);
          } else {
            if (registerItem.registermodel.status == 200) {
              Utils().showToast("${registerItem.registermodel.message}");
              prDialog.hide();
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Login();
                  },
                ),
              );
            } else {
              Utils().showToast("${registerItem.registermodel.message}");
              prDialog.hide();
            }
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10)),
        child: MyText(
            color: white,
            text: "SIGN UP",
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
              return const Login();
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
                text: "Already have an Account ?",
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
                text: "Login",
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
