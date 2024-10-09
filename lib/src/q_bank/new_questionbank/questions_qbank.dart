import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/new_questionbank/qbankcontroller.dart';
import 'package:n_prep/src/q_bank/review.dart';
import 'package:n_prep/src/q_bank/subcat_qbank.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:pinput/pinput.dart';
import 'package:vibration/vibration.dart';

import '../../Nphase2/VideoScreens/video_detail_screen.dart';
import 'ReportissueScreen.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

class questionbank_new extends StatefulWidget {
  bool timer;

  var examId;
  var checkstatus;
  var reattempt;
  var counterindex;
  bool pagestatus;
  questionbank_new(
      {Key key,
      this.timer,
      this.examId,
      this.reattempt,
      this.counterindex,
      this.checkstatus,this.pagestatus});

  @override
  State<questionbank_new> createState() => _questionbank_newState();
}

class _questionbank_newState extends State<questionbank_new> with TickerProviderStateMixin {
  QBankController qBankController = Get.put(QBankController());
  static GlobalKey previewContainer = GlobalKey();
  var questionImg;



  @override
  void initState() {
    // TODO: implement initState
log('examId==>'+widget.examId.toString());
    super.initState();
    if (widget.reattempt.toString() == "1") {
      qBankController.quecounter.value = 1;
      print("exam id for examId if  ....." + qBankController.quecounter.value.toString());
      getReattemotApiCall();
    } else {
      getdata();
    }
  }



