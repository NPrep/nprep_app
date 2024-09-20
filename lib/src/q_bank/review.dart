import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Review_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/indicator.dart';
import 'package:n_prep/src/q_bank/subcat_qbank.dart';
import 'package:n_prep/utils/colors.dart';

class ReviewPage extends StatefulWidget {
  final bool skip;
  final bool pagestatus;
  var exam_Ids;
  var pageId;
  ReviewPage({Key key,this.pagestatus, this.skip,this.exam_Ids,this.pageId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  var get_testUrl ;
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
            value: double.parse(reviewController.test_review_data['data']['correct_questions'].toString()),
            title: '${double.parse(reviewController.test_review_data['data']['correct_questions'].toString()).toStringAsFixed(1)}%',
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
            value: double.parse(reviewController.test_review_data['data']['incorrect_questions'].toString()),
            title: '${double.parse(reviewController.test_review_data['data']['incorrect_questions'].toString()).toStringAsFixed(1)}%',
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
            value: double.parse( reviewController.test_review_data['data']['skipped_questions'].toString()),
            title: '${double.parse( reviewController.test_review_data['data']['skipped_questions'].toString()).toStringAsFixed(1)}%',
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




  getTestReview() async {
    Map<String, String> queryParams = {
      'exam_id': widget.exam_Ids.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    get_testUrl = apiUrls().test_review_api+ '?' + queryString;
    print("get_testUrl...." + get_testUrl.toString());

    await reviewController.GetTestResultData(get_testUrl);
    // dataMap ={
    //   "Right Answer": double.parse(reviewController.test_review_data['data']['correct_questions'].toString()),
    //   "Wrong Answer": double.parse(reviewController.test_review_data['data']['incorrect_questions'].toString()),
    //   "Unanswered": double.parse( reviewController.test_review_data['data']['skipped_questions'].toString()),
    // };
    setState((){});
  }


  @override
  void initState() {
    super.initState();
    getTestReview();
    print("examID...."+widget.exam_Ids.toString());
    print("pageId...."+widget.pageId.toString());


  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.pagestatus==true){
          Navigator.popUntil(context, ModalRoute.withName("Foo"));

        }else{
          var perent_Id=   sprefs.getString("perent_Id");
          var catName = sprefs.getString("catName");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Subcategory(perentId: perent_Id.toString(),
              categoryName: catName.toString(),categorytype: 1,)),
          );
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(

            children: [
              // Check if showBackIcon is true
              GestureDetector(
                onTap: () {
                  if(widget.pagestatus==true){
                    Navigator.popUntil(context, ModalRoute.withName("Foo"));

                  }else{
                    var perent_Id=   sprefs.getString("perent_Id");
                    var catName = sprefs.getString("catName");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Subcategory(perentId: perent_Id.toString(),
                        categoryName: catName.toString(),categorytype: 1,)),
                    );
                  }
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
              if(reviewController.testreviewLoading.value){
                return Center(child: CircularProgressIndicator());
              }

              return reviewController.test_review_data['data'].length==0?Center(
                child: Text("No Data Found"),
              ):SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.only(top: 10, left: 10, right: 10),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.6,

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
                        Container(
                          margin: EdgeInsets.only(left: 5,right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Indicator(
                                color:  Color(0xFFC8EC92),
                                text: 'Right Answer',
                                isSquare: true,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Indicator(
                                color:Colors.red.shade200,
                                text: 'Wrong Answer',
                                isSquare: true,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Indicator(
                                color:  Colors.grey,
                                text: 'Unanswered',
                                isSquare: true,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              // Indicator(
                              //   color: Color(0xFF39CF75),
                              //   text: 'Mutual Funds',
                              //   isSquare: true,
                              // ),
                              // SizedBox(
                              //   height: 18,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      itemCount: reviewController.test_review_data['data']['attempt_questions'].length,
                      // Replace 'options.length' with the actual number of options
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final optionIndex = String.fromCharCode(97 +
                            index);
                        var exam_result_data =reviewController.test_review_data
                        ['data']['attempt_questions'][index];

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
                                                  fontFamily: 'PublicSans',
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
                                                      fontFamily: 'PublicSans',
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
                                                    fontFamily: 'PublicSans',
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
                                exam_result_data['ans_description'].toString()=="null"?
                                Container():GestureDetector(
                                  onTap: (){
                                    reviewController.callagainindex(index);
                                  },
                                  child: Container(

                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        reviewController.review_truefalse[index]==true?"Hide":"See Rationale: ",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration
                                                .underline,
                                            fontWeight:
                                            FontWeight.bold),
                                      )),
                                ),
                                reviewController.review_truefalse[index]==true?
                                exam_result_data['ans_description'].toString()=="null"?Container():
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      exam_result_data['ans_description_attachment'].toString() ==
                                          "null"
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
    );
  }
}
