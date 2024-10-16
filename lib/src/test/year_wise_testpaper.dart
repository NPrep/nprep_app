import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/test/LeadershipScore.dart';

import 'package:n_prep/utils/colors.dart';

import '../../../Controller/Category_Controller.dart';
import '../../../constants/custom_text_style.dart';
import 'AllCommonTest_Ui.dart';
import 'Subject_wise_testpaper.dart';
import 'TestSeriesHistory.dart';




class YWTestPaper extends StatefulWidget {
  int indexslected ;
   YWTestPaper({Key key,this.indexslected});

  @override
  State<YWTestPaper> createState() => _YWTestPaperState();
}

class _YWTestPaperState extends State<YWTestPaper> with SingleTickerProviderStateMixin {
  TabController _controller;
  ExamController examController =Get.put(ExamController());
  SettingController settingController=Get.put(SettingController());

  var getExamUrl;
  // var examTypedata;
  // List Typedata=[];
  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(() {
        print('my index is' + _controller.index.toString());
        if(_controller.index==0){
          getTestData("1","");
        }else if(_controller.index==1){
          getTestDataMock("4","");
        }else if(_controller.index==2){
          getTestDataMock("2","");
        }
    });
if(widget.indexslected==3){

} else if(widget.indexslected==1){

}else{
  getTestData("1","");
}

