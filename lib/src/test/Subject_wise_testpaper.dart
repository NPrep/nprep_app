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

class SubjetWiseTestPaper extends StatefulWidget {
  var subjectId;
  var subjectName;
  SubjetWiseTestPaper({this.subjectId,this.subjectName});

  @override
  State<SubjetWiseTestPaper> createState() => _SubjetWiseTestPaperState();
}

class _SubjetWiseTestPaperState extends State<SubjetWiseTestPaper> {
  ExamController examController = Get.put(ExamController());
  SettingController settingController = Get.put(SettingController());

  var getExamUrl;

  @override
  void initState() {
    super.initState();
    log('subjectName==>'+widget.subjectName.toString());
    log('subjectId==>'+widget.subjectId.toString());
    getTestData("3", widget.subjectId);
  }

  var typeId;
  getTestData(exam_type, subjectId) async {
    Map<String, String> queryParams;
    queryParams = {
      'exam_type': exam_type,
      'subject': subjectId.toString(),
    };
    log('queryParams==>' + queryParams.toString());
    String queryString = Uri(queryParameters: queryParams).query;
    var getExamUrl = apiUrls().exam_list_api + '?' + queryString;
    log('getExamUrl==>' + getExamUrl.toString());
    // getExamUrl = apiUrls().exam_list_api;
    await examController.GetExamData3(getExamUrl);
    setState(() {});
    log('getExamTypeData(Pyq,mock,sub)==>' +examController.get_data.toString());
    log('length==>' + examController.get_data['data'].length.toString());
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
          title:Text('${widget.subjectName}',
              style: TextStyle(color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: 0.5), maxLines: 2),



        ),
        body: examController.getELoader == true || examController.get_data['data'].length == 0 || examController.get_data['data'][0]['id']==null ? Center(
          child: CircularProgressIndicator(),
        ) : SubjectListscroll());
  }

  Widget SubjectListscroll() {
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
              examController.get_data['data'].length == 0
                  ? Container(
                  height: MediaQuery.of(context).size.height-50,
                  child: Center(child: Text(examController.get_data['message'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)))
                  : ListView.builder(
                      itemCount: examController.get_data['data'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, index1) {
                        var examdetails = examController.get_data['data'][index1];
                        return  GestureDetector(
                          onTap: () async {
                            print("examdetails......"+examdetails.toString());
                            examController.QuestionTitle.value= examdetails['title'];
                            examController.sessionValueSetDefault(examdetails['is_section'],3) ;

                            if(examdetails['last_attempt_result_id']!=null){
                              Get.to(TestSeriesHistory(
                                title: examdetails['title'],
                                data_type: 0,
                                header: "${widget.subjectName}",
                                attempquestion: examdetails['MCQs'],
                                checkstatus: 3,
                                completed_date: examdetails['last_attempt_result_date'],
                                examid:examdetails['id'] ,
                                lastexamid: examdetails['last_attempt_result_id'] ,
                                total_questions: examdetails['MCQs'],
                                total_questions_duration: int.parse(examdetails['exam_duration'].toString()), created_at: examdetails['last_attempt_result_date'],));
                            }else{
                              var exam_details_id =
                              examdetails['id'];
                              var exam_duration = int.parse(
                                  examdetails[
                                  'exam_duration']
                                      .toString());
                              var attemptExamUrl =
                                  "${apiUrls().exam_attempt_api}"
                                  "${exam_details_id}";

                              await examController
                                  .AttemptExamData(
                                  attemptExamUrl,
                                  exam_duration);

                              print("attemptExamUrl......" +
                                  attemptExamUrl
                                      .toString());
                            }
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ReviewPage(exam_Ids:13)));

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 0),
                            child: AllCommonTest_TimeLine(
                              step: (index1+1),
                              examid: examdetails['id'],
                              fee_type: examdetails['fee_type'].toString(),
                              mcq: examdetails['MCQs'].toString(),
                              duration: examdetails['exam_duration'].toString(),
                              topic: examdetails['title'],


                            ),
                          ),
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //     color: white,
                          //     // color: lightPrimary,
                          //     borderRadius:
                          //     BorderRadius.circular(
                          //         4),
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         height: 14,
                          //       ),
                          //       Container(
                          //         // color: Colors.redAccent,
                          //         alignment:
                          //         Alignment.center,
                          //         width: MediaQuery.of(
                          //             context)
                          //             .size
                          //             .width -
                          //             85,
                          //         child: Text(
                          //           '${examdetails['title'].toString()}',
                          //           style: TextStyle(
                          //               color: primary,
                          //               letterSpacing:
                          //               0.6,
                          //               fontWeight:
                          //               FontWeight
                          //                   .w500,
                          //               fontSize: 16),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 14,
                          //       ),
                          //       Container(
                          //         decoration:
                          //         BoxDecoration(
                          //           // color: Colors.red,
                          //           image: DecorationImage(
                          //               image: AssetImage(
                          //                   "assets/images/backwithout_color.png"),
                          //               fit:
                          //               BoxFit.cover),
                          //           borderRadius:
                          //           BorderRadius.only(
                          //               bottomLeft: Radius
                          //                   .circular(
                          //                   4),
                          //               bottomRight: Radius
                          //                   .circular(
                          //                   4)),
                          //         ),
                          //         child: Padding(
                          //           padding:
                          //           const EdgeInsets
                          //               .symmetric(
                          //               horizontal:
                          //               15,
                          //               vertical: 5),
                          //           child: Row(
                          //             mainAxisAlignment:
                          //             MainAxisAlignment
                          //                 .spaceAround,
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Icon(
                          //                     Icons
                          //                         .ballot_outlined,
                          //                     color:
                          //                     white,
                          //                     size: 16,
                          //                   ),
                          //                   Text(
                          //                     'MCQs ${examdetails['MCQs'].toString()}',
                          //                     style: TextStyle(
                          //                         color:
                          //                         white,
                          //                         fontSize:
                          //                         12),
                          //                   ),
                          //                 ],
                          //               ),
                          //               // Text('${test['type']}',
                          //               //     style:
                          //               //         TextStyle(color: white, fontSize: 16)),
                          //               Row(
                          //                 children: [
                          //                   Icon(
                          //                     Icons
                          //                         .watch_later_outlined,
                          //                     color:
                          //                     white,
                          //                     size: 16,
                          //                   ),
                          //                   Text(
                          //                       ' ${examdetails['exam_duration'].toString()}Min',
                          //                       style: TextStyle(
                          //                           color:
                          //                           white,
                          //                           fontSize:
                          //                           12)),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        );
                      },
                    ),
            ],
          ),
        );
      }
    });
  }
}
