import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/login_page/login_page.dart';


class HomeController extends GetxController{

  var homeLoading = false.obs;
  var home_data;
  List home_List_Question_Color= [].obs;
  var todayLoading = false.obs;
  var lessormore = false.obs;
  var today_data;


  var message;
  var  _correct;
  get correct=>_correct;

  var _incorrect;
  get incorrect=>_incorrect;

  var _user_answer;
  get user_answer =>_user_answer;
  var _correct_ans;
  get correct_ans =>_correct_ans;
  var _is_answer;
  get is_answer =>_is_answer;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  updatelessmore() {
    if(lessormore.value==true){
      lessormore.value =false;
      update();
    }else{
      lessormore.value =true;
      update();
    }
    var homeUrl = apiUrls().home_api;
    Logger_D(homeUrl);
    HomeApi(homeUrl,false);
    log("lessormore $lessormore");
  }
  HomeApi(url,bool status)async{
    homeLoading(status);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){
          home_data =jsonDecode(result.body);
          // _correct_ans = home_data['data']['todayquestion']['currect_answer'];
          // _user_answer = home_data['data']['todayquestion']['your_answer'];
          // _is_answer = home_data['data']['todayquestion']['is_answer'];
          homeLoading(false);
          update(['home_page']);
          refresh();
        }else if(result.statusCode == 401){
          homeLoading(false);
          Get.offAll(LoginPage());
          update();
          refresh();
        }
      } else if(result.statusCode == 501){
        homeLoading(false);
        update();
        refresh();
      }else {
        homeLoading(false);
        update();
        refresh();
      }
    }
    on SocketException {
      throw FetchDataException('No Internet connection');

    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  TodayQuestionApi(url, parameter)async{
    todayLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter, true);
      if (result != null) {
        if(result.statusCode == 200){
          today_data =jsonDecode(result.body);
          message = today_data['message'].toString();
          var homeUrl = apiUrls().home_api;
          Get.find<HomeController>().HomeApi(homeUrl,false);
          todayLoading(false);
          update(['home_page']);
          refresh();
        }else if(result.statusCode == 404){
          todayLoading(false);
          update(['home_page']);
          refresh();
        }
        else if(result.statusCode == 401){
          todayLoading(false);
          update(['home_page']);
          Get.offAll(LoginPage());
          refresh();
        }
        else if(result.statusCode == 500){
          todayLoading(false);
          toastMsg("Internal Server Error", true);
          update(['home_page']);
          refresh();
        }
      } else {
        todayLoading(false);
        update(['home_page']);
        refresh();
      }
    }
    on SocketException {
      throw FetchDataException('No Internet connection');

    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

}