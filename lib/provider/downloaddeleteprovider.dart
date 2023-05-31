import 'package:dtlearning/model/downloaddeletemodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class DownloadDeleteProvider extends ChangeNotifier {
  DownloaddeleteModel downloaddeleteModel = DownloaddeleteModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getdownloaddelete(String userid, String courseid) async {
    loading = true;
    downloaddeleteModel = await ApiService().downloaddelete(userid, courseid);
    loading = false;
    notifyListeners();
  }
}
