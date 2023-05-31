import 'dart:io';

import 'package:dtlearning/model/profilemodel.dart';
import 'package:dtlearning/model/updateprofilemodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  Updateprofilemodel updateprofilemodel = Updateprofilemodel();
  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getProfile(String id) async {
    loading = true;
    profileModel = await ApiService().profile(id);
    loading = false;
    notifyListeners();
  }

   getUpdateProfile(userid,name, File image) async {
    loading = true;
    updateprofilemodel = await ApiService().updateprofile(userid, name, image);
    loading = false;
    notifyListeners();
  }
}
