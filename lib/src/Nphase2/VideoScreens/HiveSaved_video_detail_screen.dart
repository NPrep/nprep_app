

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/src/Nphase2/Controller/VideoDetailController.dart';
import 'package:n_prep/src/Nphase2/Controller/custom_controls_widget.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/HiveVideoStampsModel.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';


import '../../../main.dart';




class HiveSavedVideoDetailScreen extends StatefulWidget {
  var index;
  var title;
  HiveSavedVideoDetailScreen({this.index, this.title});


  @override
  State<StatefulWidget> createState() {
    return _HiveSavedVideoDetailScreenState();
  }
}


class _HiveSavedVideoDetailScreenState extends State<HiveSavedVideoDetailScreen> with  TickerProviderStateMixin  {
  TabController tabController;
  VideoDetailcontroller videoDetailcontroller = Get.put(VideoDetailcontroller());
  bool buttonpress = false;
  bool VideoDetailloader = false;
  ChewieController Hive_betterPlayerController;
  VideoPlayerController Hive_betterPlayerController_videoplayer;
  // List VideoStamps=[
  //   {
  //     "video_id": 173,
  //     "title": "Introduction to Nursing",
  //     "time": "00:02:04",
  //     "status": 1,
  //     "deleted_at": null
  //   },
  //   {
  //     "video_id": 173,
  //     "title": "Nursing theories",
  //     "time": "00:11:06",
  //     "status": 1,
  //     "deleted_at": null
  //   },
  //   {
  //     "video_id": 173,
  //     "title": "Ethics",
  //     "time": "00:17:52",
  //     "status": 1,
  //     "deleted_at": null
  //   },
  //   {
  //     "video_id": 173,
  //     "title": "Tort",
  //     "time": "00:25:25",
  //     "status": 1,
  //     "deleted_at": null
  //   },
  //   {
  //     "video_id": 173,
  //     "title": "Vital Signs",
  //     "time": "00:41:35",
  //     "status": 1,
  //     "deleted_at": null
  //   },
  //   {
  //     "video_id": 173,
  //     "title": "Vital Signs - Temperature",
  //     "time": "00:44:15",
  //     "status": 1,
  //     "deleted_at": null
  //   }
  // ];
  File file;


  @override
  void initState() {
    super.initState();
    getdata();
    getvideoFlag();
  }


  getdata() async {
    tabController = TabController(length: 2, vsync: this);




    log("videonotes before> "+videodatatasks[widget.index].videonotes.toString());
    log("videonotes before> "+videodatatasks[widget.index].videopath.toString());
    log("videonotes before> "+videodatatasks[widget.index].videostamps);



    // log("model after> "+model.);


    HivevideoPlayer(videodatatasks[widget.index].videopath, videodatatasks[widget.index].videokey);
    setState(() {});


    // VideoStamps = HivevideoData.videoStamps;


  }


