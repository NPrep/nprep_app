import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pinput/pinput.dart';

import 'review.dart';

class QuestionMcq extends StatefulWidget {
  bool timer;

  var examId;
  var checkstatus;
  var reattempt;
  var counterindex;

  QuestionMcq(
      {Key key,
      this.timer,
      this.examId,
      this.reattempt,
      this.counterindex,
      this.checkstatus});

  @override
  State<QuestionMcq> createState() => _QuestionMcqState();
}

class _QuestionMcqState extends State<QuestionMcq>
    with TickerProviderStateMixin {
  CategoryController categoryController = Get.put(CategoryController());

  SettingController settingController = Get.put(SettingController());

  List<bool> isSelected = List.generate(4, (_) => false);
  bool startt = true;
  List<String> options = [
    'Pneumonia is an infection of the',
    'Pneumonia is an infection of the',
    'Pneumonia is an infection of the',
    'Pneumonia is an infection of the',
    // ... Add more options ...
  ];
  int tappedIndex = -1;
  int questions_No = 30; // default no. of question isse apiu se connect krna h
  bool showExplanation = false;

  var newcounter = 1;

  List<Widget> icons;
  var get_questionUrl;
  var _timerno = 10000;
  get timerno => _timerno;

  var examID;

  var Q_time_interval;

  double _percent = 0.0;
  // Timer timer;

  // startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() async {
  //       if (timeInMinutes > 0) {
  //         timeInMinutes--;
  //         print("timeInMinutes...${timeInMinutes} ");
  //       } else if (timeInMinutes < 1) {
  //         timeInMinutes++;
  //
  //         print("timeInMinutes ++...${timeInMinutes} ");
  //       } else {
  //         // gotoNextQuestion();
  //         timer.cancel();
  //
  //         startTimer();
  //         print("else wali ");
  //         var attemptQUrl = apiUrls().attempt_question_api;
  //         var attemptQBody = {
  //           'exam_id': examID.toString(),
  //           // 'question_id': question_ID.toString(),
  //           // 'answer_id': "null"
  //         };
  //         print("attemptQUrl....." + attemptQUrl.toString());
  //         print("attemptQBody....." + attemptQBody.toString());
  //         // await categoryController.AttemptQuestionApi(attemptQUrl, attemptQBody);
  //         // Get.find<CategoryController>().GetQuestionApi(get_questionUrl, false,false);
  //         // quecounter = quecounter + 1;
  //       }
  //     });
  //   });
  // }

  AnimationController controllernew;

  var timeInMilisecondes;
  var timeInMinutes;
  var timeMilisecond;

  @override
  void dispose() {
    controllernew.dispose();
    super.dispose();
  }

  @override
  void initState() {
    log('Dataa==>');
    controllernew = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    // controllernew.reset();
    super.initState();

    if (widget.reattempt.toString() == "1") {
      categoryController.quecounter.value = 1;
      print("exam id for examId if  ....." + categoryController.quecounter.value.toString());
      getReattemotApiCall();
    } else {
      print("exam id for examId else  .....");
      getdata();
    }
  }



  getdata() async {
    await getQuestion(true);
    categoryController.examid.value = int.parse(widget.examId);
    categoryController.quecounter.value = widget.counterindex;
    categoryController.animationStops();
    print("quecounter on start -> " + categoryController.quecounter.value.toString());

    icons = List.generate(30, (index) {
      return Icon(
        Icons.circle,
        size: 11,
        color: Colors.grey,
      ); // Replace this with your circle icon widget
    });
  }

  getQuestion(status) async {
    Map<String, String> queryParams = {
      'exam_id': widget.examId.toString(),
      'exam_status': widget.reattempt.toString() == "1"
          ? widget.reattempt.toString()
          : widget.checkstatus.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    get_questionUrl = apiUrls().get_question_api + '?' + queryString;
    print("get_questionUrl...." + get_questionUrl.toString());

    await categoryController.GetQuestionApi(get_questionUrl, status, false);
  }

  var get_reattemotUrl;

  getReattemotApiCall() async {
    categoryController.examid.value = int.parse(widget.examId);
    categoryController.quecounter.value = 1;
    categoryController.animationStops();
    Map<String, String> queryParams = {
      'exam_id': categoryController.checkexamid.toString(),
      'exam_status': 1.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    get_reattemotUrl = apiUrls().get_question_api + '?' + queryString;
    print("get_reattemotUrl...." + get_reattemotUrl.toString());

    await categoryController.GetQuestionApi(get_reattemotUrl, true, false);

    icons = List.generate(30, (index) {
      return Icon(
        Icons.circle,
        size: 11,
        color: Colors.grey,
      ); // Replace this with your circle icon widget
    });
  }

  void quit_exam() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      'Are you sure you want to  exit the MCQ session?',
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
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PublicSans',
                            letterSpacing: 0.6,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  bool animationEnd = false;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // Size size = Me
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BottomBar(
        //             bottomindex: 1,
        //           )),
        // );
        quit_exam();
        return false;
      },
      child: Scaffold(
        body: GetBuilder<CategoryController>(builder: (getQuestionContro) {
          if (getQuestionContro.getQLoader.value) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: getQuestionContro.getQuestionList.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          height: 800,
                          alignment: Alignment.center,
                          child: Text(
                              "${getQuestionContro.decode['message'].toString()}"))
                    ],
                  )
                : Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 10),
                              child: Image.asset(
                                logo,
                                scale: 3.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // AnimatedBuilder(
                      //     animation: _animation,
                      //     builder: (context, child) {
                      //     return ;
                      //   }
                      // ),
                      // LinearPercentIndicator(
                      //   width: MediaQuery.of(context).size.width,
                      //   lineHeight: 20.0,
                      //   padding: EdgeInsets.zero,
                      //   percent: getQuestionContro.controller.value,
                      //   center: Text("${(getQuestionContro.controller.value * 100).toStringAsFixed(0)}%"),
                      //   backgroundColor: Colors.grey,
                      //   animation: true,
                      //   progressColor: primary,
                      //   // addAutomaticKeepAlive: true,
                      //   // addAutomaticKeepAlive: true,
                      //   isRTL: true,
                      //   animationDuration: 10000,
                      //   restartAnimation: false,
                      //
                      // ),

                      // CircularProgressIndicator(
                      //   value: getQuestionContro.progressValue,
                      //   backgroundColor: Colors.grey[200],
                      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      // ),
                      // SizedBox(height: 20),
                      // Text(
                      //   '${(getQuestionContro.progressValue ).toStringAsFixed(2)}%',
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      // SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: getQuestionContro.progressValue,
                        backgroundColor: Colors.grey[400],

                        valueColor: AlwaysStoppedAnimation<Color>(primary),),
                      // LinearProgressIndicator(
                      //   value: controllernew.value,
                      //   semanticsLabel: 'Linear progress indicator',
                      // ),
                      // LinearProgressIndicator(
                      //   value: getQuestionContro.progressValue,
                      //   backgroundColor: primary,
                      //   valueColor:
                      //       AlwaysStoppedAnimation<Color>(Colors.grey[400]),
                      // ),
                      // GestureDetector(
                      //     onTap: () {
                      //       getQuestionContro.controllertimerstart();
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Text("Start"),
                      //     )),
                      // GestureDetector(
                      //     onTap: () {
                      //       getQuestionContro.controllertimerstop();
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Text("Stop"),
                      //     )),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: quit_exam,
                              child: Icon(
                                Icons.close,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // THIS GRID VIEW FOR SUBMITTED ANSWER  DOTS HERE =====>

                      Container(
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // scrollDirection: Axis.vertical,
                          itemCount: getQuestionContro.getQuestionList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 3,
                            crossAxisCount: 24,
                            crossAxisSpacing: 4,
                            childAspectRatio:
                                MediaQuery.of(context).size.height / 900,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item_list =
                                getQuestionContro.getQuestionList[index];
                            // print("item_list...."+item_list.toString());
                            return Container(
                              // height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item_list['is_attempt'] == 0
                                    ? Colors.grey
                                    : item_list['attempt_test_questions'][0]
                                                ['currect_answer'] ==
                                            item_list['attempt_test_questions']
                                                [0]['your_answer']
                                        ? ansBackgroundColor
                                        : item_list['attempt_test_questions'][0]
                                                    ['is_answer'] ==
                                                3
                                            ? redBackgroundColor
                                            : redBackgroundColor,
                              ),
                              // child: item_list
                            );
                          },
                        ),
                      ),

                      ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var get_data =
                              getQuestionContro.getQuestionList[categoryController.quecounter.value - 1];

                          return get_data['is_attempt'] == 0
                              ? Column(
                                  children: [
                                    get_data['question'].toString() == "null"
                                        ? Container()
                                        : Padding(
                                            padding: EdgeInsets.only(left: 17.0, bottom: 8,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Q.${categoryController.quecounter.value})",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  // color: primary,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70,
                                                  child: Text(
                                                      '${get_data['question'].toString() == "null" ? "" : get_data['question'].toString()}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'PublicSans',
                                                        color: black54,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(height: 10),
                                    get_data['attachment'].toString() == "null"
                                        ? Container()
                                        : Image.network(
                                            "${get_data['attachment'].toString()}"),

                                    // getQuestionContro.getTapLoader==true?
                                    // Center(child: CircularProgressIndicator()):
                                    ListView.builder(
                                      itemCount:
                                          get_data['questionObjects'].length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int indexs) {
                                        final optionIndex = String.fromCharCode(97 +
                                            indexs); // Convert index to 'a', 'b', 'c', ...
                                        final optionText = get_data[
                                                'questionObjects'][
                                            indexs]; // Replace 'options[index]' with your actual options
                                        bool isSelectedOption =
                                            isSelected[indexs];
                                        return GestureDetector(
                                          onTap: () async {
                                            // UniqueKey();
                                            print("QuestionList.length -> " +
                                                getQuestionContro
                                                    .getQuestionList.length
                                                    .toString());
                                            print(
                                                "QuestionList quecounter -> " +
                                                    categoryController.quecounter.value.toString());
                                            var attemptQUrl =
                                                apiUrls().attempt_question_api;
                                            print(" question ID -> " +
                                                get_data['id'].toString());
                                            print(" question ExamID -> " +
                                                widget.examId.toString());
                                            print("Next question -> " +
                                                categoryController.quecounter.value.toString());
                                            getQuestionContro.controllertimerstop();
                                            var attemptQBody = {
                                              'exam_id':
                                                  widget.examId.toString(),
                                              'question_id':
                                                  get_data['id'].toString(),
                                              'answer_id':
                                                  optionText['option_id']
                                                      .toString(),
                                            };
                                            print("ontap_attemp_Url....." +
                                                attemptQUrl.toString());
                                            print("ontap_attemp_Body....." +
                                                attemptQBody.toString());
                                            await getQuestionContro
                                                .AttemptQuestionApi(
                                                    attemptQUrl, attemptQBody);
                                            Map<String, String> queryParams = {
                                              'exam_id':
                                                  widget.examId.toString(),
                                              'exam_status': "2",
                                            };
                                            String queryString = Uri(queryParameters:queryParams).query;
                                            get_questionUrl =
                                                apiUrls().get_question_api +
                                                    '?' +
                                                    queryString;
                                            print("get_questionUrl...." +
                                                get_questionUrl.toString());

                                            categoryController.GetQuestionApi(
                                                get_questionUrl, false, false);
                                            UniqueKey();
                                            setState(() {});
                                            if(tappedIndex == index){
                                              HapticFeedback.vibrate();
                                            }
                                            // var examID = getQuestionContro.checkexamid.toString();
                                            // var question_ID = get_data['id'].toString();
                                            // var answer_ID = optionText['option_id'].toString();
                                            // // print("examID....." + examID.toString());
                                            // // print("question_ID....." + question_ID.toString());
                                            // // print("answer_ID....." + answer_ID.toString());
                                            // var attemptQUrl = apiUrls().attempt_question_api;
                                            // var attemptQBody = {
                                            //   'exam_id': examID.toString(),
                                            //   'question_id': question_ID.toString(),
                                            //   'answer_id': answer_ID.toString()
                                            // };
                                            // print("attemptQUrl....." + attemptQUrl.toString());
                                            // print("attemptQBody....." + attemptQBody.toString());
                                            // await getQuestionContro.AttemptQuestionApi(attemptQUrl, attemptQBody);
                                            //  Get.find<CategoryController>().GetQuestionApi(get_questionUrl, false,false);
                                          },
                                          child: Card(

                                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            elevation: 3,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 0),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(color: isSelectedOption
                                                      ? ansBackgroundColor
                                                      : (tappedIndex == index
                                                          ? redBackgroundColor
                                                          : Colors.white),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.fromBorderSide(
                                                      BorderSide(
                                                          color: Colors.grey.shade300))),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: isSelectedOption
                                                            ? white
                                                            : primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      child: Text(
                                                        optionIndex
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Poppins-Regular',

                                                          //  color red krna h agar answer galat ho
                                                          color: isSelectedOption
                                                              ? ansBackgroundColor
                                                              : white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  optionText['objective'].toString() == "null"
                                                      ? Container()
                                                      : Container(
                                                          width: MediaQuery.of(context).size.width -120,
                                                          child: Text(
                                                            optionText[
                                                                    'objective']
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'PublicSans',
                                                              color:
                                                                  isSelectedOption
                                                                      ? black54
                                                                      : black54,
                                                            ),
                                                          ),
                                                        ),
                                                  optionText['attachment']
                                                              .toString() ==
                                                          "null"
                                                      ? Container()
                                                      : Container(
                                                          margin:EdgeInsets.only(
                                                                  top: 10),
                                                          alignment:Alignment.topLeft,
                                                          width: MediaQuery.of( context).size .width *0.3,
                                                          height: MediaQuery.of(context).size.height *0.1,
                                                          child: Image.network(
                                                            optionText[
                                                                    'attachment']
                                                                .toString(),
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Container(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons
                                                                      .hide_image_outlined,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // UniqueKey();
                                        print("QuestionList.length -> " +
                                            getQuestionContro
                                                .getQuestionList.length
                                                .toString());
                                        print("QuestionList quecounter -> " +
                                            categoryController.quecounter.value.toString());
                                        var attemptQUrl =
                                            apiUrls().attempt_question_api;
                                        if (getQuestionContro.getQuestionList.length >=categoryController.quecounter.value + 1) {
                                          // categoryController.quecounter.value = categoryController.quecounter.value + 1;
                                          print(" question ID -> " +get_data['id'].toString());
                                          print(" question ExamID -> " +widget.examId.toString());
                                          print("Next question -> " + categoryController.quecounter.value.toString());
                                          //
                                          //
                                          categoryController.nextquestion();
                                          // var attemptQBody = {
                                          //   'exam_id': widget.examId.toString(),
                                          //   'question_id':
                                          //       get_data['id'].toString(),
                                          //   // 'answer_id': null
                                          // };
                                          // print("skipattemp_Url....." +
                                          //     attemptQUrl.toString());
                                          // print("skipattemp_Body....." +
                                          //     attemptQBody.toString());
                                          // await getQuestionContro
                                          //     .AttemptQuestionApi(
                                          //         attemptQUrl, attemptQBody);
                                          // Get.find<CategoryController>().GetQuestionApi(get_questionUrl, false,false);

                                          setState(() {});
                                        } else {
                                          print("No More question -> " +
                                              categoryController.quecounter.value.toString());
                                          print(" else question ID -> " +
                                              get_data['id'].toString());
                                          print(" question ExamID -> " +
                                              widget.examId.toString());
                                          var attemptQBody = {
                                            'exam_id': widget.examId.toString(),
                                            'question_id':get_data['id'].toString(),
                                            // 'answer_id': null
                                          };
                                          print("skipattemp_Url....." + attemptQUrl.toString());
                                          print("skipattemp_Body....." + attemptQBody.toString());
                                          await getQuestionContro.AttemptQuestionApi(attemptQUrl, attemptQBody);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        margin: EdgeInsets.only(
                                            bottom: 20, top: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: primary),
                                        child: Text(
                                          "Skip",
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins-Regular',
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0, bottom: 8, top: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Q.${categoryController.quecounter.value})",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: primary,
                                                  fontWeight: FontWeight.w700)),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            // color: primary,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            child: Text(
                                                '${get_data["attempt_test_questions"][0]['question_name'].toString()}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'PublicSans',
                                                  color: black54,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 10),
                                    get_data["attempt_test_questions"][0]
                                                    ['question_attachment']
                                                .toString() ==
                                            "null"
                                        ? Container()
                                        : Image.network(
                                            "${get_data["attempt_test_questions"][0]['question_attachment'].toString()}"),
                                    ListView.builder(
                                      itemCount:
                                          get_data["attempt_test_questions"][0]
                                                  ['object_json']
                                              .length,
                                      // Replace 'options.length' with the actual number of options
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int indexd) {
                                        final optionIndex = String.fromCharCode(97 +
                                            indexd); // Convert index to 'a', 'b', 'c', ...
                                        final optionText = get_data[
                                                    "attempt_test_questions"][0]
                                                ['object_json'][
                                            indexd]; // Replace 'options[index]' with your actual options
                                        bool isSelectedOption =
                                            isSelected[indexd];

                                        // return Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 16, vertical: 2),
                                        //   child: Container(
                                        //     margin: EdgeInsets.symmetric(
                                        //         vertical: 2),
                                        //     padding: EdgeInsets.all(12),
                                        //     decoration: BoxDecoration(
                                        //       color: indexd == get_data["attempt_test_questions"][0]['currect_answer']
                                        //           ? ansBackgroundColor
                                        //           : (indexd != get_data["attempt_test_questions"][0]['currect_answer'] &&
                                        //                   get_data["attempt_test_questions"][0]['your_answer'] == indexd
                                        //               ? redBackgroundColor
                                        //               : Colors.white),
                                        //       // border: Border.all(color: Colors.grey.shade300),
                                        //       borderRadius:
                                        //           BorderRadius.circular(8),
                                        //     ),
                                        //     child: Row(
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment.center,
                                        //       children: [
                                        //         Container(
                                        //           decoration: BoxDecoration(
                                        //               color: isSelectedOption
                                        //                   ? white
                                        //                   : primary,
                                        //               borderRadius:
                                        //                   BorderRadius
                                        //                       .circular(30)),
                                        //           child: Padding(
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                     horizontal: 12,
                                        //                     vertical: 8),
                                        //             child: Text(
                                        //               optionIndex.toUpperCase(),
                                        //               style: TextStyle(
                                        //                 fontSize: 19,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //                 fontFamily: 'Poppins-Regular',
                                        //                 //  color red krna h agar answer galat ho
                                        //                 color: isSelectedOption
                                        //                     ? ansBackgroundColor
                                        //                     : white,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         SizedBox(width: 8),
                                        //         optionText['objective'].toString() == "null"
                                        //             ? Container()
                                        //             : Container(
                                        //                 width: MediaQuery.of(context).size.width - 120,
                                        //                 child: Text(
                                        //                   optionText['objective'].toString(),
                                        //                   style: TextStyle(
                                        //                     fontSize: 15,
                                        //                     fontWeight: FontWeight.w600,
                                        //                     fontFamily: 'Helvetica',
                                        //                     color: isSelectedOption ? black54 : black54,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //         optionText['attachment'].toString() == "null"
                                        //             ? Container()
                                        //             : Container(
                                        //                 margin: EdgeInsets.only(top: 10),
                                        //                 alignment: Alignment.topLeft,
                                        //                 width: MediaQuery.of(context).size.width *
                                        //                     0.3,
                                        //                 height: MediaQuery.of(
                                        //                             context)
                                        //                         .size
                                        //                         .height *
                                        //                     0.1,
                                        //                 child: Image.network(
                                        //                   optionText[
                                        //                           'attachment']
                                        //                       .toString(),
                                        //                   errorBuilder:
                                        //                       (context, error,
                                        //                           stackTrace) {
                                        //                     return Container(
                                        //                       color: Colors
                                        //                           .grey
                                        //                           .shade300,
                                        //                       alignment:
                                        //                           Alignment
                                        //                               .center,
                                        //                       child: Icon(
                                        //                         Icons
                                        //                             .hide_image_outlined,
                                        //                         size: 50,
                                        //                         color: Colors
                                        //                             .grey
                                        //                             .shade500,
                                        //                       ),
                                        //                     );
                                        //                   },
                                        //                 ),
                                        //               ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // );
                                        return Column(
                                          children: [
                                            SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                indexd ==
                                                        get_data["attempt_test_questions"]
                                                                [0]
                                                            ['currect_answer']
                                                    ? Icon(Icons.check,
                                                        color: Colors.green,
                                                        size: 16)
                                                    : (indexd !=
                                                                get_data["attempt_test_questions"]
                                                                        [0][
                                                                    'currect_answer'] &&
                                                            get_data["attempt_test_questions"]
                                                                        [0][
                                                                    'your_answer'] ==
                                                                indexd
                                                        ? Icon(
                                                            Icons.close,
                                                            color:
                                                                redBackgroundColor,
                                                            size: 16,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color: Colors
                                                                .transparent,
                                                            size: 16)),
                                                Text(
                                                  optionIndex.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                    //  color red krna h agar answer galat ho
                                                    color: indexd ==
                                                            get_data["attempt_test_questions"]
                                                                    [0][
                                                                'currect_answer']
                                                        ? Colors.green
                                                        : (indexd !=
                                                                    get_data["attempt_test_questions"]
                                                                            [0][
                                                                        'currect_answer'] &&
                                                                get_data["attempt_test_questions"]
                                                                            [0][
                                                                        'your_answer'] ==
                                                                    indexd
                                                            ? redBackgroundColor
                                                            : Colors.black54),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                optionText['objective']
                                                            .toString() ==
                                                        "null"
                                                    ? Container()
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        // color: primary,
                                                        child: Text(
                                                          optionText[
                                                                  'objective']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'PublicSans',
                                                              color: indexd ==
                                                                      get_data["attempt_test_questions"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          'currect_answer']
                                                                  ? Colors.green
                                                                  : (indexd != get_data["attempt_test_questions"][0]['currect_answer'] &&
                                                                          get_data["attempt_test_questions"][0]['your_answer'] ==
                                                                              indexd
                                                                      ? redBackgroundColor
                                                                      : Colors
                                                                          .black54),
                                                              letterSpacing:
                                                                  0.7),
                                                        ),
                                                      ),
                                                optionText['attachment']
                                                            .toString() ==
                                                        "null"
                                                    ? Container()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        alignment:
                                                            Alignment.topLeft,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        child: Image.network(
                                                          optionText[
                                                                  'attachment']
                                                              .toString(),
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Icon(
                                                                Icons
                                                                    .hide_image_outlined,
                                                                size: 50,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            // SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 2),
                                      child: Column(
                                        children: [
                                          getQuestionContro.getQuestionList[
                                          categoryController.quecounter.value - 1]
                                                          ['ans_description']
                                                      .toString() ==
                                                  "null"
                                              ? Container()
                                              : Html(
                                                  data: getQuestionContro
                                                      .getQuestionList[
                                                  categoryController.quecounter.value - 1]
                                                          ['ans_description']
                                                      .toString(),
                                            style: {
                                              "table": Style( ),
                                              // some other granulr customizations are also possible
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
                                              "td": Style(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.topLeft,
                                              ),
                                            },
                                            customRenders: {
                                              tableMatcher(): tableRender(),
                                            },
                                                ),

                                          // Text(
                                          //   "${getQuestionContro.getQuestionList[quecounter]['ans_description'].toString()}",
                                          //   style: TextStyle(
                                          //     fontSize: 14,
                                          //     fontWeight: FontWeight.w400,
                                          //     fontFamily: 'Helvetica',
                                          //     color: black54,
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          getQuestionContro.getQuestionList[
                                          categoryController.quecounter.value - 1][
                                                          'ans_description_attachment']
                                                      .toString() ==
                                                  "null"
                                              ? Container()
                                              : Image.network(
                                                  getQuestionContro
                                                      .getQuestionList[
                                                  categoryController.quecounter.value - 1][
                                                          'ans_description_attachment']
                                                      .toString(),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        thickness: 1.5,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (getQuestionContro.getQuestionList.length >= categoryController.quecounter.value + 1) {
                                          // var id= getQuestionContro.getQuestionList[quecounter - 1];
                                          // examID = getQuestionContro.checkexamid.toString();
                                          // var question_ID = id['id'];
                                          // var attemptQUrl = apiUrls().attempt_question_api;
                                          // var attemptQBody = {
                                          //   'exam_id': examID.toString(),
                                          //   'question_id': question_ID.toString(),
                                          //   // 'answer_id': "null"
                                          // };
                                          // print("attemptQUrl....." + attemptQUrl.toString());
                                          // print("attemptQBody....." + attemptQBody.toString());
                                          // await getQuestionContro.AttemptQuestionApi(attemptQUrl, attemptQBody);
                                          // toastMsg("next question", true);
                                          categoryController.quecounter.value = categoryController.quecounter.value + 1;
                                          categoryController.controllertimerstart();
                                          // getQuestionContro.getQuestionList[quecounter];
                                          Get.find<CategoryController>()
                                              .GetQuestionApi(get_questionUrl,
                                                  false, false);
                                          setState(() {});
                                        } else {
                                          toastMsg("No Question Left", true);
                                          var examD = widget.examId.toString();
                                          print("attemptQUrl.....${examD}");
                                          // categoryController.controllertimerstart();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewPage(
                                                          exam_Ids: examD
                                                              .toString())));
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        margin: EdgeInsets.only(
                                            bottom: 20, top: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: primary),
                                        child: Text(
                                          "Next ",
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins-Regular',
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      if (showExplanation)
                        widget.timer == true
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 2),
                                child: Column(
                                  children: [
                                    Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n'
                                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n'
                                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n'
                                      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n'
                                      'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n'
                                      'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'PublicSans',
                                        color: black54,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Image.asset(ques_poster),
                                  ],
                                ),
                              ),

                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
