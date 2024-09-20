import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/plan_detail.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/Samplevideo.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_sub_subjectscreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/Exam_Controller.dart';
import '../constants/Api_Urls.dart';
import '../main.dart';
import '../src/home/bottom_bar.dart';
import '../src/q_bank/subcat_qbank.dart';
import '../src/test/AllCommonTest_Ui.dart';
import '../src/test/Subject_wise_testpaper.dart';
import 'NotificationModel.dart';
class notification{
  callredirect(Payload) async {

    //var originalString  = '{"redirection_info": {"redirection_page":"1","exam_type":null,"module_id":null,"module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"2","exam_type":null,"module_id":629,"module_name":Pharmacology,"index_id":null,"external_link":null}, "redirection_type": 1}';
    // var originalString  = '{"redirection_info": {"redirection_page":"3","exam_type":"1","module_id":"AIIMS NORCET","module_name":"xyz name","index_id":"xyz","external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"3","exam_type":"2","module_id":"SGPGI Staff Nurse","module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"3","exam_type":"3","module_id":"513","module_name":"Fundamental of Nursing","index_id":null,"external_link":null}, "redirection_type": 1}';
    // var originalString  = '{"redirection_info": {"redirection_page":"3","exam_type":"4","module_id":"DSSSB Staff Nurse","module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"4","exam_type":null,"module_id":"10","module_name":"Pathology","index_id":null,"external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"5","exam_type":null,"module_id":null,"module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';
    //var originalString  = '{"redirection_info": {"redirection_page":"6","exam_type":null,"module_id":null,"module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';
    //   var originalString  = '{"redirection_info": {"redirection_page":"7","exam_type":null,"module_id":"2","module_name":null,"index_id":null,"external_link":null}, "redirection_type": 1}';

    log("NotificationResponse Redirect 1:> "+Payload.toString());
    // Replace 'redirection_info' with '"redirection_info"'
    // Replace 'redirection_type' with '"redirection_type"'
    // var updatedString = originalString.replaceAll('redirection_info', '"redirection_info"');
    // var NotificationData = updatedString.replaceAll('redirection_type', '"redirection_type"');

    // log("NotificationResponse Redirect :> "+NotificationData.toString());
    log("NotificationResponse Checking ");
    var model = notificationModelFromJson(Payload);
    log("NotificationResponse redirectionType "+model.redirectionType.toString());
    log("NotificationResponse redirectionPage "+model.redirectionInfo.redirectionPage.toString());


    if(model.redirectionType==1){
        if(model.redirectionInfo.redirectionPage=="1"){
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 0,)));
        }
        else if(model.redirectionInfo.redirectionPage=="2"){
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 1,)));
          sprefs.setString("perent_Id", model.redirectionInfo.moduleId.toString());
          sprefs.setString("catName", model.redirectionInfo.moduleName.toString());
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
              Subcategory(
                perentId: model.redirectionInfo.moduleId.toString(),
                categoryName: model.redirectionInfo.moduleName.toString(),
                categorytype: 1,
              )));
        }
        else if(model.redirectionInfo.redirectionPage=="3"){
          // 1>> PYQ (1) >> Exam
          // 3>> Subject (3)>>Exam
          // 2>> Mock (2) >>Mock Api
          // 4>> Daily (4)>> Mock Api
          ExamController examController =Get.put(ExamController());
          Map<String, String> queryParams;
          var yearwiseTabindexNo;
          var yearwiseTapindex;
          if(model.redirectionInfo.examType=="1"){

            yearwiseTabindexNo = 0;
            queryParams = {
              'exam_type': model.redirectionInfo.examType,
            };
            String queryString = Uri(queryParameters: queryParams).query;
            var getExamUrl = apiUrls().exam_list_api + '?' + queryString;
            await examController.GetExamData(getExamUrl);
            log('PYQ length==>'+examController.get_data['data'].length.toString());
            await examController.get_data['data'].forEach((e){
              yearwiseTapindex= examController.get_data['data'].indexWhere((item) => item['exam_year']==model.redirectionInfo.moduleId);
              log('yearwiseTapindex ==> '+yearwiseTapindex.toString());

            });
            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 2,yearwiseTabindex: yearwiseTabindexNo,)));

            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
                AllCommonTest_Ui(Index1:yearwiseTapindex ,subjectName: model.redirectionInfo.moduleId,type:yearwiseTabindexNo ,)
            ));
          }
          else if(model.redirectionInfo.examType=="2"){

            yearwiseTabindexNo = 2;

            queryParams = {
              'exam_type': model.redirectionInfo.examType,
            };
            String queryString = Uri(queryParameters: queryParams).query;
            var getExamUrl = apiUrls().Mock_exam_list_api + '?' + queryString;
            await examController.GetExamData(getExamUrl);
            log('Mock length==>'+examController.get_data['data'].length.toString());
            await examController.get_data['data'].forEach((e){
              yearwiseTapindex= examController.get_data['data'].indexWhere((item) => item['exam_year']==model.redirectionInfo.moduleId);
              log('yearwiseTapindex ==> '+yearwiseTapindex.toString());

            });
            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 2,yearwiseTabindex: yearwiseTabindexNo,)));

            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
                AllCommonTest_Ui(Index1:yearwiseTapindex ,subjectName: model.redirectionInfo.moduleId,type:yearwiseTabindexNo ,)
            ));
          }
          else if(model.redirectionInfo.examType=="3"){
              yearwiseTabindexNo = 3;


            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 2,yearwiseTabindex: yearwiseTabindexNo,)));

              navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>SubjetWiseTestPaper(subjectId: model.redirectionInfo.moduleId,subjectName:model.redirectionInfo.moduleName)));

          }
          else if(model.redirectionInfo.examType=="4"){
            yearwiseTabindexNo = 1;
            queryParams = {
              'exam_type': model.redirectionInfo.examType,
            };
            String queryString = Uri(queryParameters: queryParams).query;
            var getExamUrl = apiUrls().Mock_exam_list_api + '?' + queryString;
            await examController.GetExamData(getExamUrl);
            log('PYQ length==>'+examController.get_data['data'].length.toString());
            await examController.get_data['data'].forEach((e){
              yearwiseTapindex= examController.get_data['data'].indexWhere((item) => item['exam_year']==model.redirectionInfo.moduleId);
              log('yearwiseTapindex ==> '+yearwiseTapindex.toString());

            });
            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 2,yearwiseTabindex: yearwiseTabindexNo,)));

            navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
                AllCommonTest_Ui(Index1:yearwiseTapindex ,subjectName: model.redirectionInfo.moduleId,type:yearwiseTabindexNo ,)
            ));
          }
          else{
            yearwiseTabindexNo = 0;
          }

        }
        else if(model.redirectionInfo.redirectionPage=="4"){
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 3,)));

          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
              SubSubjectScreen(showprmpt: true,showDilog: false,
                Catname: model.redirectionInfo.moduleName,Catparentid:model.redirectionInfo.moduleId ,)
          ));


        }
        else if(model.redirectionInfo.redirectionPage=="5"){
          List Videosubjectdata = [];
          var result = await apiCallingHelper().getAPICall(apiUrls().parent_video_categories_api, true);
          var FetchSubjectData =jsonDecode(result.body);
          Videosubjectdata.clear();
          Videosubjectdata.add(FetchSubjectData['data']);
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 3,)));
          var data =Videosubjectdata[0]['data']['sample_videos'];

          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>
              Samplevideo(SampleVideoList: data.length==0?[]:data,)

          ));


        }
        else if(model.redirectionInfo.redirectionPage=="6"){
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 4,)));
        }
        else if(model.redirectionInfo.redirectionPage=="7"){
          var planTapindex;
         var subscriptions_apiUrl = apiUrls().subscriptions_api;

          var result = await apiCallingHelper().getAPICall(subscriptions_apiUrl, true);
         var subscriptionData;
          if(result.statusCode == 200){
           subscriptionData =jsonDecode(result.body);
           log('subscriptionData ==> '+subscriptionData['data'].toString());

          }
         await subscriptionData['data'].forEach((e){
           planTapindex= subscriptionData['data'].indexWhere((item) => item['id'].toString()==model.redirectionInfo.moduleId);
           log('yearwiseTapindex ==> '+planTapindex.toString());

         });
          var subscription_datas= subscriptionData['data'][planTapindex];

          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 4,)));
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=> PlandetailScreen(
            plan_name: subscription_datas['name'].toString(),
            plan_description:subscription_datas['description'].toString(),
            plan_price: subscription_datas['price'].toString(),
            plan_index: planTapindex,
          )));
        }
        else{
          navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 3,)));
        }
    }else if(model.redirectionType==2){
      print("url = > "+model.redirectionInfo.externalLink.toString());
      if (await canLaunch(model.redirectionInfo.externalLink.toString())) {
        await launch(model.redirectionInfo.externalLink.toString());
      } else {
        throw 'Could not launch ${model.redirectionInfo.externalLink}';
      }
    }


  }
  demoarrayList(){
    List<int> dummyArray = List<int>.generate(50, (index) => index);
    List arraydata2 = [{"id":1,"number":20},{"id":2,"number":20},{"id":3,"number":10}];
    List getlist = [];
    var session = 0;
    var start = 0;
    var end = 0;
    arraydata2.forEach((element) {

      end=element['number']+start;
      getlist= dummyArray.sublist(start, end);
      // log("end>> "+end.toString());
      start=end;


      log("getlist>> "+getlist.toString());

    });



  }
}
