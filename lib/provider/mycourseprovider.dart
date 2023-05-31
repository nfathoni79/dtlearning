import 'package:dtlearning/model/coursemodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class MyCourseProvider extends ChangeNotifier {
  CourseModel myCourseModel = CourseModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getMyCourse(userid) async {
    loading = true;
    myCourseModel = await ApiService().mycourse(userid);
    loading = false;
    notifyListeners();
  }
}
