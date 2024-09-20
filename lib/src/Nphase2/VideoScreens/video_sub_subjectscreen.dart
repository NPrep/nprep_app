import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/App_update/App_BuySubcription.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/src/Nphase2/Constant/nprep_2_custom_timeline.dart';
import 'package:n_prep/src/Nphase2/Constant/textstyles_constants.dart';
import 'package:n_prep/src/Nphase2/Controller/VideoSUBSubjectController.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SubSubjectScreen extends StatefulWidget {
  var Catname;
  var showprmpt;
  var showDilog;

  var Catparentid;
  SubSubjectScreen({this.Catname,this.Catparentid,this.showprmpt,this.showDilog});

  @override
  State<SubSubjectScreen> createState() => _SubSubjectScreenState();
}

class _SubSubjectScreenState extends State<SubSubjectScreen> with SingleTickerProviderStateMixin {
  TabController tabController;

  VideoSubsubjectcontroller videosubsubjectcontroller =Get.put(VideoSubsubjectcontroller());

  ItemScrollController _scrollControllernew = ItemScrollController();

  scrolledddd(selectindex) {
    print("check scroll : "+selectindex.toString());
    try{
      // myScrollController.jumpTo(double.parse(selectindex.toString()));
      // _scrollControllernew.animateScroll(offset: 100, duration: Duration(seconds: 1));
      // _scrollControllernew.jumpTo(index: selectindex,);
      _scrollControllernew.scrollTo(index: selectindex,duration: Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }catch(e){
      print("check scroll : "+e.toString());
    }


    // _scrollController.animateTo(
    //   selectindex * 100.0,
    //   // Multiply by item height to scroll to the correct position
    //   duration: Duration(milliseconds: 500),
    //   // Adjust the duration as per your preference
    //   curve: Curves.easeInOut, // Adjust the scroll animation curve as per your preference
    // );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      print('my index is' + tabController.index.toString());

      videosubsubjectcontroller.updateFetchSubSubjectData(tabController.index);
    });
    videosubsubjectcontroller.catparentId.value =int.parse(widget.Catparentid.toString());
    videosubsubjectcontroller.FetchSubSubjectData();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
      statusBarColor: Color(0xFF64C4DA), // status bar color
    ));
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
          statusBarColor: Color(0xFF64C4DA), // status bar color
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                bottomindex: 3,
              )),
        );

        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                  statusBarColor: Color(0xFF64C4DA), // status bar color
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBar(
                        bottomindex: 3,
                      )),
                );
              },
              icon: Icon(Icons.chevron_left,size: 30,color: white,),
            ),
            actions: [
              GetBuilder<VideoSubsubjectcontroller>(
                  builder: (videosubsubjectcontroller) {
                    if (videosubsubjectcontroller.VideoSubsubjectloader.value) {
                      return CircularProgressIndicator();
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () async {
                          // final RelativeRect position = buttonMenuPosition(context);
                          showMenu(context: context,
                              constraints:  BoxConstraints.expand(
                                  width: 200, height: videosubsubjectcontroller.VideoSubsubjectdata[0]['second_level'].length==1?60:videosubsubjectcontroller.VideoSubsubjectdata[0]['second_level'].length==2?110:200),
                              position: RelativeRect.fromLTRB(10, 80, 2, 0),
                              items:
                              List.generate( videosubsubjectcontroller.VideoSubsubjectdata[0]['second_level'].length, (index1){
                                return PopupMenuItem<int>(
                                  value: index1,
                                  onTap: (){
                                    scrolledddd(index1);
                                  },
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        videosubsubjectcontroller.VideoSubsubjectdata[0]['second_level']
                                        [index1]['category_name']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),

                                      Text(
                                        "${videosubsubjectcontroller.VideoSubsubjectdata[0]['second_level']
                                        [index1]['total_categories'].toString()} videos",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: grey,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      sizebox_height_10,
                                    ],
                                  ),
                                );
                              })

                          );






                        },
                        child: Row(
                          children: [
                            Container(height: 30,width: 50,color: primary,),
                            Icon(
                              Icons.format_list_bulleted,
                              color: white,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              )
            ],
            centerTitle: true,
            title: Text("${widget.Catname} ",style: AppbarTitleTextyle,),
            backgroundColor: primary,
            bottom: TabBar(
              labelColor: white,
              controller: tabController,
              //labelPadding: EdgeInsets.only(right: 20),
              physics: const NeverScrollableScrollPhysics(),
              // onTap: tabbarotap(),
              isScrollable: false,
              labelStyle: AppbarTabLableTextyle,
              dragStartBehavior: DragStartBehavior.start,
              indicatorColor: white,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Paused'),
                Tab(text: 'Unattempted'),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AllListscroll(height,size),
              AllAttemptedList(height,size),
              AllUnAttemptedList(height,size),
            ],
          ),
        ),

      ),
    );

  }
  Widget AllListscroll(height,size ){
      return GetBuilder<VideoSubsubjectcontroller>(
          builder: (videosubsubjectcontroller) {
            if (videosubsubjectcontroller.VideoSubsubjectloader.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Center(child: CircularProgressIndicator(color: primary,)),
                  SizedBox(height: 5,),
                  Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                  Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                      color: primary,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600
                  )),

                ],
              );
            }
            else
              return Container(

                margin: EdgeInsets.only(left: 12,right: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding:EdgeInsets.only(top: height*0.02),
                        child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['attempt_categories']}/${videosubsubjectcontroller.VideoSubsubjectdata[0]['total_categories']} Videos  watched",style: PauseWatchedTextyle,),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top: height*0.02),
                        child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_name']??"Title"}",style: teacherNameTextyle,),
                      ),

                      Padding(
                        padding:EdgeInsets.only(top: height*0.01),
                        child: ReadMoreText(
                          '${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_about']??"About"}',
                          textAlign: TextAlign.justify,
                          // style: teacherDescriptionTextyle,
                          trimLines: 4,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read More',
                          trimExpandedText: '  Read Less',
                          moreStyle: teacherDescriptionTextyle,
                          lessStyle: teacherDescriptionTextyle,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: size.height-300,
                        // color: Colors.red,
                        child: RefreshIndicator(
                          displacement: 80,
                          backgroundColor:primary,
                          color: white,
                          strokeWidth: 3,
                          triggerMode: RefreshIndicatorTriggerMode.onEdge,
                          onRefresh: () async {
                            await Future.delayed(Duration(milliseconds: 1500));
                            // getdata();
                          },
                          child: videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length==0?
                          Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Hold Tight!\n",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                              Text("${widget.Catname} Lectures are \ncoming out soon!\n\n Tabtak, keep working hard!",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                            ],
                          )):
                          ScrollablePositionedList.builder(

                            itemScrollController: _scrollControllernew,
                            itemCount:  videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length,
                            itemBuilder: (context, index) {
                              var cat = videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'][index];
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(top: 8.0,left: 8),
                                      child: Text(
                                        cat['category_name'].toUpperCase() ?? "",
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          color: black54,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                    ),
                                    Column(
                                        children: (cat['sub_category'] as List).map((data) {
                                          final subcategoryIndex = (cat['sub_category'] as List)
                                              .indexOf(data) + 1;
                                          // log("Datta>>"+data['image'].toString());
                                          return GestureDetector(
                                            onTap: () async {
                                            if(data['is_subscribe']==true){
                                              if(data['is_allow']==true){
                                                // toastMsg("No Video Allowed", false);
                                                // if(widget.showDilog==true){
                                                //   Get.dialog(MyDialogSub());
                                                // }else{
                                                //   Get.to(SubscriptionPlan());
                                                // }
                                                var sabcatid = data['id'];
                                                var cate_names = data['category_name'];
                                                var perent_id = cat['category_name'];

                                                print("data......"+data.toString());
                                                print("sabcatid......"+sabcatid.toString());
                                                print("cate_names......"+cate_names.toString());
                                                print("perent_id......"+perent_id.toString());

                                                 Get.to(VideoDetailScreen(CatId: sabcatid));

                                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                                  systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                                                  statusBarColor: Color(0xFF000000), // status bar color
                                                ));
                                              }
                                              else{
                                                Get.dialog(MyDialogSub());

                                              }
                                            }else{
                                              Get.to(SubscriptionPlan());
                                            }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: 0),
                                              child: Nprep2CustomTimeline(
                                                step: subcategoryIndex,
                                                image: data['image'],
                                                isLast: true,
                                                isFirst: true,
                                                attemptdate:data['attempt_date'],
                                                mcq: data['video_time'],
                                                noofattemp:data['attempt_videos'] ,
                                                questionnoofattemp: data['attempt_videos'] ,
                                                examstatus:data['video_status'] ,
                                                topic: data['category_name'],
                                                status: data['attempt_videos']
                                                    .toString() +
                                                    "/" +
                                                    data['total_videos'].toString(),
                                                label: data['fee_type'],
                                                labelColor: data['fee_type'].toString() ==
                                                    '2'
                                                    ? Colors.orange
                                                    : Colors.indigo.shade700,
                                              ),
                                            ),
                                          );
                                        }).toList()),

                                  ]);
                            },
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              );
          }
      );
  }
  Widget AllAttemptedList(height,size ){
    return GetBuilder<VideoSubsubjectcontroller>(
        builder: (videosubsubjectcontroller) {
          if (videosubsubjectcontroller.VideoSubsubjectloader.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Center(child: CircularProgressIndicator(color: primary,)),
                SizedBox(height: 5,),
                Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                    color: primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600
                )),
              ],
            );
          }
          else
            return Container(

              margin: EdgeInsets.only(left: 12,right: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top: height*0.02),
                      child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['attempt_categories']}/${videosubsubjectcontroller.VideoSubsubjectdata[0]['total_categories']} Videos  watched",style: PauseWatchedTextyle,),
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: height*0.02),
                      child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_name']??"Title"}",style: teacherNameTextyle,),
                    ),

                    Padding(
                      padding:EdgeInsets.only(top: height*0.01),
                      child: ReadMoreText(
                        '${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_about']??"About"}',
                        textAlign: TextAlign.justify,
                        // style: teacherDescriptionTextyle,
                        trimLines: 4,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read More',
                        trimExpandedText: '  Read Less',

                        moreStyle: teacherDescriptionTextyle,
                        lessStyle: teacherDescriptionTextyle,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: size.height-300,
                      child: RefreshIndicator(
                        displacement: 80,
                        backgroundColor:primary,
                        color: white,
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        onRefresh: () async {
                          await Future.delayed(Duration(milliseconds: 1500));
                          // getdata();
                        },
                        child: videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length==0?
                       // Center(child: Text("There is no paused video modules for ${widget.Catname}")):
                        Center(child: Text("There are no paused video modules for ${widget.Catname}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)):

                        ScrollablePositionedList.builder(

                          itemScrollController: _scrollControllernew,
                          itemCount:  videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length,
                          itemBuilder: (context, index) {
                            var cat = videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'][index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.only(top: 8.0,left: 8),
                                    child: Text(
                                      cat['category_name'].toUpperCase() ?? "",
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        color: black54,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                    ),
                                  ),
                                  Column(
                                      children: (cat['sub_category'] as List).map((
                                          data) {
                                        final subcategoryIndex = (cat['sub_category'] as List)
                                            .indexOf(data) + 1;
                                        return GestureDetector(
                                          onTap: () async {

                                            if(data['is_subscribe']==true){
                                              if(data['is_allow']==true){
                                                // toastMsg("No Video Allowed", false);
                                                // if(widget.showDilog==true){
                                                //   Get.dialog(MyDialogSub());
                                                // }else{
                                                //   Get.to(SubscriptionPlan());
                                                // }
                                                var sabcatid = data['id'];
                                                var cate_names = data['category_name'];
                                                var perent_id = cat['category_name'];

                                                print("sabcatid......"+data.toString());
                                                print("sabcatid......"+sabcatid.toString());
                                                print("cate_names......"+cate_names.toString());
                                                print("perent_id......"+perent_id.toString());

                                                 Get.to(VideoDetailScreen(CatId: sabcatid,VideoDuration:data['pause_duration'] ,));

                                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                                  systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                                                  statusBarColor: Color(0xFF000000), // status bar color
                                                ));
                                              }
                                              else{
                                                Get.dialog(MyDialogSub());

                                              }
                                            }
                                            else{
                                              Get.to(SubscriptionPlan());
                                            }




                                          },
                                          child: Container(

                                            margin: EdgeInsets.only(right: 0),
                                            child: Nprep2CustomTimeline(
                                              step: subcategoryIndex,
                                              image: data['image'],
                                              isLast: true,
                                              isFirst: true,
                                              attemptdate:data['attempt_date'],
                                              mcq: data['video_time'],
                                              noofattemp:data['attempt_videos'] ,
                                              questionnoofattemp: data['attempt_videos'] ,
                                              examstatus:data['video_status'] ,
                                              topic: data['category_name'],
                                              status: data['attempt_videos']
                                                  .toString() +
                                                  "/" +
                                                  data['total_videos'].toString(),
                                              label: data['fee_type'],
                                              labelColor: data['fee_type'].toString() ==
                                                  '2'
                                                  ? Colors.orange
                                                  : Colors.indigo.shade700,
                                            ),
                                          ),
                                        );
                                      }).toList())
                                ]);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
        }
    );
  }
  Widget AllUnAttemptedList(height,size ){
    return GetBuilder<VideoSubsubjectcontroller>(
        builder: (videosubsubjectcontroller) {
          if (videosubsubjectcontroller.VideoSubsubjectloader.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Center(child: CircularProgressIndicator(color: primary,)),
                SizedBox(height: 5,),
                Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                    color: primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600
                )),
              ],
            );
          }
          else
            return Container(

              margin: EdgeInsets.only(left: 12,right: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top: height*0.02),
                      child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['attempt_categories']}/${videosubsubjectcontroller.VideoSubsubjectdata[0]['total_categories']} Videos  watched",style: PauseWatchedTextyle,),
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: height*0.02),
                      child: Text("${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_name']??"Title"}",style: teacherNameTextyle,),
                    ),

                    Padding(
                      padding:EdgeInsets.only(top: height*0.01),
                      child: ReadMoreText(
                        '${videosubsubjectcontroller.VideoSubsubjectdata[0]['lecturer_content']['lecturer_about']??"About"}',
                        textAlign: TextAlign.justify,
                        // style: teacherDescriptionTextyle,
                        trimLines: 4,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read More',
                        trimExpandedText: '  Read Less',
                        moreStyle: teacherDescriptionTextyle,
                        lessStyle: teacherDescriptionTextyle,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: size.height-300,
                      child: RefreshIndicator(
                        displacement: 80,
                        backgroundColor:primary,
                        color: white,
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        onRefresh: () async {
                          await Future.delayed(Duration(milliseconds: 1500));
                          // getdata();
                        },
                        child: videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length==0?
                       // Center(child: Text("There is no unattempted video modules for ${widget.Catname}")):
                        Center(child: Text("There are no unattempted video modules for ${widget.Catname}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)):

                        ScrollablePositionedList.builder(

                          itemScrollController: _scrollControllernew,
                          itemCount:  videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'].length,
                          itemBuilder: (context, index) {
                            var cat = videosubsubjectcontroller.VideoSubsubjectdata[0]['third_level'][index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.only(top: 8.0,left: 8),
                                    child: Text(
                                      cat['category_name'].toUpperCase() ?? "",
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        color: black54,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins-Regular',
                                      ),
                                    ),
                                  ),
                                  Column(
                                      children: (cat['sub_category'] as List).map((
                                          data) {
                                        final subcategoryIndex = (cat['sub_category'] as List)
                                            .indexOf(data) + 1;
                                        return GestureDetector(
                                          onTap: () async {

                                            if(data['is_subscribe']==true){
                                              if(data['is_allow']==true){
                                                // toastMsg("No Video Allowed", false);
                                                // if(widget.showDilog==true){
                                                //   Get.dialog(MyDialogSub());
                                                // }else{
                                                //   Get.to(SubscriptionPlan());
                                                // }
                                                var sabcatid = data['id'];
                                                var cate_names = data['category_name'];
                                                var perent_id = cat['category_name'];

                                                print("sabcatid......"+sabcatid.toString());
                                                print("cate_names......"+cate_names.toString());
                                                print("perent_id......"+perent_id.toString());

                                                 Get.to(VideoDetailScreen(CatId: sabcatid));

                                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                                  systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                                                  statusBarColor: Color(0xFF000000), // status bar color
                                                ));
                                              }
                                              else{
                                                Get.dialog(MyDialogSub());

                                              }
                                            }else{
                                              Get.to(SubscriptionPlan());
                                            }
                                            // var sabcatid = data['id'];
                                            // var cate_names = data['category_name'];
                                            // var perent_id = cat['category_name'];
                                            //
                                            // print("sabcatid......"+sabcatid.toString());
                                            // print("cate_names......"+cate_names.toString());
                                            // print("perent_id......"+perent_id.toString());
                                            //



                                          },
                                          child: Container(

                                            margin: EdgeInsets.only(right: 0),
                                            child: Nprep2CustomTimeline(
                                              step: subcategoryIndex,
                                              image: data['image'],
                                              isLast: true,
                                              isFirst: true,
                                              attemptdate:data['attempt_date'],
                                              mcq: data['video_time'],
                                              noofattemp:data['attempt_videos'] ,
                                              questionnoofattemp: data['attempt_videos'] ,
                                              examstatus:data['video_status'] ,
                                              topic: data['category_name'],
                                              status: data['attempt_videos']
                                                  .toString() +
                                                  "/" +
                                                  data['total_videos'].toString(),
                                              label: data['fee_type'],
                                              labelColor: data['fee_type'].toString() ==
                                                  '2'
                                                  ? Colors.orange
                                                  : Colors.indigo.shade700,
                                            ),
                                          ),
                                        );
                                      }).toList())
                                ]);
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
        }
    );
  }

}