    getSubjectData();

  }

  var page = 1;
  var limit = 100;
  var perentUrl;


  var typeId;
  getTestData(exam_type,subjectId) async {
    Map<String, String> queryParams;
    subjectId==''?
    queryParams = {
      'exam_type': exam_type,
    }:
    queryParams = {
      'exam_type': exam_type,
      'subject': subjectId,
    };
    log('queryParams==>'+queryParams.toString());
    String queryString = Uri(queryParameters: queryParams).query;
    var getExamUrl = apiUrls().exam_list_api + '?' + queryString;
    log('getExamUrl==>'+getExamUrl.toString());
   // getExamUrl = apiUrls().exam_list_api;
    await examController.GetExamData(getExamUrl);
    setState(() {

    });
  }
  getTestDataMock(exam_type,subjectId) async {
    Map<String, String> queryParams;
    subjectId==''?
    queryParams = {
      'exam_type': exam_type,
    }:
    queryParams = {
      'exam_type': exam_type,
      'subject': subjectId,
    };
    log('queryParams==>'+queryParams.toString());
    String queryString = Uri(queryParameters: queryParams).query;
    var getExamUrl = apiUrls().Mock_exam_list_api + '?' + queryString;
    log('getExamUrl==>'+getExamUrl.toString());
   // getExamUrl = apiUrls().exam_list_api;
    await examController.GetExamData2(getExamUrl,exam_type);
    setState(() {

    });
  }

  getSubjectData() async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    perentUrl = apiUrls().exam_subjects_categories_api + '?' + queryString;
    print("perentUrl==>" + perentUrl.toString());

    await examController.SubjectApi(perentUrl);
    log('parentData==>'+examController.SubjectData.toString());
    log('parentData==>'+examController.SubjectData['data']['data'].length.toString());
    if(widget.indexslected!=null){
      _controller.animateTo(widget.indexslected);
    }
  }



  var _tabs =[

    'PYQ',
    "Daily Test",
    "Mock",
    "Subject",


  ];
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;
    var mediaquary=MediaQuery.of(context);
    var    scale =mediaquary.textScaleFactor.clamp(1.10, 1.10);



    return DefaultTabController(
        length: 4,
  child: Scaffold(

    body: MediaQuery(
      child: Column(
        children: [
          Container(
            color: primary,
            child: TabBar(
              indicatorColor: white,

              controller: _controller,
              labelColor: white,
              // labelPadding: EdgeInsets.zero,
              labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
              // dragStartBehavior: DragStartBehavior.start,

              // physics: ScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // onTap: tabbarotap(),
              isScrollable: false,

              labelPadding: EdgeInsets.only(left: 10, right: 5),
              tabs: _tabs
                  .map((label) => Padding(
                padding:
                const EdgeInsets.only(right: 10),
                child: Tab(text: "$label"),
              ))
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                PYQListscroll(),
                DailyTestListscroll(),
                MockListscroll(),
                AllListSubject(size),


              ],
            ),
          ),
        ],
      ),
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

    ),
  ),
);

  }
  Widget PYQListscroll(){

   return GetBuilder<ExamController>(
        builder: (examController) {
          if(examController.getELoader.value){
            return Center(child: Padding(
              padding:  EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            ));
          }
          else {
            return examController.get_data['data'].length==0?Center(child: Text(examController.get_data['message'])):
            ListView.builder(
              itemCount: examController.get_data['data'].length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index1) {
                var yeardata = examController.get_data['data'][index1];
                return GestureDetector(
                  onTap: (){
                    log('my index is ONTAP' + _controller.index.toString());
                    Get.to(
                        AllCommonTest_Ui(Index1:index1 ,subjectName: yeardata['exam_year'],type:_controller.index ,)
                    );

                    },
                  child: Container(
                    padding:  EdgeInsets.all(1.0),
                    margin:  EdgeInsets.all(8.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: grey,width: 0.54)),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(1, -1),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey, // here for close state
                              colorScheme: ColorScheme.light(
                                primary: primary,
                              ), // here for open state in replacement of deprecated accentColor
                              dividerColor: Colors.transparent, // if you want to remove the border
                            ),
                            child: ListTile(

                              title: Text(
                                ' ${yeardata['exam_year']}' ,
                                style: TextStyle(color: black54, fontSize: 20,
                                    fontFamily: 'PublicSans',fontWeight: FontWeight.w400),
                              ),

                              trailing: Icon(Icons.arrow_forward_ios_rounded),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }


        }
    );
  }
  Widget MockListscroll(){
    return GetBuilder<ExamController>(
        builder: (examController) {
          if(examController.getELoader.value){
            return Center(child: Padding(
              padding:  EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            ));
          }
          else {
            return examController.get_data['data'].length==0?Center(child: Text(examController.get_data['message'])):
            ListView.builder(
              itemCount: examController.get_data['data'].length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index1) {
                var yeardata = examController.get_data['data'][index1];
                return GestureDetector(
                  onTap: (){
                    log('my index is ONTAP' + _controller.index.toString());
                    Get.to(AllCommonTest_Ui(Index1:index1 ,subjectName: yeardata['exam_year'],type:_controller.index ,));

                  },
                  child: Container(
                    padding:  EdgeInsets.all(1.0),
                    margin:  EdgeInsets.all(8.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: grey,width: 0.54)),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(1, -1),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey, // here for close state
                              colorScheme: ColorScheme.light(
                                primary: primary,
                              ), // here for open state in replacement of deprecated accentColor
                              dividerColor: Colors.transparent, // if you want to remove the border
                            ),
                            child: ListTile(

                              title: Text(
                                ' ${yeardata['exam_year']}' ,
                                style: TextStyle(color: black54, fontSize: 20,
                                    fontFamily: 'PublicSans',fontWeight: FontWeight.w400),
                              ),

                              // onExpansionChanged: (isExpanded) {
                              //   print('isExpanded....true.......${isExpanded}');
                              // },
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }


        }
    );
  }
  Widget DailyTestListscroll(){
    return GetBuilder<ExamController>(
        builder: (examController) {
          if(examController.getELoader.value){
            return Center(child: Padding(
              padding:  EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            ));
          }
          else {
            return examController.get_data['data'].length==0?Center(child: Text(examController.get_data['message'])):
            ListView.builder(
              itemCount: examController.get_data['data'].length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index1) {
                var yeardata = examController.get_data['data'][index1];
                return GestureDetector(
                  onTap: (){
                    log('my index is ONTAP' + _controller.index.toString());
                    Get.to(AllCommonTest_Ui(Index1:index1 ,subjectName: yeardata['exam_year'],type:_controller.index ,));

                  },
                  child: Container(
                    padding:  EdgeInsets.all(1.0),
                    margin:  EdgeInsets.all(8.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: grey,width: 0.54)),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(1, -1),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey, // here for close state
                              colorScheme: ColorScheme.light(
                                primary: primary,
                              ), // here for open state in replacement of deprecated accentColor
                              dividerColor: Colors.transparent, // if you want to remove the border
                            ),
                            child: ListTile(

                              title: Text(
                                ' ${yeardata['exam_year']}' ,
                                style: TextStyle(color: black54, fontSize: 20,
                                    fontFamily: 'PublicSans',fontWeight: FontWeight.w400),
                              ),

                              // onExpansionChanged: (isExpanded) {
                              //   print('isExpanded....true.......${isExpanded}');
                              // },
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }


        }
    );
  }
  Widget AllListSubject(size){
    return GetBuilder<ExamController>(
        builder: (examController) {
          if(examController.SubjectLoader.value){
            return Center(child: Padding(
              padding:  EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            ));
          }
          else{
            return ListView.builder(
                itemCount: examController.SubjectData['data']['data'].length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 8),
                // clipBehavior: Clip.none,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {

                  var subjectlistdata = examController.SubjectData['data']['data'][index];
                  return Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    child: GestureDetector(
                      onTap: () async {
                        await Get.to(SubjetWiseTestPaper(subjectId: subjectlistdata['id'],subjectName:subjectlistdata['category_name'] ,));
                        getSubjectData();
                      },
                      child: Card(
                        elevation: 5.0,
                        // color: subjectsData['id'].toString()=="43"? white:grey,
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color:textColor),),
                        child: Padding(
                          padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FadeInImage.assetNetwork(
                                      height: 50,
                                      width: 50,
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Container(

                                          // color: Colors.grey.shade300,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/nprep2_images/LOGO.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                          //   color: Colors.grey.shade300,),
                                        );
                                      },
                                      placeholder: "assets/nprep2_images/LOGO.png",
                                      image: subjectlistdata['image'].toString()),

                                  sizebox_width_5,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width-120,
                                        // color: Colors.red,
                                        child: Text(
                                          '${subjectlistdata['category_name']}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(0xFF6A6E70),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // sizebox_height_5,
                                      // Container(
                                      //   width: size.width-120,
                                      //   // color: Colors.red,
                                      //   child: Text(
                                      //     '${subjectsData['attempt_categories']}/${subjectsData['total_categories']} Videos',
                                      //     textAlign: TextAlign.justify,
                                      //     style: TextStyle(
                                      //         color: textColor,
                                      //         fontSize: 11,
                                      //         fontWeight: FontWeight.w400),
                                      //   ),
                                      // ),
                                    ],
                                  ),

                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                });
          }
        }
    );
  }
}
