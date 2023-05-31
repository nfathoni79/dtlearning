import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:dtlearning/model/addtocartmodel.dart';
import 'package:dtlearning/model/addtransectionmodel.dart';
import 'package:dtlearning/model/addwishlistmodel.dart';
import 'package:dtlearning/model/applycouponmodel.dart';
import 'package:dtlearning/model/bannermodel.dart';
import 'package:dtlearning/model/browsecategorymodel.dart';
import 'package:dtlearning/model/cartbyusermodel.dart';
import 'package:dtlearning/model/cartdeletemodel.dart';
import 'package:dtlearning/model/categorymodel.dart';
import 'package:dtlearning/model/contectusmodel.dart';
import 'package:dtlearning/model/coursedetailsmodel.dart';
import 'package:dtlearning/model/courselistbycategoryidmodel.dart';
import 'package:dtlearning/model/courselistbytutoridmodel.dart';
import 'package:dtlearning/model/coursemodel.dart';
import 'package:dtlearning/model/courseviewmodel.dart';
import 'package:dtlearning/model/deletewishlistmodel.dart';
import 'package:dtlearning/model/downloaddeletemodel.dart';
import 'package:dtlearning/model/generalsettingmodel.dart';
import 'package:dtlearning/model/getcoursebycategoryidmodel.dart';
import 'package:dtlearning/model/getdownload.dart';
import 'package:dtlearning/model/getpagemodel.dart';
import 'package:dtlearning/model/getsearchcoursemodel.dart';
import 'package:dtlearning/model/loginmodel.dart';
import 'package:dtlearning/model/profilemodel.dart';
import 'package:dtlearning/model/registermodel.dart';
import 'package:dtlearning/model/relatedcoursemodel.dart';
import 'package:dtlearning/model/topcoursemodel.dart';
import 'package:dtlearning/model/tutormodel.dart';
import 'package:dtlearning/model/updateprofilemodel.dart';
import 'package:dtlearning/model/wishlistmodel.dart';
import 'package:dtlearning/model/couponlistmodel.dart';
import 'package:dtlearning/utils/constant.dart';
import 'package:path/path.dart';

class ApiService {
  String baseUrl = Constant.baseurl;

  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.interceptors.add(dioLoggerInterceptor);
  }

  // general_setting API
  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel generalSettingModel;
    String apiname = "general_setting";
    Response response = await dio.post('$baseUrl$apiname');
    generalSettingModel = GeneralSettingModel.fromJson(response.data);
    return generalSettingModel;
  }

  // Banner
  Future<BannerModel> banner() async {
    BannerModel bannerModel;
    String apiname = "banner";
    Response response = await dio.post('$baseUrl$apiname');
    bannerModel = BannerModel.fromJson(response.data);
    return bannerModel;
  }

  // Category
  Future<CategoryModel> category() async {
    CategoryModel categoryModel;
    String apiname = "category";
    Response response = await dio.post('$baseUrl$apiname');
    categoryModel = CategoryModel.fromJson(response.data);
    return categoryModel;
  }

  // Course
  Future<CourseModel> course() async {
    CourseModel courseModel;
    String apiname = "get_all_course";
    Response response = await dio.post('$baseUrl$apiname');
    courseModel = CourseModel.fromJson(response.data);
    return courseModel;
  }

  //top
  Future<TopcourseModel> topcourse() async {
    TopcourseModel topcourseModel;
    String apiname = "top_course";
    Response response = await dio.post('$baseUrl$apiname');
    topcourseModel = TopcourseModel.fromJson(response.data);
    return topcourseModel;
  }

  // Course
  Future<CourseModel> mycourse(userid) async {
    CourseModel courseModel;
    String apiname = "my_courses";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    courseModel = CourseModel.fromJson(response.data);
    return courseModel;
  }

  // Search Course
  Future<GetsearchcourseModel> searchcourse(courcename) async {
    GetsearchcourseModel getsearchcourseModel;
    String apiname = "search_course";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_name': MultipartFile.fromString(courcename),
        }));
    getsearchcourseModel = GetsearchcourseModel.fromJson(response.data);
    return getsearchcourseModel;
  }

  // Get Course By Category ID
  Future<GetcoursebycategoryidModel> getcourcebycategoryid(String id) async {
    GetcoursebycategoryidModel getcoursebycategoryidModel;
    String apiname = "get_course_by_category_id";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'category_id': MultipartFile.fromString(id),
        }));
    getcoursebycategoryidModel =
        GetcoursebycategoryidModel.fromJson(response.data);
    return getcoursebycategoryidModel;
  }

  // Profile
  Future<ProfileModel> profile(String id) async {
    ProfileModel profileModel;
    String apiname = "profile";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'id': MultipartFile.fromString(id),
        }));
    profileModel = ProfileModel.fromJson(response.data);
    return profileModel;
  }

  // Get Course Details
  Future<CourseDetailsModel> getcourcedetails(courseid, userid) async {
    CourseDetailsModel courseDetailsModel;
    String apiname = "course_detail";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_id': MultipartFile.fromString(courseid),
          'user_id': MultipartFile.fromString(userid),
        }));
    courseDetailsModel = CourseDetailsModel.fromJson(response.data);
    return courseDetailsModel;
  }

  // Login
  Future<Loginmodel> login(email, password, type) async {
    Loginmodel loginmodel;
    String apiname = "login";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'email': MultipartFile.fromString(email),
          'password': MultipartFile.fromString(password),
          'type': MultipartFile.fromString(type),
        }));
    loginmodel = Loginmodel.fromJson(response.data);
    return loginmodel;
  }

