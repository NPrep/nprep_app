import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/Service/Service.dart';

class ReviewController extends GetxController{

  var reviewLoading = false.obs;
  var exam_review_data;
  List sessionexam_review_data=[];

  var start = 0;
  var end = 0;
  List exam_List =[];
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  GetExamResultData(url)async{
    reviewLoading(true);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      log('statusCode==>'+result.statusCode.toString());
      if (result != null) {
        exam_review_data =jsonDecode(result.body);
        Testreview_truefalse.clear();
        if(result.statusCode == 200){
          sessionexam_review_data.clear();
          exam_review_data =jsonDecode(result.body);
          // log("sessionexam_dailysection...."+Get.find<ExamController>().dailysection.toString());
          // log("sessionexam_dailysectionData.length..."+Get.find<ExamController>().dailysectionData['data'].toString());
          // log("sessionexam_exam_review_data.length..."+exam_review_data['data']['attempt_questions'].length.toString());

          if(Get.find<ExamController>().dailysection==true){
            Get.find<ExamController>().dailysectionData['data'].forEach((e){
              log(e['sections_questions'].toString()+"<<Section_question");
              end=e['sections_questions']+start;
              log("sessionexam_exam_review_data.end..."+end.toString());
              sessionexam_review_data.add(exam_review_data['data']['attempt_questions'].sublist(start, end))  ;

              start=end;


            });

          }
          else{
            exam_review_data['data']['attempt_questions'].forEach((e){
              log("test_review_e...."+e.toString());
              Testreview_truefalse.add(false);
            });
          }
          // log("sessionexam_review_data...."+sessionexam_review_data.toString());
          // log("exam_review_data...."+exam_review_data.toString());
          // log("exam_review_data.attempt_questions..."+exam_review_data['data']['attempt_questions'].length.toString());

          reviewLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          reviewLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 404){
          exam_review_data =jsonDecode(result.body);
          reviewLoading(false);
          update();
          refresh();
        }

      } else {
        reviewLoading(false);
        update();
        refresh();
      }

    }
    catch (e){
      Logger().e("catch error ........${e}");
      reviewLoading(false);
      update();
    }
  }

  var testreviewLoading = false.obs;
  var test_review_data;
  List review_truefalse=[].obs;
  List Testreview_truefalse=[].obs;

  callagainindex(index){
    if(review_truefalse[index]==false){
      review_truefalse[index]=true;
      update();
    }else{
      review_truefalse[index]=false;
      update();
    }


  }
  callagainTestindex(index){
    if(Testreview_truefalse[index]==false){
      Testreview_truefalse[index]=true;
      update();
    }else{
      Testreview_truefalse[index]=false;
      update();
    }


  }
  GetTestResultData(url)async{
    testreviewLoading(true);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        test_review_data =jsonDecode(result.body);
        if(result.statusCode == 200){
          test_review_data =jsonDecode(result.body);
          test_review_data['data']['attempt_questions'].forEach((e){
            print("test_review_e...."+e.toString());
            review_truefalse.add(false);
          });
          print("test_review_data...."+test_review_data.toString());
          print("review_truefalse_data...."+review_truefalse.toString());
          testreviewLoading(false);
          update();
          refresh();
        }else  if(result.statusCode == 404){
          print("test_review_data...."+test_review_data.toString());
          testreviewLoading(false);
          update();
          refresh();
        }

      } else {
        testreviewLoading(false);
        update();
        refresh();
      }

    }
    catch (e){
      Logger().e("catch error ........${e}");
      testreviewLoading(false);
      update();
    }
  }
}