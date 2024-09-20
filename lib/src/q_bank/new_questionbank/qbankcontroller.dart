import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/src/q_bank/new_questionbank/questions_qbank.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

class QBankController  extends GetxController{
  ///screenshot image...
  var screenShotPath=''.obs;
  PageController MCQQuestion_controller = PageController(viewportFraction: 1, keepPage: true);
  var examid=0.obs;
  var questionid=0.obs;
  var quecounter =1.obs;



  var getQLoader= false.obs;
  List getQuestionList = [];
  var attempTestData;
  // Track the selected index

  Color tileColor = Colors.white;
  double progressValue = 0.0;
  Timer timer;

  var attempQLoader= false.obs;
  RxBool attempans= false.obs;
  @override
  void onReady() {
    super.onReady();

  }
  AnimationController bcontroller;
  RxBool isPaused = false.obs;

  @override
  void onClose() {
    super.onClose();
  }
  var tick = 0;
  // animationStops(){
  //   // _controller = AnimationController(
  //   //   vsync: this,
  //   //   duration: Duration(seconds: 10), // Adjust the duration as needed
  //   // );
  //   // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  //   // controller = AnimationController(
  //   //   vsync: this,
  //   //   duration: Duration(seconds: 10),
  //   // )..forward();// You can adjust the duration as needed
  //   // )..addStatusListener((status) {
  //   //   if (status == AnimationStatus.completed) {
  //   //     controller.reverse(); // R
  //   //     // update();// everse the animation when it's completed
  //   //   } else if (status == AnimationStatus.dismissed) {
  //   //     controller.forward();
  //   //     // update();// Start the animation again when it's dismissed
  //   //   }
  //   //   update();
  //   // });
  //   // controller.addListener(() {
  //   //   controller.value = 0.0;
  //   //   print("reset: > ");
  //   //   update();
  //   // });
  //   // controller.forward();
  //   var timeLimitInSeconds = int.parse(Environment.test_time.toString()); // 10 minutes = 600 seconds
  //   var interval = const Duration(seconds: 1);
  //
  //
  //   timer = Timer.periodic(interval, (timer)  {
  //     progressValue = tick / timeLimitInSeconds;
  //     // tick =tick +0.1;
  //     tick ++;
  //     update();
  //     if (tick > timeLimitInSeconds) {
  //       print("check-->"+tick.toString());
  //       // tick = 0.0;
  //       tick = 0;
  //       // updatequestion_timer();
  //       // Reset the timer when it reaches 10 minutes
  //       update();
  //     }
  //
  //   });
  //
  // }
  // void togglePause() {
  //   isPaused.value = !isPaused.value;
  //   if (isPaused.value) {
  //     bcontroller.stop();
  //     update();
  //   } else {
  //     bcontroller.repeat();
  //     update();
  //   }
  // }
  controllertimerstop(){

    bcontroller.stop();
    bcontroller.reset();
    update();

  }
  controllertimerstart(){
    // tick = 0.0;
    bcontroller.reset();
    bcontroller.repeat();
    update();
  }
  @override
  void onInit() {
    super.onInit();
  }
  updatequestion_next(){

    quecounter.value = quecounter.value +1;
    if(getQuestionList[0]['questions'][quecounter.value]['is_attempt'] ==0){
      MCQQuestion_controller.jumpToPage(quecounter.value);
      bcontroller.reset();
      bcontroller.repeat();
    }else{
      MCQQuestion_controller.jumpToPage(quecounter.value);
    }

    print("quecounter value : "+quecounter.value.toString());
    update();
  }
  updatequestion_prev(){

    quecounter.value = quecounter.value -1;
    if(getQuestionList[0]['questions'][quecounter.value]['is_attempt'] ==0){
      MCQQuestion_controller.jumpToPage(quecounter.value);
      bcontroller.reset();
      bcontroller.repeat();
    }else{
      MCQQuestion_controller.jumpToPage(quecounter.value);
    }

    print("quecounter value : "+quecounter.value.toString());
    update();
  }

