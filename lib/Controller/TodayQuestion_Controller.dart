import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/error_message.dart';

class TodayQuestionController extends GetxController{
  var todayLoader = false.obs;
  var todayData;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  TodayQuestionData(url, parameter, header)async{
    todayLoader(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter, header);
      if (result != null) {
        if(result.statusCode == 200){
          todayData =jsonDecode(result.body);

         Logger_D(todayData);
          todayLoader(false);
          update();
          refresh();
        }else  if(result.statusCode == 401){
          todayLoader(false);
          update();
          refresh();
        }
      } else {
        todayLoader(false);
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

}