import 'dart:developer';
import 'dart:io';
import 'package:dtlearning/provider/profileprovider.dart';
import 'package:dtlearning/utils/color.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/utils/utils.dart';
import 'package:dtlearning/widget/appbar.dart';
import 'package:dtlearning/widget/myimage.dart';
import 'package:dtlearning/widget/mynetworkimg.dart';
import 'package:dtlearning/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String userid;
  const EditProfile({super.key, required this.userid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SharedPre sharedpre = SharedPre();
  Constant constant = Constant();
  // ignore: prefer_typing_uninitialized_variables
  var imageFile;
  late ProgressDialog prDialog;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    _getapi();
  }

  void _getapi() async {
    log('userid=>${widget.userid}');
    final profileProvider =
        // ignore: use_build_context_synchronously
        Provider.of<ProfileProvider>(context, listen: false);
    Utils.showProgress(context, prDialog);
    await profileProvider.getProfile(widget.userid);
    prDialog.hide();
  }

  getImageFromGallery() async {
    var image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        // ignore: unnecessary_brace_in_string_interps
        debugPrint("Image Path:${imageFile}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorprimaryDark,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: colorprimaryDark,
          title: MyAppbar(
              backTap: () {
                Navigator.of(context).pop(false);
              },
              type: 1,
              startImg: "ic_back.svg",
              startImgcolor: white),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: colorprimaryDark,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: pink, width: 2),
                                borderRadius: BorderRadius.circular(100)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageFile == null
                                  ? MyNetworkImage(
                                      imgWidth: 150,
                                      imgHeight: 150,
                                      imageUrl: profileProvider
                                              .profileModel.result?[0].image
                                              .toString() ??
                                          "",
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                            ),
                          ),
                          Positioned.fill(
                            right: 5,
                            bottom: 5,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  getImageFromGallery();
                                },
                                child: MyImage(
                                    width: 35,
                                    height: 35,
                                    imagePath: "ic_editimg.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MyText(
                          color: white,
                          fontwaight: FontWeight.w600,
                          fontsize: 16,
                          overflow: TextOverflow.ellipsis,
                          maxline: 1,
                          text: profileProvider.profileModel.result?[0].fullname
                                  .toString() ??
                              "",
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              MyText(
                  color: white,
                  fontwaight: FontWeight.w600,
                  fontsize: 14,
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  text: constant.editname,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
              const SizedBox(height: 10),
              Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                return SizedBox(
                  height: 45,
                  child: TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorPrimary,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: colorPrimary,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(width: 1, color: white),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(width: 1, color: white),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(width: 1, color: white),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(width: 1, color: white)),
                      hintText: profileProvider.profileModel.result?[0].fullname
                              .toString() ??
                          "",
                      hintStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          color: colorprimaryDark,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    var image = File(imageFile!.path);
                    final updateprofileItem =
                        Provider.of<ProfileProvider>(context, listen: false);
                    Utils.showProgress(context, prDialog);
                    await updateprofileItem.getUpdateProfile(
                        widget.userid, nameController.text.toString(), image);

                    if (updateprofileItem.loading) {
                      if (!mounted) return;
                      Utils.showProgress(context, prDialog);
                    } else {
                      if (updateprofileItem.updateprofilemodel.status == 200) {
                        Utils().showToast(updateprofileItem
                            .updateprofilemodel.message
                            .toString());
                        prDialog.hide();
                        setState(() {});
                        _getapi();
                      } else {
                        Utils().showToast(updateprofileItem
                            .updateprofilemodel.message
                            .toString());
                        prDialog.hide();
                      }
                    }
                  },
                  child: Container(
                    width: 220,
                    height: 45,
                    decoration: BoxDecoration(
                        color: pink, borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: MyText(
                        color: white,
                        fontwaight: FontWeight.w600,
                        fontsize: 16,
                        overflow: TextOverflow.ellipsis,
                        maxline: 1,
                        text: constant.save,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