  updatequestion_timer() async {

    controllertimerstop();
    final questoptionText = getQuestionList[0]['questions'][quecounter.value ];

    final questoptionwrong_right = getQuestionList[0]['queue'][quecounter.value ];
    var attemptQUrl =apiUrls().attempt_question_api;
    var attemptQBody = {
      'exam_id': examid.value.toString(),
      'question_id':questoptionText['id'].toString(),

    };
    print("attemp attemptQUrl > " + attemptQUrl.toString());
    print("attemp attemptQBody > " + attemptQBody.toString());
    questoptionText['questionObjects'].forEach((e){
      if(e['is_correct']==1){
          e['is_correct']= 2;
          questoptionwrong_right['is_answer'] =3;
      }
    });
    // questoptionText['questionObjects']= 2;
    // questoptionwrong_right['is_answer'] =4;



    Timer(Duration(seconds: 1),
            () {
          questoptionText['is_attempt'] = 1;
          questoptionText['attempt_test_questions']['your_answer'] = null;
          // print("selectedoption isCorrect: "+optionText['is_correct'].toString());
          update();
        });


    update();
    await AttemptQuestionApi(attemptQUrl, attemptQBody);

    print("quecounter value : "+quecounter.value.toString());
    update();
  }
  updatequestion_color_result(iscorrectoption,index,index1,isanswer,questionid) async {
    attempans.value = true;
    update();
    print("attemp attempans.value 2> " + attempans.value.toString());
    controllertimerstop();
    final optionText = getQuestionList[0]['questions'][quecounter.value ]['questionObjects'][index];
    final questoptionText = getQuestionList[0]['questions'][quecounter.value ];
    final questoptionwrong_right = getQuestionList[0]['queue'][quecounter.value ];
    var attemptQUrl =apiUrls().attempt_question_api;
    var attemptQBody = {
      'exam_id': examid.value.toString(),
      'question_id':questionid.toString(),
      'answer_id': isanswer.toString()
    };

    print("attemp attemptQUrl > " + attemptQUrl.toString());
    print("attemp attemptQBody > " + attemptQBody.toString());
    if(iscorrectoption == 1){
      optionText['is_correct']= 2;
      questoptionwrong_right ['is_answer'] =1;

    }
    else{

      Vibration.vibrate(amplitude: 2000,intensities: [1, 255] );
      HapticFeedback.selectionClick();
      optionText['is_correct']= 3;
      questoptionwrong_right ['is_answer'] =2;
    }

    Timer(Duration(milliseconds: 500),
            () {
          questoptionText['is_attempt'] = 1;
          questoptionText['attempt_test_questions']['your_answer'] = isanswer;
          print("selectedoption isCorrect: "+optionText['is_correct'].toString());
          attempans.value = false;
          update();
        });
    // questoptionText['is_attempt'] = 1;
    // questoptionText['attempt_test_questions']['your_answer'] = isanswer;
    print("selectedoption isCorrect: "+optionText['is_correct'].toString());


    update();
    print("attemp attempans.value 3> " + attempans.value.toString());
    await AttemptQuestionApi(attemptQUrl, attemptQBody);

  }
  GetQuestionApi(url,bool status)async{
    getQLoader(status);

    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){
        var  decode = jsonDecode(result.body);
          getQuestionList.clear();
          getQuestionList.add(decode['data']);

          print("getQuestionList ....."+getQuestionList.toString());


          getQLoader(false);

          update();
          refresh();
        }else  if(result.statusCode == 404){
        var  decode =jsonDecode(result.body);
          toastMsg(decode['message'], true);
          Get.to(SubscriptionPlan());
          getQuestionList.clear();
          getQuestionList=[];
          getQLoader(false);

          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          attempTestData =jsonDecode(result.body);
          print("attempTestData 401......"+attempTestData.toString());
          getQLoader(false);

          update();
          refresh();
        }
        else  if(result.statusCode == 500){
          attempTestData =jsonDecode(result.body);
          print("attempTestData 500......"+attempTestData.toString());
          getQLoader(false);

          update();
          refresh();
        }
      } else {
        getQLoader(false);

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
  AttemptQuestionApi(url,parameter)async{
    attempQLoader(true);

    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter, true);
      if (result != null) {
        if(result.statusCode == 200){

          attempQLoader(false);
          update();
          refresh();

        }else if(result.statusCode == 404){

          attempQLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 401){

          attempQLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 500){
          attempQLoader(false);
          update();
          refresh();
        }
      } else {
        attempQLoader(false);
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