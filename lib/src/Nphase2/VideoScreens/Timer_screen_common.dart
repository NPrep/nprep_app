import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/test/ExamReview_Page.dart';

class Timerclass extends StatefulWidget {
bool today=false;
   Timerclass(@required this.today);

  @override
  State<Timerclass> createState() => _TimerclassState();
}

class _TimerclassState extends State<Timerclass> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExamController>(
      builder: (examController) {
        return TweenAnimationBuilder<Duration>(
            key: ValueKey(examController.dailysectionData['data'][examController.sessionCount]['id']),
            duration: Duration(minutes: examController.timevalueInMin),
            tween: Tween(begin: Duration(minutes: examController.timevalueInMin), end: Duration.zero),
            onEnd: () async {
              if((examController.sessionCount+1)==examController.dailysectionData['data'].length){
                var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+examController.questionid.toString();
                var examBody = jsonEncode({
                  'answer_data': examController.Copy_get_que_list
                });
                log("examBody skip...."+examBody.toString());
                log("examBody skip...."+examansUrl.toString());
                await examController.ExamAnswerData(examansUrl, examBody);
                Get.off(ExamReviewPage(exam_Ids:examController.questionid,exam_Id:examController.questionExamid,today: widget.today,
                    pageId:2));


              }else{

                await examController.sessionIncrement();
                ///navigate screen into another page and delete current page

              }
            },
            builder: (BuildContext context, Duration value, Widget child) {


              final hour = value.inHours;
              final minutes = value.inMinutes%60;
              final seconds = value.inSeconds % 60;
              String hoursStr = hour.toString().padLeft(2, '0');
              String minutesStr = minutes.toString().padLeft(2, '0');
              String secondsStr = seconds.toString().padLeft(2, '0');
              // print("hoursStr......${hoursStr}");
              // print("minutesStr......${minutesStr}");
              // print("secondsStr......"+secondsStr.toString());
              return Row(
                children: [
                  Icon(Icons.watch_later_outlined ,color: Colors.black,size: 18,),
                  SizedBox(width: 5,),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('$hoursStr:$minutesStr:$secondsStr',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))),
                ],
              );
            });
      }
    );
  }
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

