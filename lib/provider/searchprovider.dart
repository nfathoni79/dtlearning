import 'package:dtlearning/model/browsecategorymodel.dart';
import 'package:dtlearning/model/getcoursebycategoryidmodel.dart';
import 'package:dtlearning/model/getsearchcoursemodel.dart';
import 'package:dtlearning/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  BrowsecategoryModel browsecategoryModel = BrowsecategoryModel();
  GetcoursebycategoryidModel getcourcebycategoryid= GetcoursebycategoryidModel();
  GetsearchcourseModel getsearchcourseModel = GetsearchcourseModel();

  bool loading = false;

  Future<void> getbrowseCategory() async {
    loading = true;
    browsecategoryModel = await ApiService().browseCategory();
    loading = false;
    notifyListeners();
  }

  Future<void> getSearchCourse(courcename) async {
    loading = true;
    getsearchcourseModel = await ApiService().searchcourse(courcename);
    loading = false;
    notifyListeners();
  }

  Future<void> getCourseByCategoryId(String id) async {
    loading = true;
    getcourcebycategoryid = await ApiService().getcourcebycategoryid(id);
    loading = false;
    notifyListeners();
  }
}
