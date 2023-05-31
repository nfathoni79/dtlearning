import 'package:dtlearning/model/cartdeletemodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class DeleteCartProvider extends ChangeNotifier {
  CartdeleteModel cartdeleteModel = CartdeleteModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();
 

  Future<void> getcartdelete(String userid,String courseid) async {
    loading = true;
    cartdeleteModel = await ApiService().cartdelete(userid,courseid);
    loading = false;
    notifyListeners();
  }
}