  newanimation() {
    var timeLimitInSeconds = int.parse(sprefs.getString("test_time"));
    print("timeinsec : " + timeLimitInSeconds.toString());
    qBankController.bcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: timeLimitInSeconds),
    )..addListener(() {
        setState(() {
          qBankController.bcontroller.value;
          // print("yooooo> " + qBankController.bcontroller.value.toString());

          if (qBankController.bcontroller.value >= 0.99) {
            // print("--Stop--");

            // qBankController.bcontroller.reset();
            // qBankController.bcontroller.stop();
            // qBankController.bcontroller.repeat();
            qBankController.controllertimerstop();
            qBankController.updatequestion_timer();
          } else {
            // print("--Play--");
          }
        });
      });

    qBankController.bcontroller.repeat(reverse: false);
  }

  getdata() async {

    await getQuestion(true);
    qBankController.examid.value = int.parse(widget.examId);
    qBankController.quecounter.value = widget.counterindex-1;
    print("quecounter on start -> " + qBankController.quecounter.value.toString());
    Timer(Duration(milliseconds: 5),(){
      qBankController.MCQQuestion_controller.jumpToPage(qBankController.quecounter.value);
    });

    newanimation();



  }

  getQuestion(status) async {
    Map<String, String> queryParams = {
      'exam_id': widget.examId.toString(),
      'exam_status': widget.reattempt.toString() == "1"
          ? widget.reattempt.toString()
          : widget.checkstatus.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var get_questionUrl = apiUrls().get_question_api + '?' + queryString;
    print("get_questionUrl...." + get_questionUrl.toString());

    await qBankController.GetQuestionApi(get_questionUrl, status);
  }

  getReattemotApiCall() async {

    qBankController.examid.value = int.parse(widget.examId);
    qBankController.quecounter.value = 0;
    newanimation();
    Map<String, String> queryParams = {
      'exam_id': qBankController.examid.toString(),
      'exam_status': "1",
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var get_reattemotUrl = apiUrls().get_question_api + '?' + queryString;
    print("get_reattemotUrl...." + get_reattemotUrl.toString());

    await qBankController.GetQuestionApi(get_reattemotUrl, true);
  }

  void quit_exam() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              height: 200,
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
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'PublicSans',
                        color: Colors.black87,
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
                            ),
                          ),
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        qBankController.controllertimerstop();
                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                          statusBarColor: Color(0xFF64C4DA), // status bar color
                        ));
                        // sas;
                        var perent_Id=   sprefs.getString("perent_Id");
                        var catName = sprefs.getString("catName");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Subcategory(perentId: perent_Id.toString(),
                            categoryName: catName.toString(),categorytype: 1,)),
                        );
                     //    if(widget.pagestatus!=true){
                     // var perent_Id=   sprefs.getString("perent_Id");
                     //  var catName = sprefs.getString("catName");
                     //    Navigator.pushReplacement(
                     //      context,
                     //      MaterialPageRoute(builder: (context) => Subcategory(perentId: perent_Id.toString(),
                     //        categoryName: catName.toString(),categorytype: 1,)),
                     //    );
                     //    }else{
                     //      toastMsg("Hit Back", true);
                     //      Navigator.pop(context);
                     //    }
                     //    var examD = widget.examId.toString();
                     //    print("attemptQUrl.....${examD}");
                     //    // // categoryController.controllertimerstart();
                     //    Navigator.pushReplacement(
                     //        context,
                     //        MaterialPageRoute(
                     //            builder: (context) => ReviewPage(
                     //                exam_Ids: examD.toString())));
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => BottomBar(
                        //             bottomindex: 1,
                        //           )),
                        // ); // Close the dialog
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PublicSans',
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.20);
    var scale2 = mediaquary.textScaleFactor.clamp(1.2, 1.2);

    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BottomBar(
        //             bottomindex: 1,
        //           )),
        // );
        // Fluttertoast.showToast(msg: "Hello");
        quit_exam();
        return false;
      },
      child: RepaintBoundary(
        key:previewContainer ,
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white38, // <-- SEE HERE
              // statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
              // statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
            ),
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.white38,
            // brightness: Brightness.light,
            centerTitle: true,
            title: Image.asset(
              logo,
              scale: 3.5,
            ),
          ),
          body: GetBuilder<QBankController>(builder: (getQuestionContro) {
            if (getQuestionContro.getQLoader.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return getQuestionContro.getQuestionList.length == 0
                  ? Container(
                      height: 800,
                      alignment: Alignment.center,
                      child: Text("No Question Found"))
                  : MediaQuery(
                    child: Wrap(
                        children: [
                          // Stack(
                          //   children: [
                          //     Container(
                          //       alignment: Alignment.center,
                          //       child: Padding(
                          //         padding: EdgeInsets.only(top: 30, bottom: 10),
                          //         child: Image.asset(
                          //           logo,
                          //           scale: 3.5,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          RotatedBox(
                            quarterTurns: 10,
                            child: LinearProgressIndicator(
                              value: getQuestionContro.bcontroller.value,
                              backgroundColor: primary,
                              semanticsLabel: 'Linear progress indicator',
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(lightPrimary),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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

                          Container(
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.red,
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // scrollDirection: Axis.vertical,
                              itemCount: getQuestionContro.getQuestionList[0]['queue'].length,
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 2,
                                crossAxisCount: 24,
                                crossAxisSpacing: 2,
                                childAspectRatio:MediaQuery.of(context).size.height / 500,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var item_list = getQuestionContro.getQuestionList[0]['queue'][index];
                                // print("item_list...."+item_list.toString());
                                return Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (getQuestionContro.quecounter.value ) ==
                                              index
                                          ? primary
                                          : item_list['is_answer'] == 1
                                              ? ansBackgroundColor
                                              : item_list['is_answer'] == 2
                                                  ? redBackgroundColor
                                                  : item_list['is_answer'] == 3
                                                      ? redBackgroundColor
                                                      : item_list['is_answer'] == 4
                                                          ? Colors.grey
                                                          : Colors.white
                                      //     : item_list['attempt_test_questions'][0]
                                      // ['currect_answer'] ==
                                      //     item_list['attempt_test_questions']
                                      //     [0]['your_answer']
                                      //     ? ansBackgroundColor
                                      //     : item_list['attempt_test_questions'][0]
                                      // ['is_answer'] ==
                                      //     3
                                      //     ? redBackgroundColor
                                      //     : redBackgroundColor,
                                      ),

                                  // child: item_list
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            height: getQuestionContro.getQuestionList[0]['questions'][getQuestionContro.quecounter.value]['is_attempt']==1? size.height - 280:size.height - 210 ,
                            // color: Colors.red,
                            child: PageView.builder(
                                itemCount: getQuestionContro.getQuestionList[0]['questions'].length,
                                // shrinkWrap: true,
                                controller: getQuestionContro.MCQQuestion_controller,
                                onPageChanged: (v){
                                  log("quecounter on start -> OnChange >> "+v.toString());
                                  getQuestionContro.quecounter.value=v;
                                  if(getQuestionContro.getQuestionList[0]['questions'][getQuestionContro.quecounter.value ]['is_attempt']==1){

                                  }else{
                                    getQuestionContro.bcontroller.reset();
                                    getQuestionContro.bcontroller.repeat();
                                  }
                                  setState(() {

                                  });

                                },
                                physics: getQuestionContro.getQuestionList[0]['questions'][getQuestionContro.quecounter.value ]['is_attempt']==1?AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  var get_data = getQuestionContro.getQuestionList[0]['questions'][index];

                                  log("get_data>> "+get_data.toString());
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 17.0,
                                      // bottom: 8,
                                    ),
                                    child: get_data['is_attempt'] == 0
                                        ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Q.${index+1})",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: primary,
                                                      fontWeight:
                                                      FontWeight.w700)),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                // color: primary,
                                                margin: EdgeInsets.only(top: 2),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    70,
                                                child: Text(
                                                    '${get_data['question'].toString() == "null" ? "" : get_data['question'].toString()}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                      FontWeight.w100,
                                                      fontFamily: 'PublicSans',
                                                      color: black54,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          get_data['attachment'].toString() ==
                                              "null"
                                              ? Container()
                                              : SizedBox(height: 10),
                                          get_data['attachment'].toString() ==
                                              "null"
                                              ? Container()
                                              : GestureDetector(
                                            onTap: () {
                                              // showDialog(
                                              //   barrierDismissible: false,
                                              //   context: context,
                                              //   builder: (BuildContext
                                              //       context) {
                                              //     return WillPopScope(
                                              //         onWillPop:
                                              //             () async =>
                                              //                 true,
                                              //         child: Stack(
                                              //           clipBehavior:
                                              //               Clip.none,
                                              //           children: [
                                              //             AlertDialog(
                                              //
                                              //               content:
                                              //                   new SingleChildScrollView(
                                              //                 child:
                                              //                     Container(
                                              //                   height:
                                              //                       250,
                                              //                   width:
                                              //                       250,
                                              //                   child:
                                              //                       PhotoView(
                                              //                     imageProvider:
                                              //                         NetworkImage("${get_data['attachment'].toString()}"),
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //               // actions: <Widget>[
                                              //               //   ElevatedButton(
                                              //               //     child: const Text(
                                              //               //       'Close',
                                              //               //     ),
                                              //               //     style: ElevatedButton.styleFrom(
                                              //               //       minimumSize: const Size(0, 45),
                                              //               //       primary: Colors.amber,
                                              //               //       onPrimary: const Color(0xFFFFFFFF),
                                              //               //       shape: RoundedRectangleBorder(
                                              //               //         borderRadius: BorderRadius.circular(8),
                                              //               //       ),
                                              //               //     ),
                                              //               //     onPressed: () {
                                              //               //       Get.back();
                                              //               //     },
                                              //               //   ),
                                              //               // ],
                                              //             ),
                                              //             Positioned(
                                              //                 top: 199,
                                              //                 right: 50,
                                              //                 child: GestureDetector(
                                              //                     onTap: () {
                                              //
                                              //                       Get.back();
                                              //                     },
                                              //                     child: Icon(
                                              //                       Icons
                                              //                           .cancel,
                                              //                       color:
                                              //                           primary,
                                              //                     )))
                                              //           ],
                                              //         ));
                                              //   },
                                              // );
                                            },
                                            child:Container(
                                              width: size.width,
                                              height: 190,
                                              color: Colors.grey.shade300,
                                              margin: EdgeInsets.only(
                                                  right: 10),
                                              child:
                                              InteractiveViewer(
                                                child: Image.network(
                                                  get_data['attachment'].toString(),
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.hide_image_outlined,
                                                        size: 110,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                    );
                                                  },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                maxScale: 5.0,
                                              ),

                                              // PhotoView(
                                              //   backgroundDecoration: BoxDecoration(
                                              //       color: Colors.white
                                              //   ),
                                              //   errorBuilder: (context, error, stackTrace){
                                              //     return Container(
                                              //       color: Colors.grey.shade300,
                                              //       alignment: Alignment.center,
                                              //       child: Icon(Icons.hide_image_outlined,size: 110,
                                              //         color: Colors.grey.shade500,),
                                              //     );
                                              //   },
                                              //   loadingBuilder: ( context,  child) {
                                              //     // if (child == null) return child;
                                              //     return Center(
                                              //       child: CircularProgressIndicator(),
                                              //     );
                                              //   },
                                              //   imageProvider: NetworkImage(
                                              //     get_data['attachment'].toString(),
                                              //
                                              //   ),
                                              // ),

                                            ),
                                            // child: Container(
                                            //   margin: EdgeInsets.only(
                                            //       right: 10),
                                            //   child: Image.network(
                                            //       "${get_data['attachment'].toString()}",
                                            //     loadingBuilder: (BuildContext context, Widget child,
                                            //       ImageChunkEvent loadingProgress) {
                                            //     if (loadingProgress == null) return child;
                                            //     return Center(
                                            //       child: CircularProgressIndicator(
                                            //         value: loadingProgress.expectedTotalBytes != null
                                            //             ? loadingProgress.cumulativeBytesLoaded /
                                            //             loadingProgress.expectedTotalBytes
                                            //             : null,
                                            //       ),
                                            //     );
                                            //   },),
                                            // ),
                                          ),

                                          SizedBox(
                                            height: 30,
                                          ),
                                          ListView.builder(
                                              itemCount:get_data['questionObjects'].length,
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int indexs) {
                                                final optionIndex =
                                                String.fromCharCode(97 + indexs);
                                                final optionText = get_data['questionObjects'][indexs];

                                                log('questionImg==>'+questionImg.toString());
                                                // Default to white for not selected

                                                return GestureDetector(
                                                  onTap: () async {


                                                    questionImg= get_data['attachment'].toString();
                                                    if (getQuestionContro.attempans.value ==false) {
                                                      await getQuestionContro.
                                                      updatequestion_color_result(
                                                          optionText['is_correct'],
                                                          indexs,
                                                          index,
                                                          optionText['option_id'],
                                                          optionText['question_id']);



                                                    }
                                                    else {
                                                      // toastMsg("You Submited Answer", false);
                                                    }
                                                  },
                                                  child: Card(

                                                    margin: EdgeInsets.only(
                                                        left: 25,
                                                        bottom: 12,
                                                        right: 15),
                                                    shape:RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    elevation: 1,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    child: Container(
                                                      margin:EdgeInsets.symmetric(vertical: 0),
                                                      padding:EdgeInsets.all(12),

                                                      decoration: BoxDecoration(
                                                          color: optionText['is_correct'] ==
                                                              2
                                                              ? ansBackgroundColor
                                                              : optionText[
                                                          'is_correct'] ==
                                                              3
                                                              ? redBackgroundColor
                                                              : Colors.white,
                                                          // color: getQuestionContro.selectedoption==1?Colors.green:Colors.white,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(8),
                                                          border: Border.fromBorderSide(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300))),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: primary,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    30)),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  12,
                                                                  vertical:
                                                                  8),
                                                              child: Text(
                                                                optionIndex
                                                                    .toString()
                                                                    .capitalizeFirst,
                                                                style:
                                                                TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              optionText['objective']
                                                                  .toString() ==
                                                                  "null"
                                                                  ? Container()
                                                                  : Container(
                                                                width: MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                    130,
                                                                child:
                                                                Text(
                                                                  optionText['objective']
                                                                      .toString(),
                                                                  // textAlign:
                                                                  // TextAlign
                                                                  //     .justify,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    15,
                                                                    letterSpacing:
                                                                    0.5,
                                                                    fontWeight:
                                                                    FontWeight.w400,
                                                                    fontFamily:
                                                                    'PublicSans',
                                                                    color:
                                                                    Colors.black87,
                                                                  ),
                                                                ),
                                                              ),
                                                              optionText['attachment']
                                                                  .toString() ==
                                                                  "null"
                                                                  ? Container()
                                                                  : GestureDetector(
                                                                onTap: () {
                                                                  // showDialog(
                                                                  //   barrierDismissible: false,
                                                                  //   context: context,
                                                                  //   builder: (BuildContext
                                                                  //   context) {
                                                                  //     return WillPopScope(
                                                                  //         onWillPop:
                                                                  //             () async =>
                                                                  //         true,
                                                                  //         child: Stack(
                                                                  //           clipBehavior:
                                                                  //           Clip.none,
                                                                  //           children: [
                                                                  //             AlertDialog(
                                                                  //
                                                                  //               content:
                                                                  //               new SingleChildScrollView(
                                                                  //                 child:
                                                                  //                 Container(
                                                                  //                   height:
                                                                  //                   250,
                                                                  //                   width:
                                                                  //                   250,
                                                                  //                   child:
                                                                  //                   PhotoView(
                                                                  //                     imageProvider:
                                                                  //                     NetworkImage("${optionText['attachment'].toString()}"),
                                                                  //                   ),
                                                                  //                 ),
                                                                  //               ),
                                                                  //               // actions: <Widget>[
                                                                  //               //   ElevatedButton(
                                                                  //               //     child: const Text(
                                                                  //               //       'Close',
                                                                  //               //     ),
                                                                  //               //     style: ElevatedButton.styleFrom(
                                                                  //               //       minimumSize: const Size(0, 45),
                                                                  //               //       primary: Colors.amber,
                                                                  //               //       onPrimary: const Color(0xFFFFFFFF),
                                                                  //               //       shape: RoundedRectangleBorder(
                                                                  //               //         borderRadius: BorderRadius.circular(8),
                                                                  //               //       ),
                                                                  //               //     ),
                                                                  //               //     onPressed: () {
                                                                  //               //       Get.back();
                                                                  //               //     },
                                                                  //               //   ),
                                                                  //               // ],
                                                                  //             ),
                                                                  //             Positioned(
                                                                  //                 top: 199,
                                                                  //                 right: 50,
                                                                  //                 child: GestureDetector(
                                                                  //                     onTap: () {
                                                                  //
                                                                  //                       Get.back();
                                                                  //                     },
                                                                  //                     child: Icon(
                                                                  //                       Icons
                                                                  //                           .cancel,
                                                                  //                       color:
                                                                  //                       primary,
                                                                  //                     )))
                                                                  //           ],
                                                                  //         ));
                                                                  //   },
                                                                  // );
                                                                },
                                                                child:    InteractiveViewer(
                                                                  child: Image.network(
                                                                    optionText['attachment'].toString(),
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                      return Container(
                                                                        color: Colors.grey.shade300,
                                                                        alignment: Alignment.center,
                                                                        child: Icon(
                                                                          Icons.hide_image_outlined,
                                                                          size: 110,
                                                                          color: Colors.grey.shade500,
                                                                        ),
                                                                      );
                                                                    },
                                                                    loadingBuilder: (context, child, loadingProgress) {
                                                                      if (loadingProgress == null) return child;
                                                                      return Center(
                                                                        child: CircularProgressIndicator(
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                                              loadingProgress.expectedTotalBytes
                                                                              : null,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  maxScale: 5.0,
                                                                ),



                                                                // Container(
                                                                //       width: size.width,
                                                                //       height: 150,
                                                                //       color: Colors.grey.shade300,
                                                                //       margin: EdgeInsets.only(
                                                                //           right: 10),
                                                                //       child: PhotoView(
                                                                //         backgroundDecoration: BoxDecoration(
                                                                //             color: Colors.white
                                                                //         ),
                                                                //         errorBuilder: (context, error, stackTrace){
                                                                //           return Container(
                                                                //             color: Colors.grey.shade300,
                                                                //             alignment: Alignment.center,
                                                                //             child: Icon(Icons.hide_image_outlined,size: 110,
                                                                //               color: Colors.grey.shade500,),
                                                                //           );
                                                                //         },
                                                                //         loadingBuilder: ( context,  child) {
                                                                //           // if (child == null) return child;
                                                                //           return Center(
                                                                //             child: CircularProgressIndicator(),
                                                                //           );
                                                                //         },
                                                                //         imageProvider: NetworkImage(
                                                                //
                                                                //           // "https://adiyogionlinetrade.com/nprep/public/images/default.png",
                                                                //           optionText['attachment'].toString(),
                                                                //
                                                                //         ),
                                                                //       ),
                                                                //     )






                                                                // child: Container(
                                                                //     margin: EdgeInsets .only(top: 10),
                                                                //     alignment:Alignment.topLeft,
                                                                //     width: MediaQuery.of(context)
                                                                //             .size
                                                                //             .width *
                                                                //         0.3,
                                                                //     height: MediaQuery.of(context)
                                                                //             .size
                                                                //             .height *
                                                                //         0.1,
                                                                //     child: Image.network(
                                                                //       optionText['attachment']
                                                                //           .toString(),
                                                                //       loadingBuilder: (BuildContext context, Widget child,
                                                                //           ImageChunkEvent loadingProgress) {
                                                                //         if (loadingProgress == null) return child;
                                                                //         return Center(
                                                                //           child: CircularProgressIndicator(
                                                                //             value: loadingProgress.expectedTotalBytes != null
                                                                //                 ? loadingProgress.cumulativeBytesLoaded /
                                                                //                 loadingProgress.expectedTotalBytes
                                                                //                 : null,
                                                                //           ),
                                                                //         );
                                                                //       },
                                                                //       errorBuilder: (context,
                                                                //           error,
                                                                //           stackTrace) {
                                                                //         return Container(
                                                                //           color:Colors.grey.shade300,
                                                                //           alignment: Alignment.center,
                                                                //           child:
                                                                //               Icon(
                                                                //             Icons.hide_image_outlined,
                                                                //             size: 50,
                                                                //             color: Colors.grey.shade500,
                                                                //           ),
                                                                //         );
                                                                //       },
                                                                //     ),
                                                                //   ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                    )
                                        : SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Q.${index+1})",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: primary,
                                                      fontWeight:FontWeight.w700)
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                // color: primary,
                                                margin: EdgeInsets.only(top: 2),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    70,
                                                child: Text(
                                                    '${get_data['question'].toString() == "null" ? "" : get_data['question'].toString()}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontFamily: 'PublicSans',
                                                      color: Colors.black54,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(right: 50.0,left: 15.0,top: 6.0,bottom: 6.0),
                                          //   child: Divider(
                                          //     color: Colors.grey[350],
                                          //     thickness: 2.5,
                                          //   ),
                                          // ),
                                          get_data['attachment'].toString() ==
                                              "null"
                                              ? Container()
                                              : SizedBox(height: 10),
                                          get_data['attachment'].toString() == "null"
                                              ? Container()
                                              : GestureDetector(
                                            onTap: () {
                                              // showDialog(
                                              //   barrierDismissible: false,
                                              //   context: context,
                                              //   builder: (BuildContext
                                              //       context) {
                                              //     return WillPopScope(
                                              //         onWillPop:
                                              //             () async =>
                                              //                 true,
                                              //         child: Stack(
                                              //           clipBehavior:
                                              //               Clip.none,
                                              //           children: [
                                              //             AlertDialog(
                                              //
                                              //               content:
                                              //                   new SingleChildScrollView(
                                              //                 child:
                                              //                     Container(
                                              //                   height:
                                              //                       250,
                                              //                   width:
                                              //                       250,
                                              //                   child:
                                              //                       PhotoView(
                                              //                     imageProvider:
                                              //                         NetworkImage("${get_data['attachment'].toString()}"),
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //
                                              //             ),
                                              //             Positioned(
                                              //                 top: 199,
                                              //                 right: 50,
                                              //                 child: GestureDetector(
                                              //                     onTap: () {
                                              //
                                              //                       Get.back();
                                              //                     },
                                              //                     child: Icon(
                                              //                       Icons
                                              //                           .cancel,
                                              //                       color:
                                              //                           primary,
                                              //                     )))
                                              //           ],
                                              //         ));
                                              //   },
                                              // );

                                            },

                                            child:Container(
                                            width: size.width,
                                            height: 190,
                                            color: Colors.grey.shade300,
                                            margin: EdgeInsets.only(
                                                right: 10),
                                            child:
                                            InteractiveViewer(
                                              child: Image.network(
                                                get_data['attachment'].toString(),
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade300,
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.hide_image_outlined,
                                                      size: 110,
                                                      color: Colors.grey.shade500,
                                                    ),
                                                  );
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                              maxScale: 5.0,
                                            ),

                                            // PhotoView(
                                            //   backgroundDecoration: BoxDecoration(
                                            //       color: Colors.white
                                            //   ),
                                            //   errorBuilder: (context, error, stackTrace){
                                            //     return Container(
                                            //       color: Colors.grey.shade300,
                                            //       alignment: Alignment.center,
                                            //       child: Icon(Icons.hide_image_outlined,size: 110,
                                            //         color: Colors.grey.shade500,),
                                            //     );
                                            //   },
                                            //   loadingBuilder: ( context,  child) {
                                            //     // if (child == null) return child;
                                            //     return Center(
                                            //       child: CircularProgressIndicator(),
                                            //     );
                                            //   },
                                            //   imageProvider: NetworkImage(
                                            //     get_data['attachment'].toString(),
                                            //
                                            //   ),
                                            // ),

                                          ),

                                          ),

                                          SizedBox(
                                            height: 30,
                                          ),
                                          ListView.builder(
                                            itemCount:get_data['questionObjects'].length,
                                            // Replace 'options.length' with the actual number of options
                                            shrinkWrap: true,
                                            physics:NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,int indexd) {
                                              final optionIndex = String.fromCharCode(97 +indexd); // Convert index to 'a', 'b', 'c', ...
                                              final optionText =get_data['questionObjects'][indexd];

                                              return Container(
                                                // color: Colors.red,
                                                padding: EdgeInsets.all(5.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    indexd ==get_data["attempt_test_questions"]['currect_answer']
                                                        ? Icon(Icons.check,
                                                        color: Colors.green,
                                                        size: 16)
                                                        : (indexd !=get_data["attempt_test_questions"]
                                                    ['currect_answer'] &&
                                                        get_data["attempt_test_questions"]
                                                        ['your_answer'] ==indexd
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
                                                      "${optionIndex.toUpperCase()}.",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontFamily:
                                                        'Poppins-Regular',
                                                        //  color red krna h agar answer galat ho
                                                        color: indexd ==
                                                            get_data[
                                                            "attempt_test_questions"]
                                                            [
                                                            'currect_answer']
                                                            ? Colors.green
                                                            : (indexd !=
                                                            get_data["attempt_test_questions"]
                                                            [
                                                            'currect_answer'] &&
                                                            get_data["attempt_test_questions"]
                                                            [
                                                            'your_answer'] ==
                                                                indexd
                                                            ? redBackgroundColor
                                                            : Colors
                                                            .black54),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        optionText['objective']
                                                            .toString() ==
                                                            "null"
                                                            ? Container()
                                                            : Container(
                                                          // color:Colors.red,
                                                          width: MediaQuery.of(
                                                              context).size.width -100,
                                                          // color: primary,
                                                          // alignment: Alignment
                                                          //     .centerLeft,
                                                          child: Text(
                                                            // "hhhhnjanvjansvnaslnvlkasnvlkanslkvnaklnvlaks",
                                                            optionText[
                                                            'objective']
                                                                .toString(),
                                                            // textAlign:
                                                            //     TextAlign
                                                            //         .justify,
                                                            style: TextStyle(
                                                              fontSize:
                                                              16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              fontFamily:
                                                              'PublicSans',
                                                              color: indexd ==
                                                                  get_data["attempt_test_questions"][
                                                                  'currect_answer']
                                                                  ? Colors
                                                                  .green
                                                                  : (indexd != get_data["attempt_test_questions"]['currect_answer'] && get_data["attempt_test_questions"]['your_answer'] == indexd
                                                                  ? redBackgroundColor
                                                                  : Colors
                                                                  .black54),
                                                            ),
                                                          ),
                                                        ),
                                                        optionText['attachment']
                                                            .toString() ==
                                                            "null"
                                                            ? Container()
                                                            : Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                              top:
                                                              10),
                                                          alignment:
                                                          Alignment
                                                              .topLeft,
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
                                                          child: Image
                                                              .network(
                                                            optionText[
                                                            'attachment']
                                                                .toString(),
                                                            errorBuilder:
                                                                (context,
                                                                error,
                                                                stackTrace) {
                                                              return Container(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child:
                                                                Icon(
                                                                  Icons
                                                                      .hide_image_outlined,
                                                                  size:
                                                                  50,
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
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 50.0,
                                                left: 15.0,
                                                top: 6.0,
                                                bottom: 2.0),
                                            child: Divider(
                                              color: Colors.grey[350],
                                              thickness: 2.5,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Text(
                                                      "Rationale: ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          decoration: TextDecoration
                                                              .underline,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    )),
                                                GestureDetector(
                                                    onTap:screenshotloader==true?null: () async {
                                                      await takeScreenShot(get_data['id']);
                                                      Get.to(ReportIssueScreen(examid:widget.examId ,questionId:get_data['id'],screenshot:imagePath.toString(),));
                                                    },
                                                    child: screenshotloader==true?Container(
                                                        height: 20,
                                                        width: 20,
                                                        margin: EdgeInsets.only(right: 20),
                                                        alignment: Alignment.centerLeft,
                                                        child: CircularProgressIndicator()):Text('Have any query?',style: TextStyle(color: primary),)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          SizedBox(height: 10),

                                          get_data['ans_description_attachment']
                                              .toString() ==
                                              "null"
                                              ? Container()
                                              : GestureDetector(
                                            onTap: (){
                                              // showDialog(
                                              //   barrierDismissible: false,
                                              //   context: context,
                                              //   builder: (BuildContext
                                              //   context) {
                                              //     return WillPopScope(
                                              //         onWillPop:
                                              //             () async =>
                                              //         true,
                                              //         child: Stack(
                                              //           clipBehavior:
                                              //           Clip.none,
                                              //           children: [
                                              //             AlertDialog(
                                              //
                                              //               content:
                                              //               new SingleChildScrollView(
                                              //                 child:
                                              //                 Container(
                                              //                   height:
                                              //                   250,
                                              //                   width:
                                              //                   250,
                                              //                   child:
                                              //                   PhotoView(
                                              //                     imageProvider:
                                              //                     NetworkImage("${get_data['ans_description_attachment'].toString()}"),
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //               // actions: <Widget>[
                                              //               //   ElevatedButton(
                                              //               //     child: const Text(
                                              //               //       'Close',
                                              //               //     ),
                                              //               //     style: ElevatedButton.styleFrom(
                                              //               //       minimumSize: const Size(0, 45),
                                              //               //       primary: Colors.amber,
                                              //               //       onPrimary: const Color(0xFFFFFFFF),
                                              //               //       shape: RoundedRectangleBorder(
                                              //               //         borderRadius: BorderRadius.circular(8),
                                              //               //       ),
                                              //               //     ),
                                              //               //     onPressed: () {
                                              //               //       Get.back();
                                              //               //     },
                                              //               //   ),
                                              //               // ],
                                              //             ),
                                              //             Positioned(
                                              //                 top: 199,
                                              //                 right: 50,
                                              //                 child: GestureDetector(
                                              //                     onTap: () {
                                              //
                                              //                       Get.back();
                                              //                     },
                                              //                     child: Icon(
                                              //                       Icons
                                              //                           .cancel,
                                              //                       color:
                                              //                       primary,
                                              //                     )))
                                              //           ],
                                              //         ));
                                              //   },
                                              // );
                                            },
                                            child: Container(
                                              width: size.width,
                                              height: 150,
                                              color: Colors.grey.shade300,
                                              margin: EdgeInsets.only(
                                                  right: 10),
                                              child:   InteractiveViewer(

                                                child: Image.network(
                                                  get_data['ans_description_attachment'].toString(),
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.hide_image_outlined,
                                                        size: 110,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                    );
                                                  },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                maxScale: 5.0,
                                              ),

                                              // PhotoView(
                                              //   backgroundDecoration: BoxDecoration(
                                              //       color: Colors.white
                                              //   ),
                                              //   errorBuilder: (context, error, stackTrace){
                                              //     return Container(
                                              //       color: Colors.grey.shade300,
                                              //       alignment: Alignment.center,
                                              //       child: Icon(Icons.hide_image_outlined,size: 110,
                                              //         color: Colors.grey.shade500,),
                                              //     );
                                              //   },
                                              //   loadingBuilder: ( context,  child) {
                                              //     // if (child == null) return child;
                                              //     return Center(
                                              //       child: CircularProgressIndicator(),
                                              //     );
                                              //   },
                                              //   imageProvider: NetworkImage(
                                              //
                                              //     // "https://adiyogionlinetrade.com/nprep/public/images/default.png",
                                              //     get_data['ans_description_attachment'].toString(),
                                              //
                                              //   ),
                                              // ),


                                            ),
                                            // child: PhotoView(
                                            //   errorBuilder: (context, error, stackTrace){
                                            //     return Container(
                                            //       color: Colors.grey.shade300,
                                            //       alignment: Alignment.center,
                                            //       child: Icon(Icons.hide_image_outlined,size: 110,
                                            //         color: Colors.grey.shade500,),
                                            //     );
                                            //   },
                                            //   loadingBuilder: ( context,  child) {
                                            //     // if (child == null) return child;
                                            //     return Center(
                                            //       child: CircularProgressIndicator(),
                                            //     );
                                            //   },
                                            //     imageProvider:
                                            //   NetworkImage(
                                            //       get_data['ans_description_attachment']
                                            //           .toString(),
                                            //     // loadingBuilder: (BuildContext context, Widget child,
                                            //     //     ImageChunkEvent loadingProgress) {
                                            //     //   if (loadingProgress == null) return child;
                                            //     //   return Center(
                                            //     //     child: CircularProgressIndicator(
                                            //     //       value: loadingProgress.expectedTotalBytes != null
                                            //     //           ? loadingProgress.cumulativeBytesLoaded /
                                            //     //           loadingProgress.expectedTotalBytes
                                            //     //           : null,
                                            //     //     ),
                                            //     //   );
                                            //     // },
                                            //     //   errorBuilder: (context, error, stackTrace) {
                                            //     //     return Container(
                                            //     //       color: Colors.grey.shade300,
                                            //     //       alignment: Alignment.center,
                                            //     //       child: Icon(Icons.hide_image_outlined,size: 110,
                                            //     //         color: Colors.grey.shade500,),
                                            //     //     );
                                            //     //   }
                                            //     ),
                                            // ),
                                          ),

                                          get_data['ans_description']
                                              .toString() ==
                                              "null"
                                              ? Container()
                                              : Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 10.0,
                                                top: 12),
                                            child:
                                            Html(
                                              data:
                                              get_data['ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString(),
                                              style: {
                                                "body": Style(fontSize: FontSize(16.0)),

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
                                                "p": Style(
                                                  fontSize: FontSize.small,

                                                ),
                                                "ol": Style(
                                                  fontSize: FontSize.small,

                                                ),
                                                "th": Style(
                                                  padding: EdgeInsets.all(6),
                                                  backgroundColor: Colors.black,
                                                ),
                                                "td": Style(
                                                  padding: EdgeInsets.all(2),
                                                  alignment: Alignment.topLeft,
                                                ),
                                                "pr": Style(
                                                  // fontSize: 12,
                                                    fontSize:FontSize.xSmall ,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'PublicSans',
                                                    color: black54),
                                              },
                                              customRenders: {
                                                tableMatcher(): tableRender(),
                                              },
                                            ),
                                            // Html(
                                            //   data: get_data['ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString(),
                                            //   style: {
                                            //     "table": Style(),
                                            //
                                            //     "tr": Style(
                                            //       border: Border(
                                            //         bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                            //         top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                            //         right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                            //         left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                            //       ),
                                            //     ),
                                            //     "th": Style(
                                            //       padding: EdgeInsets.all(10),
                                            //       backgroundColor: Colors.green,
                                            //       color: Colors.yellow, // Optional: Change text color of header cells
                                            //     ),
                                            //     "td": Style(
                                            //       padding: EdgeInsets.all(5),
                                            //       alignment: Alignment.topLeft,
                                            //       // backgroundColor: Colors.yellow,
                                            //     ),
                                            //   },
                                            //   customRenders: {
                                            //     tableMatcher(): tableRender(),
                                            //   },
                                            // ),

                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            padding: EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "MCQ ID : ${get_data['id'].toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'PublicSans',
                                                    color: black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding: const EdgeInsets.all(6.0),
                                          //   child: Divider(
                                          //     color: Colors.grey[350],
                                          //     thickness: 1.5,
                                          //   ),
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () async {
                                          //     // if (getQuestionContro
                                          //     //     .getQuestionList.length >=
                                          //     //     categoryController.quecounter.value + 1) {
                                          //     //   // var id= getQuestionContro.getQuestionList[quecounter - 1];
                                          //     //   // examID = getQuestionContro.checkexamid.toString();
                                          //     //   // var question_ID = id['id'];
                                          //     //   // var attemptQUrl = apiUrls().attempt_question_api;
                                          //     //   // var attemptQBody = {
                                          //     //   //   'exam_id': examID.toString(),
                                          //     //   //   'question_id': question_ID.toString(),
                                          //     //   //   // 'answer_id': "null"
                                          //     //   // };
                                          //     //   // print("attemptQUrl....." + attemptQUrl.toString());
                                          //     //   // print("attemptQBody....." + attemptQBody.toString());
                                          //     //   // await getQuestionContro.AttemptQuestionApi(attemptQUrl, attemptQBody);
                                          //     //   toastMsg("next question", true);
                                          //     //   categoryController.quecounter.value = categoryController.quecounter.value + 1;
                                          //     //   categoryController.controllertimerstart();
                                          //     //   // getQuestionContro.getQuestionList[quecounter];
                                          //     //   setState(() {});
                                          //     // } else {
                                          //     //   toastMsg("No Question Left", true);
                                          //     //   var examD = widget.examId.toString();
                                          //     //   print("attemptQUrl.....${examD}");
                                          //     //   // categoryController.controllertimerstart();
                                          //     //   Navigator.pushReplacement(
                                          //     //       context,
                                          //     //       MaterialPageRoute(
                                          //     //           builder: (context) =>
                                          //     //               ReviewPage(
                                          //     //                   exam_Ids: examD
                                          //     //                       .toString())));
                                          //     // }
                                          //   },
                                          //   child: Container(
                                          //     alignment: Alignment.center,
                                          //     width:
                                          //     MediaQuery.of(context).size.width *
                                          //         0.6,
                                          //     height:
                                          //     MediaQuery.of(context).size.height *
                                          //         0.05,
                                          //     margin: EdgeInsets.only(
                                          //         bottom: 20, top: 20),
                                          //     decoration: BoxDecoration(
                                          //         borderRadius:
                                          //         BorderRadius.circular(4),
                                          //         color: primary),
                                          //     child: Text(
                                          //       "Next ",
                                          //       style: TextStyle(
                                          //         fontSize: 19,
                                          //         fontWeight: FontWeight.w500,
                                          //         fontFamily: 'Poppins-Regular',
                                          //         color: white,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),

                          getQuestionContro.getQuestionList[0]['questions']
                                          [getQuestionContro.quecounter.value ]
                                      ['is_attempt'] ==
                                  1
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Divider(
                                    color: Colors.grey[350],
                                    thickness: 1.5,
                                  ),
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: getQuestionContro.quecounter.value ==0?MainAxisAlignment.center: MainAxisAlignment.spaceBetween,
                            children: [
                              getQuestionContro.getQuestionList[0]['questions'][getQuestionContro.quecounter.value]['is_attempt'] ==
                                  1
                                  ?getQuestionContro.quecounter.value ==0?Container():
                              GestureDetector(
                                onTap: () async {
                           print("question length : " +getQuestionContro .getQuestionList[0]['questions'].length.toString());
                           print("question quecounter : " +getQuestionContro.quecounter.value.toString());
                            await getQuestionContro.updatequestion_prev();
                                  // if (getQuestionContro .getQuestionList[0]['questions'] .length >=
                                  //     getQuestionContro.quecounter.value + 1) {
                                  //   // toastMsg("next question", false);
                                  //   await getQuestionContro.updatequestion_prev();
                                  //   // setState(() {});
                                  //   // categoryController.controllertimerstart();
                                  //   // // getQuestionContro.getQuestionList[quecounter];

                                  //   // setState(() {});
                                  // }
                                  // else {
                                  //   // toastMsg("No Question Left", true);
                                  //   var examD = widget.examId.toString();
                                  //   // print("attemptQUrl.....${examD}");
                                  //   // // categoryController.controllertimerstart();
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => ReviewPage(
                                  //               exam_Ids: examD.toString())));
                                  // }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height:
                                  MediaQuery.of(context).size.height * 0.05,
                                  margin: EdgeInsets.only(bottom: 20, top: 20,left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: primary),
                                  child: Text("Previous",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins-Regular',
                                      color: white,
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),
                              // SizedBox(width: 10,),
                              getQuestionContro.getQuestionList[0]['questions'][getQuestionContro.quecounter.value ]['is_attempt'] ==
                                  1
                                  ? GestureDetector(
                                onTap: () async {

                                  print("question length : " +getQuestionContro .getQuestionList[0]['questions'].length.toString());
                                  print("question quecounter : " +getQuestionContro.quecounter.value.toString());
                                  if ((getQuestionContro .getQuestionList[0]['questions'].length-1) !=getQuestionContro.quecounter.value) {
                                    // toastMsg("next question", false);
                                    await getQuestionContro.updatequestion_next();

                                  }
                                  else {
                                    // toastMsg("No Question Left", true);
                                    var examD = widget.examId.toString();
                                    // print("attemptQUrl.....${examD}");
                                    // // categoryController.controllertimerstart();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReviewPage(
                                                exam_Ids: examD.toString())));
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height:
                                  MediaQuery.of(context).size.height * 0.05,
                                  margin: EdgeInsets.only(bottom: 20, top: 20,right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: primary),
                                  child: Text(
                                    ((getQuestionContro
                                        .getQuestionList[0]['questions']
                                        .length-1) !=
                                        getQuestionContro.quecounter.value )
                                        ? "Next "
                                        : "Finish",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins-Regular',
                                      color: white,
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          ),


                        ],
                      ),
                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

              );
            }
          }),
        ),
      ),
    );
  }
  String removeHtmlTags(String htmlString) {
    // Remove HTML tags
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' '); // Remove non-breaking space
  }


  ///for screenshot....
  String imagePath;
bool screenshotloader= false;
  Future<void> takeScreenShot(id) async {
    screenshotloader = true;
    setState((){});
    imagePath='';
    try {

      // Add a delay to ensure that the widget is fully rendered
      await Future.delayed(Duration(seconds: 1));

      // Capture the screenshot
      final boundary = previewContainer.currentContext.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      imagePath = '${directory.path}/screenshot${id}.png';
      log('screenShotPath==> $imagePath');
      screenshotloader = false;
      setState((){});
      // Write the screenshot to a file
      final imgFile = File(imagePath);
      await imgFile.writeAsBytes(pngBytes);

      log('Screenshot saved at: $imagePath');
    } catch (e) {
      screenshotloader = false;
      setState((){});
      log('Error capturing screenshot: $e');
    }
  }

}
