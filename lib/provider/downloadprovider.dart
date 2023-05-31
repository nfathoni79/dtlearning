import 'package:dtlearning/model/getdownload.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class DownloadProvider extends ChangeNotifier {
  GetdownloadModel getdownloadModel = GetdownloadModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getdownloadList(String userid) async {
    loading = true;
    getdownloadModel = await ApiService().getdownload(userid);
    loading = false;
    notifyListeners();
  }
}
