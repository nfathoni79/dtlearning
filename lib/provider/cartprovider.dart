import 'package:dtlearning/model/applycouponmodel.dart';
import 'package:dtlearning/model/cartbyusermodel.dart';
import 'package:dtlearning/model/couponlistmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class CartlistProvider extends ChangeNotifier {
  CartbyuserModel cartbyuserModel = CartbyuserModel();
  CouponlistModel couponlistModel = CouponlistModel();
  ApplycouponModel applycouponModel = ApplycouponModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getcartbyuser(String userid) async {
    loading = true;
    cartbyuserModel = await ApiService().cartbyuser(userid);
    loading = false;
    notifyListeners();
  }

  Future<void> getcouponlit() async {
    loading = true;
    couponlistModel = await ApiService().couponlist();
    loading = false;
    notifyListeners();
  }

  Future<void> getapplycoupon(String userid, String couponcode) async {
    loading = true;
    applycouponModel = await ApiService().applycoupon(userid, couponcode);
    loading = false;
    notifyListeners();
  }
}