  getvideoFlag() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // _controller.play();
  }


  HivevideoPlayer(videourl, videoid) async {
    VideoDetailloader = true;
    setState(() {


    });
    // if(Environment.videoduration!=null){
    //   var data = Environment.videoduration;
    //   log("show data : "+data.toString());
    //   HivebetterPlayerController.seekTo(Duration(
    //       hours:int.parse(data.toString().split(":")[0]) ,
    //       minutes: int.parse(data.toString().split(":")[1]),
    //       seconds:int.parse(data.toString().split(":")[2].split(".")[0]) ));
    // }
    log("HivevideoPlayer videourl>> "+videourl.toString());
    File file = File(videourl);
    if (await file.exists()) {
      print('Video downloaded successfully: $videourl');
    } else {
      print('Failed to download video.');
    }
    try{
      Hive_betterPlayerController_videoplayer = VideoPlayerController.file(
          File(videourl)
      );
      try {
        await Hive_betterPlayerController_videoplayer.initialize();
      } catch (e) {
        log("Video Initialization Error: $e");
      }


      Hive_betterPlayerController = ChewieController(
          videoPlayerController: Hive_betterPlayerController_videoplayer,
          autoPlay: false,
          looping: false,
          allowMuting: false,
          fullScreenByDefault: false,
          showControls: false
      );


      VideoDetailloader=false;


      setState(() {


      });
    }
    catch(e){
      VideoDetailloader=false;
      setState(() {


      });
      log("HivevideoPlayer Exception>> "+e.toString());
    }
  }


  Duration _parseTime(String timeString) {
    List<String> parts = timeString.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }


  bool Savevideo_showColorLabels(time,end_time) {
    // Duration currentPosition = event.parameters['duration'];

  print("hello ${time.runtimeType}");


    Duration currentPosition = _parseTime(Hive_betterPlayerController_videoplayer.value.position.toString().split(".")[0]);


    Duration startTime = _parseTime(time);
    Duration endTime = _parseTime(end_time);
    log("timee>> currentPosition>> "+currentPosition.toString());
    log("timee>> startTime>> "+startTime.toString());
    log("timee>> endTime>> "+endTime.toString());
    if (currentPosition > startTime && currentPosition < endTime) {
      // Display label




      // update();
      return true;


    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Hive_betterPlayerController_videoplayer.dispose();
    Hive_betterPlayerController.dispose();
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var sheight = MediaQuery.of(context).size.height;
    var swidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Colors.white, // Change the icon color here
        //   ),
        //   centerTitle: true,
        //   title: Text(
        //     widget.title ?? "",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        body: GetBuilder<VideoDetailcontroller>(builder: (videoDetailcontroller) {
          if (VideoDetailloader==true) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    )),
                SizedBox(
                  height: 5,
                ),
                // Get.find<SettingController>()
                //             .settingData['data']['general_settings']['quotes']
                //             .length ==
                //         0
                //     ? Text("")
                //     : Text(
                //         Get.find<SettingController>()
                //             .settingData['data']['general_settings']['quotes'][
                //                 random.nextInt(Get.find<SettingController>()
                //                     .settingData['data']['general_settings']
                //                         ['quotes']
                //                     .length)]
                //             .toString(),
                //         textAlign: TextAlign.justify,
                //         style: TextStyle(
                //           color: primary,
                //         ),
                //       ),
              ],
            );
          }
          else {
            // return videoDetailcontroller.VideoDetailStatusCode == 401 ||
            //         videoDetailcontroller.VideoDetailStatusCode == 404
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Container(
            //             width: size.width,
            //             child: Text(
            //               '${videoDetailcontroller.VideoDetailErrorMSg}',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: primary,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 18,
            //                 // fontWeight: FontWeight.bold
            //               ),
            //             ),
            //           ),
            //           // Center(child: CircularProgressIndicator(color: primary,)),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Get.find<SettingController>()
            //                       .settingData['data']['general_settings']
            //                           ['quotes']
            //                       .length ==
            //                   0
            //               ? Text("")
            //               : Text(
            //                   '"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                       color: primary,
            //                       letterSpacing: 0.5,
            //                       fontWeight: FontWeight.w600)),
            //         ],
            //       )
            //     :
            return videoDetailcontroller.isInSmallMode == true
                ? Stack(
              children: [
                PDFView(
                  // fitEachPage: true,
                  filePath: videodatatasks[widget.index].videonotes,
                  enableSwipe: true,
                  fitEachPage: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  pageSnap: false,
                  defaultPage: videoDetailcontroller.currentPage,
                  // fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation:
                  false,
                  onRender: (_pages) {
                    setState(() {
                      videoDetailcontroller.pages = _pages;
                      videoDetailcontroller.isReady = true;


                    });
                  },
                  onError: (error) {
                    setState(() {
                      videoDetailcontroller.errorMessage =
                          error.toString();
                    });
                    print("Check pdf path>> " + error.toString());
                  },
                  onPageError: (page, error) {
                    setState(() {
                      videoDetailcontroller.errorMessage =
                      '$page: ${error.toString()}';
                    });
                    print(
                        'Check >> Error PDF > $page: ${error.toString()}');
                  },
                  onViewCreated:
                      (PDFViewController pdfViewController) {
                    // videoDetailcontroller.controllerpdfview
                    //     .complete(pdfViewController);
                  },
                  onLinkHandler: (String uri) {
                    print('goto uri: $uri');
                  },
                  onPageChanged: (int page, int total) {
                    print('page change: $page/$total');
                    setState(() {
                      videoDetailcontroller.currentPage = page;
                      videoDetailcontroller.TotalPage = total;
                    });
                  },
                ),
                Positioned(
                    top: 75,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(FullPage());
                        videoDetailcontroller.updatevideoscreen();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.2),
                            borderRadius:
                            BorderRadius
                                .circular(50),
                            border: Border.all(
                                color: primary)),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.2),
                              borderRadius:
                              BorderRadius
                                  .circular(50),
                              border: Border.all(
                                  color: primary)),
                          child: Image.asset("assets/nprep2_images/zoom_out.png",scale: 35,),
                          // child: Icon(
                          //   Icons.code,
                          //   size: 25,
                          //   color: Colors.black,
                          // ),
                        ),
                      ),
                    )),
                GestureDetector(
                  onPanUpdate: (details) {




                    setState(() {
                      videoDetailcontroller.dragAlignment += Alignment(
                        details.delta.dx / (swidth / 2),
                        details.delta.dy / (sheight / 2),
                      );
                      // Ensure the position stays within the bounds of the screen
                      videoDetailcontroller.dragAlignment =
                          Alignment(
                            videoDetailcontroller.dragAlignment.x
                                .clamp(-1.0, 1.0),
                            videoDetailcontroller.dragAlignment.y
                                .clamp(-1.0, 1.0),
                          );
                    });
                  },
                  onPanEnd: (details) =>
                      videoDetailcontroller.runAnimation(
                          details.velocity.pixelsPerSecond, size),
                  child: Align(
                    alignment: videoDetailcontroller.dragAlignment,
                    child: Container(
                      height: size.height * 0.2-50,
                      width: size.width * 0.5,
                      // color: Colors.pink,
                      padding: EdgeInsets.all(0.0),
                      child: Stack(
                        children: [
                          CustomControlsWidget(controller:Hive_betterPlayerController ,videocontroller: Hive_betterPlayerController_videoplayer,hiveornot: true),
                          Positioned(
                              top: double.parse(videoDetailcontroller.top_post_small.value.toString()),
                              right: double.parse(videoDetailcontroller.right_post_small.value.toString()),
                              child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: double.parse(videoDetailcontroller.top_post.value.toString()),
                  right: double.parse(videoDetailcontroller.right_post.value.toString()),


                  child: Container(
                    // height: 35,
                    // width: 35,


                    child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
                  ),
                ),
              ],
            ):
            Column(
              children: [
                SizedBox(
                  height: statusBarHeight,
                ),
                Container(
                  // height: size.height*0.5,
                  padding: EdgeInsets.all(0.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomControlsWidget(controller:Hive_betterPlayerController ,videocontroller: Hive_betterPlayerController_videoplayer,hiveornot: true),
                  ),
                ),
                sizebox_height_15,
                Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: ReadMoreText(
                    widget.title,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    trimLines: 1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read More',
                    trimExpandedText: ' || Show Less',
                    moreStyle: TextStyle(
                        color: black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    lessStyle: TextStyle(
                        color: black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 30,
                  color: grey,
                  indent: 0,
                  endIndent: 0,
                ),
                TabBar(
                  indicatorColor: primary,
                  indicatorWeight: 2,
                  unselectedLabelColor: grey,
                  labelColor: primary,


                  // dragStartBehavior: DragStartBehavior.start,
                  controller: tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        'Stamps',
                        style: TextStyle(
                          color: black54,
                          fontSize: 15,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Notes (${videoDetailcontroller.pages})',
                        style: TextStyle(
                          color: black54,
                          fontSize: 15,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),


                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          jsonDecode(videodatatasks[widget.index].videostamps).length==0?
                          Container(
                              margin: EdgeInsets.only(top: 200),
                              child: Text("No Stamps Found")):
                          ListView.builder(
                              itemCount: jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps)).length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                var Tablistdata =  jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps))[index];
                                return GestureDetector(
                                  onTap: (){
                                    Hive_betterPlayerController.seekTo(Duration(
                                        hours:int.parse(Tablistdata['time'].toString().split(":")[0]) ,
                                        minutes: int.parse(Tablistdata['time'].toString().split(":")[1]),
                                        seconds:int.parse(Tablistdata['time'].toString().split(":")[2]) ));
                                    Savevideo_showColorLabels(Tablistdata['time']
                                        ,jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps)).length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps))[index+1]['time']);
                                    setState(() {


                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    margin: EdgeInsets.all(0.8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                              size.width *
                                                  0.10,
                                              child:
                                              Savevideo_showColorLabels(Tablistdata['time']
                                                  ,jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps)).length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps))[index+1]['time'])==true?Icon(Icons.pause):
                                              Image.asset(
                                                "assets/nprep2_images/timer.png",
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            sizebox_width_5,
                                            Text(
                                              Tablistdata['time'].toString(),
                                              style: TextStyle(
                                                  color:Savevideo_showColorLabels(Tablistdata['time'],
                                                      jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps)).length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:jsonDecode(jsonDecode(videodatatasks[widget.index].videostamps))[index+1]['time'])==true?primary:black54,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,
                                                  fontSize: 15),
                                            ),
                                            sizebox_width_10,
                                            Container(
                                              // color: Colors.red,
                                              width: size.width*0.8-50,
                                              child: Text(
                                                Tablistdata['title'].toString(),
                                                style: TextStyle(
                                                    color:black54,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(


                                          thickness: 1,
                                          height: 20,
                                          color: grey,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                      videodatatasks[widget.index].videonotes==""?   Container(
                          margin: EdgeInsets.only(top: 80),
                          child: Center(child: Text("No PDF Found"))):
                      Stack(
                        children: [
                          PDFView(


                            filePath: videodatatasks[widget.index].videonotes,
                            enableSwipe: true,


                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                            pageSnap: true,
                            defaultPage: videoDetailcontroller.currentPage,
                            fitPolicy: FitPolicy.WIDTH,


                            preventLinkNavigation:false, // if set to true the link is handled in flutter
                            onRender: (_pages) {
                              setState(() {
                                videoDetailcontroller.pages = _pages;
                                videoDetailcontroller.isReady = true;
                              });
                            },
                            onError: (error) {
                              setState(() {
                                videoDetailcontroller.errorMessage = error.toString();
                              });
                              print("Check pdf path>> "+error.toString());
                            },
                            onPageError: (page, error) {
                              setState(() {
                                videoDetailcontroller.errorMessage = '$page: ${error.toString()}';
                              });
                              print('Check >> Error PDF > $page: ${error.toString()}');
                            },
                            onViewCreated: (PDFViewController pdfViewController) {
                              // videoDetailcontroller.controllerpdfview.complete(pdfViewController);




                            },
                            onLinkHandler: (String uri) {
                              print('goto uri: $uri');
                            },
                            onPageChanged: (int page, int total) {
                              print('page change: $page/$total');
                              setState(() {
                                videoDetailcontroller.currentPage = page;
                              });
                            },
                          ),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.to(FullPage());
                                  videoDetailcontroller.updatevideoscreen();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius
                                          .circular(50),
                                      border: Border.all(
                                          color: primary)),
                                  child: Image.asset("assets/nprep2_images/zoom_in.png",scale: 35,),
                                  // child: Icon(
                                  //   Icons.code,
                                  //   size: 25,
                                  //   color: Colors.black,
                                  // ),
                                ),
                              )),
                          Positioned(
                            top: double.parse(videoDetailcontroller.top_post.value.toString()),
                            right: double.parse(videoDetailcontroller.right_post.value.toString()),


                            child: Container(
                              // height: 35,
                              // width: 35,


                              child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
                            ),
                          ),
                        ],
                      ),






                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         buttonpress = false;
                //         setState(() {});
                //       },
                //       child: Container(
                //         width: 100,
                //         height: 40,
                //         child: Padding(
                //           padding: EdgeInsets.all(1),
                //           child: DecoratedBox(
                //             child: Center(
                //               child: Text(
                //                 'Stamps',
                //                 style: TextStyle(
                //                   color: buttonpress == false
                //                       ? Colors.white
                //                       : primary,
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //             decoration: ShapeDecoration(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               color: buttonpress == false
                //                   ? primary
                //                   : lightPrimary,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         buttonpress = true;
                //         setState(() {});
                //       },
                //       child: Container(
                //         width: 100,
                //         height: 40,
                //         child: Padding(
                //           padding: EdgeInsets.all(1),
                //           child: DecoratedBox(
                //             child: Center(
                //               child: Text(
                //                 'Notes',
                //                 style: TextStyle(
                //                   color: buttonpress == true
                //                       ? Colors.white
                //                       : primary,
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //             decoration: ShapeDecoration(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               color: buttonpress == true
                //                   ? primary
                //                   : lightPrimary,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // sizebox_height_10,
                // buttonpress == false
                //     ? HivevideoData['video_Stamps'].toString() == "[]"
                //         ? Container(
                //             margin: EdgeInsets.only(top: 150),
                //             child: Text("No Stamps Found"))
                //         : Container(
                //             height: size.height,
                //             child: ListView.builder(
                //                 itemCount:HivevideoData['video_Stamps'].length,
                //                     // HivevideoData['video_Stamps'].length,
                //                 scrollDirection: Axis.vertical,
                //                 shrinkWrap: true,
                //                 physics: AlwaysScrollableScrollPhysics(),
                //                 itemBuilder: (BuildContext context, index) {
                //                   var Tablistdata = HivevideoData['video_Stamps'][index];
                //                   log("Tablistdata>> $Tablistdata");
                //                   return GestureDetector(
                //                     onTap: () {
                //                       videoDetailcontroller
                //                           .betterPlayerController
                //                           .seekTo(Duration(
                //                               hours: int.parse(
                //                                   Tablistdata['time']
                //                                       .toString()
                //                                       .split(":")[0]),
                //                               minutes: int.parse(
                //                                   Tablistdata['time']
                //                                       .toString()
                //                                       .split(":")[1]),
                //                               seconds: int.parse(
                //                                   Tablistdata['time']
                //                                       .toString()
                //                                       .split(":")[2])));
                //                     },
                //                     child: Container(
                //                       margin: EdgeInsets.all(0.8),
                //                       child: Column(
                //                         children: [
                //                           Row(
                //                             children: [
                //                               Container(
                //                                 width: size.width * 0.10,
                //                                 child: Image.asset(
                //                                   "assets/nprep2_images/timer.png",
                //                                   height: 20,
                //                                   width: 20,
                //                                 ),
                //                               ),
                //                               sizebox_width_5,
                //                               Text(
                //                                 Tablistdata['time']
                //                                     .toString(),
                //                                 style: TextStyle(
                //                                     color: black54,
                //                                     fontWeight:
                //                                         FontWeight.w700,
                //                                     fontSize: 15),
                //                               ),
                //                               sizebox_width_10,
                //                               Text(
                //                                 Tablistdata['title']
                //                                     .toString(),
                //                                 style: TextStyle(
                //                                     color: black54,
                //                                     fontWeight:
                //                                         FontWeight.w400,
                //                                     fontSize: 15),
                //                               ),
                //                             ],
                //                           ),
                //                           Divider(
                //                             thickness: 1,
                //                             height: 20,
                //                             color: grey,
                //                             indent: 10,
                //                             endIndent: 10,
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   );
                //                 }),
                //           )
                //     : Container(
                //         height: size.height,
                //         child: PDFView(
                //           // fitEachPage: true,
                //           filePath: HivevideoData['video_Notes'],
                //           enableSwipe: true,
                //
                //           swipeHorizontal: false,
                //           autoSpacing: true,
                //           pageFling: true,
                //           pageSnap: true,
                //           defaultPage: videoDetailcontroller.currentPage,
                //           fitPolicy: FitPolicy.WIDTH,
                //
                //           preventLinkNavigation:
                //               false, // if set to true the link is handled in flutter
                //           onRender: (_pages) {
                //             setState(() {
                //               videoDetailcontroller.pages = _pages;
                //               videoDetailcontroller.isReady = true;
                //             });
                //           },
                //           onError: (error) {
                //             setState(() {
                //               videoDetailcontroller.errorMessage =
                //                   error.toString();
                //             });
                //             print("Check pdf path>> $error");
                //           },
                //           onPageError: (page, error) {
                //             setState(() {
                //               videoDetailcontroller.errorMessage =
                //                   '$page: ${error.toString()}';
                //             });
                //             print('$page: ${error.toString()}');
                //           },
                //           onViewCreated:
                //               (PDFViewController pdfViewController) {
                //             videoDetailcontroller.controllerpdfview
                //                 .complete(pdfViewController);
                //           },
                //           onLinkHandler: (String uri) {
                //             print('goto uri: $uri');
                //           },
                //           onPageChanged: (int page, int total) {
                //             print('page change: $page/$total');
                //             setState(() {
                //               videoDetailcontroller.currentPage = page;
                //             });
                //           },
                //         ),
                //       ),
              ],
            );
          }
        }),
      ),
    );
  }
}



