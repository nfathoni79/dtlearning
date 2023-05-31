import 'package:dtlearning/model/addtransectionmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class AddtransectionProvider extends ChangeNotifier {
  AddtransectionModel addtransectionModel = AddtransectionModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getaddtransection(coursedetail, userid, paymenttype, couponid,
      currencycode, discountamount, assignCouponid, paymentid) async {
    loading = true;
    addtransectionModel = await ApiService().addtransection(
        coursedetail,
        userid,
        paymenttype,
        couponid,
        currencycode,
        discountamount,
        assignCouponid,
        paymentid);
    loading = false;
    notifyListeners();
  }
}
