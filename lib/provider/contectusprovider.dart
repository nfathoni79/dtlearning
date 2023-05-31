import 'package:dtlearning/model/contectusmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ContectUsProvider extends ChangeNotifier {
  ContectusModel contectusModel= ContectusModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getContectus(String fullname, String email, String number, String message) async {
    loading = true;
    contectusModel = await ApiService().contactus(fullname,email,number,message);
    loading = false;
    notifyListeners();
  }
}