// Login With Otp
  Future<Loginmodel> loginwithOTP(number, type) async {
    Loginmodel loginmodel;
    String apiname = "login";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'mobile_number': MultipartFile.fromString(number),
          'type': MultipartFile.fromString(type),
        }));
    loginmodel = Loginmodel.fromJson(response.data);
    return loginmodel;
  }

// Register
  Future<Registermodel> register(type, email, password, number) async {
    Registermodel registermodel;
    String apiname = "register";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'type': MultipartFile.fromString(type),
          'email': MultipartFile.fromString(email),
          'password': MultipartFile.fromString(password),
          'mobile_number': MultipartFile.fromString(number),
        }));
    registermodel = Registermodel.fromJson(response.data);
    return registermodel;
  }

// UpdateProfile
  Future<Updateprofilemodel> updateprofile(userid, name, image) async {
    Updateprofilemodel updateprofilemodel;
    String updateprofile = "update/profile";
    Response response = await dio.post('$baseUrl$updateprofile',
        data: FormData.fromMap({
          'id': MultipartFile.fromString(userid),
          'fullname': MultipartFile.fromString(name),
          'image': await MultipartFile.fromFile(image.path,
              filename: basename(image.path)),
        }));

    updateprofilemodel = Updateprofilemodel.fromJson(response.data);
    return updateprofilemodel;
  }

