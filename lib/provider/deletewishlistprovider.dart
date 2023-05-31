import 'package:dtlearning/model/deletewishlistmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class DeletewishlistProvider extends ChangeNotifier {
  Deletewishlistmodel deletewishlistmodel = Deletewishlistmodel();

  bool loading = false;

  SharedPre sharePref = SharedPre();

 

  Future<void> deletewishlist(String userid,String courseid) async {
    loading = true;
    deletewishlistmodel = await ApiService().deletewishlist(userid,courseid);
    loading = false;
    notifyListeners();
  }


}
