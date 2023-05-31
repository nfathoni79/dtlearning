import 'package:dtlearning/model/wishlistmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  Wishlistmodel wishlistmodel = Wishlistmodel();

  bool loading = false;

  SharedPre sharePref = SharedPre();

  Future<void> wishlist(String userid) async {
    loading = true;
    wishlistmodel = await ApiService().wishlist(userid);
    loading = false;
    notifyListeners();
  }
}
