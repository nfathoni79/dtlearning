import 'package:dtlearning/provider/contectusprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
   Constant constant = Constant();
  double? width;
  double? height;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorprimaryDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title:  MyAppbar(
          type: 1,
          backTap: (){
            Navigator.of(context).pop(false);
          },
          startImg: "ic_back.svg",
          startImgcolor: white,
          text: constant.contactus,
          textcolor: white,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: TextField(
                obscureText: false,
                keyboardType: TextInputType.text,
                controller: fullnameController,
                textInputAction: TextInputAction.next,
                cursorColor: lightgray,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: colorPrimary,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: colorPrimary,
                      fontWeight: FontWeight.w400),
                  hintText: constant.fullname,
                  filled: true,
                  fillColor: white,
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 1, color: colorAccent)),
                ),
              ),
            ),
            SizedBox(height: height! * 0.03),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: TextField(
                obscureText: false,
                keyboardType: TextInputType.text,
                controller: emailController,
                textInputAction: TextInputAction.next,
                cursorColor: lightgray,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: colorPrimary,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: colorPrimary,
                      fontWeight: FontWeight.w400),
                  hintText: constant.email,
                  filled: true,
                  fillColor: white,
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 1, color: colorAccent)),
                ),
              ),
            ),
            SizedBox(height: height! * 0.03),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: TextField(
                obscureText: false,
                keyboardType: TextInputType.number,
                controller: numberController,
                textInputAction: TextInputAction.next,
                cursorColor: lightgray,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: colorPrimary,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: colorPrimary,
                      fontWeight: FontWeight.w400),
                  hintText: constant.mobile,
                  filled: true,
                  fillColor: white,
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 1, color: colorAccent)),
                ),
              ),
            ),
            SizedBox(height: height! * 0.03),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: TextField(
                obscureText: false,
                keyboardType: TextInputType.text,
                controller: messageController,
                textInputAction: TextInputAction.done,
                cursorColor: lightgray,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: colorPrimary,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: colorPrimary,
                      fontWeight: FontWeight.w400),
                  hintText: constant.message,
                  filled: true,
                  fillColor: white,
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: colorAccent),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 1, color: colorAccent)),
                ),
              ),
            ),
            SizedBox(height: height! * 0.03),
            InkWell(
              onTap: () async {
                String fullname = fullnameController.text.toString();
                String email = emailController.text.toString();
                String number = numberController.text.toString();
                String message = messageController.text.toString();
                if (fullname.isEmpty) {
                  Utils().showToast("Please Enter Your Fullname");
                } else if (email.isEmpty) {
                  Utils().showToast("Please Enter Your email");
                } else if (number.isEmpty) {
                  Utils().showToast("Please Enter Your Mobile");
                } else if (message.isEmpty) {
                  Utils().showToast("Please Enter Your Message");
                } else {
                  final contectUsItem =
                      Provider.of<ContectUsProvider>(context, listen: false);
                  await contectUsItem.getContectus(
                      fullname, email, number, message);

                  if (contectUsItem.loading) {
                    Utils.pageLoader();
                  } else {
                    if (contectUsItem.contectusModel.status == 200 &&
                        contectUsItem.contectusModel.result!.isNotEmpty) {
                      Utils()
                          .showToast("${contectUsItem.contectusModel.message}");
                    } else {
                      Utils()
                          .showToast("${contectUsItem.contectusModel.message}");
                    }
                  }
                }
              },
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
                    text: constant.contactus,
                    fontsize: 16,
                    fontwaight: FontWeight.w600,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
