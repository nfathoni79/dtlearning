import 'package:dtlearning/model/courselistbytutoridmodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class CourselistByTutoridProvider extends ChangeNotifier {
  CourselistbytutoridModel courselistbytutoridModel =
      CourselistbytutoridModel();

  bool loading = false;
  SharedPre sharePref = SharedPre();

  Future<void> getcourselistBytutorid(String tutorid) async {
    loading = true;
    courselistbytutoridModel = await ApiService().courselistbytutorid(tutorid);
    loading = false;
    notifyListeners();
  }
}
