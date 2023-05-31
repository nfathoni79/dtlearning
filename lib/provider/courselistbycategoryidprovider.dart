import 'package:dtlearning/model/courselistbycategoryidmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class CourselistByCategoryidProvider extends ChangeNotifier {
 CourselistbycategoryidModel courselistbycategoryidModel = CourselistbycategoryidModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getcourselistBycategoryid(String courseid) async {
    loading = true;
    courselistbycategoryidModel = await ApiService().courselistbycategorid(courseid);
    loading = false;
    notifyListeners();
  }
}
