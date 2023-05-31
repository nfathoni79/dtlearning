import 'package:dtlearning/model/generalsettingmodel.dart';
import 'package:dtlearning/model/loginmodel.dart';
import 'package:dtlearning/model/profilemodel.dart';
import 'package:dtlearning/model/registermodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralSettingModel generalSettingModel = GeneralSettingModel();
  Loginmodel loginmodel = Loginmodel();
  Registermodel registermodel = Registermodel();
  ProfileModel profileModel = ProfileModel();

  bool loading = false;

  SharedPre sharePref = SharedPre();

  Future<void> getGeneralsetting(context) async {
    loading = true;
    generalSettingModel = await ApiService().genaralSetting();
    loading = false;
    notifyListeners();
  }

  Future<void> loginWithSocial(String email, String name, String type) async {
    loading = true;
    loginmodel = await ApiService().login(email, name, type);
    loading = false;
    notifyListeners();
  }

  Future<void> loginWithOTP(number, type) async {
    loading = true;
    loginmodel = await ApiService().loginwithOTP(number, type);
    loading = false;
    notifyListeners();
  }

 

  Future<void> register(
      String type, String email, String password, String number) async {
    loading = true;
    registermodel = await ApiService().register(type, email, password, number);
    loading = false;
    notifyListeners();
  }
}
