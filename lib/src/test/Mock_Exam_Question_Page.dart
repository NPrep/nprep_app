import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/Timer_screen_common.dart';
import 'package:n_prep/src/test/ExamReview_Page.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'exam_menu.dart';

class MockExamQuestion extends StatefulWidget {

  const MockExamQuestion({Key key});

  @override
  State<MockExamQuestion> createState() => _MockExamQuestionState();
}

class _MockExamQuestionState extends State<MockExamQuestion> with TickerProviderStateMixin {

  int quecounter = 0;
  ExamController examController =Get.put(ExamController());

  PageController Question_controller2 ;


  var count = 1;

  dynamic id;

  dynamic percentage;
  dynamic today;


  // AnimationController controller;

  var exam_id;
  var selectedIndex;

  timeComplete(){
    print("object");
  }

  double percentagess = 1.0;

  @override
  void initState() {
    super.initState();
    examController.callback = updatevaluetoZero;

    Question_controller2 = PageController(viewportFraction: 1, keepPage: true);

    // examController.callback = newanimation;
    getinitdatacall();

  }
  void updatevaluetoZero(){
    Question_controller2.jumpToPage(0);
    setState(() {

    });
  }
  @override
  void dispose() {
    Question_controller2.dispose();
    super.dispose();
  }
  getinitdatacall() async {
    if(examController.dailysection==true){
      examController.timevalueInMin = examController.dailysectionData['data'][0]['section_time'];
      int timeInMinutes = int.parse(examController.timevalueInMin.toString());
      examController.timeInMilisecondes=  Duration(minutes: timeInMinutes).inMilliseconds;
      print("timevalueInMin......"+examController.timevalueInMin.toString());
      print("timeInMinutes......"+timeInMinutes.toString());
      print("timeInMilisecondes......"+examController.timeInMilisecondes.toString());
      examController.statusMinSec = true;
    }
    else{
      examController.timevalueInMin = Get.arguments[1];
      int timeInMinutes = int.parse(examController.timevalueInMin.toString());
      examController.timeInMilisecondes=  Duration(minutes: timeInMinutes).inMilliseconds;
      print("timevalueInMin......"+examController.timevalueInMin.toString());
      print("timeInMinutes......"+timeInMinutes.toString());
      print("timeInMilisecondes......"+examController.timeInMilisecondes.toString());
      examController.statusMinSec = Get.arguments[3];
    }


    id = Get.arguments[0];
    examController.questionid =Get.arguments[0];
    examController.questionExamid =Get.arguments[4];
    percentage = Get.arguments[2];
    today = Get.arguments[5];

    exam_id = Get.arguments[4];
    var getQueUrl ="${apiUrls().Mock_exam_questions_api}" "${id}";
   await examController.GetQuestionData(getQueUrl);
    examController.MenuQuestionList[quecounter] = examController.Seenquestion;
    print("exam_id......"+exam_id.toString());
    print("id......"+id.toString());
    print("timevalueInMin......"+examController.timevalueInMin.toString());
    print("percentage......"+percentage.toString());
    print("getQueUrl......"+getQueUrl.toString());
    print("getQueUrl..arguments...."+today.toString());

  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    examController.width=MediaQuery.of(context).size.width;
    var mediaquary=MediaQuery.of(context);

    var scale = mediaquary.textScaleFactor.clamp(0.9, 1.2);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
      statusBarColor: Color(0xFF64C4DA), // status bar color
    ));
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (stfContext, stfSetState) {
                  return Dialog(
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: GetBuilder<ExamController>(
                      builder: (examController) {
                        return Container(
                          height: 250,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Are you sure you want to submit the test?',
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'PublicSans',
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                    height: 1.3,

                                  ),

                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      child: Text(
                                        'No, let me continue',
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'PublicSans',
                                          letterSpacing: 0.5,

                                        ),
                                      ),
                                    )),
                              ),
                              TextButton(
                                  onPressed:examController.ExitLoader==true?null:() async {

                                    await examController.updateExitLoader();
                                    stfSetState((){

                                    });
                                    var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+id.toString();
                                    var examBody = jsonEncode({
                                      'answer_data': examController.Copy_get_que_list
                                    });
                                    log("examBody skip...."+examBody.toString());
                                    log("examansUrl...."+examansUrl.toString());
                                    await examController.ExamAnswerData(examansUrl, examBody);
                                    stfSetState((){

                                    });

                                    var exitexamUrl = "${apiUrls().exit_exam_api}" "${id}";
                                    print("exitexamUrl.... "+exitexamUrl.toString());

                                    await examController.Exit_Exam_Data(exitexamUrl,today);
                                    count = 1;
                                    stfSetState((){

                                    });
                                    await examController.StopupdateExitLoader();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      examController.ExitLoader==true? SizedBox(
                                        child: Center(
                                            child: CircularProgressIndicator(color: primary,strokeWidth: 3.0,)
                                        ),
                                        height: 20.0,
                                        width: 20.0,
                                      ):Container(),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          examController.ExitLoader==true?"Submitting test": 'OK',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: primary,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'PublicSans',
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        );
                      }
                    ),
                  );
                }
              );
            });
      },
      child: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

          child: Scaffold(
            backgroundColor: examBgColor,
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            // ),
            // appBar: PreferredSize(
            //   preferredSize: Size.fromHeight(0.0),
            //   child: AppBar(
            //     automaticallyImplyLeading: false,
            //     backgroundColor: Color(0xFF020202),
            //     iconTheme: IconThemeData(color: Colors.white),
            //   ),
            // ),
            body: GetBuilder<ExamController>(
                builder: (examController) {

                  if(examController.getQueLoader.value){
                    return Center(child: CircularProgressIndicator());
                  }
                  return examController.get_que_list.length==0?Center(child: Text("No Question Found")):Wrap(
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(top: 40),
                      //   alignment: Alignment.center,
                      //   // child: Image.asset(
                      //   //   logo,
                      //   //   scale: 4.5,
                      //   // ),
                      // ),

                      Container(
                        // margin: EdgeInsets.only(top: ),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder: (stfContext, stfSetState) {
                                            return Dialog(
                                              shape:
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              child: Container(
                                                height: 250,
                                                width: 300,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Text(
                                                        'Are you sure you want to submit the test?',
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        textAlign: TextAlign.center,

                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'PublicSans',
                                                          color: Colors.black87,
                                                          letterSpacing: 0.5,
                                                          height: 1.3,

                                                        ),

                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: primary,
                                                              borderRadius: BorderRadius.circular(8)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 20, vertical: 12),
                                                            child: Text(
                                                              'No, let me continue',
                                                              style: TextStyle(
                                                                color: white,
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.w700,
                                                                fontFamily: 'PublicSans',
                                                                letterSpacing: 0.5,

                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    TextButton(
                                                        onPressed:examController.ExitLoader==true?null: () async {
                                                          await examController.updateExitLoader();
                                                          stfSetState((){

                                                          });
                                                          var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+id.toString();
                                                          var examBody = jsonEncode({
                                                            'answer_data': examController.Copy_get_que_list
                                                          });
                                                          log("examBody skip...."+examBody.toString());
                                                          await examController.ExamAnswerData(examansUrl, examBody);
                                                          stfSetState((){

                                                          });
                                                          var exitexamUrl = "${apiUrls().exit_exam_api}" "${id}";
                                                          print("exitexamUrl.... "+exitexamUrl.toString());

                                                          await examController.Exit_Exam_Data(exitexamUrl,today);
                                                          await examController.StopupdateExitLoader();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            examController.ExitLoader==true? SizedBox(
                                                              child: Center(
                                                                  child: CircularProgressIndicator(color: primary,strokeWidth: 3.0,)
                                                              ),
                                                              height: 20.0,
                                                              width: 20.0,
                                                            ):Container(),
                                                            Padding(
                                                              padding: const EdgeInsets.all(12.0),
                                                              child: Text(
                                                                examController.ExitLoader==true?"Submitting test": 'OK',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: primary,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: 'PublicSans',
                                                                  letterSpacing: 0.6,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          );
                                        });
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => BottomBar(
                                    //         bottomindex: 2,
                                    //       )),
                                    // );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_back_ios, color: Colors.black54),
                                  ),
                                ),

                                examController.dailysection==true?
                                Timerclass(today):
                                examController.statusMinSec == false ?
                                TweenAnimationBuilder<Duration>(
                                    duration: Duration(seconds: examController.timevalueInMin),
                                    tween: Tween(begin: Duration(seconds: examController.timevalueInMin), end: Duration.zero),
                                    onEnd: () {
                                      print('Timer ended');
                                    },
                                    builder: (BuildContext context, Duration value, Widget child) {
                                      final hour = value.inHours;
                                      final minutes = value.inMinutes%60;
                                      final seconds = value.inSeconds % 60;
                                      String hoursStr = hour.toString().padLeft(2, '0');
                                      String minutesStr = minutes.toString().padLeft(2, '0');
                                      String secondsStr = seconds.toString().padLeft(2, '0');

                                      return Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined ,color: Colors.black,size: 18,),
                                          SizedBox(width: 5,),
                                          Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: Text('${hoursStr}:$minutesStr:$secondsStr',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15))),
                                        ],
                                      );

                                    }):
                                TweenAnimationBuilder<Duration>(
                                    duration: Duration(minutes: examController.timevalueInMin),
                                    tween: Tween(begin: Duration(minutes: examController.timevalueInMin), end: Duration.zero),
                                    onEnd: () async {
                                        setState(() {

                                        });
                                      print('Timer ended');
                                      var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+id.toString();
                                      var examBody = jsonEncode({
                                        'answer_data': examController.Copy_get_que_list
                                      });
                                      log("examBody skip...."+examBody.toString());
                                      await examController.ExamAnswerData(examansUrl, examBody);

                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => ExamReviewPage(exam_Ids:id,exam_Id: exam_id,today:today,
                                                  pageId:2)));
                                      // percentagess=0.0;
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
                                    }),
                                GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return  Exam_Menu(pagecontrl: Question_controller2,id: id,exam_id: exam_id,quecounter: quecounter,today:today,);
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Icon(Icons.menu_rounded,size: 30,),
                                    )),

                              ],
                          ),
                        ),
                      ),

                      examController.dailysection==true?
                      LinearPercentIndicator(
                        key: ValueKey(examController.dailysectionData['data'][examController.sessionCount]['id']),
                        animateFromLastPercent: true,
                        width: MediaQuery.of(context).size.width,
                        percent: 1.0,
                        lineHeight: 4.0,
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey,
                        progressColor: primary,
                        animation: true,
                        animationDuration: examController.timeInMilisecondes,
                        restartAnimation: false,
                        isRTL: true,
                        addAutomaticKeepAlive: true,
                        // onAnimationEnd: timeComplete ,
                      ) :
                      LinearPercentIndicator(
                        animateFromLastPercent: true,
                        width: MediaQuery.of(context).size.width,
                        percent: 1.0,
                        lineHeight: 4.0,
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey,
                        progressColor: primary,
                        animation: true,
                        animationDuration: examController.timeInMilisecondes,
                        restartAnimation: false,
                        isRTL: true,
                        addAutomaticKeepAlive: true,
                        // onAnimationEnd: timeComplete ,
                      ),

                      examController.dailysection==true?
                      Container(
                        height: 50,
// color: Colors.grey,
                        child: ListView.builder(

                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: examController.dailysectionData['data'].length,
                            itemBuilder:(BuildContext context, int index) {
                            var data = examController.dailysectionData['data'][index];
                            return Card(
                              elevation: examController.sessionCount==index?8.0:1.0,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),

                                    child: Text(
                                        examController.sessionCount==index? "${data['section_name']}":"${data['section_name']}"
                                        // examController.dailysectionData['data'][examController.sessionCount]['section_name']
                                        ,style: TextStyle(
                                        fontSize: 10,
                                        color: examController.sessionCount==index?primary:Colors.grey,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold)
                                    ),
                                  )),
                            );
                          }
                        ),
                      ):
                      Container(),

                      GestureDetector(
                        onTap: () async {
                          // await examController.sessionIncrement();

                        },
                        child: Container(
                          // color: Colors.green,
                          alignment: Alignment.center,
                          child: Padding(

                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(" ${quecounter+1} of ${examController.get_que_list.length} ",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: primary,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      examController.get_que_list.length==0?Center(child: Text("No Question Found")):
                      SingleChildScrollView(
                        child: Container(
                          // color: Colors.red,
                          height:  size.height - (examController.dailysection==true?280:250),
                          child: PageView.builder(
                            controller:Question_controller2,
                              key:ValueKey(id),
                            // padding: EdgeInsets.all(2.0),

                            itemCount: examController.get_que_list.length,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (v){
                              log("onPageChanged >> Mock "+v.toString());
                              quecounter = v;
                              setState(() {
                                log("MenuQuestionList onPageChanged before>> "+ examController.MenuQuestionList[quecounter].toString());

                                if(examController.MenuQuestionList[quecounter]==examController.NotSeenquestion){
                                  examController.MenuQuestionList[quecounter] = examController.Seenquestion;
                                }
                                log("MenuQuestionList onPageChanged after>> "+ examController.MenuQuestionList[quecounter].toString());
                              });
                            },
                            // shrinkWrap: true,

                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var get_data = examController.get_que_list[index];
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,

                                  children: [

                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0,right: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text("Q.${quecounter}) ",
                                          //     style: TextStyle(
                                          //         fontSize: 18,
                                          //         color: primary,
                                          //         fontWeight: FontWeight.w700)),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          get_data['question'].toString()=="null"?Container():
                                          Container(
                                            // alignment: Alignment.centerLeft,
                                            // color: primary,
                                            width: MediaQuery.of(context).size.width - 80,
                                            child: Text('${get_data['question'].toString()=="null"?""
                                                :get_data['question'].toString()}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'PublicSans',
                                                    color: black54,
                                                    letterSpacing: 0.5
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    get_data['attachment'].toString() == "null"
                                        ? Container()
                                        : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext
                                          context) {
                                            return WillPopScope(
                                                onWillPop:
                                                    () async =>
                                                true,
                                                child: Stack(
                                                  clipBehavior:
                                                  Clip.none,
                                                  children: [
                                                    AlertDialog(

                                                      content:
                                                      new SingleChildScrollView(
                                                        child:
                                                        Container(
                                                          height:
                                                          250,
                                                          width:
                                                          250,
                                                          child:
                                                          InteractiveViewer(
                                                            child: Image.network(
                                                              "${get_data['attachment'].toString()}",

                                                            ),
                                                            maxScale: 5.0,
                                                          ),
                                                          // PhotoView(
                                                          //   imageProvider:
                                                          //   NetworkImage("${get_data['attachment'].toString()}"),
                                                          // ),
                                                        ),
                                                      ),
                                                      // actions: <Widget>[
                                                      //   ElevatedButton(
                                                      //     child: const Text(
                                                      //       'Close',
                                                      //     ),
                                                      //     style: ElevatedButton.styleFrom(
                                                      //       minimumSize: const Size(0, 45),
                                                      //       primary: Colors.amber,
                                                      //       onPrimary: const Color(0xFFFFFFFF),
                                                      //       shape: RoundedRectangleBorder(
                                                      //         borderRadius: BorderRadius.circular(8),
                                                      //       ),
                                                      //     ),
                                                      //     onPressed: () {
                                                      //       Get.back();
                                                      //     },
                                                      //   ),
                                                      // ],
                                                    ),
                                                    Positioned(
                                                        top: 199,
                                                        right: 50,
                                                        child: GestureDetector(
                                                            onTap: () {

                                                              Get.back();
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .cancel,
                                                              color:
                                                              primary,
                                                            )))
                                                  ],
                                                ));
                                          },
                                        );

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                                        padding: EdgeInsets.all( 5),
                                        // color: primary,
                                        alignment: Alignment.topCenter,
                                        width: MediaQuery.of(context).size.width,


                                        height: 250,
                                        child: Image.network(get_data['attachment'].toString(),
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade300,
                                              alignment: Alignment.center,
                                              child: Icon(Icons.broken_image_outlined,size: 50,
                                                color: Colors.grey.shade500,),
                                            );
                                          },),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      itemCount: get_data['examQuestionObjects'].length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(2.0),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:(BuildContext context, int indexs) {
                                        final optionIndex = String.fromCharCode(97 + indexs);
                                        final optionText =get_data['examQuestionObjects'][indexs];

                                        // print("optionText...."+index.toString());
                                        // log("optionText...."+examController.ontap_answer[index].toString());

                                        return GestureDetector(
                                          onTap: () async {
                                            examController.MenuQuestionList[quecounter]=examController.AttempSeenquestion;
                                            log("optionText...."+examController.dailysection.toString());

                                            if(examController.dailysection==true){
                                              examController.updatesessioncallindex((quecounter),get_data['id'],optionText['option_id']);

                                            }else{
                                              examController.callindex(index,indexs);
                                              examController.UpdateExamAnswerData((quecounter),optionText['option_id']);

                                            }
                                            if(examController.get_que_list.length>quecounter){
                                              selectedIndex = indexs;
                                              print("if index  ....."+selectedIndex.toString());

                                              print("selected index ....."+selectedIndex.toString());

                                              setState((){});
                                            }
                                            else{
                                              selectedIndex = indexs;
                                              print("else index  ....."+selectedIndex.toString());

                                            }


                                          },
                                          child: Card(
                                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            elevation: 3,
                                            child: Container(
                                              // margin: EdgeInsets.symmetric(vertical: 2),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color:get_data['is_attempt']==1?get_data['your_answer'].toString() == optionText['option_id'].toString()?Colors.blue.shade100:white:white,
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  border: Border.fromBorderSide(
                                                      BorderSide(color: Colors.grey.shade300))
                                              ),

                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:primary,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      child: Text(
                                                        optionIndex.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontFamily:
                                                          'Poppins-Regular',
                                                          //  color red krna h agar answer galat ho
                                                          color: white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),

                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      optionText['objective'].toString()=="null"?Container():
                                                      Container(
                                                        width: MediaQuery.of(context).size.width-120,
                                                        child: Text(
                                                          "${optionText['objective'].toString()=="null"?"":
                                                          optionText['objective'].toString()}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: 'PublicSans',
                                                              color:black54,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ),

                                                      optionText['attachment'].toString()== "null"?Container()
                                                          : GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) {
                                                              return WillPopScope(
                                                                  onWillPop:
                                                                      () async =>
                                                                  true,
                                                                  child: Stack(
                                                                    clipBehavior:
                                                                    Clip.none,
                                                                    children: [
                                                                      AlertDialog(

                                                                        content:
                                                                        new SingleChildScrollView(
                                                                          child:
                                                                          Container(
                                                                            height:
                                                                            250,
                                                                            width:
                                                                            250,
                                                                            child:
                                                                            InteractiveViewer(
                                                                              child: Image.network(
                                                                                "${optionText['attachment'].toString()}",

                                                                              ),
                                                                              maxScale: 5.0,
                                                                            ),
                                                                            // PhotoView(
                                                                            //   imageProvider:
                                                                            //   NetworkImage("${optionText['attachment'].toString()}"),
                                                                            // ),
                                                                          ),
                                                                        ),
                                                                        // actions: <Widget>[
                                                                        //   ElevatedButton(
                                                                        //     child: const Text(
                                                                        //       'Close',
                                                                        //     ),
                                                                        //     style: ElevatedButton.styleFrom(
                                                                        //       minimumSize: const Size(0, 45),
                                                                        //       primary: Colors.amber,
                                                                        //       onPrimary: const Color(0xFFFFFFFF),
                                                                        //       shape: RoundedRectangleBorder(
                                                                        //         borderRadius: BorderRadius.circular(8),
                                                                        //       ),
                                                                        //     ),
                                                                        //     onPressed: () {
                                                                        //       Get.back();
                                                                        //     },
                                                                        //   ),
                                                                        // ],
                                                                      ),
                                                                      Positioned(
                                                                          top: 199,
                                                                          right: 50,
                                                                          child: GestureDetector(
                                                                              onTap: () {

                                                                                Get.back();
                                                                              },
                                                                              child: Icon(
                                                                                Icons
                                                                                    .cancel,
                                                                                color:
                                                                                primary,
                                                                              )))
                                                                    ],
                                                                  ));
                                                            },
                                                          );

                                                        },
                                                        child: Container(
                                                          // color: primary,
                                                          margin: EdgeInsets.only(top: 10),
                                                          alignment: Alignment.topLeft,
                                                          width: MediaQuery.of(context).size.width*0.3,
                                                          height: MediaQuery.of(context).size.height*0.1,
                                                          child: Image.network(optionText['attachment'].toString(),
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return Container(
                                                                color: Colors.grey.shade300,
                                                                alignment: Alignment.center,
                                                                child: Icon(Icons.broken_image_outlined,size: 50,
                                                                  color: Colors.grey.shade500,),
                                                              );
                                                            },),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        thickness: 1.5,
                                      ),
                                    ),

                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     examController.ontap_answer[index]==true?  GestureDetector(
                                    //       onTap: () async{
                                    //         print("qr: "+quecounter.toString());
                                    //         // print("qr: "+(quecounter>1).toString());
                                    //         if((quecounter>1)==true){
                                    //           quecounter = quecounter - 1;
                                    //         // log("qr: "+examController.get_que_list[quecounter]['your_answer'].toString());
                                    //           // examController.callagainindex(index);
                                    //           setState(()  {
                                    //           });
                                    //         }
                                    //         else{
                                    //
                                    //           toastMsg("No Previous Question Left", true);
                                    //           /* toastMsg("No Question Left", true);*/
                                    //         }
                                    //
                                    //
                                    //       },
                                    //       child: Container(
                                    //         alignment: Alignment.center,
                                    //         width: size.width * 0.3,
                                    //         height: size.height * 0.05,
                                    //         margin: EdgeInsets.only(bottom: 20, top: 20),
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(4),
                                    //             color: primary),
                                    //         child: Text(
                                    //           "Previous" ,
                                    //           style: TextStyle(
                                    //             fontSize: 19,
                                    //             fontWeight: FontWeight.w500,
                                    //             fontFamily: 'Poppins-Regular',
                                    //             color: white,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ):Container(),
                                    //     examController.ontap_answer[index]==true? SizedBox(
                                    //       width: 20,
                                    //     ):Container(),
                                    //     GestureDetector(
                                    //       onTap: () async{
                                    //         log("data>> index: "+index.toString());
                                    //         log("data>> onlist: "+examController. ontap_answer[index].toString());
                                    //         if(examController.ontap_answer[index]==true){
                                    //           if(examController.get_que_list.length>quecounter){
                                    //             quecounter = quecounter + 1;
                                    //             examController.callagainindex(index);
                                    //             setState(()  {
                                    //             });
                                    //           }else{
                                    //
                                    //             var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
                                    //             var examBody = {'question_id': qid.toString(), 'answer_id': ansid.toString(),};
                                    //             print("examBody...."+examBody.toString());
                                    //             await examController.ExamAnswerData(examansUrl, examBody);
                                    //             setState((){});
                                    //             Navigator.pushReplacement(context,
                                    //                 MaterialPageRoute(
                                    //                     builder: (context) => ExamReviewPage(exam_Ids:id,
                                    //                         pageId:2)));
                                    //             /* toastMsg("No Question Left", true);*/
                                    //           }
                                    //
                                    //         }
                                    //         else{
                                    //           var qid =get_data['id'];
                                    //           var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
                                    //           var examBody = {
                                    //             'question_id': qid.toString(),
                                    //           };
                                    //           print("examBody skip...."+examBody.toString());
                                    //           await examController.ExamAnswerData(examansUrl, examBody);
                                    //
                                    //           if (examController.get_que_list.length > quecounter) {
                                    //             quecounter = quecounter + 1;
                                    //             print("quecounter after update......"+quecounter.toString());
                                    //             // examController.get_que_list[quecounter];
                                    //
                                    //             setState(()  {
                                    //             });
                                    //
                                    //             // getQuestion(false);
                                    //           } else {
                                    //             var qid =get_data['id'];
                                    //             var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
                                    //             var examBody = {
                                    //               'question_id': qid.toString(),
                                    //             };
                                    //             print("examansUrl...."+examansUrl.toString());
                                    //             print("examBody...."+examBody.toString());
                                    //             await examController.ExamAnswerData(examansUrl, examBody);
                                    //             Navigator.pushReplacement(
                                    //                 context,
                                    //                 MaterialPageRoute(
                                    //                     builder: (context) => ExamReviewPage(exam_Ids:id,
                                    //                         pageId:2)));
                                    //             // toastMsg("No Question Left", true);
                                    //             // quecounter = quecounter - 1;
                                    //             // examController.get_que_list[quecounter];
                                    //             // Navigator.push(context,
                                    //             //     MaterialPageRoute(builder: (context) => ReviewPage(skip:true)));
                                    //           }
                                    //
                                    //         }
                                    //
                                    //
                                    //       },
                                    //       child: Container(
                                    //         alignment: Alignment.center,
                                    //         width: examController.ontap_answer[index]==true?size.width*0.3:size.width * 0.6,
                                    //         height: size.height * 0.05,
                                    //         margin: EdgeInsets.only(bottom: 20, top: 20),
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(4),
                                    //             color: primary),
                                    //         child: Text(
                                    //           examController. ontap_answer[index]==true?"Next":  "Skip",
                                    //           style: TextStyle(
                                    //             fontSize: 19,
                                    //             fontWeight: FontWeight.w500,
                                    //             fontFamily: 'Poppins-Regular',
                                    //             color: white,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //
                                    //   ],
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Container(
                        // margin: EdgeInsets.only(bottom: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: Row(
                            mainAxisAlignment: examController.ontap_answer[quecounter]==true?MainAxisAlignment.spaceBetween:MainAxisAlignment.spaceAround,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Tooltip(
                                message: 'Mark Review',
                                preferBelow: true,
                                enableFeedback: true,

                                child: GestureDetector(
                                    onTap: (){
                                      if(examController.MenuQuestionMarkReviewList[quecounter]==examController.MarkReviewSeenquestion){
                                        examController.MenuQuestionMarkReviewList[quecounter] = examController.MarkReviewNotSeenquestion;
                                        setState(() {

                                        });
                                      }
                                      else{
                                        examController.MenuQuestionMarkReviewList[quecounter] = examController.MarkReviewSeenquestion;
                                        setState(() {

                                        });
                                      }
                                    },
                                    child: Icon(examController.MenuQuestionMarkReviewList[quecounter]==examController.MarkReviewSeenquestion?Icons.star:Icons.star_border_outlined,color:   primary,)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              examController.ontap_answer[quecounter]==true?
                              GestureDetector(
                                onTap: () async{
                                  print("qr: "+quecounter.toString());
                                  // print("qr: "+(quecounter>1).toString());
                                  if((quecounter>0)==true){
                                    quecounter = quecounter - 1;
                                    Question_controller2.jumpToPage(quecounter);
                                    print("IF qr: "+quecounter.toString());
                                    setState(()  {
                                    });
                                  }
                                  else{

                                    toastMsg("No Previous Question Left", true);
                                    /* toastMsg("No Question Left", true);*/
                                  }


                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.3,
                                  height: size.height * 0.05,
                                  margin: EdgeInsets.only(bottom: 20, top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: primary),
                                  child: Text(
                                    "Previous" ,
                                    style: TextStyle(
                                      fontSize:examController.dailysection==true?13: 19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins-Regular',
                                      color: white,
                                    ),
                                  ),
                                ),
                              ):Container(),
                              examController.ontap_answer[quecounter]==true?
                              SizedBox(
                                width: 15,
                              ):Container(),
                              GestureDetector(
                                onTap: () async{

                                  if(examController.get_que_list.length==(quecounter+1)){
                                    if(examController.dailysection==true){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder: (stfContext, stfSetState) {
                                              return Dialog(
                                                shape:
                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                child: GetBuilder<ExamController>(
                                                    builder: (examController) {
                                                      return Container(
                                                        height: 250,
                                                        width: 300,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Text(
                                                                'Are you sure you want to submit ${examController.dailysectionData['data'][examController.sessionCount]['section_name']} ?',
                                                                maxLines: 2,
                                                                softWrap: true,
                                                                textAlign: TextAlign.center,

                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: 'PublicSans',
                                                                  color: Colors.black87,
                                                                  letterSpacing: 0.5,
                                                                  height: 1.3,

                                                                ),

                                                              ),
                                                            ),

                                                            GestureDetector(
                                                              onTap: examController.ExitLoader==true?null:() async {
                                                                await examController.updateExitLoader();
                                                                stfSetState((){

                                                                });
                                                                if((examController.sessionCount+1)==examController.dailysectionData['data'].length){

                                                                  var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+id.toString();
                                                                  var examBody = jsonEncode({
                                                                    'answer_data': examController.Copy_get_que_list
                                                                  });
                                                                  log("examBody skip...."+examBody.toString());
                                                                  log("examBody skip...."+examansUrl.toString());
                                                                  await examController.ExamAnswerData(examansUrl, examBody);

                                                                  setState((){});

                                                                  Navigator.pushReplacement(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ExamReviewPage(exam_Ids:id,exam_Id: exam_id,today: today,
                                                                              pageId:2)));
                                                                }
                                                                else{
                                                                  quecounter =0;

                                                                  await examController.sessionIncrement();
                                                                  ///navigate screen into another page and delete current page
                                                                  setState(() {
                                                                    Navigator.of(context).pop();
                                                                  });
                                                                }
                                                                stfSetState((){

                                                                });
                                                                await examController.StopupdateExitLoader();

                                                              },
                                                              child: Container(
                                                                  margin:  EdgeInsets.symmetric(
                                                                      horizontal: 50, vertical: 12),
                                                                  padding:EdgeInsets.symmetric(
                                                                      vertical: 12) ,
                                                                  decoration: BoxDecoration(
                                                                      color: primary,
                                                                      borderRadius: BorderRadius.circular(8)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      examController.ExitLoader==true? SizedBox(
                                                                        child: Center(
                                                                            child: CircularProgressIndicator(color: primary,strokeWidth: 3.0,)
                                                                        ),
                                                                        height: 20.0,
                                                                        width: 20.0,
                                                                      ):Container(),
                                                                      Text(
                                                                        examController.ExitLoader==true?"Submitting ${examController.dailysectionData['data'][examController.sessionCount]['section_name']}": 'Yes',
                                                                        style: TextStyle(
                                                                          color: white,
                                                                          fontSize: 17,
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: 'PublicSans',
                                                                          letterSpacing: 0.5,

                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            TextButton(
                                                                onPressed:() async {

                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    examController.ExitLoader==true? SizedBox(
                                                                      child: Center(
                                                                          child: CircularProgressIndicator(color: primary,strokeWidth: 3.0,)
                                                                      ),
                                                                      height: 20.0,
                                                                      width: 20.0,
                                                                    ):Container(),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(12.0),
                                                                      child: Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                          fontSize: 18,
                                                                          color: primary,
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: 'PublicSans',
                                                                          letterSpacing: 0.6,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                ),
                                              );
                                            }
                                            );
                                          });

                                    }
                                    else{
                                      var  examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api+id.toString();
                                      var examBody = jsonEncode({
                                        'answer_data': examController.Copy_get_que_list
                                      });
                                      log("examBody skip...."+examBody.toString());
                                      log("examBody skip...."+examansUrl.toString());
                                      await examController.ExamAnswerData(examansUrl, examBody);

                                      setState((){});
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => ExamReviewPage(exam_Ids:id,exam_Id: exam_id,today: today,
                                                  pageId:2)));
                                    }

                                  }
                                  else{
                                    quecounter = quecounter + 1;
                                    Question_controller2.jumpToPage(quecounter);
                                    setState(()  {
                                    });
                                  }


                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: examController.ontap_answer[quecounter]==true?size.width*0.3:size.width * 0.6,
                                  height: size.height * 0.05,
                                  margin: EdgeInsets.only(bottom: 20, top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: primary),
                                  child: Text(
                                    examController.get_que_list.length==(quecounter+1)?
                                    examController.dailysection==true?
                                    "Submit Section ${examController.sessionCount+1}":
                                    "Submit Test": examController.ontap_answer[quecounter]==true?
                                    "Next":"Skip",
                                    style: TextStyle(
                                      fontSize: examController.dailysection==true?13:19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins-Regular',
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:n_prep/Controller/Exam_Controller.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
// import 'package:n_prep/constants/images.dart';
// import 'package:n_prep/constants/validations.dart';
// import 'package:n_prep/src/test/ExamReview_Page.dart';
// import 'package:n_prep/src/home/bottom_bar.dart';
// import 'package:n_prep/utils/colors.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:photo_view/photo_view.dart';
//
// class ExamQuestion extends StatefulWidget {
//
//   const ExamQuestion({Key key});
//
//   @override
//   State<ExamQuestion> createState() => _ExamQuestionState();
// }
//
// class _ExamQuestionState extends State<ExamQuestion> with TickerProviderStateMixin {
//
//   int quecounter = 0;
//   ExamController examController =Get.put(ExamController());
//   List<bool> isSelected = List.generate(4, (_) => false);
//
//   var count = 1;
//
//   dynamic id;
//   dynamic timevalueInMin;
//   dynamic percentage;
//   dynamic statusMinSec;
//   String formattedTime;
//   AnimationController controller;
//   var timeInMilisecondes;
//   var exam_id;
//   var selectedIndex;
//
//   timeComplete(){
//     print("object");
//   }
//
//   double percentagess = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     timevalueInMin = Get.arguments[1];
//     int timeInMinutes = int.parse(timevalueInMin.toString());
//     timeInMilisecondes=  Duration(minutes: timeInMinutes).inMilliseconds;
//     print("timevalueInMin......"+timevalueInMin.toString());
//     print("timeInMinutes......"+timeInMinutes.toString());
//     print("timeInMilisecondes......"+timeInMilisecondes.toString());
//
//     id = Get.arguments[0];
//     percentage = Get.arguments[2];
//     statusMinSec = Get.arguments[3];
//     exam_id = Get.arguments[4];
//     var getQueUrl ="${apiUrls().exam_questions_api}" "${id}";
//     examController.GetQuestionData(getQueUrl);
//     Duration duration = Duration(minutes: timevalueInMin);
//     formattedTime = formatDuration(duration);
//     print("exam_id......"+exam_id.toString());
//     print("id......"+id.toString());
//     print("timevalueInMin......"+timevalueInMin.toString());
//     print("percentage......"+percentage.toString());
//     print("getQueUrl......"+getQueUrl.toString());
//
//
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
//       statusBarColor: Color(0xFF64C4DA), // status bar color
//     ));
//     return WillPopScope(
//       onWillPop: () async {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return StatefulBuilder(builder: (stfContext, stfSetState) {
//                 return Dialog(
//                   shape:
//                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   child: GetBuilder<ExamController>(
//                       builder: (examController) {
//                         return Container(
//                           height: 250,
//                           width: 300,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Text(
//                                   'Are you sure you want to submit the test?',
//                                   maxLines: 2,
//                                   softWrap: true,
//                                   textAlign: TextAlign.center,
//
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: 'PublicSans',
//                                     color: Colors.black87,
//                                     letterSpacing: 0.5,
//                                     height: 1.3,
//
//                                   ),
//
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                         color: primary,
//                                         borderRadius: BorderRadius.circular(8)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 12),
//                                       child: Text(
//                                         'No, let me continue',
//                                         style: TextStyle(
//                                           color: white,
//                                           fontSize: 17,
//                                           fontWeight: FontWeight.w700,
//                                           fontFamily: 'PublicSans',
//                                           letterSpacing: 0.5,
//
//                                         ),
//                                       ),
//                                     )),
//                               ),
//                               TextButton(
//                                   onPressed:count==0?null:() async {
//                                     count = 0;
//                                     var  examansUrl = apiUrls().Copy_exam_ans_attempt_api+id.toString();
//                                     var examBody = jsonEncode({
//                                       'answer_data': examController.Copy_get_que_list
//                                     });
//                                     log("examBody skip...."+examBody.toString());
//                                     await examController.ExamAnswerData(examansUrl, examBody);
//                                     setState(() {
//
//                                     });
//                                     var exitexamUrl = "${apiUrls().exit_exam_api}" "${id}";
//                                     print("exitexamUrl.... "+exitexamUrl.toString());
//
//                                     await examController.Exit_Exam_Data(exitexamUrl);
//                                     count = 1;
//                                     setState(() {
//
//                                     });
//
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Text(
//                                       'OK',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w700,
//                                         fontFamily: 'PublicSans',
//                                         letterSpacing: 0.6,
//                                       ),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         );
//                       }
//                   ),
//                 );
//               }
//               );
//             });
//       },
//       child: Scaffold(
//         backgroundColor: examBgColor,
//         // appBar: AppBar(
//         //   automaticallyImplyLeading: false,
//         // ),
//         // appBar: PreferredSize(
//         //   preferredSize: Size.fromHeight(0.0),
//         //   child: AppBar(
//         //     automaticallyImplyLeading: false,
//         //     backgroundColor: Color(0xFF020202),
//         //     iconTheme: IconThemeData(color: Colors.white),
//         //   ),
//         // ),
//         body: GetBuilder<ExamController>(
//             builder: (examController) {
//
//               if(examController.getQueLoader.value){
//                 return Center(child: CircularProgressIndicator());
//               }
//               return SingleChildScrollView(
//                 child: Stack(
//                   children: [
//                     Wrap(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(top: 40),
//                           alignment: Alignment.center,
//                           child: Image.asset(
//                             logo,
//                             scale: 4.5,
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 10,
//                           child: Container(
//                             height: 10,
//                             color: examBgColor,
//                           ),
//                         ),
//
//                         LinearPercentIndicator(
//                           width: MediaQuery.of(context).size.width,
//                           percent: 1.0,
//                           lineHeight: 4.0,
//                           padding: EdgeInsets.zero,
//                           backgroundColor: Colors.grey,
//                           progressColor: primary,
//                           animation: true,
//                           animationDuration: timeInMilisecondes,
//                           restartAnimation: false,
//                           isRTL: true,
//                           addAutomaticKeepAlive: true,
//                           // onAnimationEnd: timeComplete ,
//                         ),
//                         Container(
//                           // color: Colors.green,
//                           alignment: Alignment.center,
//                           child: Padding(
//
//                             padding: EdgeInsets.symmetric(vertical: 20),
//                             child: Text(" ${quecounter+1} of ${examController.get_que_list.length}",
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     color: primary,
//                                     fontWeight: FontWeight.w400)),
//                           ),
//                         ),
//                         Container(
//                           // color: Colors.red,
//                           height:  size.height - 250,
//                           child: PageView.builder(
//                             // padding: EdgeInsets.all(2.0),
//                             itemCount: examController.get_que_list.length,
//                             scrollDirection: Axis.horizontal,
//                             onPageChanged: (v){
//                               log("onPageChanged >> "+v.toString());
//                               quecounter = v;
//                               setState(() {
//
//                               });
//                             },
//                             // shrinkWrap: true,
//                             physics: AlwaysScrollableScrollPhysics(),
//                             itemBuilder: (BuildContext context, int index) {
//                               var get_data = examController.get_que_list[index];
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//
//                                 children: [
//
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 10.0,right: 8),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         // Text("Q.${quecounter}) ",
//                                         //     style: TextStyle(
//                                         //         fontSize: 18,
//                                         //         color: primary,
//                                         //         fontWeight: FontWeight.w700)),
//                                         SizedBox(
//                                           width: 3,
//                                         ),
//                                         get_data['question'].toString()=="null"?Container():
//                                         Container(
//                                           // alignment: Alignment.centerLeft,
//                                           // color: primary,
//                                           width: MediaQuery.of(context).size.width - 80,
//                                           child: Text('${get_data['question'].toString()=="null"?""
//                                               :get_data['question'].toString()}',
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.w400,
//                                                   fontFamily: 'PublicSans',
//                                                   color: black54,
//                                                   letterSpacing: 0.5
//                                               )),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   get_data['attachment'].toString() == "null"
//                                       ? Container()
//                                       : GestureDetector(
//                                     onTap: () {
//                                       showDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (BuildContext
//                                         context) {
//                                           return WillPopScope(
//                                               onWillPop:
//                                                   () async =>
//                                               true,
//                                               child: Stack(
//                                                 clipBehavior:
//                                                 Clip.none,
//                                                 children: [
//                                                   AlertDialog(
//
//                                                     content:
//                                                     new SingleChildScrollView(
//                                                       child:
//                                                       Container(
//                                                         height:
//                                                         250,
//                                                         width:
//                                                         250,
//                                                         child:
//                                                         InteractiveViewer(
//                                                           child: Image.network(
//                                                             "${get_data['attachment'].toString()}",
//
//                                                           ),
//                                                           maxScale: 5.0,
//                                                         ),
//                                                         // PhotoView(
//                                                         //   imageProvider:
//                                                         //   NetworkImage("${get_data['attachment'].toString()}"),
//                                                         // ),
//                                                       ),
//                                                     ),
//                                                     // actions: <Widget>[
//                                                     //   ElevatedButton(
//                                                     //     child: const Text(
//                                                     //       'Close',
//                                                     //     ),
//                                                     //     style: ElevatedButton.styleFrom(
//                                                     //       minimumSize: const Size(0, 45),
//                                                     //       primary: Colors.amber,
//                                                     //       onPrimary: const Color(0xFFFFFFFF),
//                                                     //       shape: RoundedRectangleBorder(
//                                                     //         borderRadius: BorderRadius.circular(8),
//                                                     //       ),
//                                                     //     ),
//                                                     //     onPressed: () {
//                                                     //       Get.back();
//                                                     //     },
//                                                     //   ),
//                                                     // ],
//                                                   ),
//                                                   Positioned(
//                                                       top: 199,
//                                                       right: 50,
//                                                       child: GestureDetector(
//                                                           onTap: () {
//
//                                                             Get.back();
//                                                           },
//                                                           child: Icon(
//                                                             Icons
//                                                                 .cancel,
//                                                             color:
//                                                             primary,
//                                                           )))
//                                                 ],
//                                               ));
//                                         },
//                                       );
//
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(top: 10,left: 10,right: 10),
//                                       padding: EdgeInsets.all( 5),
//                                       // color: primary,
//                                       alignment: Alignment.topCenter,
//                                       width: MediaQuery.of(context).size.width,
//
//
//                                       height: 250,
//                                       child: Image.network(get_data['attachment'].toString(),
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Container(
//                                             color: Colors.grey.shade300,
//                                             alignment: Alignment.center,
//                                             child: Icon(Icons.broken_image_outlined,size: 50,
//                                               color: Colors.grey.shade500,),
//                                           );
//                                         },),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   ListView.builder(
//                                     itemCount: get_data['examQuestionObjects'].length,
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.all(2.0),
//                                     physics: NeverScrollableScrollPhysics(),
//                                     itemBuilder:(BuildContext context, int indexs) {
//                                       final optionIndex = String.fromCharCode(97 + indexs);
//                                       final optionText =get_data['examQuestionObjects'][indexs];
//                                       bool isSelectedOption = isSelected[indexs];
//                                       print("optionText...."+index.toString());
//                                       log("optionText...."+examController.ontap_answer[index].toString());
//
//                                       return GestureDetector(
//                                         onTap: () async {
//                                           examController.callindex(index,indexs);
//                                           examController.UpdateExamAnswerData((quecounter),optionText['option_id']);
//                                           if(examController.get_que_list.length>quecounter){
//                                             selectedIndex = indexs;
//                                             print("if index  ....."+selectedIndex.toString());
//
//                                             print("selected index ....."+selectedIndex.toString());
//
//                                             setState((){});
//                                           }
//                                           else{
//                                             selectedIndex = indexs;
//                                             print("else index  ....."+selectedIndex.toString());
//
//                                           }
//
//
//                                         },
//                                         child: Card(
//                                           margin: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(10)),
//                                           elevation: 3,
//                                           child: Container(
//                                             // margin: EdgeInsets.symmetric(vertical: 2),
//                                             padding: EdgeInsets.all(10),
//                                             decoration: BoxDecoration(
//                                                 color:get_data['is_attempt']==1?get_data['your_answer'].toString() == optionText['option_id'].toString()?Colors.blue.shade100:white:white,
//                                                 borderRadius:
//                                                 BorderRadius.circular(8),
//                                                 border: Border.fromBorderSide(
//                                                     BorderSide(color: Colors.grey.shade300))
//                                             ),
//
//                                             child: Row(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                               children: [
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                       color: isSelectedOption
//                                                           ? white
//                                                           : primary,
//                                                       borderRadius:
//                                                       BorderRadius.circular(
//                                                           30)),
//                                                   child: Padding(
//                                                     padding:
//                                                     EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                                     child: Text(
//                                                       optionIndex.toUpperCase(),
//                                                       style: TextStyle(
//                                                         fontSize: 19,
//                                                         fontWeight:
//                                                         FontWeight.w400,
//                                                         fontFamily:
//                                                         'Poppins-Regular',
//                                                         //  color red krna h agar answer galat ho
//                                                         color: white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 8),
//
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//
//                                                     optionText['objective'].toString()=="null"?Container():
//                                                     Container(
//                                                       width: MediaQuery.of(context).size.width-120,
//                                                       child: Text(
//                                                         "${optionText['objective'].toString()=="null"?"":
//                                                         optionText['objective'].toString()}",
//                                                         style: TextStyle(
//                                                             fontSize: 15,
//                                                             fontWeight: FontWeight.w600,
//                                                             fontFamily: 'PublicSans',
//                                                             color: isSelectedOption
//                                                                 ? black54
//                                                                 : black54,
//                                                             letterSpacing: 0.5
//                                                         ),
//                                                       ),
//                                                     ),
//
//                                                     optionText['attachment'].toString()== "null"?Container()
//                                                         : GestureDetector(
//                                                       onTap: () {
//                                                         showDialog(
//                                                           barrierDismissible: false,
//                                                           context: context,
//                                                           builder: (BuildContext
//                                                           context) {
//                                                             return WillPopScope(
//                                                                 onWillPop:
//                                                                     () async =>
//                                                                 true,
//                                                                 child: Stack(
//                                                                   clipBehavior:
//                                                                   Clip.none,
//                                                                   children: [
//                                                                     AlertDialog(
//
//                                                                       content:
//                                                                       new SingleChildScrollView(
//                                                                         child:
//                                                                         Container(
//                                                                           height:
//                                                                           250,
//                                                                           width:
//                                                                           250,
//                                                                           child:
//                                                                           InteractiveViewer(
//                                                                             child: Image.network(
//                                                                               "${optionText['attachment'].toString()}",
//
//                                                                             ),
//                                                                             maxScale: 5.0,
//                                                                           ),
//                                                                           // PhotoView(
//                                                                           //   imageProvider:
//                                                                           //   NetworkImage("${optionText['attachment'].toString()}"),
//                                                                           // ),
//                                                                         ),
//                                                                       ),
//                                                                       // actions: <Widget>[
//                                                                       //   ElevatedButton(
//                                                                       //     child: const Text(
//                                                                       //       'Close',
//                                                                       //     ),
//                                                                       //     style: ElevatedButton.styleFrom(
//                                                                       //       minimumSize: const Size(0, 45),
//                                                                       //       primary: Colors.amber,
//                                                                       //       onPrimary: const Color(0xFFFFFFFF),
//                                                                       //       shape: RoundedRectangleBorder(
//                                                                       //         borderRadius: BorderRadius.circular(8),
//                                                                       //       ),
//                                                                       //     ),
//                                                                       //     onPressed: () {
//                                                                       //       Get.back();
//                                                                       //     },
//                                                                       //   ),
//                                                                       // ],
//                                                                     ),
//                                                                     Positioned(
//                                                                         top: 199,
//                                                                         right: 50,
//                                                                         child: GestureDetector(
//                                                                             onTap: () {
//
//                                                                               Get.back();
//                                                                             },
//                                                                             child: Icon(
//                                                                               Icons
//                                                                                   .cancel,
//                                                                               color:
//                                                                               primary,
//                                                                             )))
//                                                                   ],
//                                                                 ));
//                                                           },
//                                                         );
//
//                                                       },
//                                                       child: Container(
//                                                         // color: primary,
//                                                         margin: EdgeInsets.only(top: 10),
//                                                         alignment: Alignment.topLeft,
//                                                         width: MediaQuery.of(context).size.width*0.3,
//                                                         height: MediaQuery.of(context).size.height*0.1,
//                                                         child: Image.network(optionText['attachment'].toString(),
//                                                           errorBuilder: (context, error, stackTrace) {
//                                                             return Container(
//                                                               color: Colors.grey.shade300,
//                                                               alignment: Alignment.center,
//                                                               child: Icon(Icons.broken_image_outlined,size: 50,
//                                                                 color: Colors.grey.shade500,),
//                                                             );
//                                                           },),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(6.0),
//                                     child: Divider(
//                                       color: Colors.grey[350],
//                                       thickness: 1.5,
//                                     ),
//                                   ),
//
//                                   // Row(
//                                   //   mainAxisAlignment: MainAxisAlignment.center,
//                                   //   children: [
//                                   //     examController.ontap_answer[index]==true?  GestureDetector(
//                                   //       onTap: () async{
//                                   //         print("qr: "+quecounter.toString());
//                                   //         // print("qr: "+(quecounter>1).toString());
//                                   //         if((quecounter>1)==true){
//                                   //           quecounter = quecounter - 1;
//                                   //         // log("qr: "+examController.get_que_list[quecounter]['your_answer'].toString());
//                                   //           // examController.callagainindex(index);
//                                   //           setState(()  {
//                                   //           });
//                                   //         }
//                                   //         else{
//                                   //
//                                   //           toastMsg("No Previous Question Left", true);
//                                   //           /* toastMsg("No Question Left", true);*/
//                                   //         }
//                                   //
//                                   //
//                                   //       },
//                                   //       child: Container(
//                                   //         alignment: Alignment.center,
//                                   //         width: size.width * 0.3,
//                                   //         height: size.height * 0.05,
//                                   //         margin: EdgeInsets.only(bottom: 20, top: 20),
//                                   //         decoration: BoxDecoration(
//                                   //             borderRadius: BorderRadius.circular(4),
//                                   //             color: primary),
//                                   //         child: Text(
//                                   //           "Previous" ,
//                                   //           style: TextStyle(
//                                   //             fontSize: 19,
//                                   //             fontWeight: FontWeight.w500,
//                                   //             fontFamily: 'Poppins-Regular',
//                                   //             color: white,
//                                   //           ),
//                                   //         ),
//                                   //       ),
//                                   //     ):Container(),
//                                   //     examController.ontap_answer[index]==true? SizedBox(
//                                   //       width: 20,
//                                   //     ):Container(),
//                                   //     GestureDetector(
//                                   //       onTap: () async{
//                                   //         log("data>> index: "+index.toString());
//                                   //         log("data>> onlist: "+examController. ontap_answer[index].toString());
//                                   //         if(examController.ontap_answer[index]==true){
//                                   //           if(examController.get_que_list.length>quecounter){
//                                   //             quecounter = quecounter + 1;
//                                   //             examController.callagainindex(index);
//                                   //             setState(()  {
//                                   //             });
//                                   //           }else{
//                                   //
//                                   //             var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
//                                   //             var examBody = {'question_id': qid.toString(), 'answer_id': ansid.toString(),};
//                                   //             print("examBody...."+examBody.toString());
//                                   //             await examController.ExamAnswerData(examansUrl, examBody);
//                                   //             setState((){});
//                                   //             Navigator.pushReplacement(context,
//                                   //                 MaterialPageRoute(
//                                   //                     builder: (context) => ExamReviewPage(exam_Ids:id,
//                                   //                         pageId:2)));
//                                   //             /* toastMsg("No Question Left", true);*/
//                                   //           }
//                                   //
//                                   //         }
//                                   //         else{
//                                   //           var qid =get_data['id'];
//                                   //           var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
//                                   //           var examBody = {
//                                   //             'question_id': qid.toString(),
//                                   //           };
//                                   //           print("examBody skip...."+examBody.toString());
//                                   //           await examController.ExamAnswerData(examansUrl, examBody);
//                                   //
//                                   //           if (examController.get_que_list.length > quecounter) {
//                                   //             quecounter = quecounter + 1;
//                                   //             print("quecounter after update......"+quecounter.toString());
//                                   //             // examController.get_que_list[quecounter];
//                                   //
//                                   //             setState(()  {
//                                   //             });
//                                   //
//                                   //             // getQuestion(false);
//                                   //           } else {
//                                   //             var qid =get_data['id'];
//                                   //             var  examansUrl = apiUrls().exam_ans_attempt_api+id.toString();
//                                   //             var examBody = {
//                                   //               'question_id': qid.toString(),
//                                   //             };
//                                   //             print("examansUrl...."+examansUrl.toString());
//                                   //             print("examBody...."+examBody.toString());
//                                   //             await examController.ExamAnswerData(examansUrl, examBody);
//                                   //             Navigator.pushReplacement(
//                                   //                 context,
//                                   //                 MaterialPageRoute(
//                                   //                     builder: (context) => ExamReviewPage(exam_Ids:id,
//                                   //                         pageId:2)));
//                                   //             // toastMsg("No Question Left", true);
//                                   //             // quecounter = quecounter - 1;
//                                   //             // examController.get_que_list[quecounter];
//                                   //             // Navigator.push(context,
//                                   //             //     MaterialPageRoute(builder: (context) => ReviewPage(skip:true)));
//                                   //           }
//                                   //
//                                   //         }
//                                   //
//                                   //
//                                   //       },
//                                   //       child: Container(
//                                   //         alignment: Alignment.center,
//                                   //         width: examController.ontap_answer[index]==true?size.width*0.3:size.width * 0.6,
//                                   //         height: size.height * 0.05,
//                                   //         margin: EdgeInsets.only(bottom: 20, top: 20),
//                                   //         decoration: BoxDecoration(
//                                   //             borderRadius: BorderRadius.circular(4),
//                                   //             color: primary),
//                                   //         child: Text(
//                                   //           examController. ontap_answer[index]==true?"Next":  "Skip",
//                                   //           style: TextStyle(
//                                   //             fontSize: 19,
//                                   //             fontWeight: FontWeight.w500,
//                                   //             fontFamily: 'Poppins-Regular',
//                                   //             color: white,
//                                   //           ),
//                                   //         ),
//                                   //       ),
//                                   //     ),
//                                   //
//                                   //   ],
//                                   // ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//
//                         Container(
//                           margin: EdgeInsets.only(bottom: 20),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 15.0,right: 15.0),
//                             child: Row(
//                               mainAxisAlignment: examController.ontap_answer[examController.count.value]==true?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
//                               children: [
//                                 examController.ontap_answer[examController.count.value]==true?  GestureDetector(
//                                   onTap: () async{
//                                     print("qr: "+quecounter.toString());
//                                     // print("qr: "+(quecounter>1).toString());
//                                     if((quecounter>0)==true){
//                                       quecounter = quecounter - 1;
//
//                                       setState(()  {
//                                       });
//                                     }
//                                     else{
//
//                                       toastMsg("No Previous Question Left", true);
//                                       /* toastMsg("No Question Left", true);*/
//                                     }
//
//
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     width: size.width * 0.4,
//                                     height: size.height * 0.05,
//                                     margin: EdgeInsets.only(bottom: 20, top: 20),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(4),
//                                         color: primary),
//                                     child: Text(
//                                       "Previous" ,
//                                       style: TextStyle(
//                                         fontSize: 19,
//                                         fontWeight: FontWeight.w500,
//                                         fontFamily: 'Poppins-Regular',
//                                         color: white,
//                                       ),
//                                     ),
//                                   ),
//                                 ):Container(),
//                                 examController.ontap_answer[examController.count.value]==true?
//                                 SizedBox(
//                                   width: 20,
//                                 ):Container(),
//                                 GestureDetector(
//                                   onTap: () async{
//
//                                     if(examController.ontap_answer[examController.count.value]==true){
//                                       if(examController.get_que_list.length>quecounter){
//                                         quecounter = quecounter + 1;
//                                         examController.callagainindex(examController.count.value);
//                                         setState(()  {
//                                         });
//                                       }else{
//
//                                         var  examansUrl = apiUrls().Copy_exam_ans_attempt_api+id.toString();
//                                         var examBody = jsonEncode({
//                                           'answer_data': examController.Copy_get_que_list
//                                         });
//                                         log("examBody skip...."+examBody.toString());
//                                         await examController.ExamAnswerData(examansUrl, examBody);
//
//                                         setState((){});
//                                         Navigator.pushReplacement(context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => ExamReviewPage(exam_Ids:id,
//                                                     pageId:2)));
//                                         /* toastMsg("No Question Left", true);*/
//                                       }
//
//                                     }
//                                     else{
//
//
//                                       if (examController.get_que_list.length > quecounter) {
//                                         quecounter = quecounter + 1;
//                                         print("quecounter after update......"+quecounter.toString());
//                                         // examController.get_que_list[quecounter];
//
//                                         setState(()  {
//                                         });
//
//
//                                       } else {
//                                         var  examansUrl = apiUrls().Copy_exam_ans_attempt_api+id.toString();
//                                         var examBody = jsonEncode({
//                                           'answer_data': examController.Copy_get_que_list
//                                         });
//                                         log("examBody skip...."+examBody.toString());
//                                         await examController.ExamAnswerData(examansUrl, examBody);
//
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => ExamReviewPage(exam_Ids:id,
//                                                     pageId:2)));
//
//                                       }
//
//                                     }
//
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     width: examController.ontap_answer[examController.count.value]==true?size.width*0.4:size.width * 0.6,
//                                     height: size.height * 0.05,
//                                     margin: EdgeInsets.only(bottom: 20, top: 20),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(4),
//                                         color: primary),
//                                     child: Text(
//                                       examController. ontap_answer[examController.count.value]==true?"Next":  "Skip",
//                                       style: TextStyle(
//                                         fontSize: 19,
//                                         fontWeight: FontWeight.w500,
//                                         fontFamily: 'Poppins-Regular',
//                                         color: white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     Positioned(
//                       top: 60,
//                       right: 10,
//                       child: Row(
//                         children: [
//                           Icon(Icons.watch_later_outlined,color: Colors.black,size: 18,),
//                           SizedBox(width: 5,),
//                           statusMinSec == false ?TweenAnimationBuilder<Duration>(
//                               duration: Duration(seconds: timevalueInMin),
//                               tween: Tween(begin: Duration(seconds: timevalueInMin), end: Duration.zero),
//                               onEnd: () {
//                                 print('Timer ended');
//                               },
//                               builder: (BuildContext context, Duration value, Widget child) {
//                                 final hour = value.inHours;
//                                 final minutes = value.inMinutes%60;
//                                 final seconds = value.inSeconds % 60;
//                                 String hoursStr = hour.toString().padLeft(2, '0');
//                                 String minutesStr = minutes.toString().padLeft(2, '0');
//                                 String secondsStr = seconds.toString().padLeft(2, '0');
//                                 print("hoursStr......${hoursStr}");
//                                 print("minutesStr......${minutesStr}");
//                                 print("secondsStr......"+secondsStr.toString());
//                                 return Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 5),
//                                     child: Text('${hoursStr}:$minutesStr:$secondsStr',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15)));
//
//                               }):
//                           TweenAnimationBuilder<Duration>(
//                               duration: Duration(minutes: timevalueInMin),
//                               tween: Tween(begin: Duration(minutes: timevalueInMin), end: Duration.zero),
//                               onEnd: () async {
//                                 print('Timer ended');
//                                 var  examansUrl = apiUrls().Copy_exam_ans_attempt_api+id.toString();
//                                 var examBody = jsonEncode({
//                                   'answer_data': examController.Copy_get_que_list
//                                 });
//                                 log("examBody skip...."+examBody.toString());
//                                 await examController.ExamAnswerData(examansUrl, examBody);
//                                 Navigator.pushReplacement(context,
//                                     MaterialPageRoute(
//                                         builder: (context) => ExamReviewPage(exam_Ids:id,
//                                             pageId:2)));
//                                 // percentagess=0.0;
//                               },
//                               builder: (BuildContext context, Duration value, Widget child) {
//
//
//                                 final hour = value.inHours;
//                                 final minutes = value.inMinutes%60;
//                                 final seconds = value.inSeconds % 60;
//                                 String hoursStr = hour.toString().padLeft(2, '0');
//                                 String minutesStr = minutes.toString().padLeft(2, '0');
//                                 String secondsStr = seconds.toString().padLeft(2, '0');
//                                 return Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 5),
//                                     child: Text('$hoursStr:$minutesStr:$secondsStr',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15)));
//                               }),
//                           // Padding(
//                           //     padding: const EdgeInsets.symmetric(vertical: 5),
//                           //     child: Text('$formattedTime',
//                           //         textAlign: TextAlign.center,
//                           //         style: TextStyle(
//                           //             color: Colors.black,
//                           //             fontWeight: FontWeight.bold,
//                           //             fontSize: 15)))
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       top: 60,
//                       left: 10,
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return Dialog(
//                                       shape:
//                                       RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                       child: Container(
//                                         height: 250,
//                                         width: 300,
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(16.0),
//                                               child: Text(
//                                                 'Are you sure you want to submit the test?',
//                                                 maxLines: 2,
//                                                 softWrap: true,
//                                                 textAlign: TextAlign.center,
//
//                                                 style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w700,
//                                                   fontFamily: 'PublicSans',
//                                                   color: Colors.black87,
//                                                   letterSpacing: 0.5,
//                                                   height: 1.3,
//
//                                                 ),
//
//                                               ),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                               child: Container(
//                                                   decoration: BoxDecoration(
//                                                       color: primary,
//                                                       borderRadius: BorderRadius.circular(8)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(
//                                                         horizontal: 20, vertical: 12),
//                                                     child: Text(
//                                                       'No, let me continue',
//                                                       style: TextStyle(
//                                                         color: white,
//                                                         fontSize: 17,
//                                                         fontWeight: FontWeight.w700,
//                                                         fontFamily: 'PublicSans',
//                                                         letterSpacing: 0.5,
//
//                                                       ),
//                                                     ),
//                                                   )),
//                                             ),
//                                             TextButton(
//                                                 onPressed: () async {
//                                                   var  examansUrl = apiUrls().Copy_exam_ans_attempt_api+id.toString();
//                                                   var examBody = jsonEncode({
//                                                     'answer_data': examController.Copy_get_que_list
//                                                   });
//                                                   log("examBody skip...."+examBody.toString());
//                                                   await examController.ExamAnswerData(examansUrl, examBody);
//                                                   setState(() {
//
//                                                   });
//                                                   var exitexamUrl = "${apiUrls().exit_exam_api}" "${id}";
//                                                   print("exitexamUrl.... "+exitexamUrl.toString());
//
//                                                   await examController.Exit_Exam_Data(exitexamUrl);
//                                                 },
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(12.0),
//                                                   child: Text(
//                                                     'OK',
//                                                     style: TextStyle(
//                                                       fontSize: 18,
//                                                       fontWeight: FontWeight.w700,
//                                                       fontFamily: 'PublicSans',
//                                                       letterSpacing: 0.6,
//                                                     ),
//                                                   ),
//                                                 )),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   });
//                               // Navigator.pushReplacement(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) => BottomBar(
//                               //         bottomindex: 2,
//                               //       )),
//                               // );
//                             },
//                             child: Icon(Icons.arrow_back_ios, color: Colors.black54),
//                           )
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//         ),
//       ),
//     );
//   }
// }
// String formatDuration(Duration duration) {
//   int hours = duration.inHours;
//   int minutes = duration.inMinutes % 60;
//   int seconds = duration.inSeconds % 60;
//
//   String hoursStr = hours.toString().padLeft(2, '0');
//   String minutesStr = minutes.toString().padLeft(2, '0');
//   String secondsStr = seconds.toString().padLeft(2, '0');
//
//   return '$hoursStr:$minutesStr:$secondsStr';
// }