import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/Controller/Review_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/indicator.dart';
import 'package:n_prep/src/test/LeadershipScore.dart';
import 'package:n_prep/utils/colors.dart';

class ExamReviewPage extends StatefulWidget {
  final bool skip;
  var exam_Ids;
  var exam_Id;
  var pageId;
  bool today = false;
  ExamReviewPage({Key key, this.skip,this.exam_Ids,this.pageId,@required this.exam_Id,@required this.today});

  @override
  State<ExamReviewPage> createState() => _ExamReviewPageState();
}

class _ExamReviewPageState extends State<ExamReviewPage> {
  var get_reviewUrl ;
  ExamController examController =Get.put(ExamController());

  ReviewController reviewController = Get.put(ReviewController());

  double right;
  double wrong;
  double unanswered;
  // Map<String, double> dataMap ;
  final colorList = <Color>[
    Color(0xFFC8EC92),
    Colors.red.shade200,
    Colors.grey,
  ];



  int touchedIndex = -1;
  int indextap = -1;

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 60.0 : 55.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color:  Color(0xFFC8EC92),
            value: double.parse(reviewController.exam_review_data['data']['correct_questions'].toString()),
            title: '${double.parse(reviewController.exam_review_data['data']['correct_questions'].toString()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              // shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color:   Colors.red.shade200,
            value: double.parse(reviewController.exam_review_data['data']['incorrect_questions'].toString()),
            title: '${double.parse(reviewController.exam_review_data['data']['incorrect_questions'].toString()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              // shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color:Colors.grey,
            value: double.parse( reviewController.exam_review_data['data']['skipped_questions'].toString()),
            title: '${double.parse( reviewController.exam_review_data['data']['skipped_questions'].toString()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              // shadows: shadows,
            ),
          );
      // case 3:
      //   return PieChartSectionData(
      //     color:     Color(0xFF39CF75),
      //     value: 15,
      //     title: '15%',
      //     radius: radius,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
      // case 4:
      //   return PieChartSectionData(
      //     color: Color(0xFF37BCF9),
      //     value: 15,
      //     title: '15%',
      //     radius: radius,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
        default:
          throw Error();
      }
    });
  }




  getExamReview() async {
    reviewController.start=0;
    reviewController.end=0;
    get_reviewUrl = "${apiUrls().exam_review_api}${widget.exam_Ids}";
    log("get_reviewUrl...." + get_reviewUrl.toString());

    await reviewController.GetExamResultData(get_reviewUrl);
    log('exam_review_data==>'+reviewController.exam_review_data.toString());
    // print("check > "+reviewController.exam_review_data['data']['correct_questions'].toString());
    // dataMap ={
    //   "Right Answer": double.parse(reviewController.exam_review_data['data']['correct_questions'].toString()),
    //   "Wrong Answer": double.parse(reviewController.exam_review_data['data']['incorrect_questions'].toString()),
    //   "Unanswered": double.parse( reviewController.exam_review_data['data']['skipped_questions'].toString()),
    // };
    // print("check > "+dataMap.toString());
    setState((){});

  }


  @override
  void initState() {
    super.initState();
    getExamReview();
    print("examID...."+widget.exam_Ids.toString());
    print("pageId...."+widget.pageId.toString());


  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.20);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar(bottomindex: 2,)),
        );
        return true;
      },
      child:  MediaQuery(
        child: Scaffold(
          appBar: AppBar(
            title: Row(

              children: [
                // Check if showBackIcon is true
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomBar(bottomindex: 2,)),
                    );
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                Text('Review',
                    style: TextStyle(color: Colors.white, )),

              ],
            ),

            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          body: GetBuilder<ReviewController>(
              builder: (reviewController) {
                if(reviewController.reviewLoading.value){
                  return Center(child: CircularProgressIndicator());
                }
                return reviewController.exam_review_data['data'].length==0?
                Center(
                  child: Text("No Data Found"),
                ):SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //
                      //   children: <Widget>[
                      //     Indicator(
                      //       color:  Color(0xFFC8EC92),
                      //       text: 'Right Answer',
                      //       isSquare: true,
                      //     ),
                      //     SizedBox(width: 5,),
                      //     Indicator(
                      //       color:Colors.red.shade200,
                      //       text: 'Wrong Answer',
                      //       isSquare: true,
                      //     ),
                      //     SizedBox(width: 5,),
                      //     Indicator(
                      //       color:  Colors.grey,
                      //       text: 'Unanswered',
                      //       isSquare: true,
                      //     ),
                      //
                      //     // Indicator(
                      //     //   color: Color(0xFF39CF75),
                      //     //   text: 'Mutual Funds',
                      //     //   isSquare: true,
                      //     // ),
                      //     // SizedBox(
                      //     //   height: 18,
                      //     // ),
                      //   ],
                      // ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(reviewController.exam_review_data['data']['score'],style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500)),
                            Text(' Marks',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
                            Text(' out of '+reviewController.exam_review_data['data']['total_questions'].toString(),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      examController.type==1||examController.type==2?   GestureDetector(
                        onTap: (){
                          Get.to(ScoreListScreen(exam_id:widget.exam_Id ,today: widget.today,));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // margin: EdgeInsets.only(left: 15,right: 15,),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(width: 0.5,color:primary)
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Check your rank",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              Image.asset("assets/nprep2_images/winnercup.png",height: 50,),
                            ],
                          ),
                        ),
                      ):Container(),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding:  EdgeInsets.only(top: 10, right:0),
                            height: MediaQuery.of(context).size.height*0.2,
                            width: MediaQuery.of(context).size.width*0.55,

                            child: PieChart(
                              PieChartData(
                                borderData: FlBorderData(
                                  show: true,
                                ),

                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                          // Container(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       // RichText(
                          //       //     text: TextSpan(
                          //       //         children: [
                          //       //           TextSpan(text: reviewController.exam_review_data['data']['score'],style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500)),
                          //       //           TextSpan(text:' Marks',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500)),
                          //       //           TextSpan(text: '\nout of ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black)),
                          //       //           TextSpan(text: reviewController.exam_review_data['data']['total_questions'].toString(),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400)),
                          //       //
                          //       //         ]
                          //       // )),
                          //
                          //       // RichText(
                          //       //     text: TextSpan(
                          //       // style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),
                          //       //         children: [
                          //       //           TextSpan(text:'Correct Questions: ',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black),),
                          //       //           TextSpan(text: reviewController.exam_review_data['data']['total_correct'].toString()),
                          //       //         ]
                          //       //     )),
                          //       // RichText(
                          //       //     text: TextSpan(
                          //       //         style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),
                          //       //         children: [
                          //       //           TextSpan(text:'Incorrect Questions: ', style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black),),
                          //       //           TextSpan(text: reviewController.exam_review_data['data']['total_incorrect'].toString()),
                          //       //         ]
                          //       //     )),
                          //       // RichText(
                          //       //     text: TextSpan(
                          //       //         style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),
                          //       //         children: [
                          //       //           TextSpan(text:'Skipped Questions: ',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black),),
                          //       //           TextSpan(text:  reviewController.exam_review_data['data']['total_skipped'].toString()),
                          //       //         ]
                          //       //     )),
                          //     ],
                          //   ),
                          // ),

                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height:height*0.07,
                        width: width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(

                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: height,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFC8EC92),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          topLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),

                                        )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('CORRECT',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.grey),),
                                          SizedBox(height: 7,),
                                          Text(reviewController.exam_review_data['data']['total_correct'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(

                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: height,
                                      decoration: BoxDecoration(
                                          color:Colors.red.shade200,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),

                                          )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('INCORRECT',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.grey),),
                                          SizedBox(height: 7,),
                                          Text(reviewController.exam_review_data['data']['total_incorrect'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(

                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: height,
                                      decoration: BoxDecoration(
                                          color:  Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),

                                          )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('SKIPPED',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.grey),),
                                          SizedBox(height: 7,),
                                          Text(reviewController.exam_review_data['data']['total_skipped'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //Text(examController.dailysection.toString()),
                      // Text(reviewController.sessionexam_review_data.length.toString()),
                      examController.dailysection==true?
                      ListView.builder(
                          itemCount: reviewController.sessionexam_review_data.length,
                          // Replace 'options.length' with the actual number of options
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,sectionindex){
                            var sectiondata= examController.dailysectionData['data'][sectionindex];
                            var sectiondatalist= reviewController.sessionexam_review_data[sectionindex];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),

                                Row(
                                    children: <Widget>[
                                      SizedBox(width: 5,),
                                      Expanded(
                                          child: Divider(color: primary,)
                                      ),

                                      Text(
                                          "${sectiondata['section_name']}"
                                          ,style: TextStyle(
                                          fontSize: 20,
                                          color: primary,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold)
                                      ),

                                      Expanded(
                                          child: Divider(color: primary,)
                                      ),
                                      SizedBox(width: 5,),
                                    ]
                                ),
                                // Row(
                                //   children: [
                                //
                                //     Container(
                                //         alignment: Alignment.center,
                                //         child: Padding(
                                //           padding: EdgeInsets.only(top: 10,left: 10),
                                //
                                //           child: Text(
                                //              "-- ${sectiondata['section_name']} --"
                                //               ,style: TextStyle(
                                //               fontSize: 20,
                                //               color: primary,
                                //               letterSpacing: 2,
                                //               fontWeight: FontWeight.bold)
                                //           ),
                                //         )),
                                //   ],
                                // ),
                                SizedBox(height: 10,),
                                ListView.builder(
                                  itemCount: sectiondatalist.length,
                                  // Replace 'options.length' with the actual number of options
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int indexs) {
                                    final optionIndex = String.fromCharCode(97 + indexs);
                                    var exam_result_data =sectiondatalist[indexs];

                                    return Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.fromBorderSide(
                                                BorderSide(color: Colors.grey.shade400))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(

                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,

                                                children: [

                                                  Container(

                                                    padding:  EdgeInsets.only(top: 16,left: 5),
                                                    // padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 16),
                                                    child: Text("${indexs+1}.)",style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'PublicSans',
                                                        color: black54,
                                                        fontWeight: FontWeight.w400
                                                    ),),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      exam_result_data['question_name'].toString()=="null"
                                                          ?Container():
                                                      Container(
                                                        padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                                                        width: MediaQuery.of(context).size.width-60,
                                                        // color: primary,
                                                        child: Text(
                                                          "${exam_result_data['question_name'].toString()=="null"?
                                                          "":exam_result_data['question_name'].toString()}",

                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: 'Helvetica',
                                                              color: black54,
                                                              fontWeight: FontWeight.w400
                                                          ),),
                                                      ),
                                                      exam_result_data['question_attachment'].toString()=="null"?Container():
                                                      Container(
                                                        margin: EdgeInsets.only(top: 0,left: 5),
                                                        alignment: Alignment.topLeft,

                                                        width: MediaQuery.of(context).size.width*0.3,
                                                        height: MediaQuery.of(context).size.height*0.1,
                                                        child: Image.network(exam_result_data['question_attachment'].toString(),
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              color: Colors.grey.shade300,
                                                              alignment: Alignment.center,
                                                              child: Icon(Icons.hide_image_outlined,size: 50,
                                                                color: Colors.grey.shade500,),
                                                            );
                                                          },),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                            sizebox_height_5,

                                            // RIGHT ANSWER FOR HERE ======
                                            exam_result_data['correct_answer'].toString()=="null"?Container():
                                            Column(
                                              children: [
                                                int.parse( exam_result_data['is_answer'].toString())==1?Container():
                                                Row(
                                                  children: [
                                                    Container(

                                                      padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                                      child: Text("Right Answer",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily: 'Poppins-Regular',
                                                            color: black54,
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                    )
                                                  ],
                                                ),
                                                int.parse( exam_result_data['is_answer'].toString())==1?Container():
                                                Container(

                                                  color: int.parse(exam_result_data['is_answer'].toString())==3?
                                                  Colors.grey.shade300:
                                                  int.parse(exam_result_data['is_answer'].toString())==2?
                                                  answerColor:Colors.white,
                                                  // answerColor:
                                                  // int.parse(exam_result_data['is_answer'].toString())==2?wrongColor:,
                                                  child: Row(
                                                    children: [

                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          exam_result_data['correct_answer']['objective'].toString()=="null"?Container():
                                                          Container(
                                                            width: MediaQuery.of(context).size.width-20,
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("${exam_result_data['correct_answer']['objective'].toString()
                                                                =="null"?"":exam_result_data['correct_answer']['objective'].toString()}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'Helvetica',
                                                                  fontWeight: FontWeight.w400
                                                              ),),
                                                          ),
                                                          exam_result_data['correct_answer']['attachment'].toString()=="null"?Container():
                                                          // Image.network(exam_result_data['question_attachment'].toString())
                                                          Container(
                                                            margin: EdgeInsets.only(top: 10,left: 5,bottom: 6),
                                                            alignment: Alignment.topLeft,
                                                            width: MediaQuery.of(context).size.width*0.3,
                                                            height: MediaQuery.of(context).size.height*0.1,
                                                            child: Image.network(exam_result_data['correct_answer']['attachment'].toString(),
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return Container(
                                                                  color: Colors.grey.shade300,
                                                                  alignment: Alignment.center,
                                                                  child: Icon(Icons.hide_image_outlined,size: 50,
                                                                    color: Colors.grey.shade500,),
                                                                );
                                                              },),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            sizebox_height_10,
                                            //     YOUR ANSWER FOR HERE ======
                                            exam_result_data['your_answer'].toString()=="[]"?Container():
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                                  child: Text("You Answered",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins-Regular',
                                                        color: black54,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                )
                                              ],
                                            ),

                                            Column(
                                              children: [
                                                exam_result_data['your_answer'].toString()=="[]"?Container():
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  // color: int.parse(exam_result_data['is_answer'].toString())==1?
                                                  // ansBackgroundColor:int.parse(exam_result_data['is_answer'].toString())!=1&&
                                                  //     int.parse(exam_result_data['is_answer'].toString())==3?redBackgroundColor :Colors.grey,
                                                  color:  int.parse(exam_result_data['is_answer'].toString())==1?
                                                  answerColor:
                                                  int.parse(exam_result_data['is_answer'].toString())==2?
                                                  wrongColor:Colors.grey.shade400,
                                                  margin: EdgeInsets.only(bottom: 16),
                                                  child: Padding(
                                                    padding:  EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        exam_result_data['your_answer']['objective'].toString()=="null"?Container():

                                                        Container(
                                                          margin: EdgeInsets.only(top: 0,left: 0),
                                                          child: Text(
                                                            "${exam_result_data['your_answer']['objective'].toString()}",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily: 'Helvetica',
                                                                color:  int.parse(exam_result_data['is_answer'].toString())==2?
                                                                redTextColor:Colors.black,
                                                                fontWeight: FontWeight.w400
                                                            ),),
                                                        ),

                                                        exam_result_data['your_answer']['attachment'].toString()=="null"?Container():
                                                        // Image.network(exam_result_data['question_attachment'].toString())
                                                        Container(
                                                          margin: EdgeInsets.only(top: 10,left: 0),
                                                          alignment: Alignment.topLeft,
                                                          width: MediaQuery.of(context).size.width*0.3,
                                                          height: MediaQuery.of(context).size.height*0.1,
                                                          child: Image.network(exam_result_data['your_answer']['attachment'].toString(),
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return Container(
                                                                color: Colors.grey.shade300,
                                                                alignment: Alignment.center,
                                                                child: Icon(Icons.hide_image_outlined,size: 50,
                                                                  color: Colors.grey.shade500,),
                                                              );
                                                            },),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            exam_result_data['ans_description'].toString()=="null"&&exam_result_data['ans_description_attachment'].toString() =="null"?Container():GestureDetector(
                                              onTap: (){
                                                if(indextap==indexs){
                                                  indextap = -1;
                                                }else{
                                                  indextap  = indexs;

                                                }
                                                setState(() {

                                                });

                                              },
                                              child: Container(
                                                  color: Colors.white.withOpacity(0.1),
                                                  width: size.width-150,
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      top: 4,
                                                      bottom: 4
                                                  ),
                                                  child: Text(
                                                    indexs==indextap?"Hide":"See Rationale: ",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        decoration: TextDecoration
                                                            .underline,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                            ),
                                            indexs==indextap? exam_result_data['ans_description'].toString()=="null"&&exam_result_data['ans_description_attachment'].toString() =="null"?Container():Padding(
                                              padding: const EdgeInsets.all(14.0),
                                              child: Column(
                                                children: [
                                                  exam_result_data['ans_description_attachment'].toString() =="null"
                                                      ? Container()
                                                      : Image.network(
                                                    exam_result_data['ans_description_attachment']
                                                        .toString(),
                                                  ),

                                                  exam_result_data['ans_description']
                                                      .toString() ==
                                                      "null"
                                                      ? Container()
                                                      : Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 10.0,
                                                        top: 12),
                                                    child: Html(
                                                      data: exam_result_data['ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString()
                                                      ,
                                                      style: {
                                                        "table": Style( ),
                                                        // some other granular customizations are also possible
                                                        "tr": Style(
                                                          border: Border(
                                                            bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                            top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                            right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                            left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                          ),
                                                        ),
                                                        "th": Style(
                                                          padding: EdgeInsets.all(6),
                                                          backgroundColor: Colors.black,
                                                        ),
                                                        "p": Style(
                                                          fontSize: FontSize.xxSmall,

                                                        ),
                                                        "td": Style(
                                                          padding: EdgeInsets.all(2),
                                                          alignment: Alignment.topLeft,
                                                        ),
                                                      },
                                                      customRenders: {
                                                        tableMatcher(): tableRender(),
                                                      },
                                                      // defaultTextStyle: TextStyle(
                                                      //     fontSize: 16,
                                                      //     letterSpacing: 0.5),

                                                      //           data: Text(get_data['ans_description'].toString(),
                                                      //         textAlign: TextAlign.justify,
                                                      //         style: TextStyle(
                                                      //           fontSize: 14,
                                                      //
                                                      //           fontWeight: FontWeight.w400,
                                                      //           fontFamily: 'Helvetica',
                                                      //           color: black54,
                                                      //         ),
                                                      // ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ):Container(),
                                            sizebox_height_10,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );

                      }):
                      ListView.builder(
                        itemCount: reviewController.exam_review_data['data']['attempt_questions'].length,
                        // Replace 'options.length' with the actual number of options
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final optionIndex = String.fromCharCode(97 +
                              index);
                          var exam_result_data =reviewController.exam_review_data['data']['attempt_questions'][index];

                          return Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.fromBorderSide(
                                      BorderSide(color: Colors.grey.shade400))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        Container(

                                          padding:  EdgeInsets.only(top: 16,left: 5),
                                          // padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 16),
                                          child: Text("${index+1}.)",style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'PublicSans',
                                              color: black54,
                                              fontWeight: FontWeight.w400
                                          ),),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            exam_result_data['question_name'].toString()=="null"
                                                ?Container():
                                            Container(
                                              padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                                              width: MediaQuery.of(context).size.width-60,
                                              // color: primary,
                                              child: Text(
                                                "${exam_result_data['question_name'].toString()=="null"?
                                                "":exam_result_data['question_name'].toString()}",

                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Helvetica',
                                                    color: black54,
                                                    fontWeight: FontWeight.w400
                                                ),),
                                            ),
                                            exam_result_data['question_attachment'].toString()=="null"?Container():
                                            Container(
                                              margin: EdgeInsets.only(top: 0,left: 5),
                                              alignment: Alignment.topLeft,

                                              width: MediaQuery.of(context).size.width*0.3,
                                              height: MediaQuery.of(context).size.height*0.1,
                                              child: Image.network(exam_result_data['question_attachment'].toString(),
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade300,
                                                    alignment: Alignment.center,
                                                    child: Icon(Icons.hide_image_outlined,size: 50,
                                                      color: Colors.grey.shade500,),
                                                  );
                                                },),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  sizebox_height_5,

                                  // RIGHT ANSWER FOR HERE ======
                                  exam_result_data['correct_answer'].toString()=="null"?Container():
                                  Column(
                                    children: [
                                      int.parse( exam_result_data['is_answer'].toString())==1?Container():
                                      Row(
                                        children: [
                                          Container(

                                            padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                            child: Text("Right Answer",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins-Regular',
                                                  color: black54,
                                                  fontWeight: FontWeight.w500
                                              ),),
                                          )
                                        ],
                                      ),
                                      int.parse( exam_result_data['is_answer'].toString())==1?Container():
                                      Container(

                                        color: int.parse(exam_result_data['is_answer'].toString())==3?
                                        Colors.grey.shade300:
                                        int.parse(exam_result_data['is_answer'].toString())==2?
                                        answerColor:Colors.white,
                                        // answerColor:
                                        // int.parse(exam_result_data['is_answer'].toString())==2?wrongColor:,
                                        child: Row(
                                          children: [

                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                exam_result_data['correct_answer']['objective'].toString()=="null"?Container():
                                                Container(
                                                  width: MediaQuery.of(context).size.width-20,
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${exam_result_data['correct_answer']['objective'].toString()
                                                      =="null"?"":exam_result_data['correct_answer']['objective'].toString()}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Helvetica',
                                                        fontWeight: FontWeight.w400
                                                    ),),
                                                ),
                                                exam_result_data['correct_answer']['attachment'].toString()=="null"?Container():
                                                // Image.network(exam_result_data['question_attachment'].toString())
                                                Container(
                                                  margin: EdgeInsets.only(top: 10,left: 5,bottom: 6),
                                                  alignment: Alignment.topLeft,
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  height: MediaQuery.of(context).size.height*0.1,
                                                  child: Image.network(exam_result_data['correct_answer']['attachment'].toString(),
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.grey.shade300,
                                                        alignment: Alignment.center,
                                                        child: Icon(Icons.hide_image_outlined,size: 50,
                                                          color: Colors.grey.shade500,),
                                                      );
                                                    },),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizebox_height_10,
                                  //     YOUR ANSWER FOR HERE ======
                                  exam_result_data['your_answer'].toString()=="[]"?Container():
                                  Row(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                        child: Text("You Answered",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins-Regular',
                                              color: black54,
                                              fontWeight: FontWeight.w500
                                          ),),
                                      )
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      exam_result_data['your_answer'].toString()=="[]"?Container():
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        // color: int.parse(exam_result_data['is_answer'].toString())==1?
                                        // ansBackgroundColor:int.parse(exam_result_data['is_answer'].toString())!=1&&
                                        //     int.parse(exam_result_data['is_answer'].toString())==3?redBackgroundColor :Colors.grey,
                                        color:  int.parse(exam_result_data['is_answer'].toString())==1?
                                        answerColor:
                                        int.parse(exam_result_data['is_answer'].toString())==2?
                                        wrongColor:Colors.grey.shade400,
                                        margin: EdgeInsets.only(bottom: 16),
                                        child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              exam_result_data['your_answer']['objective'].toString()=="null"?Container():

                                              Container(
                                                margin: EdgeInsets.only(top: 0,left: 0),
                                                child: Text(
                                                  "${exam_result_data['your_answer']['objective'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Helvetica',
                                                      color:  int.parse(exam_result_data['is_answer'].toString())==2?
                                                      redTextColor:Colors.black,
                                                      fontWeight: FontWeight.w400
                                                  ),),
                                              ),

                                              exam_result_data['your_answer']['attachment'].toString()=="null"?Container():
                                              // Image.network(exam_result_data['question_attachment'].toString())
                                              Container(
                                                margin: EdgeInsets.only(top: 10,left: 0),
                                                alignment: Alignment.topLeft,
                                                width: MediaQuery.of(context).size.width*0.3,
                                                height: MediaQuery.of(context).size.height*0.1,
                                                child: Image.network(exam_result_data['your_answer']['attachment'].toString(),
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Icon(Icons.hide_image_outlined,size: 50,
                                                        color: Colors.grey.shade500,),
                                                    );
                                                  },),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  exam_result_data['ans_description'].toString()=="null"&&exam_result_data['ans_description_attachment'].toString() =="null"?
                                  Container():GestureDetector(
                                    onTap: (){
                                          if(indextap==index){
                                            indextap = -1;
                                          }else{
                                            indextap  = index;

                                          }
                                          setState(() {

                                          });
                                      },
                                    child: Container(
                                    color: Colors.white.withOpacity(0.1),
                                    width: size.width-150,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          top: 4,
                                          bottom: 4
                                        ),
                                        child: Text(
                                          index==indextap?"Hide":"See Rationale: ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              decoration: TextDecoration
                                                  .underline,
                                              fontWeight:
                                              FontWeight.bold),
                                        )),
                                  ),
                                  index==indextap?
                                  exam_result_data['ans_description'].toString()=="null"&&exam_result_data['ans_description_attachment'].toString() =="null"?Container():Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      children: [
                                        exam_result_data['ans_description_attachment'].toString() =="null"
                                            ? Container()
                                            : Image.network(
                                          exam_result_data['ans_description_attachment']
                                              .toString(),
                                        ),

                                        exam_result_data['ans_description']
                                            .toString() ==
                                            "null"
                                            ? Container()
                                            : Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 8.0,
                                              right: 10.0,
                                              top: 12),
                                          child: Html(
                                            data: exam_result_data['ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString()
                                            ,
                                            style: {
                                              "table": Style( ),
                                              // some other granular customizations are also possible
                                              "tr": Style(
                                                border: Border(
                                                  bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                  top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                  right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                  left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                ),
                                              ),
                                              "th": Style(
                                                padding: EdgeInsets.all(6),
                                                backgroundColor: Colors.black,
                                              ),
                                              "p": Style(
                                                fontSize: FontSize.xxSmall,

                                              ),
                                              "td": Style(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.topLeft,
                                              ),
                                            },
                                            customRenders: {
                                              tableMatcher(): tableRender(),
                                            },
                                            // defaultTextStyle: TextStyle(
                                            //     fontSize: 16,
                                            //     letterSpacing: 0.5),

                                            //           data: Text(get_data['ans_description'].toString(),
                                            //         textAlign: TextAlign.justify,
                                            //         style: TextStyle(
                                            //           fontSize: 14,
                                            //
                                            //           fontWeight: FontWeight.w400,
                                            //           fontFamily: 'Helvetica',
                                            //           color: black54,
                                            //         ),
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):Container(),
                                  sizebox_height_10,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

      ),
    );
  }
}
