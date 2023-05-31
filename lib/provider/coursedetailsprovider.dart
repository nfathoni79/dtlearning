import 'package:dtlearning/model/addtocartmodel.dart';
import 'package:dtlearning/model/addwishlistmodel.dart';
import 'package:dtlearning/model/coursedetailsmodel.dart';
import 'package:dtlearning/model/courseviewmodel.dart';
import 'package:dtlearning/model/relatedcoursemodel.dart';
import 'package:dtlearning/utils/sharedpre.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class CourseDetailsProvider extends ChangeNotifier {
  CourseDetailsModel courseDetailsModel = CourseDetailsModel();
  AddtocartModel addtocartModel = AddtocartModel();
  AddwishlistModel addwishlistmodel = AddwishlistModel();
  CourseviewModel courseviewModel = CourseviewModel();
  RelatedcourseModel relatedcourseModel = RelatedcourseModel();
  bool loading = false;
  SharedPre sherdpre = SharedPre();

  Future<void> getCourseDetails(courseid) async {
    loading = true;

    dynamic userid = await sherdpre.read("userid") ?? "";
    courseDetailsModel = await ApiService().getcourcedetails(courseid, userid);
    loading = false;
    notifyListeners();
  }

  Future<void> getaddtocart(String courseid, String userid) async {
    loading = true;
    addtocartModel = await ApiService().addtocart(courseid, userid);
    loading = false;
    notifyListeners();
  }

  Future<void> getaddwishlist(String userid, String courseid) async {
    loading = true;
    addwishlistmodel = await ApiService().addwishlist(userid, courseid);
    loading = false;
    notifyListeners();
  }

  Future<void> getcourseview(String courseid, String userid) async {
    loading = true;
    courseviewModel = await ApiService().courseview(courseid, userid);
    loading = false;
    notifyListeners();
  }

  Future<void> getrelatedcourse(String categoryid, String courseid) async {
    loading = true;
    relatedcourseModel = await ApiService().relatedcourse(categoryid, courseid);
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    loading = false;
    courseDetailsModel = CourseDetailsModel();
  }
}
