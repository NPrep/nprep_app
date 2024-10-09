import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/test/TestSeriesHistory.dart';

import 'package:n_prep/utils/colors.dart';

import 'AllCommonTest_timeline.dart';

class AllCommonTest_Ui extends StatefulWidget {
  var Index1;
  var type;
  var subjectName;
  AllCommonTest_Ui({Key key,this.Index1,this.type,this.subjectName});

  @override
  State<AllCommonTest_Ui> createState() => _AllCommonTest_UiState();
}

class _AllCommonTest_UiState extends State<AllCommonTest_Ui> {
  ExamController examController = Get.put(ExamController());
  SettingController settingController = Get.put(SettingController());



  @override
  void initState() {
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Scaffold(
        appBar:AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF64C4DA), // <-- SEE HERE
            // statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
            // statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          elevation: 0,
          toolbarHeight: 50,
          title: Text('${widget.type==0?"PYQ":widget.type==1?"Daily Test":widget.type==2?"Mock":"Test"}',
              style: TextStyle(color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: 0.5), maxLines: 2),



        ),
        body: AllUiTestscroll());
  }

  Widget AllUiTestscroll() {
    return GetBuilder<ExamController>(builder: (examController) {
      if (examController.getELoader.value) {
        return Center(
            child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ));
      } else {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40,top: 20,bottom: 20),
                child: Text('Exam : ${widget.subjectName}',
                    textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),

                    style: TextStyle(color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        // fontSize: 20,
                        letterSpacing: 0.5), maxLines: 2),
              ),

              widget.type==1?  examController.get_data['data'].length == 0
                  ? Container(
                  height: MediaQuery.of(context).size.height-50,
                  child: Center(child: Text(examController.get_data['message'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)))
                  : ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index2) {
                    var examdetails = examController.get_data['data'][widget.Index1]['exam_details'][index2];
                    log("is_today......"+examdetails['is_today'].toString());
                    return GestureDetector(
                      onTap: () async {
                        log("issection>1> "+examdetails['is_section'].toString());
                        examController.QuestionTitle.value= examdetails['title'];
                        log("examdetails......"+examdetails.toString());
                        examController.sessionValueSetDefault(examdetails['is_section'],widget.type) ;

                        if(examdetails['is_section']==true){

                          examController.callSessionApi(examdetails['id']);
                        }
                        log("is_today......"+examdetails['is_today'].toString());
                        if(examdetails['last_attempt_result_id']!=null){
                          Get.to(TestSeriesHistory(title: examdetails['title'],
                            header: "${widget.subjectName}",
                            data_type:widget.type ,
                            today: true,
                            // header: "Year ${yeardata['exam_year']}",
                            attempquestion: examdetails['MCQs'],
                            checkstatus: 3,
                            completed_date: examdetails['last_attempt_result_date'],
                            examid:examdetails['id'] ,
                            lastexamid: examdetails['last_attempt_result_id'] ,
                            total_questions: examdetails['MCQs'],
                            total_questions_duration: int.parse(examdetails['exam_duration'].toString()), created_at: examdetails['last_attempt_result_date'],));
                        }
                        else{
                          var exam_details_id = examdetails['id'];
                          var exam_duration = int.parse(examdetails['exam_duration'].toString());
                          var attemptExamUrl;
                          if(widget.type==0){
                             attemptExamUrl = "${apiUrls().exam_attempt_api}" "${exam_details_id}";
                             await examController.AttemptExamData(attemptExamUrl,exam_duration);

                          }
                          else{
                             attemptExamUrl = "${apiUrls().Mock_exam_attempt_api}" "${exam_details_id}";
                            await examController.MockAttemptExamData(attemptExamUrl,exam_duration,true);

                          }



                          log("attemptExamUrl......"+attemptExamUrl.toString());

                        }

                      },
                      child: examdetails['is_today']==true?
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text("Today", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: textColor
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 0),
                            child: AllCommonTest_TimeLine(
                              step: (index2+1),
                              examid: examdetails['id'],
                              fee_type: examdetails['fee_type'].toString(),
                              mcq: examdetails['MCQs'].toString(),
                              duration: examdetails['exam_duration'].toString(),
                              topic: examdetails['title'],
                              datetype:examdetails['exam_date'] ,

                            ),
                          ),
                        ],
                      ):Container(),
                    );
                  }):Container(),

              widget.type==1?Container(
                padding: EdgeInsets.all(10),
                child: Text("Previous", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor
                )),
              ):Container(),

              widget.type==1?  examController.get_data['data'].length == 0
                  ? Container(
                  height: MediaQuery.of(context).size.height-50,

                  child: Center(child: Text(examController.get_data['message'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)))
                  : ListView.builder(
                      itemCount: examController.get_data['data'][widget.Index1]['exam_details'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index2) {
                        var examdetails= examController.get_data['data'][widget.Index1]['exam_details'][index2];
                        return GestureDetector(
                      onTap: () async {
                        log("examdetails......"+examdetails.toString());
                        log("issection>2> "+examdetails['is_section'].toString());
                        examController.QuestionTitle.value= examdetails['title'];

                        examController.sessionValueSetDefault(examdetails['is_section'],widget.type) ;

                      if(examdetails['is_section']==true){

                        examController.callSessionApi(examdetails['id']);
                      }
                        if(examdetails['last_attempt_result_id']!=null){
                          Get.to(TestSeriesHistory(title: examdetails['title'],
                            header: "${widget.subjectName}",
                            data_type:widget.type ,
                            today: false,
                            // header: "Year ${yeardata['exam_year']}",
                            attempquestion: examdetails['MCQs'],
                            checkstatus: 3,
                            completed_date: examdetails['last_attempt_result_date'],
                            examid:examdetails['id'] ,
                            lastexamid: examdetails['last_attempt_result_id'] ,
                            total_questions: examdetails['MCQs'],
                            total_questions_duration: int.parse(examdetails['exam_duration'].toString()), created_at: examdetails['last_attempt_result_date'],));
                        }
                        else{
                          var exam_details_id = examdetails['id'];
                          var exam_duration = int.parse(examdetails['exam_duration'].toString());
                          var attemptExamUrl;
                          if(widget.type==0){
                             attemptExamUrl = "${apiUrls().exam_attempt_api}" "${exam_details_id}";
                             await examController.AttemptExamData(attemptExamUrl,exam_duration);

                          }
                          else{
                             attemptExamUrl = "${apiUrls().Mock_exam_attempt_api}" "${exam_details_id}";
                            await examController.MockAttemptExamData(attemptExamUrl,exam_duration,false);

                          }
                          log("attemptExamUrl......"+attemptExamUrl.toString());
                        }
                      },
                      child: examdetails['is_today']==false?Container(
                        margin: EdgeInsets.only(right: 0),
                        child: AllCommonTest_TimeLine(
                          step: (index2+1),
                          examid: examdetails['id'],
                          fee_type: examdetails['fee_type'].toString(),
                          mcq: examdetails['MCQs'].toString(),
                          duration: examdetails['exam_duration'].toString(),
                          topic: examdetails['title'],
                          datetype:examdetails['exam_date'] ,

                        ),
                      ):Container(),
                    );
                  }):
              examController.get_data['data'].length == 0
                  ? Container(
                  height: MediaQuery.of(context).size.height-50,
                  child: Center(child: Text(examController.get_data['message'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)))
                  : ListView.builder(
                  itemCount: examController.get_data['data'][widget.Index1]['exam_details'].length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index2) {
                    var examdetails= examController.get_data['data'][widget.Index1]['exam_details'][index2];
                    return GestureDetector(
                                onTap: () async {
                                  log("issection>3> "+examdetails['is_section'].toString());
                                  log("issection>type> "+widget.type.toString());
                                  examController.QuestionTitle.value= examdetails['title'];

                                  examController.sessionValueSetDefault(examdetails['is_section'],widget.type) ;

                                  if(examdetails['is_section']==true){

                                    examController.callSessionApi(examdetails['id']);
                                  }
                                  log("examdetails......"+examdetails.toString());
                                  if(examdetails['last_attempt_result_id']!=null){
                                    Get.to(TestSeriesHistory(
                                      title: examdetails['title'],
                                      header: "${widget.subjectName}",
                                      data_type:widget.type ,
                                      today: false,
                                      // header: "Year ${yeardata['exam_year']}",
                                      attempquestion: examdetails['MCQs'],
                                      checkstatus: 3,
                                      completed_date: examdetails['last_attempt_result_date'],
                                      examid:examdetails['id'] ,
                                      lastexamid: examdetails['last_attempt_result_id'] ,
                                      total_questions: examdetails['MCQs'],
                                      total_questions_duration: int.parse(examdetails['exam_duration'].toString()), created_at: examdetails['last_attempt_result_date'],));
                                  }
                                  else{
                                    var exam_details_id = examdetails['id'];
                                    var exam_duration = int.parse(examdetails['exam_duration'].toString());
                                    var attemptExamUrl;
                                    if(widget.type==0){
                                       attemptExamUrl = "${apiUrls().exam_attempt_api}" "${exam_details_id}";
                                       await examController.AttemptExamData(attemptExamUrl,exam_duration);

                                    }else{
                                       attemptExamUrl = "${apiUrls().Mock_exam_attempt_api}" "${exam_details_id}";
                                      await examController.MockAttemptExamData(attemptExamUrl,exam_duration,false);

                                    }



                                    log("attemptExamUrl......"+attemptExamUrl.toString());

                                  }

                                },
                      child: Container(
                        margin: EdgeInsets.only(right: 0),
                        child: AllCommonTest_TimeLine(
                          step: (index2+1),
                            examid: examdetails['id'],
                            fee_type: examdetails['fee_type'].toString(),
                          mcq: examdetails['MCQs'].toString(),
                          duration: examdetails['exam_duration'].toString(),
                          topic: examdetails['title'],
                            datetype:null

                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      }
    });
  }
}
