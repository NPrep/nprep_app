import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/test/ExamReview_Page.dart';
import 'package:n_prep/utils/colors.dart';

import '../../Controller/Exam_Controller.dart';

class Exam_Menu extends StatefulWidget {
  PageController pagecontrl;
  int quecounter;
  var id;
  var exam_id;
  bool today = false;
   Exam_Menu({this.pagecontrl,this.quecounter,this.id,this.exam_id,@required this.today});

  @override
  State<Exam_Menu> createState() => _Exam_MenuState();
}

class _Exam_MenuState extends State<Exam_Menu> {



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: GetBuilder<ExamController>(
              builder: (examController) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                              Icons.close
                          )
                      ),
                      SizedBox(width: 15,)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                          examController.QuestionTitle.value,
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'PublicSans',
                              color: black54,
                              letterSpacing: 1)),
                    ),
                  ),
                  Container(
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
                              Text(examController.countvalue(examController.AttempSeenquestion.value).toString(),style: TextStyle(fontSize: 15,color: primary,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text("Attempted",style: TextStyle(fontSize: 14,color: Colors.grey.shade700))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                          child: VerticalDivider(color: grey,thickness: 0.9,),
                        ),
                        Container(
                          // color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(examController.countvalue(examController.Seenquestion.value).toString(),style: TextStyle(fontSize: 15,color: redBackgroundColor,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text("Skipped",style: TextStyle(fontSize: 14,color: Colors.grey.shade700))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                          child: VerticalDivider(color: grey,thickness: 0.9,),
                        ),
                        Container(
                          // color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(examController.countvalue(examController.NotSeenquestion.value).toString(),style: TextStyle(fontSize: 15,color: black54,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text("Not Visited",style: TextStyle(fontSize: 14,color: Colors.grey.shade700),)
                              ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text((examController.get_que_list[0]).toString()),
                  Expanded(
                      child:Container(
                        margin: EdgeInsets.all(10.0),


                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                              // width / height: fixed for *all* items
                              childAspectRatio: 1.80,
                            ),
                            itemCount: examController.get_que_list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  widget.pagecontrl.jumpToPage((index));
                                  Navigator.pop(context);

                                },
                                child: Container(
                                  // height: 2,
                                  // width: 2,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: examController.MenuQuestionList[index]==examController.Seenquestion?
                                        examController.MenuQuestionMarkReviewList[index]==examController.MarkReviewSeenquestion?
                                        AssetImage('assets/nprep2_images/question_purpel.png'):
                                        AssetImage('assets/nprep2_images/question_red.png'):
                                        examController.MenuQuestionList[index]==examController.AttempSeenquestion?
                                        examController.MenuQuestionMarkReviewList[index]==examController.MarkReviewSeenquestion?
                                        AssetImage('assets/nprep2_images/question_purpelgreen.png'):
                                        AssetImage('assets/nprep2_images/question_green.png'):

                                        AssetImage('assets/nprep2_images/question_white.png',),
// scale: 0.8,
                                        fit: BoxFit.contain,
                                      ),

                                      // color: examController.get_que_list[index]['is_attempt']==1?(examController.get_que_list[index]['your_answer'].toString()==examController.get_que_list[index]['correct_answer'].toString())?ansBackgroundColor:redBackgroundColor:grey

                                    ),

                                    child: Text((index+1).toString(),style: TextStyle(fontSize: 11),),

                                ),
                              );
                            }),
                      )
                  ),
                  GestureDetector(
                    onTap: () async{

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
                                                    var examansUrl;
                                                    if(examController.type==4||examController.type==2) {
                                                       examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api +widget.id.toString();
                                                    }else{
                                                      examansUrl = apiUrls().Copy_exam_ans_attempt_api +widget.id.toString();
                                                    }
                                                    if((examController.sessionCount-1)==examController.dailysectionData['data'].length) {
                                                      var examBody = jsonEncode({
                                                        'answer_data': examController.Copy_get_que_list
                                                      });
                                                      log("examBody skip...." +examBody.toString());
                                                      log("examBody skip...." +examansUrl.toString());
                                                      await examController.ExamAnswerData(examansUrl, examBody);

                                                      setState(() {});

                                                      Navigator.pushReplacement(
                                                          context,MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExamReviewPage(
                                                                  exam_Ids: widget.id,
                                                                  exam_Id: widget.exam_id,today: widget.today,
                                                                  pageId: 2)
                                                      ));
                                                    }
                                                    else{
                                                      widget.quecounter =0;

                                                      await examController.sessionIncrement();
                                                      ///navigate screen into another page and delete current page
                                                      setState(() {
                                                        Navigator.of(context).pop();
                                                      });
                                                    }


                                                    stfSetState((){});
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
                          var examansUrl;
                          if(examController.type==1||examController.type==2) {
                            examansUrl = apiUrls().Mock_Copy_exam_ans_attempt_api +widget.id.toString();
                          }else{
                            examansUrl = apiUrls().Copy_exam_ans_attempt_api +widget.id.toString();
                          }                          var examBody = jsonEncode({
                            'answer_data': examController.Copy_get_que_list
                          });
                          log("examBody skip...."+examBody.toString());
                          log("examBody skip...."+examansUrl.toString());
                          await examController.ExamAnswerData(examansUrl, examBody);

                          setState((){});
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => ExamReviewPage(exam_Ids:widget.id,exam_Id: widget.exam_id,today: widget.today,
                                      pageId:2)));
                        }





                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: examController.ontap_answer[widget.quecounter]==true?
                      size.width*0.3:size.width * 0.6,
                      height: size.height * 0.05,
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: primary),
                      child: Text(

                        examController.dailysection==true?
                        "Submit Section ${examController.sessionCount+1}":
                        "Submit Test",
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
              );
            }
          )
      ),
    );
  }
}

