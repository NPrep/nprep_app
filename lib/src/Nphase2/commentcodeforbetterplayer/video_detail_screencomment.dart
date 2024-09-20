// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'dart:math' as math;
//
// import 'package:background_downloader/background_downloader.dart';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:get/get.dart';
// import 'package:image_pixels/image_pixels.dart';
// import 'package:n_prep/Controller/Category_Controller.dart';
// import 'package:n_prep/Controller/Setting_controller.dart';
// import 'package:n_prep/Envirovement/Environment.dart';
// import 'package:n_prep/Service/Service.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
// import 'package:n_prep/constants/custom_text_style.dart';
// import 'package:n_prep/constants/validations.dart';
// import 'package:n_prep/main.dart';
// import 'package:n_prep/src/Nphase2/Constant/Video_questions_qbank.dart';
// import 'package:n_prep/src/Nphase2/Controller/VideoDetailController.dart';
// import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
// import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
// import 'package:n_prep/utils/colors.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:readmore/readmore.dart';
// import 'package:wakelock/wakelock.dart';
//
// import '../Constant/VideoMcqdetail.dart';
// import 'package:screen_protector/screen_protector.dart';
//
// class VideoDetailScreencomment extends StatefulWidget {
//   var CatId;
//   var VideoDuration;
//
//   VideoDetailScreencomment({
//     this.CatId,
//     this.VideoDuration,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return _VideoDetailScreencommentState();
//   }
// }
//
// class _VideoDetailScreencommentState extends State<VideoDetailScreencomment>
//     with TickerProviderStateMixin {
//   TabController tabController;
//
//   // SimplePip pip=SimplePip();
//   SettingController settingController = Get.put(SettingController());
//   VideoDetailcontroller videoDetailcontroller = Get.put(VideoDetailcontroller());
//
//   bool _showForwardAnimation = false;
//   bool _showBackwardAnimation = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//
//     ]);
//     getdata();
//     getvideoFlag();
//
//     tabController = TabController(length: 3, vsync: this);
//     log('pages==>'+videoDetailcontroller.pages.toString());
//   }
//
//   @override
//   void dispose() {
//     videoDetailcontroller.Animation_controller.dispose();
//     super.dispose();
//   }
//
//   getdata() {
//     videoDetailcontroller.Animation_controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     videoDetailcontroller.DurationMessage.value = "";
//
//     videoDetailcontroller.updatecatid(widget.CatId);
//     videoDetailcontroller.videolisner();
//     videoDetailcontroller.FetchVideoDetailData(widget.VideoDuration);
//
//
//   }
//
//   getvideoFlag() async {
//     Wakelock.toggle(enable: true);
//     if(Platform.isAndroid){
//       await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//     }else{
//       await ScreenProtector.protectDataLeakageWithBlur();
//       await ScreenProtector.preventScreenshotOn();
//     }
//
//     // _controller.play();
//   }
//
//   var currentAlignment = Alignment.topCenter;
//
//   var minVideoHeight = 100.0;
//   var minVideoWidth = 150.0;
//
//   var maxVideoHeight = 200.0;
//
// // This is an arbitrary value and will be changed when layout is built.
//   var maxVideoWidth = 250.0;
//
//   var currentVideoHeight = 200.0;
//   var currentVideoWidth = 200.0;
//
//   categoryImage(imagess) {
//     return ImagePixels.container(
//       imageProvider: NetworkImage(imagess),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(5.0),
//         child: Image(
//           image: NetworkImage(imagess),
//           fit: BoxFit.contain,
//           height: 80,
//           width: 100,
//         ),
//       ),
//     );
//   }
//
//   CategoryController categoryController = Get.put(CategoryController());
//   attempt_test_api(sab_cat_id, perentId, cat_name) async {
//     if (categoryController.attempLoader.value) {
//       // toastMsg("You allready selected blocks category, please wait....", true);
//     } else {
//       Map<String, String> queryParams = {
//         'category_id': sab_cat_id.toString(),
//       };
//       String queryString = Uri(queryParameters: queryParams).query;
//       var attempUrl = apiUrls().test_attempt_api + '?' + queryString;
//       print("attempUrl......" + attempUrl.toString());
//       try{
//         var result=  await apiCallingHelper().getAPICall(attempUrl,true);
//         if (result != null) {
//           if(result.statusCode == 200){
//           var  attempTestData =jsonDecode(result.body);
//           var  _checkexamid = attempTestData['data']['id'];
//           var  _checkstatus = attempTestData['data']['exam_status'];
//            var   _totalattempt_que = attempTestData['data']['attempt_questions'];
//             var total_que = attempTestData['data']['total_questions'];
//             var completed_date = attempTestData['data']['completed_date'];
//             var created_at = attempTestData['data']['created_at'];
//             if(_checkstatus==3){
//               log("check status> 3");
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Foo"),
//                     builder: (BuildContext context) => VideoMcqDetails(
//                       title: cat_name.toString(),
//                       header :perentId.toString(),
//                       examid :_checkexamid.toString(),
//                       checkstatus: _checkstatus,
//                       attempquestion:_totalattempt_que ,
//                       total_questions:total_que ,
//                       completed_date: completed_date,
//                       created_at:  created_at,
//                       pagestatus: true,
//                     )),
//               );
//               // Get.to(VideoMcqDetails(
//               //   title: cat_name.toString(),
//               //   header :perentId.toString(),
//               //   examid :_checkexamid.toString(),
//               //   checkstatus: _checkstatus,
//               //   attempquestion:_totalattempt_que ,
//               //   total_questions:total_que ,
//               //   completed_date: completed_date,
//               //   created_at:  created_at,
//               //   pagestatus: true,
//               // ));
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) =>
//               //             Details(
//               //               title: cat_name.toString(),
//               //               header :perentId.toString(),
//               //               examid :_checkexamid.toString(),
//               //               checkstatus: _checkstatus,
//               //               attempquestion:_totalattempt_que ,
//               //               total_questions:total_que ,
//               //               completed_date: completed_date,
//               //               created_at:  created_at,
//               //               pagestatus: true,
//               //             )));
//             }
//             else if(_checkstatus==2){
//               log("check status> 2");
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Foo"),
//                     builder: (BuildContext context) => VideoMcqDetails(
//                       title: cat_name.toString(),
//                       header :perentId.toString(),
//                       examid :_checkexamid.toString(),
//                       checkstatus: _checkstatus,
//                       attempquestion:_totalattempt_que ,
//                       total_questions:total_que ,
//                       completed_date: completed_date,
//                       created_at:  created_at,
//                       pagestatus: true,
//                     )),
//               );
//               // Get.to(VideoMcqDetails(
//               //   title: cat_name.toString(),
//               //   header :perentId.toString(),
//               //   examid :_checkexamid.toString(),
//               //   checkstatus: _checkstatus,
//               //   attempquestion:_totalattempt_que ,
//               //   total_questions:total_que ,
//               //   completed_date: completed_date,
//               //   created_at:  created_at,
//               //   pagestatus: true,
//               // ));
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) =>
//               //             Details(
//               //               title: cat_name.toString(),
//               //               header :perentId.toString(),
//               //               examid :_checkexamid.toString(),
//               //               checkstatus: _checkstatus,
//               //               attempquestion:_totalattempt_que ,
//               //               total_questions:total_que ,
//               //               completed_date: completed_date,
//               //               created_at:  created_at,
//               //               pagestatus: true,
//               //             )));
//             }
//             else{
//               log("check status> 1");
//               // Get.to(Videoquestionbank_new(counterindex: 1,
//               //   examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,));
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Foo"),
//                     builder: (BuildContext context) => Videoquestionbank_new(counterindex: 1,
//                       examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,)),
//               );
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) =>
//               //             questionbank_new(counterindex: 1,
//               //               examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,)));
//             }
//           }
//           else  if(result.statusCode == 404){
//             var   attempTestData =jsonDecode(result.body);
//             toastMsg(attempTestData['message'], true);
//
//
//           }
//           else  if(result.statusCode == 401){
//             var   attempTestData =jsonDecode(result.body);
//             toastMsg(attempTestData['message'], true);
//           }
//
//         } else {
//           toastMsg("Not Verified", true);
//         }
//       }
//       on SocketException {
//         throw FetchDataException('No Internet connection');
//
//       } on TimeoutException {
//         throw FetchDataException('Something went wrong, try again later');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     var sheight = MediaQuery.of(context).size.height;
//     var swidth = MediaQuery.of(context).size.width;
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     return WillPopScope(
//       onWillPop: () async {
//         // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         //   systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
//         //   statusBarColor: Color(0xFF64C4DA), // status bar color
//         // ));
//         Get.back();
//         return true;
//       },
//       child: OrientationBuilder(
//           builder: (context, orientation) {
//             log("orientation> "+orientation.toString());
//             // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//             //   systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
//             //   statusBarColor: Color(0xFF020202), // status bar color
//             // ));
//             if(orientation == Orientation.landscape){
//
//               return   GetBuilder<VideoDetailcontroller>(
//                   builder: (videoDetailcontroller) {
//                   return SafeArea(
//                     child: Scaffold(
//
//                       body: Container(
//                         height: size.height,
//                         width: size.width,
//                         // aspectRatio: 16 / 9,
//                         // child: Container(
//                         //   color: Colors.red,
//                         // ),
//                         child:videoDetailcontroller.VideoAvailableloader.value==true?Container(
//                           alignment: Alignment.center,
//                           child: Text("No Video Available"),
//                         ): Stack(
//                           children: [
//                             BetterPlayer(
//                               controller: videoDetailcontroller.betterPlayerController,
//                               key:videoDetailcontroller.betterPlayerKey,
//                             ),
//                             Positioned(
//                               top: double.parse(videoDetailcontroller.top_post.value.toString()),
//                               right: double.parse(videoDetailcontroller.right_post.value.toString()),
//
//                               child: Container(
//                                 // height: 35,
//                                 // width: 35,
//
//                                 child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//                               ),
//                             ),
//                             Positioned(
//                               right: 10,
//                               bottom: 40,
//                               child:  videoDetailcontroller.betterPlayerController.videoPlayerController.value.position.toString().split(".")[0]==videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration.toString().split(".")[0]
//                                   ?
//                               videoDetailcontroller.VideoDetaildata[0]['next_video_category']==null?Container():    GestureDetector(
//                                 onTap: () async {
//                                   log("Hit Next Video");
//                                   try{
//                                     videoDetailcontroller.betterPlayerController.pause();
//
//                                     await  Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => VideoDetailScreen(CatId: videoDetailcontroller.VideoDetaildata[0]['next_video_category'])),
//                                     );
//                                     videoDetailcontroller.dispose();
//
//                                   }catch(e){
//                                     log("Hit NextNavigator Exception> "+e.toString());
//                                   }
//
//
//                                 },
//                                 child: Container(
//                                   // width: 30,
//                                     height: 30,
//                                     padding: EdgeInsets.all(5.0),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white54.withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(10)
//                                     ),
//
//                                     child: Text("Next Video",style: TextStyle(color: primary),)
//                                 ),
//                               )
//                                   :Container(),
//                             ),
//                             Positioned(
//                               top: 10,
//                               child: GestureDetector(
//                                 onTap: () {
//
//                                 },
//                                 child:  videoDetailcontroller.DurationMessage.value==""?Container():
//                                 Container(
//                                     color: Colors.red.withOpacity(0.5),
//                                     width: MediaQuery.of(context).size.width,
//
//                                     alignment: Alignment.center,
//                                     padding: EdgeInsets.all(0.8),
//                                     child:
//                                     Text("${videoDetailcontroller.DurationMessage.value}",
//                                         style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 0.8)
//                                     )
//                                 ),
//                               ),
//                             ),
//                             videoDetailcontroller.videoVisable.value==false?  Positioned(
//                               top: 0,
//                               right: 0,
//                               bottom: 0,
//                               child: GestureDetector(
//                                   onDoubleTap: () async {
//                                     const int skipSeconds = 10;
//                                     ///Right Side tap
//
//                                     final position = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.position;
//                                     final duration = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration;
//                                     log("Right Side tap duration "+duration.toString());
//                                     setState(() {
//                                       final newPosition = position + Duration(seconds: skipSeconds);
//                                       _showForwardAnimation = true;
//
//                                       if (newPosition < duration) {
//                                         videoDetailcontroller.betterPlayerController.seekTo(newPosition);
//                                       } else {
//                                         videoDetailcontroller.betterPlayerController.seekTo(duration);
//                                       }
//                                       Future.delayed(Duration(milliseconds: 500), () {
//                                         setState(() {
//                                           _showForwardAnimation = false;
//                                         });
//                                       });
//                                     });
//                                   },
//                                   child: Container(
//                                     // height: 50,
//                                     margin: EdgeInsets.only(right: 70.9,),
//                                     width: 140,
//                                     color: Colors.white.withOpacity(0.0),
//                                     child: _showForwardAnimation==true?Container(
//                                       // color: Colors.green,
//                                         margin: EdgeInsets.only(left: 20.9,top: 25.9,bottom: 25.9,right: 25.9),
//                                         height:5,width:5,child: Image.asset("assets/nprep2_images/right.gif",)):Container(),
//                                   )
//
//                               ),
//                             ):Container(),
//                             videoDetailcontroller.videoVisable.value==false? Positioned(
//                               top: 0,
//                               left: 0,
//                               bottom: 0,
//                               child: GestureDetector(
//                                   onDoubleTap: () async {
//                                     const int skipSeconds = 10;
//                                     ///Left Side tap
//                                     final position = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.position;
//                                     final duration = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration;
//                                     log("Left Side tap duration "+duration.toString());
//                                     setState(() {
//                                       final newPosition = position - Duration(seconds: skipSeconds);
//                                       _showBackwardAnimation = true;
//
//                                       videoDetailcontroller.betterPlayerController.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
//                                       Future.delayed(Duration(milliseconds: 500), () {
//                                         setState(() {
//                                           _showBackwardAnimation = false;
//                                         });
//                                       });
//                                     });
//                                   },
//                                   child:  Container(
//                                     // height: 50,
//                                     margin: EdgeInsets.only(left: 70.9,),
//                                     width: 140,
//                                     color: Colors.white.withOpacity(0.0),
//                                     child: _showBackwardAnimation==true?Container(
//                                       // color: Colors.green,
//                                         margin: EdgeInsets.only(left: 25.9,top: 25.9,bottom: 25.9,right: 20.9),
//                                         height:5,width:5,child: Image.asset("assets/nprep2_images/left.gif",)):Container(),
//                                   )
//
//                               ),
//                             ):Container(),
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               );
//             }
//             else{
//               return DefaultTabController(
//                 length: 3,
//                 child: Scaffold(
//                   appBar: PreferredSize(
//                     preferredSize: Size.fromHeight(0.0),
//                     child: AppBar(
//
//                       backgroundColor: Color(0xFF020202),
//                       iconTheme: IconThemeData(color: Colors.white),
//                     ),
//                   ),
//                   body: GetBuilder<VideoDetailcontroller>(
//                       builder: (videoDetailcontroller) {
//                         if (videoDetailcontroller.VideoDetailloader.value){
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Center(
//                                   child: CircularProgressIndicator(
//                                     color: primary,
//                                   )),
//
//                               SizedBox(
//                                 height: 5,
//                               ),
//
//                               settingController.settingData['data']['general_settings']['quotes'].length == 0
//                                   ? Text("")
//                                   : Text(
//                                   '"${settingController.settingData['data']['general_settings']['quotes'][random.nextInt(settingController.settingData['data']['general_settings']['quotes'].length)].toString()}"',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: primary,
//                                       letterSpacing: 0.5,
//                                       fontWeight: FontWeight.w600)),
//
//                             ],
//                           );
//                         }
//                         else {
//                           return videoDetailcontroller.VideoDetailStatusCode == 401 ||
//                               videoDetailcontroller.VideoDetailStatusCode == 404
//                               ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 width: size.width,
//                                 child: Text(
//                                   '${videoDetailcontroller.VideoDetailErrorMSg}',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: primary,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     // fontWeight: FontWeight.bold
//                                   ),
//                                 ),
//                               ),
//                               // Center(child: CircularProgressIndicator(color: primary,)),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               settingController.settingData['data']['general_settings']['quotes'].length == 0
//                                   ? Text("")
//                                   : Text(
//                                   '"${settingController.settingData['data']['general_settings']['quotes'][random.nextInt(settingController.settingData['data']['general_settings']['quotes'].length)].toString()}"',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: primary,
//                                       letterSpacing: 0.5,
//                                       fontWeight: FontWeight.w600)),
//                             ],
//                           )
//                               :
//                           videoDetailcontroller.isInSmallMode == true
//                               ? Stack(
//                                   children: [
//                                     PDFView(
//
//                                       filePath: videoDetailcontroller.remotePDFpath,
//                                       enableSwipe: true,
//
//                                       swipeHorizontal: false,
//                                       autoSpacing: true,
//                                       pageFling: false,
//                                       pageSnap: true,
//                                       defaultPage: videoDetailcontroller
//                                           .currentPage,
//                                       fitPolicy: FitPolicy.WIDTH,
//                                       fitEachPage: true,
//                                       // fitPolicy: FitPolicy.BOTH,
//                                       preventLinkNavigation:
//                                       false,
//                                       onRender: (_pages) {
//                                         setState(() {
//                                           videoDetailcontroller.pages = _pages;
//                                           videoDetailcontroller.isReady = true;
//
//                                         });
//                                       },
//                                       onError: (error) {
//                                         setState(() {
//                                           videoDetailcontroller.errorMessage =
//                                               error.toString();
//                                         });
//                                         print("Check pdf path>> " + error.toString());
//                                       },
//                                       onPageError: (page, error) {
//                                         setState(() {
//                                           videoDetailcontroller.errorMessage =
//                                           '$page: ${error.toString()}';
//                                         });
//                                         print(
//                                             'Check >> Error PDF > $page: ${error.toString()}');
//                                       },
//                                       onViewCreated:
//                                           (PDFViewController pdfViewController) {
//                                         // videoDetailcontroller.controllerpdfview
//                                         //     .complete(pdfViewController);
//                                       },
//                                       onLinkHandler: (String uri) {
//                                         print('goto uri: $uri');
//                                       },
//                                       onPageChanged: (int page, int total) {
//                                         print('page change: $page/$total');
//                                         setState(() {
//                                           videoDetailcontroller.currentPage = page;
//                                           videoDetailcontroller.TotalPage = total;
//                                         });
//                                       },
//                                     ),
//                                     Positioned(
//                                         top: 75,
//                                         right: 10,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Get.to(FullPage());
//                                             videoDetailcontroller.updatevideoscreen();
//                                           },
//                                           child: Container(
//                                             height: 30,
//                                             width: 30,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white
//                                                     .withOpacity(0.2),
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .circular(50),
//                                                 border: Border.all(
//                                                     color: primary)),
//                                             child: Transform.rotate(
//                                                 angle:
//                                                 180 * math.pi / 100,
//                                                 child: Icon(
//                                                   Icons.code,
//                                                   size: 25,
//                                                   color: Colors.black,
//                                                 )),
//                                           ),
//                                         )),
//                                     GestureDetector(
//                                       onPanUpdate: (details) {
//
//
//                                         setState(() {
//                                           videoDetailcontroller.dragAlignment += Alignment(
//                                             details.delta.dx / (swidth / 2),
//                                             details.delta.dy / (sheight / 2),
//                                           );
//                                           // Ensure the position stays within the bounds of the screen
//                                           videoDetailcontroller.dragAlignment =
//                                               Alignment(
//                                                 videoDetailcontroller.dragAlignment.x
//                                                     .clamp(-1.0, 1.0),
//                                                 videoDetailcontroller.dragAlignment.y
//                                                     .clamp(-1.0, 1.0),
//                                               );
//                                         });
//                                       },
//                                       onPanEnd: (details) =>
//                                           videoDetailcontroller.runAnimation(
//                                               details.velocity.pixelsPerSecond, size),
//                                       child: Align(
//                                         alignment: videoDetailcontroller.dragAlignment,
//                                         child: Container(
//                                           height: size.height * 0.2-50,
//                                           width: size.width * 0.5,
//                                           // color: Colors.pink,
//                                           padding: EdgeInsets.all(0.0),
//                                           child: Stack(
//                                             children: [
//                                               BetterPlayer(
//                                                 controller: videoDetailcontroller
//                                                     .betterPlayerController,
//                                                 key: videoDetailcontroller.betterPlayerKey,
//                                               ),
//                                               Positioned(
//                                                   top: double.parse(videoDetailcontroller.top_post_small.value.toString()),
//                                                   right: double.parse(videoDetailcontroller.right_post_small.value.toString()),
//                                                   child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)))
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: double.parse(videoDetailcontroller.top_post.value.toString()),
//                                       right: double.parse(videoDetailcontroller.right_post.value.toString()),
//
//                                       child: Container(
//                                         // height: 35,
//                                         // width: 35,
//
//                                         child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//                                       ),
//                                     ),
//                                   ],
//                               )
//                               : Column(
//                             children: [
//                               // SizedBox(
//                               //   height: statusBarHeight,
//                               // ),
//                               ///Video Player
//                               AspectRatio(
//                                 aspectRatio: 16 / 9,
//
//                                 child:videoDetailcontroller.VideoAvailableloader.value==true?Container(
//                                   alignment: Alignment.center,
//                                   child: Text("No Video Available"),
//                                 ):
//                                 Stack(
//                                   children: [
//                                     BetterPlayer(
//                                       controller: videoDetailcontroller.betterPlayerController,
//                                       key:videoDetailcontroller.betterPlayerKey,
//                                     ),
//                                     Positioned(
//                                       top: double.parse(videoDetailcontroller.top_post.value.toString()),
//                                       right: double.parse(videoDetailcontroller.right_post.value.toString()),
//
//                                       child: Container(
//                                         // height: 35,
//                                         // width: 35,
//
//                                         child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//                                       ),
//                                     ),
//
//                                     Positioned(
//                                       right: 10,
//                                       bottom: 40,
//                                       child:  videoDetailcontroller.betterPlayerController.videoPlayerController.value.position.toString().split(".")[0]==videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration.toString().split(".")[0]
//                                           ?
//                                       videoDetailcontroller.VideoDetaildata[0]['next_video_category']==null?Container():    GestureDetector(
//                                         onTap: () async {
//                                           log("Hit Next Video");
//                                           try{
//                                             videoDetailcontroller.betterPlayerController.pause();
//                                             await  Navigator.pushReplacement(
//                                               context,
//                                               MaterialPageRoute(builder: (context) => VideoDetailScreen(CatId: videoDetailcontroller.VideoDetaildata[0]['next_video_category'])),
//                                             );
//                                             videoDetailcontroller.dispose();
//                                           }catch(e){
//                                             log("Hit NextNavigator Exception> "+e.toString());
//                                           }
//
//
//                                         },
//                                         child: Container(
//                                           // width: 30,
//                                             height: 30,
//                                             padding: EdgeInsets.all(5.0),
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white54.withOpacity(0.1),
//                                                 borderRadius: BorderRadius.circular(10)
//                                             ),
//
//                                             child: Text("Next Video",style: TextStyle(color: primary),)
//                                         ),
//                                       )
//                                           :Container(),
//                                     ),
//                                     Positioned(
//                                       top: 10,
//                                       child: GestureDetector(
//                                         onTap: () {
//
//                                         },
//                                         child:  videoDetailcontroller.DurationMessage.value==""?Container():
//                                         Container(
//                                             color: Colors.red.withOpacity(0.5),
//                                             width: MediaQuery.of(context).size.width,
//
//                                             alignment: Alignment.center,
//                                             padding: EdgeInsets.all(0.8),
//                                             child:
//                                             Text("${videoDetailcontroller.DurationMessage.value}",
//                                                 style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 0.8)
//                                             )
//                                         ),
//                                       ),
//                                     ),
//                                     videoDetailcontroller.videoVisable.value==false?  Positioned(
//                                       top: 0,
//                                       right: 0,
//                                       bottom: 0,
//                                       child: GestureDetector(
//                                           onDoubleTap: () async {
//                                             const int skipSeconds = 10;
//                                             ///Right Side tap
//
//                                             final position = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.position;
//                                             final duration = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration;
//                                             log("Right Side tap duration "+duration.toString());
//                                             setState(() {
//                                               final newPosition = position + Duration(seconds: skipSeconds);
//                                               _showForwardAnimation = true;
//
//                                               if (newPosition < duration) {
//                                                 videoDetailcontroller.betterPlayerController.seekTo(newPosition);
//                                               } else {
//                                                 videoDetailcontroller.betterPlayerController.seekTo(duration);
//                                               }
//                                               Future.delayed(Duration(milliseconds: 500), () {
//                                                 setState(() {
//                                                   _showForwardAnimation = false;
//                                                 });
//                                               });
//                                           });
//                                         },
//                                         child: Container(
//                                           // height: 50,
//                                           margin: EdgeInsets.only(right: 15.9,),
//                                           width: 100,
//                                           color: Colors.white.withOpacity(0.0),
//                                           child: _showForwardAnimation==true?Container(
//                                             // color: Colors.green,
//                                               margin: EdgeInsets.only(left: 20.9,top: 25.9,bottom: 25.9,right: 25.9),
//                                               height:5,width:5,child: Image.asset("assets/nprep2_images/right.gif",)):Container(),
//                                         )
//
//                                       ),
//                                     ):Container(),
//
//                                     videoDetailcontroller.videoVisable.value==false? Positioned(
//                                       top: 0,
//                                       left: 0,
//                                       bottom: 0,
//                                       child: GestureDetector(
//                                           onDoubleTap: () async {
//                                             const int skipSeconds = 10;
//                                             ///Left Side tap
//                                             final position = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.position;
//                                             final duration = await videoDetailcontroller.betterPlayerController.videoPlayerController.value.duration;
//                                             log("Left Side tap duration "+duration.toString());
//                                             setState(() {
//                                               final newPosition = position - Duration(seconds: skipSeconds);
//                                               _showBackwardAnimation = true;
//
//                                               videoDetailcontroller.betterPlayerController.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
//                                               Future.delayed(Duration(milliseconds: 500), () {
//                                                 setState(() {
//                                                   _showBackwardAnimation = false;
//                                                 });
//                                               });
//                                             });
//                                           },
//                                           child:  Container(
//                                             // height: 50,
//                                             margin: EdgeInsets.only(left: 15.9,),
//                                             width: 100,
//                                             color: Colors.white.withOpacity(0.0),
//                                             child: _showBackwardAnimation==true?Container(
//                                               // color: Colors.green,
//                                               margin: EdgeInsets.only(left: 25.9,top: 25.9,bottom: 25.9,right: 20.9),
//                                                 height:5,width:5,child: Image.asset("assets/nprep2_images/left.gif",)):Container(),
//                                           )
//
//                                       ),
//                                     ):Container(),
//                                     Positioned(
//                                       left: 10,
//                                       top: 10,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           SystemChrome.setSystemUIOverlayStyle(
//                                               SystemUiOverlayStyle(
//                                                 systemNavigationBarColor: Color(
//                                                     0xFFFFFFFF), // navigation bar color
//                                                 statusBarColor: Color(
//                                                     0xFF64C4DA), // status bar color
//                                               ));
//                                           Get.back();
//                                         },
//                                         child: Container(
//                                           height: 35,
//                                           width: 35,
//                                           decoration: BoxDecoration(
//                                               color:
//                                               Colors.black45.withOpacity(0.2),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(50))),
//                                           child: Icon(
//                                             Icons.chevron_left,
//                                             color: white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               ///Readmore
//                               sizebox_height_15,
//                               GetBuilder<VideoDetailcontroller>(
//                                 builder: (videoDetailcontroller) {
//                                   return Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       sizebox_width_10,
//                                       Expanded(
//                                         flex: 10,
//                                         child: ReadMoreText(
//                                           videoDetailcontroller.VideoDetaildata[0]['title'],
//                                           textAlign: TextAlign.justify,
//                                           style: TextStyle(
//                                               color: black54,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 14),
//                                           trimLines: 1,
//                                           trimMode: TrimMode.Line,
//                                           trimCollapsedText: 'Read More',
//                                           trimExpandedText: ' || Show Less',
//                                           moreStyle: TextStyle(
//                                               color: primary,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 14),
//                                           lessStyle: TextStyle(
//                                               color: primary,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 14),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 5,
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                              log("is_download>> " +videoDetailcontroller .VideoDetaildata[0]['is_download'].toString()); ///1 downladed///0 Download pending
//                                              // videoItems.length
//                                              final DatabaseService _databaseService = DatabaseService.instance;
//
//                                              await _databaseService.getDatabase();
//                                              var data =_databaseService.getTasks();
//
//                                              log("tasks.length> "+videodatatasks.length.toString());
//                                              if ( videodatatasks.length<=10) {
//                                                if (videoDetailcontroller.VideoDetaildata[0]['is_download'] ==1) {
//                                                       toastMsg('Already Downloaded', false);
//                                                } else {
//                                                   if (videoDetailcontroller .progressStatus ==false) {
//                                                       videoDetailcontroller .downloadButtonPressed
//                                                         (
//                                                           videoDetailcontroller.VideoDetaildata[0]['video_attachment'],
//                                                           videoDetailcontroller.VideoDetaildata[0] ['id'],
//                                                           videoDetailcontroller .VideoDetaildata[0]['title'],
//                                                           videoDetailcontroller .VideoDetaildata[0]['thumb_image'],
//                                                         );
//                                                    }
//                                                   else {
//                                                     log(">>>>>>>>>>"+videoDetailcontroller.buttonState.toString());
//                                                     log(">>>>>>>>>>"+ButtonState.download.toString());
//                                                     if( videoDetailcontroller.buttonState==ButtonState.pause){
//                                                       FileDownloader().pause(videoDetailcontroller.task);
//                                                     }else if(videoDetailcontroller.buttonState==ButtonState.resume){
//                                                       FileDownloader().resume(videoDetailcontroller.task);
//                                                     }else if(videoDetailcontroller.buttonState==ButtonState.download){
//                                                       FileDownloader().pause(videoDetailcontroller.task);
//                                                     }
//                                                     toastMsg('Please Wait video is downloading', false);
//
//
//                                                   }
//                                                }
//                                             }
//                                             else {
//                                               toastMsg('Not allow more than 10 videos ',false);
//                                             }
//                                           },
//                                          child: videoDetailcontroller.progressStatus == false?
//                                                 videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1?
//                                                 Icon(
//                                             Icons.check_circle_rounded,
//                                             color: primary,
//                                             size: 25,
//                                           ): videoDetailcontroller.progressStatus == false ? Image.asset(
//                                                 "assets/nprep2_images/download.png",
//                                                 color: primary,
//                                                 height: 15,
//                                                 width: 15,
//                                               ):
//                                                 CircularPercentIndicator(
//                                                       radius: 15.0,
//                                                       lineWidth: 5.0,
//                                                       percent:
//                                                       videoDetailcontroller.progress,
//                                                       center: videoDetailcontroller.buttonState==ButtonState.resume ?
//                                                       Icon(
//                                                         Icons.play_arrow,
//                                                         color: primary,
//                                                         size: 12,
//                                                       ):
//                                                       Icon(
//                                                           Icons.pause,
//                                                           color: primary,
//                                                           size: 12,
//                                                         ),
//                                             progressColor: primary,
//                                           )
//                                               : videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1? Icon(
//                                                 Icons.check_circle_rounded,
//                                                 color: primary,
//                                                 size: 25,
//                                               ):
//
//                                                 CircularPercentIndicator(
//                                                   radius: 15.0,
//                                                   lineWidth: 5.0,
//                                                   percent:
//                                                   videoDetailcontroller.progress,
//                                                   center: videoDetailcontroller.buttonState.value==ButtonState.resume ?Icon(
//                                                     Icons.play_arrow,
//                                                     color: primary,
//                                                     size: 12,
//                                                   ):videoDetailcontroller.buttonState.value==ButtonState.complete?Icon(Icons.refresh,color: primary,
//                                                     size: 12,):Icon(
//                                                     Icons.pause,
//                                                     color: primary,
//                                                     size: 12,
//                                                   ),
//                                             progressColor: primary,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 }
//                               ),
//
//                              // GestureDetector(
//                              //    onTap: (){
//                              //
//                              //      videoDetailcontroller.adddata();
//                              //    },
//                              //    child: Text("Add Data")),
//
//                               Divider(
//                                 thickness: 1,
//                                 height: 30,
//                                 color: grey,
//                                 indent: 0,
//                                 endIndent: 0,
//                               ),
//
//                               ///TabBar
//                               TabBar(
//                                 indicatorColor: primary,
//                                 indicatorWeight: 3,
//                                 unselectedLabelColor: grey,
//                                 labelColor: primary,
//
//                                 // dragStartBehavior: DragStartBehavior.start,
//                                 controller: tabController,
//                                 tabs: [
//                                   Tab(
//                                     child: Text(
//                                       'Stamps',
//                                       style: TextStyle(
//                                         color: black54,
//                                         fontSize: 15,
//                                         // fontWeight: FontWeight.bold
//                                       ),
//                                     ),
//                                   ),
//                                   Tab(
//                                     child: Text(
//                                       'Notes ${videoDetailcontroller.pages==0?"": '(${
//                                             videoDetailcontroller.pages
//                                           })'}',
//                                       style: TextStyle(
//                                         color: black54,
//                                         fontSize: 15,
//                                         // fontWeight: FontWeight.bold
//                                       ),
//                                     ),
//                                   ),
//                                   Tab(
//                                     child: Text(
//                                       'Blocks',
//                                       style: TextStyle(
//                                         color: black54,
//                                         fontSize: 15,
//                                         // fontWeight: FontWeight.bold
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 15,),
//
//                               ///TabBar View
//                               Expanded(
//                                 child: TabBarView(
//                                   controller: tabController,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   children: [
//                                     /// Video Stamp
//                                     videoDetailcontroller
//                                         .VideoDetaildata[0]['video_stamps'].length == 0
//                                         ? Container(
//                                         alignment: Alignment.center,
//                                         // margin: EdgeInsets.only(top: 200),
//                                         child: Text("No Stamps Found"))
//                                         : ListView.builder(
//                                         itemCount: videoDetailcontroller
//                                             .VideoDetaildata[0]
//                                         ['video_stamps']
//                                             .length,
//                                         scrollDirection: Axis.vertical,
//                                         shrinkWrap: true,
//                                         physics:
//                                         AlwaysScrollableScrollPhysics(),
//                                         itemBuilder:
//                                             (BuildContext context,
//                                             index) {
//                                           var Tablistdata =
//                                           videoDetailcontroller
//                                               .VideoDetaildata[0]
//                                           ['video_stamps'][index];
//                                           // log("length<< "+videoDetailcontroller.VideoDetaildata[0]['video_stamps'].length.toString());
//                                           // log("lengthindex<< "+(index+1).toString());
//                                           return GestureDetector(
//                                             onTap: () {
//                                               videoDetailcontroller.betterPlayerController.seekTo(Duration(
//                                                   hours: int.parse(
//                                                       Tablistdata['time']
//                                                           .toString()
//                                                           .split(":")[0]),
//                                                   minutes: int.parse(
//                                                       Tablistdata['time']
//                                                           .toString()
//                                                           .split(":")[1]),
//                                                   seconds: int.parse(
//                                                       Tablistdata['time']
//                                                           .toString()
//                                                           .split(
//                                                           ":")[2])));
//                                             },
//                                             child: Container(
//                                               margin: EdgeInsets.all(0.8),
//                                               child: Column(
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Container(
//                                                         width:
//                                                         size.width *
//                                                             0.10,
//                                                         child:videoDetailcontroller.VideoAvailableloader.value==true?Image.asset(
//                                                           "assets/nprep2_images/timer.png",
//                                                           height: 20,
//                                                           width: 20,
//                                                         ):
//                                                         videoDetailcontroller.showColorLabels(Tablistdata['time'].toString()
//                                                             ,videoDetailcontroller.VideoDetaildata[0]['video_stamps'].length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:videoDetailcontroller.VideoDetaildata[0]['video_stamps']
//                                                             [index+1]['time'])==true?Icon(Icons.pause):
//                                                         Image.asset(
//                                                           "assets/nprep2_images/timer.png",
//                                                           height: 20,
//                                                           width: 20,
//                                                         ),
//                                                       ),
//                                                       sizebox_width_5,
//                                                       Text(
//                                                         Tablistdata[
//                                                         'time']
//                                                             .toString(),
//                                                         style: TextStyle(
//                                                             color:
//                                                             black54,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w700,
//                                                             fontSize: 15),
//                                                       ),
//                                                       sizebox_width_10,
//                                                       Container(
//                                                         // color: Colors.red,
//                                                         width: size.width*0.8-50,
//                                                         child: Text(
//                                                           Tablistdata['title'].toString(),
//                                                           style: TextStyle(
//                                                               color:videoDetailcontroller.VideoAvailableloader.value==true?black54:videoDetailcontroller.showColorLabels(Tablistdata['time'].toString()
//                                                                   ,videoDetailcontroller.VideoDetaildata[0]['video_stamps'].length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:videoDetailcontroller.VideoDetaildata[0]['video_stamps']
//                                                                   [index+1]['time'])==true?
//                                                               primary:black54,
//                                                               fontWeight:
//                                                               FontWeight.w400,
//                                                               fontSize: 15),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Divider(
//
//                                                     thickness: 1,
//                                                     height: 20,
//                                                     color: grey,
//                                                     indent: 10,
//                                                     endIndent: 10,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         }),
//
//                                     /// Video PDF
//                                     videoDetailcontroller.VideoDetaildata[0]
//                                     ['pdf_attachment'] ==
//                                         null
//                                         ? Container(
//                                       // margin: EdgeInsets.only(top: 80),
//                                         child: Center(
//                                             child: Text("No PDF Found")))
//                                         : Stack(
//                                             children: [
//                                               PDFView(
//
//                                                 filePath: videoDetailcontroller.remotePDFpath,
//                                                 enableSwipe: true,
//
//                                                 swipeHorizontal: false,
//                                                 autoSpacing: true,
//                                                 pageFling: false,
//                                                 pageSnap: true,
//                                                 defaultPage: videoDetailcontroller.currentPage,
//                                                 fitPolicy: FitPolicy.WIDTH,
//                                                 fitEachPage: true,
//                                                 preventLinkNavigation:false, // if set to true the link is handled in flutter
//                                                 onRender: (_pages) {
//                                                   setState(() {
//                                                     videoDetailcontroller.pages = _pages;
//                                                     videoDetailcontroller
//                                                         .isReady = true;
//                                                   });
//                                                 },
//                                                 onError: (error) {
//                                                   setState(() {
//                                                     videoDetailcontroller
//                                                         .errorMessage =
//                                                         error.toString();
//                                                   });
//                                                   print("Check pdf path>> " +
//                                                       error.toString());
//                                                 },
//                                                 onPageError: (page, error) {
//                                                   setState(() {
//                                                     videoDetailcontroller
//                                                         .errorMessage =
//                                                     '$page: ${error.toString()}';
//                                                   });
//                                                   print(
//                                                       'Check >> Error PDF > $page: ${error.toString()}');
//                                                 },
//                                                 onViewCreated: (PDFViewController pdfViewController) {
//                                                   // videoDetailcontroller
//                                                   //     .controllerpdfview
//                                                   //     .complete(
//                                                   //     pdfViewController);
//                                                 },
//                                                 onLinkHandler: (String uri) {
//                                                   print('goto uri: $uri');
//                                                 },
//                                                 onPageChanged:
//                                                     (int page, int total) {
//                                                   print(
//                                                       'page change: $page/$total');
//                                                   setState(() {
//                                                     videoDetailcontroller.currentPage = page;
//                                                     videoDetailcontroller.TotalPage = total;
//                                                   });
//                                                 },
//                                               ),
//
//                                               Positioned(
//                                                   top: 10,
//                                                   right: 10,
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       // Get.to(FullPage());
//                                                       videoDetailcontroller.updatevideoscreen();
//                                                     },
//                                                     child: Container(
//                                                       height: 30,
//                                                       width: 30,
//                                                       decoration: BoxDecoration(
//                                                           color: Colors.white
//                                                               .withOpacity(0.2),
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(50),
//                                                           border: Border.all(
//                                                               color: primary)),
//                                                       child: Transform.rotate(
//                                                           angle:
//                                                           180 * math.pi / 100,
//                                                           child: Icon(
//                                                             Icons.code,
//                                                             size: 25,
//                                                             color: Colors.black,
//                                                           )),
//                                                     ),
//                                                   )),
//                                               Positioned(
//                                                 top: double.parse(videoDetailcontroller.top_post.value.toString()),
//                                                 right: double.parse(videoDetailcontroller.right_post.value.toString()),
//
//                                                 child: Container(
//                                                   // height: 35,
//                                                   // width: 35,
//
//                                                   child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                     /// Video Blocks
//                                     videoDetailcontroller.VideoDetaildata[0]['video_relates'].length ==
//                                         0
//                                         ? Container(
//                                       // margin: EdgeInsets.only(top: 80),
//                                         child: Center(
//                                             child: Text("No Blocks Found")))
//                                         : ListView.builder(
//                                         itemCount: videoDetailcontroller.VideoDetaildata[0]
//                                         ['video_relates'].length,
//                                         scrollDirection: Axis.vertical,
//                                         shrinkWrap: true,
//                                         physics:AlwaysScrollableScrollPhysics(),
//                                         itemBuilder:(BuildContext context, index) {
//                                           var Tablist2data = videoDetailcontroller.VideoDetaildata[0]
//                                                             ['video_relates'][index];
//
//                                           return Tablist2data['category_type'] == 1
//                                               ? GestureDetector(
//                                                   onTap: () async {
//                                                     videoDetailcontroller.betterPlayerController.pause();
//                                                     // videoDetailcontroller.dispose();
//                                                     await attempt_test_api(
//                                                         Tablist2data['mcq_category']['id'] .toString(),
//                                                         Tablist2data['mcq_category']['name'].toString(),
//                                                         Tablist2data['mcq_category']['name'].toString());
//                                                   },
//                                                   child: Stack(
//                                                     children: [
//                                                       // Text("MCQ"),
//                                                       Card(
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:BorderRadius.circular(10)),
//                                                         // height: sheight * .1,
//                                                         // decoration: BoxDecoration(
//                                                         //     borderRadius: BorderRadius.circular(10),
//                                                         //     color: white,
//                                                         //     boxShadow: [
//                                                         //       BoxShadow(
//                                                         //         color: Colors.grey.shade300,
//                                                         //         spreadRadius: 1,
//                                                         //         blurRadius: 0.5,
//                                                         //       )
//                                                         //     ]),
//                                                         // padding: EdgeInsets.all(5),
//                                                         child: Row(
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                           children: [
//                                                             Container(
//                                                               margin:
//                                                               EdgeInsets.only(
//                                                                 left: 5,
//                                                               ),
//                                                               decoration:
//                                                               BoxDecoration(
//                                                                 borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                     10),
//                                                               ),
//                                                               child: ClipRRect(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(5.0),
//                                                                   child: categoryImage(Environment
//                                                                       .imgapibaseurl +Tablist2data['mcq_category']
//                                                                       ['image'])),
//                                                               height:
//                                                               sheight * 0.08,
//                                                               width: swidth * 0.18,
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                               children: [
//                                                                 Container(
//                                                                   width:
//                                                                   swidth -
//                                                                       120,
//                                                                   padding: EdgeInsets.symmetric(
//                                                                       horizontal:
//                                                                       10,
//                                                                       vertical:
//                                                                       10),
//                                                                   // color: primary,
//
//                                                                   child: Text(
//                                                                     Tablist2data['mcq_category']
//                                                                     ['name']
//                                                                         .toString(),
//                                                                     style: TextStyle(
//                                                                         fontSize: 14,
//                                                                         fontWeight: FontWeight.w700,
//                                                                         fontFamily: 'PublicSans',
//                                                                         color: black54,
//                                                                         // height: 1.1,
//                                                                         letterSpacing: 0.8),
//                                                                   ),
//                                                                 ),
//                                                                 // perentdata['attempt_percentage']==0?Container():
//
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                       .all(
//                                                                       10.0),
//                                                                   child: Text(
//                                                                     Tablist2data['mcq_category']['questions_count']
//                                                                         .toString() +
//                                                                         " MCQ",
//                                                                     style:
//                                                                     TextStyle(
//                                                                       color:
//                                                                       black54,
//                                                                       fontWeight:
//                                                                       FontWeight.w400,
//                                                                       fontFamily:
//                                                                       'Poppins-Regular',
//                                                                       fontSize:
//                                                                       12,
//                                                                     ),
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Tablist2data["mcq_category"]['fee_type'] == 2
//                                                           ? Container()
//                                                           : Positioned(
//                                                         right: 10,
//                                                         top: 5,
//                                                         child:
//                                                         Container(
//                                                           height: 15,
//                                                           width: 30,
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color:
//                                                                   todayTextColor),
//                                                               borderRadius:
//                                                               BorderRadius.circular(
//                                                                   4)),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Pro",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style: TextStyle(
//                                                                   color:
//                                                                   todayTextColor,
//                                                                   fontSize:
//                                                                   10),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   )
//                                               )
//                                               : GestureDetector(
//                                                   onTap: () async {
//
//                                                     videoDetailcontroller.betterPlayerController.pause();
//                                                     videoDetailcontroller.dispose();
//
//                                                     try {
//                                                       await Navigator.of(context).pushReplacement(
//                                                         MaterialPageRoute<void>(
//                                                           builder: (BuildContext
//                                                           context) =>
//                                                               VideoDetailScreen(
//                                                                   CatId: Tablist2data[
//                                                                   'category_id']),
//                                                         ),
//                                                       );
//
//                                                     } catch (e) {
//                                                       // log("Navigation >> "+e.toString());
//                                                     }
//                                                   },
//                                                   child: Stack(
//                                                     children: [
//                                                       Card(
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                 10)),
//                                                         // height: sheight * .1,
//                                                         // decoration: BoxDecoration(
//                                                         //     borderRadius: BorderRadius.circular(10),
//                                                         //     color: white,
//                                                         //     boxShadow: [
//                                                         //       BoxShadow(
//                                                         //         color: Colors.grey.shade300,
//                                                         //         spreadRadius: 1,
//                                                         //         blurRadius: 0.5,
//                                                         //       )
//                                                         //     ]),
//                                                         // padding: EdgeInsets.all(5),
//                                                         child: Row(
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                           children: [
//                                                             Container(
//                                                               margin:
//                                                               EdgeInsets
//                                                                   .only(
//                                                                 left: 5,
//                                                               ),
//                                                               decoration:
//                                                               BoxDecoration(
//                                                                 borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                     10),
//                                                               ),
//                                                               child: ClipRRect(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(
//                                                                       5.0),
//                                                                   child: categoryImage(
//                                                                       "assets/nprep2_images/LOGO.png")),
//                                                               height:
//                                                               sheight *
//                                                                   0.08,
//                                                               width: swidth *
//                                                                   0.18,
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                               mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                               children: [
//                                                                 Container(
//                                                                   width:
//                                                                   swidth -
//                                                                       120,
//                                                                   padding: EdgeInsets.symmetric(
//                                                                       horizontal:
//                                                                       10,
//                                                                       vertical:
//                                                                       10),
//                                                                   // color: primary,
//                                                                   child: Text(
//                                                                     Tablist2data['video_category']
//                                                                     ['name']
//                                                                         .toString(),
//                                                                     style: TextStyle(
//                                                                         fontSize: 14,
//                                                                         fontWeight: FontWeight.w700,
//                                                                         fontFamily: 'PublicSans',
//                                                                         color: black54,
//                                                                         // height: 1.1,
//                                                                         letterSpacing: 0.8),
//                                                                   ),
//                                                                 ),
//                                                                 // perentdata['attempt_percentage']==0?Container():
//
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                       .all(
//                                                                       10.0),
//                                                                   child: Text(
//                                                                     Tablist2data['video_category']['video_time']
//                                                                         .toString() +
//                                                                         " Video",
//                                                                     style:
//                                                                     TextStyle(
//                                                                       color:
//                                                                       black54,
//                                                                       fontWeight:
//                                                                       FontWeight.w400,
//                                                                       fontFamily:
//                                                                       'Poppins-Regular',
//                                                                       fontSize:
//                                                                       12,
//                                                                     ),
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Tablist2data["video_category"]
//                                                       [
//                                                       'fee_type'] ==
//                                                           2
//                                                           ? Container()
//                                                           : Positioned(
//                                                         right: 10,
//                                                         top: 5,
//                                                         child:
//                                                         Container(
//                                                           height: 15,
//                                                           width: 30,
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color:
//                                                                   todayTextColor),
//                                                               borderRadius:
//                                                               BorderRadius.circular(
//                                                                   4)),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Pro",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style: TextStyle(
//                                                                   color:
//                                                                   todayTextColor,
//                                                                   fontSize:
//                                                                   10),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   )
//                                               );
//                                         }),
//                                   ],
//                                 ),
//                               ),
//
//                               ///Button
//                               GestureDetector(
//                                 onTap: () async {
//                                   if (videoDetailcontroller.VideoDetaildata[0]
//                                   ['is_attempt']
//                                       .toString() ==
//                                       "0") {
//                                     var videos_saved =
//                                         "${apiUrls().videos_attempt_api}${videoDetailcontroller.VideoDetaildata[0]['id']}";
//                                     var result = await apiCallingHelper()
//                                         .getAPICall(videos_saved, true);
//                                     videoDetailcontroller.VideoDetaildata[0]
//                                     ['is_attempt'] = 1;
//                                     var data = jsonDecode(result.body);
//                                     // toastMsg(data['message'], true);
//                                     toastMsg("Video marked complete", true);
//                                     setState(() {});
//                                   } else {
//                                     var videos_saved =
//                                         "${apiUrls().videos_unattempt_api}${videoDetailcontroller.VideoDetaildata[0]['id']}";
//                                     var result = await apiCallingHelper()
//                                         .getAPICall(videos_saved, true);
//
//                                     videoDetailcontroller.VideoDetaildata[0]
//                                     ['is_attempt'] = 0;
//                                     var data = jsonDecode(result.body);
//                                     // toastMsg(data['message'], true);
//                                     toastMsg("Video marked incomplete", true);
//                                     setState(() {});
//                                   }
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.symmetric(
//                                       vertical: 20, horizontal: 20),
//                                   height: 40,
//                                   width: 180,
//                                   decoration: BoxDecoration(
//                                     color: videoDetailcontroller
//                                         .VideoDetaildata[0]['is_attempt']
//                                         .toString() ==
//                                         "0"
//                                         ? Color(0xff64C4DA).withOpacity(0.9)
//                                         : white,
//                                     border: Border.all(color: primary),
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(8),
//                                     ),
//                                   ),
//                                   child: Center(
//                                       child: Text(
//                                         videoDetailcontroller.VideoDetaildata[0]
//                                         ['is_attempt']
//                                             .toString() ==
//                                             "0"
//                                             ? "MARK COMPLETE "
//                                             : "MARK INCOMPLETE ",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: videoDetailcontroller
//                                                 .VideoDetaildata[0]
//                                             ['is_attempt']
//                                                 .toString() ==
//                                                 "0"
//                                                 ? white
//                                                 : primary,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500),
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }
//                       }),
//                 ),
//               );
//
//             }
//         }
//       ),
//     );
//   }
// }
