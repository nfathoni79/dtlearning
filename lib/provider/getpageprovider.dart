import 'package:dtlearning/model/getpagemodel.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class GetPageProvider extends ChangeNotifier {
  GetPageModel getpagemodel = GetPageModel();

  bool loading = false;

// featurepage banner
  Future<void> getpage() async {
    loading = true;
    getpagemodel = await ApiService().getpage();
    loading = false;
    notifyListeners();
  }
}
