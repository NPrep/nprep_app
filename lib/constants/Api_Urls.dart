
import 'dart:io';
import 'dart:math';

import 'package:n_prep/Envirovement/Environment.dart';
var random = new Random();

//.. Live
//baseurl = https://nprep.in/api/


//.. Staging
//baseurl = https://adiyogionlinetrade.com/nprep/api/

var baseUrl = Environment.apibaseurl;
const appleApiKey = 'appl_IDchaKoYkRjNTVqWNMQyELIShMC';
const entitlementID = 'Plan 1 Year';

class apiUrls{

  var app_version= 31;
  var ios_app_version= 9;
  var App_force_updateNo="1";
  var App_Maintaince_updateNo="1";

  // double appversions = 1.0;
  // var maintainversion = "1";
  // String App_force_updateNo="1";
  // var appname = "Track Time";
  // var appmaintancename = "Track Time";
  // int const_refresh = 120;

  String XAPIKEY = "x-api-key";
  String XAPIVALUE = "81c6f9906b84eeda60f6e010b9360923b79055eca0b5ab1212c75b9dec5";
  String Authorization = "Authorization";
  String AuthorizationKey = "Bearer ${Environment.apibasetoken}";
  var Username = "aytadmin";
  var Password = "12345";

  String imageUrl = "https://technolite.in/staging/nprep/";

  // AUTH APIS
  var register_api = baseUrl+"register";
  var send_otp_api = baseUrl+"send_otp";

  var Social_send_otp_api = baseUrl+"social_otp/send";
  var Social_otp_verify_api = baseUrl+"social_otp/verification";


  var updatemobile_api = baseUrl+"updatemobile";
  var login_api = baseUrl+"login";
  var MobileSendOTP_api = baseUrl+"login/otp/send";
  var social_login_api = baseUrl+"social_login";
  var changepassword_api= baseUrl+"updatepassword";
  var forgotpassword_api= baseUrl+"forgotpassword";
  var resetPassword_api= baseUrl+"resetpassword";
  var MobileLoginOTP_api= baseUrl+"login/otp";

  var home_api = baseUrl+"home";
  var cpass_api = baseUrl+"updatepassword";
  var cms_api = baseUrl+"cms/";
  var setting_api = baseUrl+"setting";

  var profile_api = baseUrl+"profile";
  var updateprofile_api = baseUrl+"updateprofile";
  var country_api = baseUrl+"country";
  var state_api = baseUrl+"state/";
  var city_api = baseUrl+"city/";
  var qualifications = baseUrl+"qualifications";

  var collages_url = baseUrl+"colleges/";

  // PLAN AND BUY PLAN APIS

  var couponlist_api = baseUrl+"coupons";

  var subscriptions_api = baseUrl+"subscriptions";
  var destroy_api = baseUrl+"destroy";
  var buy_user_plan_api = baseUrl+"buy_user_plan";
  var payment_sucess_api = baseUrl+"subscriptions/payment/status/";
  var generate_in_app_purchase_api = baseUrl+"in_app_purchase";
  var payment_in_app_purchase_api = baseUrl+"in_app_purchase/payment/status/";
  var plan_history_api = baseUrl+"plan_history";

  var verify_coupon_api = baseUrl+"coupons/verify/";



  // TEST API CALLING

  var today_question_api = baseUrl+"today/question/attempt";
  var parent_categories_api = baseUrl+"parent_categories";
  var exam_subjects_categories_api = baseUrl+"exam_subjects";
  var child_categories_api = baseUrl+"child_categories";

  var test_attempt_api = baseUrl+"test/attempt";
  var get_question_api = baseUrl+"test/questions/get";
  var attempt_question_api = baseUrl+"test/question/attempt";
  var test_review_api = baseUrl+"test/result/";

  // EXAM API HERE ====

  var exam_list_api = baseUrl+"exam_list";
  var Mock_exam_list_api = baseUrl+"mock_exam_list";
  var exam_attempt_api = baseUrl+"exam/attempt/";
  var Mock_exam_attempt_api = baseUrl+"mock_exam/attempt/";
  var exam_questions_api = baseUrl+"exam/questions/";
  var Mock_exam_questions_api = baseUrl+"mock_exam/questions/";
  var exam_ans_attempt_api = baseUrl+"exam/questions/attempt/";
  var Copy_exam_ans_attempt_api = baseUrl+"exam/questions/final/attempt/";
  var Mock_Copy_exam_ans_attempt_api = baseUrl+"mock_exam/questions/final/attempt/";
  var exam_review_api = baseUrl+"exam/result/";
  var exit_exam_api = baseUrl+"exam/exit/";
  var daily_section_list_api = baseUrl+"daily_section_list?exam_id=";
  var Exam_leadership_api = baseUrl+"exam/leadership/";
  // var exit_mockexam_api = baseUrl+"mock_exam/exit/";
  //-----------Nprep2 Api-------------//
  var parent_video_categories_api = baseUrl+"parent_video_categories";
  var child_video_categories_api = baseUrl+"child_video_categories";
  var videos_deatil_api = baseUrl+"videos";
  var search_categories_api = baseUrl+"categories/search";
  var videos_saved_api = baseUrl+"videos/saved?video_id=";
  var videos_pause_api = baseUrl+"videos/pause?video_id=";
  var videos_unsaved_api = baseUrl+"videos/unsaved?video_id=";
  var videos_attempt_api = baseUrl+"videos/attempt?video_id=";
  var videos_unattempt_api = baseUrl+"videos/unattempt?video_id=";

  var test_question_review = baseUrl+"test/question/review";
  var live_classes_api = baseUrl+"live_classes";
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}