// Wishlist
  Future<Wishlistmodel> wishlist(String userid) async {
    Wishlistmodel wishlistmodel;
    String apiname = "wishlist";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    wishlistmodel = Wishlistmodel.fromJson(response.data);
    return wishlistmodel;
  }

  // deleteWishlist
  Future<Deletewishlistmodel> deletewishlist(
      String userid, String courseid) async {
    Deletewishlistmodel deletewishlistmodel;
    String apiname = "wishlist_delete";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'course_id': MultipartFile.fromString(courseid),
        }));
    deletewishlistmodel = Deletewishlistmodel.fromJson(response.data);
    return deletewishlistmodel;
  }

  Future<AddtocartModel> addtocart(String courseid, String userid) async {
    AddtocartModel addtocartModel;
    String apiname = "add/cart";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_id': MultipartFile.fromString(courseid),
          'user_id': MultipartFile.fromString(userid),
        }));
    addtocartModel = AddtocartModel.fromJson(response.data);
    return addtocartModel;
  }

  Future<CartbyuserModel> cartbyuser(String userid) async {
    CartbyuserModel cartbyuserModel;
    String apiname = "get_cart_by_user_id";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    cartbyuserModel = CartbyuserModel.fromJson(response.data);
    return cartbyuserModel;
  }

  Future<CartdeleteModel> cartdelete(String userid, String courseid) async {
    CartdeleteModel cartdeleteModel;
    String apiname = "cart_delete";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'course_id': MultipartFile.fromString(courseid),
        }));
    cartdeleteModel = CartdeleteModel.fromJson(response.data);
    return cartdeleteModel;
  }

  Future<GetdownloadModel> getdownload(String userid) async {
    GetdownloadModel getdownloadModel;
    String apiname = "get_download";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    getdownloadModel = GetdownloadModel.fromJson(response.data);
    return getdownloadModel;
  }

  Future<DownloaddeleteModel> downloaddelete(String userid, courseid) async {
    DownloaddeleteModel downloaddeleteModel;
    String apiname = "download_delete";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'course_id': MultipartFile.fromString(courseid),
        }));
    downloaddeleteModel = DownloaddeleteModel.fromJson(response.data);
    return downloaddeleteModel;
  }

  Future<TutorModel> tutor() async {
    TutorModel tutorModel;
    String apiname = "tutor";
    Response response = await dio.post('$baseUrl$apiname');
    tutorModel = TutorModel.fromJson(response.data);
    return tutorModel;
  }

  Future<BrowsecategoryModel> browseCategory() async {
    BrowsecategoryModel browsecategoryModel;
    String apiname = "browser_category";
    Response response = await dio.post('$baseUrl$apiname');
    browsecategoryModel = BrowsecategoryModel.fromJson(response.data);
    return browsecategoryModel;
  }

  Future<GetPageModel> getpage() async {
    GetPageModel getPageModel;
    String apiname = "page";
    Response response = await dio.post('$baseUrl$apiname');
    getPageModel = GetPageModel.fromJson(response.data);
    return getPageModel;
  }

  Future<ContectusModel> contactus(
      String fullname, String email, String number, String message) async {
    ContectusModel contectusModel;
    String apiname = "contactus";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'fullname': MultipartFile.fromString(fullname),
          'email': MultipartFile.fromString(email),
          'mobile_number': MultipartFile.fromString(number),
          'message': MultipartFile.fromString(message),
        }));
    contectusModel = ContectusModel.fromJson(response.data);
    return contectusModel;
  }

  Future<AddwishlistModel> addwishlist(String userid, String courseid) async {
    AddwishlistModel addwishlistModel;
    String apiname = "addremove_wishlist";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'course_id': MultipartFile.fromString(courseid),
        }));
    addwishlistModel = AddwishlistModel.fromJson(response.data);
    return addwishlistModel;
  }

  Future<CourselistbytutoridModel> courselistbytutorid(String tutorid) async {
    CourselistbytutoridModel courselistbytutoridModel;
    String apiname = "courselist_by_tutor_id";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'tutor_id': MultipartFile.fromString(tutorid),
        }));
    courselistbytutoridModel = CourselistbytutoridModel.fromJson(response.data);
    return courselistbytutoridModel;
  }

  Future<CourselistbycategoryidModel> courselistbycategorid(
      String categoryid) async {
    CourselistbycategoryidModel courselistbycategoryidModel;
    String apiname = "get_course_by_category_id";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'category_id': MultipartFile.fromString(categoryid),
        }));
    courselistbycategoryidModel =
        CourselistbycategoryidModel.fromJson(response.data);
    return courselistbycategoryidModel;
  }

  Future<CourseviewModel> courseview(String courseid, String userid) async {
    CourseviewModel courseviewModel;
    String apiname = "add_course_view";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_id': MultipartFile.fromString(courseid),
          'user_id': MultipartFile.fromString(userid),
        }));
    courseviewModel = CourseviewModel.fromJson(response.data);
    return courseviewModel;
  }

  Future<CouponlistModel> couponlist() async {
    CouponlistModel couponlistModel;
    String apiname = "couponlist";
    Response response = await dio.post('$baseUrl$apiname');
    couponlistModel = CouponlistModel.fromJson(response.data);
    return couponlistModel;
  }

  Future<ApplycouponModel> applycoupon(String userid, String couponcode) async {
    ApplycouponModel applycouponModel;
    String apiname = "apply_coupon";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'coupon_code': MultipartFile.fromString(couponcode),
        }));
    applycouponModel = ApplycouponModel.fromJson(response.data);
    return applycouponModel;
  }

  Future<AddtransectionModel> addtransection(coursedetail, userid, paymenttype,
      couponid, currencycode, discountamount, assignCouponid, paymentid) async {
    AddtransectionModel addtransectionModel;
    String apiname = "add_transaction";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'courses_detail': MultipartFile.fromString(coursedetail),
          'user_id': MultipartFile.fromString(userid),
          'payment_type': MultipartFile.fromString(paymenttype),
          'coupon_id': MultipartFile.fromString(couponid),
          'currency_code': MultipartFile.fromString(currencycode),
          'discount_amount': MultipartFile.fromString(discountamount),
          'assign_coupon_id': MultipartFile.fromString(assignCouponid),
          'payment_id': MultipartFile.fromString(paymentid),
        }));
    addtransectionModel = AddtransectionModel.fromJson(response.data);
    return addtransectionModel;
  }

  Future<RelatedcourseModel> relatedcourse(
      String categoryid, String courseid) async {
    RelatedcourseModel relatedcourseModel;
    String apiname = "related_course";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'category_id': MultipartFile.fromString(categoryid),
          'course_id': MultipartFile.fromString(courseid),
        }));
    relatedcourseModel = RelatedcourseModel.fromJson(response.data);
    return relatedcourseModel;
  }
}
