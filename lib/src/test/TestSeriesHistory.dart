import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/new_questionbank/questions_qbank.dart';
import 'package:n_prep/src/q_bank/quetions.dart';
import 'package:n_prep/src/q_bank/review.dart';
import 'package:n_prep/src/test/ExamReview_Page.dart';
import 'package:n_prep/src/test/LeadershipScore.dart';
import 'package:n_prep/utils/colors.dart';

import '../../Controller/Exam_Controller.dart';

class TestSeriesHistory extends StatefulWidget {
  final title;
  final data_type;
  final header;
  final examid ;
  final lastexamid ;
  final checkstatus;
  final attempquestion;
  final completed_date;
  final created_at;
  final total_questions;
  final total_questions_duration;
  bool today =false;
  TestSeriesHistory({
    Key key,
    this.title,
    this.data_type,
    this.header,
    this.examid,
    this.today,
    this.lastexamid,
    this.checkstatus,
    this.attempquestion,
    this.completed_date,
    this.created_at,
    this.total_questions,
    this.total_questions_duration,
  });

  @override
  State<TestSeriesHistory> createState() => _TestSeriesHistoryState();
}

class _TestSeriesHistoryState extends State<TestSeriesHistory> {

  ExamController examController =Get.put(ExamController());


  @override
  void initState() {
    super.initState();

    bool temp = sprefs.getBool("is_internet");
    if(!temp){
      Get.offAll(BottomBar(bottomindex: 2,));
      toastMsg("Please Check Your Internet Connection", true);
    }
   print("total attemp exam "+widget.attempquestion.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(0.6, 0.9);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

      child: Scaffold(
        appBar: AppBarHelper(
          title: "${widget.title}",
          context: context,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: primary,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Text(
                        widget.header,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'PublicSans',
                            color: white,letterSpacing: 1),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PublicSans',
                          color: black54,
                          letterSpacing: 1)),
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    widget.checkstatus != 3
                        ? Icon(
                      Icons.pause_circle_filled,
                      color: primary,
                      size: 19,
                    )
                        : Icon(
                      Icons.check_circle,
                      color: Colors.green.shade500,
                      size: 19,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width:MediaQuery.of(context).size.width-60,
                      // color: Colors.green,
                      child: Text(
                        widget.checkstatus != 3
                            ? 'You paused this module on ${DateFormat("d").format(
                            DateTime.parse(
                                widget.created_at.toString()))}'
                            ' ${DateFormat("MMMM").format(
                            DateTime.parse(
                                widget.created_at.toString()))}'

                            : 'You finished this exam on ${DateFormat("d").format(
                            DateTime.parse(
                                widget.completed_date.toString()))}'
                            ' ${DateFormat("MMMM").format(
                            DateTime.parse(
                                widget.completed_date.toString()))}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PublicSans',
                            color: black54,letterSpacing: 0.5),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 15,left: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Container(
                        height: 70,
                        width: size.width*0.42,

                        decoration: BoxDecoration(
                          // color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.fromBorderSide(
                                BorderSide(color: primary, width: 1))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                '${widget.total_questions.toString().length==1?"0${widget.total_questions}":widget.total_questions}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'PublicSans',
                                    color: black54),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'MCQs',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'PublicSans',
                                      color: black54),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  // width: size.width*0.25,
                                  // color: primary,
                                  padding:  EdgeInsets.only(top: 5),
                                  child: Text(
                                    widget.checkstatus == 3
                                        ?'Completed'
                                        : '${widget.attempquestion} Completed',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'PublicSans',
                                        color: black54,
                                        letterSpacing: 0.5),
                                  ),
                                )
                                // Container(
                                //   width: size.width*0.25,
                                //   // color: primary,
                                //   child: Text(
                                //     widget.checkstatus == 3
                                //         ?'${widget.attempquestion} Completed'
                                //         : '${widget.attempquestion} Completed',
                                //     maxLines: 2,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w700,
                                //         fontFamily: 'Helvetica',
                                //         color: black54),
                                //   ),
                                // )
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.checkstatus != 3) {
                            print("attemp plus "+ ((widget.attempquestion)+1).toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => questionbank_new(
                                      examId: widget.examid,
                                      timer: false,
                                      counterindex: ((widget.attempquestion)+1),
                                      checkstatus: widget.checkstatus,

                                    )));
                          }
                          else {
                            Get.offAll(ExamReviewPage(exam_Ids: widget.lastexamid.toString(),exam_Id: widget.examid,today: widget.today,));

                          }

                          // Start exam or Review
                        },
                        child: Container(
                          height: 70,
                          width: size.width*0.42,

                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.fromBorderSide(
                                  BorderSide(color: primary, width: 1))),
                          child: Padding(
                            padding:  EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(widget.checkstatus != 3 ? solve : review_img,
                                    scale: widget.checkstatus == 3? 2 : 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    widget.checkstatus != 3 ? 'SOLVE' : 'REVIEW',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'PublicSans',
                                        color: white,letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                if (widget.checkstatus == 3)
                  Padding(
                    padding:  EdgeInsets.all(20.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          //restart the test
                          if(widget.data_type==0){
                           var attemptExamUrl = "${apiUrls().exam_attempt_api}" "${widget.examid}";
                            await examController.AttemptExamData(attemptExamUrl,widget.total_questions_duration);

                          }else{
                            var attemptExamUrl = "${apiUrls().Mock_exam_attempt_api}" "${widget.examid}";

                            await examController.MockAttemptExamData(attemptExamUrl,widget.total_questions_duration,widget.today);

                          }


                        },
                        child: Container(
                          height: 55,
                          width: 180,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          // padding:EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Text(
                            'Reattempt Test',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PublicSans',
                                letterSpacing: 0.7,
                                color: white),
                          ),
                        ),
                      ),
                    ),
                  ),
                examController.type==1||examController.type==2? GestureDetector(
                    onTap: (){
                      Get.to(ScoreListScreen(exam_id:widget.examid ,today: widget.today,));
                    },
                  child: Container(
                    height: 90,
                    // color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          // color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Check Your \n Rank",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: Colors.grey.shade700))
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                        //   child: VerticalDivider(color: grey,thickness: 0.9,),
                        // ),
                        GestureDetector(
                          onTap: (){
                            Get.to(ScoreListScreen(exam_id:widget.examid ,today: widget.today));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(width: 0.5,color: Colors.white)
                            ),
                            child:  Image.asset("assets/nprep2_images/winnercup.png",height: 80,),
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
