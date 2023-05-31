import 'package:dtlearning/model/bannermodel.dart';
import 'package:dtlearning/model/categorymodel.dart';
import 'package:dtlearning/model/coursemodel.dart';
import 'package:dtlearning/model/topcoursemodel.dart';
import 'package:dtlearning/model/tutormodel.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  BannerModel bannerModel = BannerModel();
  CategoryModel categoryModel = CategoryModel();
  CourseModel courseModel = CourseModel();
  TopcourseModel topcourseModel = TopcourseModel();
  TutorModel tutorModel = TutorModel();

  bool loading = false;

// featurepage banner
  Future<void> getBanner() async {
    loading = true;
    bannerModel = await ApiService().banner();
    loading = false;
    notifyListeners();
  }

// featurepage category
  Future<void> getCategory() async {
    loading = true;
    categoryModel = await ApiService().category();
    loading = false;
    notifyListeners();
  }

  // featurepage top course
  Future<void> gettopcourse() async {
    loading = true;
    topcourseModel = await ApiService().topcourse();
    loading = false;
    notifyListeners();
  }

// featurepage TutorProfile
  Future<void> gettutor() async {
    loading = true;
    tutorModel = await ApiService().tutor();
    loading = false;
    notifyListeners();
  }

  // featurepage all course
  Future<void> getCourse() async {
    loading = true;
    courseModel = await ApiService().course();
    loading = false;
    notifyListeners();
  }
}
