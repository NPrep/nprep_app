import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/Timer_screen_common.dart';
import 'package:n_prep/src/test/ExamReview_Page.dart';
import 'package:n_prep/src/test/Exam_Question_Page.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Local_Database/database.dart';
import '../Models/Exam.dart';
import '../constants/Api_Urls.dart';
import '../src/Nphase2/VideoScreens/DatabaseSqflite.dart';
import '../main.dart';
import '../src/test/Mock_Exam_Question_Page.dart';

class ExamController extends GetxController {
  var getELoader = false.obs;
  var examScoreLoader = false.obs;
  var ExitLoader = false.obs;
  var SubjectLoader = false.obs;
  var SubjectData;
  var get_data;
  List examScore_data = [];
  var attemptELoader = false.obs;
  var attempt_data;




  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {

    super.onClose();
  }
  @override
  void onInit() {
    super.onInit();

  }





  List exam_deatils = [];

  GetExamScore(url) async {
    examScoreLoader(true);
    try {
      var result = await apiCallingHelper().getAPICall(url, true);
      examScore_data.clear();

      if (result != null) {
        if (result.statusCode == 200) {
          examScore_data.add(jsonDecode(result.body)['data']);
          print("get examScoreData > " + examScore_data.toString());


          examScoreLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          examScoreLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          examScoreLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          examScoreLoader(false);
          update();
          refresh();
        }
      } else {
        examScoreLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      examScoreLoader(false);
      update();
    }
  }


  GetExamData(url) async {
    getELoader(true);

    String jsonData = sprefs.getString('pyq_data');

    if(jsonData==null){
      await getdata(url);
    }else{
      get_data = jsonDecode(jsonData);
      getELoader(false);
      await getdata(url);
      update();
      refresh();
    }
  }

  GetExamData2(url,status) async {
    getELoader(true);
    String jsonData;

    log("status : $status");

    if(status=="4"){
      jsonData = sprefs.getString('test_data');
    }else{
      jsonData = sprefs.getString('mock_data');
    }

    if(jsonData==null){
      await getdata2(url,status);
    }else{
      get_data = jsonDecode(jsonData);
      getELoader(false);
      await getdata2(url,status);
      update();
      refresh();
    }
  }


  getdata2(url,status)async{
    try {
      var result = await apiCallingHelper().getAPICall(url, true);
      if (result != null) {
        if (result.statusCode == 200) {
           if(status == "4"){
             get_data.clear();
             get_data = jsonDecode(result.body);
             await sprefs.setString('test_data', result.body);

             print("get year exam  list > " + get_data.toString());
           }else{
             get_data.clear();
             get_data = jsonDecode(result.body);
             await sprefs.setString('mock_data', result.body);

             print("get year exam  list > " + get_data.toString());
           }

          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          getELoader(false);
          update();
          refresh();
        }
      } else {
        getELoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      getELoader(false);
      update();
    }
  }


  getdata(url)async{
    try {
      var result = await apiCallingHelper().getAPICall(url, true);
      get_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {
          get_data.clear();
          get_data = jsonDecode(result.body);
          await sprefs.setString('pyq_data', result.body);
          print("get year exam  list > " + get_data.toString());


          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          getELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          getELoader(false);
          update();
          refresh();
        }
      } else {
        getELoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      getELoader(false);
      update();
    }
  }


  Future<void> fetchAndSaveExams() async {
    // Show loading state
    getELoader(true); // Assuming you have a method to show a loading indicator

    // Fetch data from the API
    try {
      var result = await apiCallingHelper().getAPICall(apiUrls().all_exams, true);

        if (result.statusCode == 200) {
          var fetchedData = jsonDecode(result.body);

          // Clear existing exams in the database
          await DatabaseHelper().clearExams();

          // Loop through the fetched exams and save them in the database
          for (var examData in fetchedData['data']) {
            Exam exam = Exam(
              id: examData['id'],
              image: examData['image'],
              examType: examData['exam_type'],
              subject: examData['subject'],
              title: examData['title'],
              feeType: examData['fee_type'],
              examYear: examData['exam_year'],
              userTag: examData['user_tag'],
              examDuration: examData['exam_duration'],
              description: examData['description'] ?? '', // Assuming description field is present
              sortOrder: examData['sort_order'] ?? 0, // Default value if sort_order is not present
              status: examData['status'] ?? 1, // Default value if status is not present
              isPublished: examData['is_published'] ?? 0 // Default value if is_published is not present
            );

            // Insert the exam into the database
            await DatabaseHelper().insertExam(exam);
          }

          // Hide loading state
          getELoader(false);
        }
    } catch (e) {
      print(e);
      // Optionally hide loading state on error
      getELoader(false);
    }
  }



  GetExamData3(url,parentId)async{
    try {
      getELoader(true);

      var temp = sprefs.getBool("is_internet");
      if(temp){
        var result = await apiCallingHelper().getAPICall(url, true);
        get_data = jsonDecode(result.body);
        if (result != null) {
          if (result.statusCode == 200) {
            get_data.clear();
            get_data = jsonDecode(result.body);
            print("get year exam  list > " + get_data.toString());


            getELoader(false);
            update();
            refresh();
          }
          else if (result.statusCode == 401) {
            getELoader(false);
            update();
            refresh();
          }
          else if (result.statusCode == 404) {
            getELoader(false);
            update();
            refresh();
          }
          else if (result.statusCode == 500) {
            getELoader(false);
            update();
            refresh();
          }
        } else {
          getELoader(false);
          update();
          refresh();
        }
      }else{
        var res = await DatabaseHelper().fetchAndDisplayFilteredExams(parentId);
        get_data = res;
        getELoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      getELoader(false);
      update();
    }
  }



  var exitLoader = false.obs;
  var exit_exam_data;

  Exit_Exam_Data(url,bool today) async {
    exitLoader(true);
    try {
      var result = await apiCallingHelper().getAPICall(url, true);
      exit_exam_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {
          exit_exam_data = jsonDecode(result.body);
          log("exit_exam_data Exit_Exam_Data " + exit_exam_data.toString());
          final DatabaseService dbHelper = DatabaseService.instance;
          await dbHelper.deleteExamTask();
          if(exit_exam_data['data']['id']!=null){

            Get.offAll(ExamReviewPage(exam_Ids: exit_exam_data['data']['id'].toString(),exam_Id:exit_exam_data['data']['exam_id'] ,today: today,));

          }else{}
          print("exit_exam_data " + get_data.toString());

          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          exitLoader(false);
          update();
          refresh();
        }
      }
      else {
        exitLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      exitLoader(false);
      update();
    }
  }
  Exit_HomeExam_Data(url) async {
    exitLoader(true);
    try {
      var result = await apiCallingHelper().getAPICall(url, true);
      exit_exam_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {
          exit_exam_data = jsonDecode(result.body);
          log("exit_exam_data Exit_Exam_Data " + exit_exam_data.toString());
          final DatabaseService dbHelper = DatabaseService.instance;
          await dbHelper.deleteExamTask();

          print("exit_exam_data " + get_data.toString());

          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          exitLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          exitLoader(false);
          update();
          refresh();
        }
      }
      else {
        exitLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      exitLoader(false);
      update();
    }
  }
  AttemptExamData(url,Examduration) async {
    attemptELoader(true);
    log("AttemptExamData>> ");
    try {
      var result = await apiCallingHelper().getPostAPICall(url, true);
      attempt_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {
          attempt_data = jsonDecode(result.body);

          var id = attempt_data['data']['id'];
          var starttime = attempt_data['data']['exam_start_time'];
          var endtime = attempt_data['data']['exam_end_time'];
          var exam_id = attempt_data['data']['exam_id'];
          var exam_status = attempt_data['data']['exam_status'];

          var currenttime = DateTime.now();
          DateTime dt1 = DateTime.parse(currenttime.toString().split(".")[0]);
          DateTime examEndTime =DateTime.parse(endtime);

          Duration timeDifference = examEndTime.difference(dt1);


          if(int.parse(exam_status.toString())!=3){


          if (timeDifference.inMinutes >= 0) {
            // Only enter this block if the value is non-negative
            if(timeDifference.inMinutes == 1){
              int totalMinutes = Examduration; // Replace with your total minutes
              int remainingMinutes = timeDifference.inSeconds;
              double percentage = (remainingMinutes / totalMinutes) * 100;
             Get.to(ExamQuestion(), arguments: [id,timeDifference.inSeconds,percentage,false,exam_id]);

            }else{
              int totalMinutes = Examduration; // Replace with your total minutes
              int remainingMinutes = timeDifference.inMinutes;
              double percentage = (remainingMinutes / totalMinutes) * 100;
              Get.to(ExamQuestion(), arguments: [id,timeDifference.inMinutes,percentage,true,exam_id]);

            }



          }
          else {
            // Handle the case when the value is negative

            toastMsg("${attempt_data['message']}", true);

          }
          }else{
            toastMsg(attempt_data['message'], true);

          }

          attemptELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 401) {
          toastMsg(attempt_data['message'], true);
          Get.to(SubscriptionPlan());
          attemptELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          Get.to(SubscriptionPlan());
          attemptELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          attemptELoader(false);
          update();
          refresh();
        }
      } else {
        attemptELoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      attemptELoader(false);
      update();
    }
  }


  MockAttemptExamData(url,Examduration,bool value) async {
    attemptELoader(true);
    log("MockAttemptExamData>> ");
    try {
      var result = await apiCallingHelper().getPostAPICall(url, true);
      attempt_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {
          attempt_data = jsonDecode(result.body);
          print("fetch Attemp Data " + attempt_data['data'].toString());
          var id = attempt_data['data']['id'];
          var starttime = attempt_data['data']['exam_start_time'];
          var endtime = attempt_data['data']['exam_end_time'];
          var exam_id = attempt_data['data']['exam_id'];
          var exam_status = attempt_data['data']['exam_status'];
          print("exam_status......." + exam_status.toString());
          print("exam_id......." + exam_id.toString());
          var currenttime = DateTime.now();
          DateTime dt1 = DateTime.parse(currenttime.toString().split(".")[0]);
          DateTime examEndTime =DateTime.parse(endtime);
          print("Attemp Data dt1......." + dt1.toString());
          print("Attemp Data Id......." + id.toString());
          print("Attemp Data examEndTime......." + examEndTime.toString());
          print("Attemp Data starttime......." + starttime.toString());
          print("Attemp Data endtime......." + endtime.toString());
          print("Attemp Data currenttime......." + currenttime.toString());
          Duration timeDifference = examEndTime.difference(dt1);

          print("Attemp Data timeDifference......." + timeDifference.inMinutes.toString());
          print("Attemp Data timeDifference......." + timeDifference.inMinutes.toString());

          if(int.parse(exam_status.toString())!=3){

            print('exam_status check : ${exam_status.toString()}');
            if (timeDifference.inMinutes >= 0) {
              // Only enter this block if the value is non-negative
              if(timeDifference.inMinutes == 1){
                int totalMinutes = Examduration; // Replace with your total minutes
                int remainingMinutes = timeDifference.inSeconds;
                double percentage = (remainingMinutes / totalMinutes) * 100;
                Get.to(MockExamQuestion(), arguments: [id,timeDifference.inSeconds,percentage,false,exam_id,value]);
                print('Value is non-negative inSeconds : ${timeDifference.inSeconds}');
              }else{
                int totalMinutes = Examduration; // Replace with your total minutes
                int remainingMinutes = timeDifference.inMinutes;
                double percentage = (remainingMinutes / totalMinutes) * 100;
                Get.to(MockExamQuestion(), arguments: [id,timeDifference.inMinutes,percentage,true,exam_id,value]);
                print('Value is non-negative inMinutes : ${timeDifference.inMinutes}');
              }



            }
            else {
              // Handle the case when the value is negative

              toastMsg("${attempt_data['message']}", true);
              print('Value is negative: ${timeDifference.inMinutes}');
            }
          }else{
            toastMsg(attempt_data['message'], true);
            print('exam_status check else: ${exam_status.toString()}');
          }
          // Get.to(ExamQuestion(), arguments: [id,timeDifference]);

          attemptELoader(false);
          update();
          refresh();
        } else if (result.statusCode == 401) {
          toastMsg(attempt_data['message'], true);
          Get.to(SubscriptionPlan());
          attemptELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          Get.to(SubscriptionPlan());
          attemptELoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 500) {
          attemptELoader(false);
          update();
          refresh();
        }
      } else {
        attemptELoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      attemptELoader(false);
      update();
    }
  }
  var getQueLoader = false.obs;
  var get_que_data;
  List ontap_answer=[];

  List get_que_list = [];
  List Copy_get_que_list = [];

///Menu Variables
  var QuestionTitle ="".obs;
  var NotSeenquestion =0.obs;
  var Seenquestion =1.obs;
  var AttempSeenquestion =2.obs;

  var MarkReviewNotSeenquestion =3.obs;
  var MarkReviewSeenquestion =4.obs;
  var MarkReviewAttempSeenquestion =5.obs;
  List MenuQuestionList = [];
  List MenuQuestionMarkReviewList = [];

  ///Session Varibale

  var sessionCount = 0;
  var type = 0;
  bool dailysection = false;
  var start = 0;
  var end = 0;
  var questionid = 0;
  var questionExamid = 0;
  var dailysectionData;
  List allQuestiondata =[];
  dynamic timevalueInMin;
  var timeInMilisecondes;

  var remainingTimeInSeconds;


  dynamic statusMinSec;
  var width;
  ///Session Api Calling

  var callback;

  void triggerCallback() {
    if (callback != null) {
      callback();
    }
  }


  updatesessionTime() async {
    timevalueInMin = dailysectionData['data'][sessionCount]['section_time'];
    remainingTimeInSeconds = timevalueInMin * 60;
    int timeInMinutes = int.parse(timevalueInMin.toString());
    timeInMilisecondes=  Duration(minutes: timeInMinutes).inMilliseconds;
    log("_remainingTimeInSeconds......>> "+remainingTimeInSeconds.toString());
    print("timevalueInMin......>> "+timevalueInMin.toString());
    print("timeInMinutes......>> "+timeInMinutes.toString());
    log("timeInMilisecondes......>> "+timeInMilisecondes.toString());
    statusMinSec = true;
    log("Question_controller2>> jump controller");
    triggerCallback();

    await controllertimerstart();
    update();
  }
  callSessionApi(Examid) async {

    var url = "${apiUrls().daily_section_list_api}""${Examid.toString()}";
    var result = await apiCallingHelper().getAPICall(url, true);
    dailysectionData = jsonDecode(result.body);
    log("Session Data > "+dailysectionData.toString());
    log("Session Data data> "+dailysectionData['data'].toString());
    log("Session Data sessionCount> "+sessionCount.toString());


    update();
  }


  // void startTimer() {
  //   log("<updatetimesection> 00 "+remainingTimeInSeconds.toString());
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) async {
  //     log("<updatetimesection> 0 "+remainingTimeInSeconds.toString());
  //     if (remainingTimeInSeconds > 0) {
  //       log("<updatetimesection> 1 "+remainingTimeInSeconds.toString());
  //       remainingTimeInSeconds = remainingTimeInSeconds-1;
  //       log("<updatetimesection> 2 "+remainingTimeInSeconds.toString());
  //
  //       Timerclass();
  //       update();
  //     } else {
  //       timer.cancel();
  //         if((sessionCount+1)==dailysectionData['data'].length){
  //           var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+questionid.toString();
  //           var examBody = jsonEncode({
  //             'answer_data': Copy_get_que_list
  //           });
  //           log("examBody skip...."+examBody.toString());
  //           log("examBody skip...."+examansUrl.toString());
  //           await ExamAnswerData(examansUrl, examBody);
  //           Get.off(ExamReviewPage(exam_Ids:questionid,
  //               pageId:2));
  //
  //
  //         }else{
  //
  //           await sessionIncrement();
  //           ///navigate screen into another page and delete current page
  //
  //         }
  //     }
  //   });
  //   log("<updatetimesection>_timer>> "+timer.isActive.toString());
  // }


  sessionlogicFunction(){
    MenuQuestionList.clear();
    MenuQuestionMarkReviewList.clear();
    end=dailysectionData['data'][sessionCount]['sections_questions']+start;
    log("start>> "+start.toString());
    get_que_list= allQuestiondata.sublist(start, end);
    log("end>> "+end.toString());
    ontap_answer.clear();
    get_que_list.forEach((element) {
      ontap_answer.add(false);

      MenuQuestionList.add(NotSeenquestion);
      MenuQuestionMarkReviewList.add(MarkReviewNotSeenquestion);
    });
    start=end;
    getQueLoader(false);
    update();

    log("ontap_answer length>> "+ontap_answer.length.toString());
    log("dailysectionData>> "+dailysectionData['data'][sessionCount].toString());
    log("get_que_list length >> "+get_que_list.length.toString());

    updatesessionTime();
  }



  controllertimerstart(){
    // tick = 0.0;

    Timerclass(false);
    update();
  }
  sessionIncrement() async {
    getQueLoader(true);
    sessionCount=sessionCount +1;
    log("sessionCount>> "+sessionCount.toString());
    await sessionlogicFunction();

    update();
  }
  sessionValueSetDefault(bool section,int taptype){
    log("sessionValueSetDefault>> "+section.toString());
    log("sessionValueSetsessionCount>> "+sessionCount.toString());
    sessionCount=0;
    type=taptype;
    start=0;
    dailysection=section;
    update();
  }

  int countvalue(int value) {
    int count = 0;
    for (var number in MenuQuestionList) {
      if (number == value) {
        count++;
      }
    }
    return count;
  }
  GetQuestionData(url) async {
    getQueLoader(true);
    try {
      var result = await apiCallingHelper().getAPICall(url, true);

      get_que_data = jsonDecode(result.body);
      log("get_que_data>> "+get_que_data.toString() );

      if (result != null) {
        if (result.statusCode == 200) {
          get_que_data = jsonDecode(result.body);
          log("dailysection>> "+dailysection.toString() );
          if(dailysection == true && dailysectionData['data'].length!=0){
            get_que_list.clear();
            Copy_get_que_list.clear();
            allQuestiondata.clear();
            ontap_answer.clear();
            MenuQuestionList.clear();
            MenuQuestionMarkReviewList.clear();

            allQuestiondata.addAll(get_que_data['data']);
            sessionlogicFunction();
            get_que_data['data'].forEach((element) {
              Copy_get_que_list.add({
                "id": element['id'],
                "is_attempt": element['is_attempt'],
                "your_answer": element['your_answer'],
              });
            });
            log("Copy_get_que_list length>> "+Copy_get_que_list.length.toString() );
            log("allQuestiondata length>> "+allQuestiondata.length.toString() );


          }
          else{
            get_que_list.clear();
            Copy_get_que_list.clear();
            ontap_answer.clear();
            MenuQuestionList.clear();
            MenuQuestionMarkReviewList.clear();

            get_que_list.addAll(get_que_data['data']);
            get_que_list.forEach((element) {
              MenuQuestionList.add(NotSeenquestion);
              MenuQuestionMarkReviewList.add(MarkReviewNotSeenquestion);
              ontap_answer.add(false);
              Copy_get_que_list.add({
                "id": element['id'],
                "is_attempt": element['is_attempt'],
                "your_answer": element['your_answer'],
              });
            });
            log("allQuestiondata data>> "+allQuestiondata.toString() );
          }
          log("Copy_get_que_list Data>> "+Copy_get_que_list.toString() );
          print("MenuQuestionList......" + MenuQuestionList.toString());
          print("MenuQuestionList..length...." + MenuQuestionList.length.toString());
          print("get_que_data......" + get_que_data.toString());
          log("get_que_list......" + jsonEncode(get_que_list).toString());
          print("get_que_list......" + ontap_answer.toString());
          final DatabaseService dbHelper = DatabaseService.instance;
          await dbHelper.deleteExamTask();
          // Insert questiondata
          Copy_get_que_list.forEach((element) async {
            await dbHelper.insertQuestionData(
              element['id'],
              element['is_attempt'],
              element['your_answer'],
            );
          });
          // Insert examinfo

          await dbHelper.insertExamInfo(
            questionExamid.toString(),
            questionid.toString(),
            type.toString(),
          );
          getQueLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          getQueLoader(false);
          get_que_list.clear();
          Copy_get_que_list.clear();
          get_que_list.addAll(get_que_data['data']);
          get_que_list.forEach((element) {
            ontap_answer.add(false);
            Copy_get_que_list.add({
              "id": element['id'],
              "is_attempt": element['is_attempt'],
              "your_answer": element['your_answer'],
            });
          });
          update();
          refresh();
        }
      } else {
        getQueLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      getQueLoader(false);
      update();
    }
  }



  var ansLoader = false.obs;
  var exam_ans_data;
  callindex(index,indexx){
    log("ontap "+index.toString());
    log("ontap "+indexx.toString());
    log("ontap "+ontap_answer.toString());
    ontap_answer[index]=true;
    log("ontap check "+ontap_answer.toString());
    // ontap_check = indexx;
    update();
  }
  updatesessioncallindex(index,id,answer_id) async {

    var indexs = allQuestiondata.indexWhere((element) => (element['id']==id));

    log("get_que_listontap allQuestiondata> "+allQuestiondata.length.toString());
    log("get_que_listontap id> "+id.toString());
    log("get_que_listontap indexs> "+indexs.toString());
    log("get_que_listontap Copy_get_que_list> "+Copy_get_que_list.length.toString());
    log("get_que_listontap answer_id> "+answer_id.toString());
    log("get_que_listontap id > "+allQuestiondata[indexs]['id'].toString());
    log("get_que_listontap question > "+allQuestiondata[indexs]['question'].toString());
    get_que_list[index]['your_answer'] = answer_id;
    get_que_list[index]['is_attempt'] = 1;
    Copy_get_que_list[indexs]['your_answer'] = answer_id;
    ontap_answer[index]=true;
    Copy_get_que_list[indexs]['is_attempt'] = 1;
    update();
    final DatabaseService dbHelper = DatabaseService.instance;

    // Insert/Update questiondata
    await dbHelper.updateQuestionData( Copy_get_que_list[indexs]['id'], 1, Copy_get_que_list[indexs]['your_answer'].toString());


  }
  UpdateExamAnswerData(index,answer_id,is_attempt) async {
    log("UpdateExamAnswerData onstart $index :: $answer_id");
    log("UpdateExamAnswerData your_answer before ${get_que_list[index]['your_answer']}");
    log("UpdateExamAnswerData is_attempt before ${get_que_list[index]['is_attempt']}");
    get_que_list[index]['your_answer'] = answer_id;
    get_que_list[index]['is_attempt'] = 1;
    Copy_get_que_list[index]['your_answer'] = answer_id;
    Copy_get_que_list[index]['is_attempt'] = 1;
    log("UpdateExamAnswerData your_answer ${get_que_list[index]['your_answer']}");
    log("UpdateExamAnswerData is_attempt ${get_que_list[index]['is_attempt']}");
    log("Copy_get_que_list is_attempt length ${Copy_get_que_list.length.toString()}");
    update();
    final DatabaseService dbHelper = DatabaseService.instance;

    // Insert/Update questiondata
    await dbHelper.updateQuestionData( Copy_get_que_list[index]['id'], is_attempt, Copy_get_que_list[index]['your_answer'].toString());

  }
  updateExitLoader(){
    ExitLoader(true);
    update();
  }
  StopupdateExitLoader(){
    ExitLoader(false);
    update();
  }
  ExamAnswerData(url, parameter) async {
    ansLoader(true);

    try {
      var result =
          await apiCallingHelper().PostAPICallForTestPaper(url, parameter, true);

      if (result != null) {
        exam_ans_data = jsonDecode(result.body);
        print("exam_ans_data...." + exam_ans_data.toString());
        if (result.statusCode == 200) {
          ansLoader(false);
          update();
          refresh();
        } else if (result.statusCode == 404) {
          ansLoader(false);
          update();
          refresh();
        } else if (result.statusCode == 401) {
          ansLoader(false);
          update();
          refresh();
        } else if (result.statusCode == 500) {
          ansLoader(false);
          update();
          refresh();
        }
      } else {
        ansLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      Logger().e("catch error ........${e}");
      ansLoader(false);
      update();
      refresh();
    }
  }



  SubjectApi(url)async{

    SubjectLoader(true);
    String jsonData = sprefs.getString('subject_data');

    if(jsonData==null){
      await getdata3(url);
    }else{
      SubjectData = jsonDecode(jsonData);
      SubjectLoader(false);
      await getdata3(url);
      update();
      refresh();
    }

  }


  getdata3(url)async{
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        if(result.statusCode == 200){

          SubjectData =jsonDecode(result.body);
          await sprefs.setString('subject_data', result.body);
          SubjectLoader(false);
          update();
          refresh();
        }else  if(result.statusCode == 401){
          SubjectLoader(false);
          update();
          refresh();
        }
      } else {
        SubjectLoader(false);
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
