import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/Models/AllCategory.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import 'package:n_prep/src/q_bank/new_questionbank/questions_qbank.dart';
import 'package:n_prep/src/q_bank/quetions.dart';
import 'package:n_prep/src/q_bank/detail.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';

import '../Local_Database/database.dart';
import '../main.dart';
import '../src/home/bottom_bar.dart';


class CategoryController extends GetxController  with GetSingleTickerProviderStateMixin{
  var parentLoader = false.obs;
  var parentData;
  var childLoader = false.obs;
  var childdata = [];
  Map<String, dynamic> second_level;
  // List<dynamic> data;

  var examid=0.obs;
  var second_levelCount=0.obs;
  var questionid=0.obs;
  var quecounter = 1.obs;


  @override
  void onReady() {
    super.onReady();

  }


  @override
  void onClose() {
    controllertimerstop();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }
  AnimationController controller;
  Animation<double> _animation;
   Timer timer;
  double progressValue = 0.0;
  // var tick = 0.0;
  var tick = 0;
  animationStops(){
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 10), // Adjust the duration as needed
    // );
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 10),
    // )..forward();// You can adjust the duration as needed
    // )..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(); // R
    //     // update();// everse the animation when it's completed
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //     // update();// Start the animation again when it's dismissed
    //   }
    //   update();
    // });
    // controller.addListener(() {
    //   controller.value = 0.0;
    //   print("reset: > ");
    //   update();
    // });
    // controller.forward();
    var timeLimitInSeconds = int.parse(Environment.test_time.toString()); // 10 minutes = 600 seconds
    var interval = const Duration(seconds: 1);


    timer = Timer.periodic(interval, (timer)  {
      progressValue = tick / timeLimitInSeconds;
      // tick =tick +0.1;
      tick ++;
      update();
      if (tick > timeLimitInSeconds) {
        print("check-->"+tick.toString());
        // tick = 0.0;
        tick = 0;
        nextquestion();
        // Reset the timer when it reaches 10 minutes
        update();
      }

    });

  }
  nextquestion() async {
    var attemptQUrl = apiUrls().attempt_question_api;
    var get_data =getQuestionList[quecounter.value - 1];
    var attemptQBody = {
      'exam_id': examid.value.toString(),
      'question_id': get_data['id'].toString(),
      // 'answer_id': null
    };
    await AttemptQuestionApi(attemptQUrl, attemptQBody);
    Map<String, String> queryParams = {
      'exam_id':
      examid.value.toString(),
      'exam_status': "2",
    };
    String queryString = Uri(queryParameters:queryParams).query;
    var get_questionUrl =apiUrls().get_question_api +'?' +queryString;
    GetQuestionApi(get_questionUrl, false, false);
    controllertimerstop();
  }
  controllertimerstop(){
    timer.cancel();
    // tick = 0.0;
    tick = 0;
    update();
  }
  controllertimerstart(){
    // tick = 0.0;
    tick = 0;
    animationStops();
    update();
  }
 ParentCategoryApi(url)async{
   parentLoader(true);

   String jsonData = sprefs.getString('qbank_data');

   if(jsonData==null){
     await getdata(url);
   }else{
     parentData = jsonDecode(jsonData);
     parentLoader(false);
     await getdata(url);
     update();
     refresh();
   }
  }

  getdata(url)async{
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){

          parentData =jsonDecode(result.body);
          await sprefs.setString('qbank_data', result.body);

          parentLoader(false);
          update();
          refresh();
        }else  if(result.statusCode == 401){
          parentLoader(false);
          update();
          refresh();
        }
      } else {
        parentLoader(false);
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

  var child;

  ChildCategoryApi(url,int parent_id)async{
    childLoader(true);
    var temp = await sprefs.getBool("is_internet");
    if(temp) {
      try {
        var result = await apiCallingHelper().getAPICall(url, true);
        if (result != null) {
          print("childdata Check statusCode.......${result.statusCode}");
          child = jsonDecode(result.body);
          if (result.statusCode == 200) {
            // childData.clear();

            childdata.clear();
            childdata.add(child['data']);
            second_levelCount.value = childdata[0]['second_level'].length;
            print("childdata Check.......${childdata[0]['third_level']}");
            print("second_levelCount.......${second_levelCount}");
            // print("second_level Check.......${second_level}");
            await Future.delayed(Duration(seconds: 1));
            childLoader(false);
            update();
            refresh();
          } else if (result.statusCode == 404) {
            childLoader(false);
            childdata.clear();
            childdata.addAll(child['data']);

            print("childdata Check 404......${childdata}");
            update();
            refresh();
          }
          else if (result.statusCode == 401) {
            childLoader(false);
            Get.offAll(LoginPage());
            update();
            refresh();
          }
          else if (result.statusCode == 500) {
            childLoader(false);
            toastMsg("Internal Server Error", true);
            update();
            refresh();
          }
        } else {
          childLoader(false);
          update();
          refresh();
        }
      }
      on SocketException {
        throw FetchDataException('No Internet connection');
      } on TimeoutException {
        throw FetchDataException('Something went wrong, try again later');
      }
    }else{
      var dbHelper = DatabaseHelper();

      // Call fetchChildCategories using the instance
      var data = await dbHelper.fetchAllCategories(parent_id);
      childdata.clear();
      await childdata.add(data['data']);

      await Future.delayed(Duration(seconds: 1));
      childLoader(false);
      update();
    }
  }


  Future<void> fetchAllCategories() async {
    // Show loading state (you can use a loader or any state management technique)
    childLoader(true);

    // Fetch data from the API
    try {
      var result = await apiCallingHelper().getAPICall(apiUrls().all_categories, true);

      // Check if the result is valid
      if (result != null) {
        if (result.statusCode == 200) {
          var fetchedData = jsonDecode(result.body);

          // Clear existing categories in the database before inserting new ones
          await DatabaseHelper().clearQBankCategories();

          // Loop through the fetched categories and save them into the local database
          for (var categoryData in fetchedData['data']) {
            AllCategory category = AllCategory(
              id: categoryData['id'],
              slug: categoryData['slug'],
              parentId: categoryData['parent_id'],
              name: categoryData['name'],
              description: categoryData['description'],
              metaTitle: categoryData['meta_title'],
              metaKeyword: categoryData['meta_keyword'],
              metaDescription: categoryData['meta_description'],
              feeType: categoryData['fee_type'],
              isFeature: categoryData['is_feature'],
              isMixed: categoryData['is_mixed'],
              image: categoryData['image'] ?? '',
              sortOrder: categoryData['sort_order'],
              status: categoryData['status'],
              deletedAt: categoryData['deleted_at'] ?? null,
              createdAt: categoryData['created_at'] ?? null,
              updatedAt: categoryData['updated_at'] ?? null,
              totalQuestions: categoryData['total_questions']
            );


            // Insert the category into the database
            await DatabaseHelper().insertAllCategory(category);
          }

          // Hide loading state
          childLoader(false);
        }
      }
    } catch (e) {
      print(e);
      // Optionally handle errors by hiding the loading state
      childLoader(false);
    }
  }



  var attempLoader = false.obs;
  var attempTestData;

  var _checkexamid;
  get checkexamid => _checkexamid;

  var _checkstatus;
  get checkstatus => _checkstatus;
  var _totalattempt_que;
  get totalattempt_que => _totalattempt_que;


    purchasePlan(
        context,
        perentId,
        _checkexamid,
        cat_name,
        _checkstatus,
        _totalattempt_que,
        total_que,
        completed_date,
        created_at, bool status){
      var body={ "title": cat_name.toString(),
                    "header" :perentId.toString(),
                    "examid" :_checkexamid.toString(),
                    "checkstatus": _checkstatus,
                    "attempquestion":_totalattempt_que ,
                    "total_questions":total_que ,
                    "completed_date": completed_date,
                    "created_at":  created_at};
      print("attem body > "+body.toString());
    if(_checkstatus==3){
      print("check status 3");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Details(
                    title: cat_name.toString(),
                    header :perentId.toString(),
                    examid :_checkexamid.toString(),
                    checkstatus: _checkstatus,
                    attempquestion:_totalattempt_que ,
                    total_questions:total_que ,
                    completed_date: completed_date,
                    created_at:  created_at,
                    pagestatus: status,
                  )));
    }
    else if(_checkstatus==2){
      print("check status 2");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Details(
                    title: cat_name.toString(),
                    header :perentId.toString(),
                    examid :_checkexamid.toString(),
                    checkstatus: _checkstatus,
                    attempquestion:_totalattempt_que ,
                    total_questions:total_que ,
                    completed_date: completed_date,
                    created_at:  created_at,
                    pagestatus: status,
                  )));
    }
    else{
      print("check status 1");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  questionbank_new(counterindex: 1,
                  examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:status ,))
      );
    }
  }


  AttemptTestApi(url,context,perentId,cat_name,bool status)async{
    attempLoader(true);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){
          attempTestData =jsonDecode(result.body);
          log('attempTestData==>'+attempTestData.toString());
          _checkexamid = attempTestData['data']['id'];
          _checkstatus = attempTestData['data']['exam_status'];
          _totalattempt_que = attempTestData['data']['attempt_questions'];
          var total_que = attempTestData['data']['total_questions'];
         var completed_date = attempTestData['data']['completed_date'];
         var created_at = attempTestData['data']['created_at'];
          purchasePlan(context,perentId,_checkexamid,cat_name,_checkstatus,
              _totalattempt_que,
              total_que,
              completed_date,created_at,status);
          print("attempTestData......"+attempTestData.toString());
          print("checkexamid......"+_checkexamid.toString());
          print("checkstatus......"+_checkstatus.toString());
          print("totalattempt_que......"+_totalattempt_que.toString());

          attempLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 404){
          attempTestData =jsonDecode(result.body);
          toastMsg(attempTestData['message'], true);

          Get.to(SubscriptionPlan());
          print("attempTestData 404......"+attempTestData.toString());
          attempLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          attempTestData =jsonDecode(result.body);
          toastMsg(attempTestData['message'], true);

          Get.to(SubscriptionPlan());
          print("attempTestData 404......"+attempTestData.toString());
          attempLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 500){
          attempTestData =jsonDecode(result.body);
          print("attempTestData 500......"+attempTestData.toString());
          attempLoader(false);
          update();
          refresh();
        }
      } else {
        attempLoader(false);
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

  var getQLoader= false.obs;

  List getQuestionList = [];
  var decode;

  List ontap_answer=[];

  GetQuestionApi(url,bool status,bool reattempt)async{
    getQLoader(status);

    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){
           decode = jsonDecode(result.body);
          getQuestionList.clear();
          getQuestionList.addAll(decode['data']);
           Logger_D(getQuestionList);
          print("getQuestionList ....."+getQuestionList.toString());

           print("ontap_answer : "+ontap_answer.length.toString());
          // if(reattempt==true){
          //   Get.to(questionbank_new());
          // }
          getQLoader(false);

          update();
          refresh();
        }else  if(result.statusCode == 404){
          decode =jsonDecode(result.body);
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


  var attempQLoader= false.obs;




  // List attempQue_List = [];
  List Colors_List = [];


  AttemptQuestionApi(url,parameter)async{
   attempQLoader(true);

    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter, true);
      if (result != null) {
        if(result.statusCode == 200){
          // attemptQ_Data = jsonDecode(result.body);
          // print("attemptQ_Data......"+attemptQ_Data.toString());
          //
          //
          // object_decode = attemptQ_Data['data']['object_json'];
          // print("object_decode......"+object_decode.toString());

          // var data = {
          //   "status": true,
          //   "message": "Question attempt successfully",
          //   "data": {
          //     "id": 11,
          //     "master_attempt_subjectquestion_id": "12",
          //     "question_id": 1,
          //     "question_name": "To the maternal and fetal components of the structure shown below, respectively?",
          //     "question_attachment": "public/uploads/question/16945123798190.png",
          //     "object_json": "[{\"option_id\":0,\"question_id\":1,\"objective\":null,\"attachment\":\"https:\\/\\/technolite.in\\/staging\\/nprep\\/public\\/uploads\\/objective\\/16945123790.jpg\",\"is_correct\":0},{\"option_id\":1,\"question_id\":1,\"objective\":null,\"attachment\":\"https:\\/\\/technolite.in\\/staging\\/nprep\\/public\\/uploads\\/objective\\/16945123791.jpg\",\"is_correct\":1},{\"option_id\":2,\"question_id\":1,\"objective\":null,\"attachment\":\"https:\\/\\/technolite.in\\/staging\\/nprep\\/public\\/uploads\\/objective\\/16945123792.png\",\"is_correct\":0},{\"option_id\":3,\"question_id\":1,\"objective\":null,\"attachment\":\"https:\\/\\/technolite.in\\/staging\\/nprep\\/public\\/uploads\\/objective\\/16945123793.png\",\"is_correct\":0}]",
          //     "currect_answer": 1,
          //     "your_answer": "2",
          //     "is_answer": 2,
          //     "created_at": "2023-09-14T05:00:58.000000Z",
          //     "updated_at": "2023-09-14T05:00:58.000000Z"
          //   }
          // };
          // attempQue_List.clear();
          // attempQue_List.add(attemptQ_Data['data']);
          // // Colors_List.add(attemptQ_Data['data']['is_answer']);
          // // print("Colors_List....."+Colors_List.toString());
          // print("attempQue_List....."+attempQue_List.toString());
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