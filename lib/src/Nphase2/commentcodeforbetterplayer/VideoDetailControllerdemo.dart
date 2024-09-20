// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// // import 'package:chewie/chewie.dart';
// import 'package:background_downloader/background_downloader.dart';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/physics.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:get/get.dart';
// // import 'package:hive/hive.dart';
// import 'package:n_prep/App_update/App_Mentaintion_Mood.dart';
// import 'package:n_prep/Service/Service.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
// import 'package:n_prep/constants/validations.dart';
// import 'package:n_prep/main.dart';
// import 'package:n_prep/src/Nphase2/Controller/custom_controls_widget.dart';
// import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
// // import 'package:n_prep/src/Nphase2/Controller/video_item.dart';
// import 'package:n_prep/utils/colors.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../Envirovement/Environment.dart';
// enum ButtonState { download, cancel, pause, resume, reset,running,complete }
//
// class VideoDetailcontrollerComment extends GetxController {
//   ///Hive
// @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//
//   }
//
// var videoVisable = false.obs;
//   updatevideoVisable() {
//     if (videoVisable == false) {
//       VideoLoadingBeforeloader.value=false;
//       videoVisable.value = true;
//       update();
//     } else {
//       videoVisable.value = false;
//       update();
//     }
//     log("videoVisable: " + videoVisable.value.toString());
//   }
//
//
//
//
//   adddata() async {
//     final DatabaseService _databaseService = DatabaseService.instance;
//     var stamps =[
//       {
//         "video_id": 108,
//         "title": "First time stamp",
//         "time": "00:00:11",
//         "status": 1,
//         "deleted_at": null
//       }
//     ];
//     // _databaseService.addTask("CNS: Stroke", stamps.toString(), "/data/user/0/com.n_prep.medieducation/app_flutter/17071669834088.pdf", "/data/user/0/com.n_prep.medieducation/app_flutter/nprep/CNS: Stroke", "/data/user/0/com.n_prep.medieducation/app_flutter/17071669836326.jpg","00:43:59");
//    // await _databaseService.getDatabase();
//    // var data =_databaseService.getTasks();
//
//     log("tasks.length> "+videodatatasks.length.toString());
//     // _databaseService.checkTableExists();
//     // _databaseService.getDatabase();
//     _databaseService.deleteDatabaseIfExists();
//     ///
// }
//
//   DownloadTask task;
//   double progress = 0.0;
//   var progressStatus = false.obs;
//   Rx<ButtonState> buttonState = ButtonState.download.obs;
//   var _status = "Not Downloaded";
//   get status => _status;
//
//   ///Hive End
//
//   var VideoDetailloader = false.obs;
//   var VideoLoadingloader = false.obs;
//
//   var VideoAvailableloader = false.obs;
//   var VideoLoadingBeforeloader = true.obs;
//   var VideoDetailCatid = 0.obs;
//   var VideoDetailStatusCode = 0.obs;
//   var VideoDetailErrorMSg = "".obs;
//   var videoimage = "".obs;
//
//   List VideoDetaildata = [];
//   RxBool isInSmallMode = false.obs;
//   BetterPlayerController betterPlayerController;
//   BetterPlayerConfiguration betterPlayerConfiguration;
//   Duration videoduration =Duration(seconds: 10,minutes: 10,hours: 10);
//   BetterPlayerController HivebetterPlayerController;
//   BetterPlayerConfiguration HivebetterPlayerConfiguration;
//
//   GlobalKey betterPlayerKey = GlobalKey();
//   GlobalKey FullPagebetterPlayerKey = GlobalKey();
//   GlobalKey HivebetterPlayerKey = GlobalKey();
//
//   //----Pdf
//   String remotePDFpath = "";
//   String Thumbimg_remotePDFpath = "";
//   int currentPage = 0;
//   int TotalPage = 0;
//   int pages = 0;
//   var top_post = 0.obs;
//   var top_post_small = 0.obs;
//   var right_post = 0.obs;
//   var right_post_small = 0.obs;
//   bool isReady = false;
//   String errorMessage = '';
//   var DurationMessage = ''.obs;
//   PDFViewController controllerpdfview;
//
//   updatecatid(id) {
//     VideoDetailCatid.value = id;
//
//     update();
//   }
//   var dragAlignment = Alignment.bottomRight;
//    AnimationController Animation_controller;
//    Animation<Alignment> Animation_con;
//   final Animation_spring = SpringDescription(mass: 10, stiffness: 1000, damping: 0.9);
//
//   updatevideoscreen() {
//     if (isInSmallMode == false) {
//       isInSmallMode.value = true;
//       betterPlayerController.setBetterPlayerControlsConfiguration(
//           BetterPlayerControlsConfiguration(
//             enableFullscreen: false,
//               enableMute:false,
//               enablePip: false,
//               showControls: true,
//               enableProgressBar: false,
//               enableProgressText: false,
//               enableOverflowMenu: false,
//               playIcon: Icons.play_arrow,
//               pauseIcon: Icons.pause,
//               skipBackIcon: Icons.replay_10_sharp,
//               skipForwardIcon:  Icons.forward_10_sharp,
//               enablePlayPause: false,
//             playerTheme:BetterPlayerTheme.material,
//           ),);
//       update();
//     } else {
//       isInSmallMode.value = false;
//       betterPlayerController.setBetterPlayerControlsConfiguration(
//
//           BetterPlayerControlsConfiguration(
//               playerTheme:BetterPlayerTheme.custom,
//               customControlsBuilder:(controller, onControlsVisibilityChanged) =>
//                   CustomControlsWidget(
//                     controller: controller,
//
//                     onControlsVisibilityChanged:onControlsVisibilityChanged,
//                   )
//           )
//
//
//
//       );
//       update();
//     }
//     log("ismallmode: " + isInSmallMode.value.toString());
//   }
//   void runAnimation(Offset velocity, Size size) {
//
//     log("runAnimation");
//     Animation_con = Animation_controller.drive(
//       AlignmentTween(
//         begin: dragAlignment,
//         end: Alignment.center,
//       ),
//     );
//     final simulation = SpringSimulation(
//       Animation_spring, 0, 0.0,
//       _normalizeVelocity(velocity, size),
//     );
//     update();
//     Animation_controller.animateWith(simulation);
//   }
//   double _normalizeVelocity(Offset velocity, Size size) {
//     final normalizedVelocity = Offset(
//       velocity.dx / size.width,
//       velocity.dy / size.height,
//     );
//
//     return normalizedVelocity.distance;
//   }
//   @override
//   void onReady() {
//     super.onReady();
//     TimerForrandom();
//   }
//   Timer _timer ;
//   TimerForrandom(){
//     // videoDetailcontroller.isInSmallMode == true
//   _timer =  Timer.periodic(Duration(seconds: 10), (timer) {
//       top_post.value= random.nextInt(200);
//       right_post.value= random.nextInt(300);
//       top_post_small.value= random.nextInt(80);
//       right_post_small.value= random.nextInt(10);
//
//       update();
//     });
//
// }
//   opendilog() {
//     if (sprefs.getBool("updateshowpop") == false ||
//         sprefs.getBool("updateshowpop") == null) {
//       Get.dialog(MyDialog());
//     } else {}
//   }
//
//   videolisner() {
//
//     BetterPlayerControlsConfiguration controlsConfiguration;
//
//     controlsConfiguration = BetterPlayerControlsConfiguration(
//         progressBarPlayedColor: primary2,
//         progressBarHandleColor: primary2,
//        // showControlsOnInitialize: true,
//         loadingColor: primary2,
//         enableSkips: true,
//         enableProgressBar: true,
//         enableMute: false,
//         enableFullscreen: true,
//         enableSubtitles: false,
//         enableQualities: false,
//         enableAudioTracks: false,
//         enablePip: false,
//         controlBarHeight: 60,
//         forwardSkipTimeInMilliseconds: 10000,
//         backwardSkipTimeInMilliseconds: 10000,
//         overflowModalColor: Colors.white,
//         overflowModalTextColor: Colors.grey.shade700,
//         overflowMenuIconsColor: Colors.grey.shade700,
//         playerTheme:BetterPlayerTheme.material,
//         playIcon: Icons.play_arrow,
//         pauseIcon: Icons.pause,
//         skipBackIcon: Icons.replay_10_sharp,
//         skipForwardIcon:  Icons.forward_10_sharp
//
//
//     );
//     betterPlayerConfiguration = BetterPlayerConfiguration(
//         aspectRatio: 16 / 9,
//         fit: BoxFit.contain,
//         autoDispose: true,
//         autoPlay: false,
//         allowedScreenSleep: false,
//         autoDetectFullscreenDeviceOrientation: true,
//         // allowedScreenSleep: false,
//         controlsConfiguration: controlsConfiguration);
//
//
//   }
//
//   Hivevideolisner() {
//     BetterPlayerControlsConfiguration controlsConfigurationHori = BetterPlayerControlsConfiguration(
//
//         progressBarPlayedColor: primary2,
//         progressBarHandleColor: primary2,
//         enableSkips: true,
//         enableProgressBar: true,
//         enableMute: false,
//         enableFullscreen: true,
//         enableSubtitles: true,
//         enableQualities: false,
//         enableAudioTracks: false,
//         enablePip: false,
//         controlBarHeight: 60,
//         loadingColor: primary2,
//         forwardSkipTimeInMilliseconds: 10000,
//         backwardSkipTimeInMilliseconds: 10000,
//         overflowModalColor: Colors.white,
//         overflowModalTextColor: Colors.grey.shade700,
//         overflowMenuIconsColor: Colors.grey.shade700,
//         playerTheme:BetterPlayerTheme.custom,
//         customControlsBuilder:(controller, onControlsVisibilityChanged) =>
//             CustomControlsWidget(
//               controller: controller,
//
//               onControlsVisibilityChanged:onControlsVisibilityChanged,
//             )
//     );
//     HivebetterPlayerConfiguration = BetterPlayerConfiguration(
//         aspectRatio: 16 / 9,
//         fit: BoxFit.contain,
//
//         controlsConfiguration: controlsConfigurationHori);
//   }
//
//   HivevideoPlayer(videourl, videoid) {
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.file,
//       videourl.toString(),
//       placeholder: Center(
//         child: Container(
//           padding: EdgeInsets.all(0.0),
//           height: 200,
//           child: FittedBox(
//               fit: BoxFit.cover,
//               child: Image.asset('assets/nprep2_images/video_background.png',
//
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       // color: Colors.grey.shade300,
//                       alignment: Alignment.center,
//                       child: Image.asset(
//                         "assets/nprep2_images/video_background.png",
//                         // height: 20,
//                         width: MediaQuery.of(context).size.width * 0.18,
//                       ),
//                       // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
//                       //   color: Colors.grey.shade300,),
//                     );
//                   })
//
//           ),
//         ),
//       ),
//       cacheConfiguration: Platform.isAndroid?BetterPlayerCacheConfiguration(
//         useCache: true,
//         preCacheSize: 5120 * 1024 * 1024,
//         maxCacheSize: 5120 * 1024 * 1024,
//         maxCacheFileSize: 5120 * 1024 * 1024,
//
//         ///Android only option to use cached video between app sessions
//         key: videoid.toString(),
//       ):BetterPlayerCacheConfiguration(
//         useCache: false,
//         // preCacheSize: 5120 * 1024 * 1024,
//         // maxCacheSize: 5120 * 1024 * 1024,
//         // maxCacheFileSize: 5120 * 1024 * 1024,
//
//         ///Android only option to use cached video between app sessions
//         key: videoid.toString(),
//       ),
//     );
//     HivebetterPlayerController =BetterPlayerController(HivebetterPlayerConfiguration);
//
//     HivebetterPlayerController.setupDataSource(dataSource);
//
//     HivebetterPlayerController.setBetterPlayerGlobalKey(HivebetterPlayerKey);
//     HivebetterPlayerController.addEventsListener((BetterPlayerEvent event) {
//       log('An EventType: ${event.betterPlayerEventType}');
//
//       if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingStart){
//         VideoLoadingloader(true);
//         update();
//       }
//       if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingUpdate){
//         if(HivebetterPlayerController.isBuffering()==true){
//           VideoLoadingloader(true);
//           update();
//         }
//         else{
//           VideoLoadingloader(false);
//           // HivebetterPlayerController.play();
//           update();
//         }
//         // VideoLoadingloader(false);
//         // update();
//       }
//       if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingEnd){
//         VideoLoadingloader(false);
//         update();
//       }
//
//       if (event.betterPlayerEventType ==BetterPlayerEventType.initialized) {
//         if(Environment.videoduration!=null){
//           var data = Environment.videoduration;
//           log("show data : "+data.toString());
//           HivebetterPlayerController.seekTo(Duration(
//               hours:int.parse(data.toString().split(":")[0]) ,
//               minutes: int.parse(data.toString().split(":")[1]),
//               seconds:int.parse(data.toString().split(":")[2].split(".")[0]) ));
//         }
//         update();
//
//       }
//       if (event.betterPlayerEventType ==BetterPlayerEventType.exception) {
//         log('An exception: ${event.betterPlayerEventType.name}');
//       }
//       if (event.betterPlayerEventType ==BetterPlayerEventType.progress) {
//         if(event.betterPlayerEventType ==BetterPlayerEventType.finished){
//           log('Save continue watching Clear>> ');
//           // sprefs.remove("video_duration");
//           // sprefs.remove("video_duration_bar");
//           // sprefs.remove("video_Cat_Id");
//           // sprefs.remove("video_Title");
//           HivebetterPlayerController.pause();
//           update();
//         }
//         else{
//
//           if(HivebetterPlayerController.videoPlayerController.value.position == HivebetterPlayerController.videoPlayerController.value.duration) {
//             print('video Ended');
//             // sprefs.remove("video_duration");
//             // sprefs.remove("video_duration_bar");
//             // sprefs.remove("video_Cat_Id");
//             // sprefs.remove("video_Title");
//             HivebetterPlayerController.pause();
//             log('NotSave continue watching');
//             update();
//           }
//           else{
//             var duration=  (HivebetterPlayerController.videoPlayerController.value.position.inSeconds / HivebetterPlayerController.videoPlayerController.value.duration.inSeconds);
//             // sprefs.setString("video_duration",HivebetterPlayerController.videoPlayerController.value.position.toString());
//             // sprefs.setString("video_duration_bar",duration.toString());
//
//             // sprefs.setString("video_Cat_Id",VideoDetaildata[0]['id'].toString());
//             // sprefs.setString("video_Title",VideoDetaildata[0]['title'].toString());
//             // log('Save continue watching ${event.betterPlayerEventType.name}');
//             // log('Save continue watching video_duration ${sprefs.getString('video_duration')}');
//             update();
//           }
//
//         }
//
//       }
//       else if(event.betterPlayerEventType ==BetterPlayerEventType.finished){
//         log('Save continue watching Clear>> ');
//         // sprefs.remove("video_duration");
//         // sprefs.remove("video_duration_bar");
//         // sprefs.remove("video_Cat_Id");
//         // sprefs.remove("video_Title");
//         // log(sprefs.getString("video_duration").toString());
//         //
//         // log(sprefs.getString("video_Cat_Id").toString());
//         // log(sprefs.getString("video_Title").toString());
//         HivebetterPlayerController.pause();
//         update();
//       }
// log("videoVisable.value>> "+videoVisable.value.toString());
//     });
//   }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
//   List<Task> _downloadTasks;
//   /// Process the user tapping on a notification by printing a message
//   void myNotificationTapCallback(Task task, NotificationType notificationType) {
//     debugPrint(
//         'Tapped notification $notificationType for taskId ${task.taskId}');
//   }
//
//   @override
//   void dispose() {
//     Get.delete<VideoDetailcontrollerComment>();
//     _timer.cancel();
//     super.dispose();
//   }
//
//   // Method to show labels based on current playback position
//   void _showLabels(BetterPlayerEvent event) {
//     // Duration currentPosition = event.parameters['duration'];
//
//     Duration currentPosition = betterPlayerController.videoPlayerController.value.position;
//     var videoLabels =VideoDetaildata[0]['video_labels'];
//     log("To Show label videoLabels ${videoLabels}");
//     for (var labelData in videoLabels) {
//       Duration startTime = _parseTime(labelData['start_time']);
//       Duration endTime = _parseTime(labelData['end_time']);

//       if (currentPosition >= startTime && currentPosition <= endTime) {
//         // Display label
//         DurationMessage.value=labelData['label'];
//        // log("To Show label  ${DurationMessage.value}");
//         update();
//         break;
//
//       }else{
//         DurationMessage.value="";
//         update();
//       }
//     }
//   }
//
// // Method to show labels based on current playback position
//   bool showColorLabels(time,end_time) {
//     // Duration currentPosition = event.parameters['duration'];
//     // log("To Show label startTime ${time}");
//     // log("To Show label endTime ${end_time}");
//     Duration currentPosition = betterPlayerController.videoPlayerController.value.position;
//
//     Duration startTime = _parseTime(time);
//     Duration endTime = _parseTime(end_time);
//
//     if (currentPosition >= startTime && currentPosition < endTime) {
//       // Display label
//
//       // update();
//       return true;
//
//     }else{
//       // DurationMessage.value="";
//       // update();
//       return false;
//     }
//   }
//
//   bool Savevideo_showColorLabels(time,end_time) {
//     // Duration currentPosition = event.parameters['duration'];
//
//
//     Duration currentPosition = HivebetterPlayerController.videoPlayerController.value.position;
//
//     Duration startTime = _parseTime(time);
//     Duration endTime = _parseTime(end_time);
//
//     if (currentPosition >= startTime && currentPosition < endTime) {
//       // Display label
//
//       // update();
//       return true;
//
//     }else{
//       // DurationMessage.value="";
//       // update();
//       return false;
//     }
//   }
//
//   // Method to parse time string to Duration object
//   Duration _parseTime(String timeString) {
//     List<String> parts = timeString.split(':');
//     return Duration(
//       hours: int.parse(parts[0]),
//       minutes: int.parse(parts[1]),
//       seconds: int.parse(parts[2]),
//     );
//   }
//
//   FetchVideoDetailData(Pausevideoduration) async {
//     VideoDetailloader(true);
//
//     VideoLoadingloader(true);
//     VideoAvailableloader(false);
//     Map<String, String> queryParams = {
//       "category_id": VideoDetailCatid.value.toString(),
//     };
//     String queryString = Uri(queryParameters: queryParams).query;
//     var videourl_api = apiUrls().videos_deatil_api + '?' + queryString;
//     log("FetchVideoDetailData>> url :${videourl_api} ");
//     try {
//       var result = await apiCallingHelper().getAPICall(videourl_api, true);
//
//       if (result != null) {
//         if (result.statusCode == 200) {
//           var FetchSubjectData = jsonDecode(result.body);
//           // log("FetchVideoDetailData response :$FetchSubjectData ");
//           VideoDetaildata.clear();
//           VideoDetaildata.add(FetchSubjectData['data']);
//           var url = "${VideoDetaildata[0]['pdf_attachment']}";
//           var url2 = "${VideoDetaildata[0]['thumb_image']}";
//           log("FetchVideoDetailData>> pdf :${url} ");
//           print("FetchVideoDetailData>> image :${url2} ");
//           if(VideoDetaildata[0]['pdf_attachment']!=null){
//             await createFileOfPdfUrl(url).then((f) async {
//               remotePDFpath = f.path;
//               log("FetchVideoDetailData>> remotePDFpath >> " + remotePDFpath.toString());
//
//
//
//               // pages= int.parse(controllerpdfview.getPageCount().toString());
//               update();
//             });
//           }
//           if(VideoDetaildata[0]['thumb_image']!=null){
//             await createFileOfPdfUrl(url2).then((f) {
//               Thumbimg_remotePDFpath = f.path;
//               log("FetchVideoDetailData>> Thumbimg >> " + Thumbimg_remotePDFpath.toString());
//               update();
//             });
//           }
//           var videourl = VideoDetaildata[0]['video_attachment'];
//
//           var videoId = VideoDetaildata[0]['id'];
//           var videoTitle = VideoDetaildata[0]['title'];
//           log("FetchVideoDetailData>> videourl :$videourl ");
//
//           if(videourl != null){
//             final response =await http.head(Uri.parse('${videourl}'));
//             log("FetchVideoDetailData>> statusCode :${response.statusCode} ");
//
//             if (response.statusCode == 200) {
//               var uri1 =Uri.parse(videourl);
//
//               var uri2 =uri1.replace(scheme: "https");
//               Video_downloadlisner(videourl,videoId,videoTitle);
//               VideoDetailloader(false);
//               update();
//               try{
//                 BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//                   BetterPlayerDataSourceType.network,
//
//                   uri2.toString(),
//                   // videoFormat:BetterPlayerVideoFormat.hls,
//                   // placeholder: Center(
//                   //   child: Container(
//                   //     padding: EdgeInsets.all(0.0),
//                   //     height: 200,
//                   //     child: Stack(
//                   //       alignment: Alignment.center,
//                   //       children: [
//                   //         FittedBox(
//                   //             fit: BoxFit.cover,
//                   //             child: Image.asset('assets/nprep2_images/video_background.png',
//                   //
//                   //                 errorBuilder: (context, error, stackTrace) {
//                   //                   return Container(
//                   //                     // color: Colors.grey.shade300,
//                   //                     alignment: Alignment.center,
//                   //                     child: Image.asset(
//                   //                       "assets/nprep2_images/video_background.png",
//                   //                       // height: 20,
//                   //                       width: MediaQuery.of(context).size.width * 0.18,
//                   //                     ),
//                   //                     // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
//                   //                     //   color: Colors.grey.shade300,),
//                   //                   );
//                   //                 })
//                   //
//                   //         ),
//                   //         Positioned(
//                   //
//                   //             child:  Container(
//                   //                 height: 40,
//                   //                 width: 40,
//                   //                 // color: Colors.red,
//                   //                 child: CircularProgressIndicator(color: grey,)))
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   cacheConfiguration:BetterPlayerCacheConfiguration(
//                     useCache: true,
//                     preCacheSize: 5120 * 1024 * 1024,
//                     maxCacheSize: 5120 * 1024 * 1024,
//                     maxCacheFileSize: 5120 * 1024 * 1024,
//
//                     ///Android only option to use cached video between app sessions
//                     key: VideoDetaildata[0]['id'].toString(),
//                   ),
//
//                 );
//
//
//
//                 VideoAvailableloader(false);
//                 betterPlayerController =BetterPlayerController(betterPlayerConfiguration);
//                 // if(Platform.isIOS){
//                 //   final http.Response responseData = await http.get(Uri.parse(videourl));
//                 //   log("FetchVideoDetailData>> videourlstatusCode :${responseData.statusCode} ");
//                 //   Uint8List uint8list = responseData.bodyBytes;
//                 //   File files = File.fromRawPath(uint8list);
//                 //   File file = File(files.path);
//                 //
//                 //   List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
//                 //   dataSource =BetterPlayerDataSource.memory(bytes, videoExtension: "mp4");
//                 // }
//                 betterPlayerController.setupDataSource(dataSource);
//
//                 betterPlayerController.setBetterPlayerGlobalKey(betterPlayerKey);
//
//                 opendilog();
//
//                 // Register error listener
//                 print('FetchVideoDetailData>> listener dataSource: ${dataSource.toString()}');
//
//                 betterPlayerController.addEventsListener((BetterPlayerEvent event) async {
//                   print('FetchVideoDetailData>> EventType: ${event.betterPlayerEventType}');
//
//                   if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingStart){
//                     VideoLoadingloader(true);
//                     update();
//                   }
//                   if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingUpdate){
//                     if(betterPlayerController.isBuffering()==true){
//                       VideoLoadingloader(true);
//                       update();
//                     }
//                     else{
//                       VideoLoadingloader(false);
//
//                       update();
//                     }
//
//                   }
//                   if(event.betterPlayerEventType ==BetterPlayerEventType.bufferingEnd){
//                     VideoLoadingloader(false);
//                     update();
//                   }
//                   if(event.betterPlayerEventType==BetterPlayerEventType.pause){
//                     var duration=  betterPlayerController.videoPlayerController.value.position;
//
//                     var videos_saved = "${apiUrls().videos_pause_api}$videoId&pause_time=${duration.toString().split(".")[0]}";
//                     var result = await apiCallingHelper().getAPICall(videos_saved, true);
//                     if(event.betterPlayerEventType==BetterPlayerEventType.finished){
//                       var videos_saved = "${apiUrls().videos_pause_api}$videoId&pause_time=${''}";
//                       var result = await apiCallingHelper().getAPICall(videos_saved, true);
//                     }
//                   }
//                   if (event.betterPlayerEventType ==BetterPlayerEventType.initialized) {
//                     videoduration =betterPlayerController.videoPlayerController.value.duration;
//                     log("FetchVideoDetailData>> videoduration>> : "+videoduration.toString());
//                     betterPlayerController.pause();
//                     if(Pausevideoduration == null){
//                       if(Environment.videoduration!=null){
//                         var data = Environment.videoduration;
//                         log("show data : "+data.toString());
//                         betterPlayerController.seekTo(Duration(
//                             hours:int.parse(data.toString().split(":")[0]) ,
//                             minutes: int.parse(data.toString().split(":")[1]),
//                             seconds:int.parse(data.toString().split(":")[2].split(".")[0]) ));
//                       }
//                     }
//                     else{
//                       log("show data videoduration: "+Pausevideoduration.toString());
//                       log("show data videoduration: "+Pausevideoduration.toString().split(":")[2].split(".")[0].toString());
//                       betterPlayerController.seekTo(Duration(
//                           hours:int.parse(Pausevideoduration.toString().split(":")[0]) ,
//                           minutes: int.parse(Pausevideoduration.toString().split(":")[1]),
//                           seconds:int.parse(Pausevideoduration.toString().split(":")[2].split(".")[0]) ));
//                     }
//                     update();
//                   }
//                   if (event.betterPlayerEventType ==BetterPlayerEventType.exception) {
//                     log('FetchVideoDetailData>> exception: ${event.betterPlayerEventType.name}');
//                   }
//                   if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
//                     log("FetchVideoDetailData>> video_labels>> "+VideoDetaildata[0]['video_labels'].toString());
//                     if(VideoDetaildata[0]['video_labels'].length!=0){
//                       _showLabels(event);
//                       update();
//                     }
//
//                   }
//                   if (event.betterPlayerEventType ==BetterPlayerEventType.progress) {
//                     if(event.betterPlayerEventType ==BetterPlayerEventType.finished){
//                       log('FetchVideoDetailData>> Save continue watching Clear>> ');
//                       sprefs.remove("video_duration");
//                       sprefs.remove("video_duration_bar");
//                       sprefs.remove("video_Cat_Id");
//                       sprefs.remove("video_Title");
//                       betterPlayerController.pause();
//                       update();
//                     }
//                     else{
//
//                       if(betterPlayerController.videoPlayerController.value.position == betterPlayerController.videoPlayerController.value.duration) {
//                         print('FetchVideoDetailData>> video Ended');
//                         sprefs.remove("video_duration");
//                         sprefs.remove("video_duration_bar");
//                         sprefs.remove("video_Cat_Id");
//                         sprefs.remove("video_Title");
//                         betterPlayerController.pause();
//                         var videos_saved = "${apiUrls().videos_pause_api}$videoId&pause_time=${''}";
//                         var result = await apiCallingHelper().getAPICall(videos_saved, true);
//                         log('NotSave continue watching');
//                         update();
//                       }
//
//
//                       else{
//                         var duration=  (betterPlayerController.videoPlayerController.value.position.inSeconds / betterPlayerController.videoPlayerController.value.duration.inSeconds);
//                         sprefs.setString("video_duration",betterPlayerController.videoPlayerController.value.position.toString());
//                         sprefs.setString("video_duration_bar",duration.toString());
//                         sprefs.setString("video_Cat_Id",VideoDetaildata[0]['id'].toString());
//                         sprefs.setString("video_Title",VideoDetaildata[0]['title'].toString());
//                         log('FetchVideoDetailData>> Save continue watching ${event.betterPlayerEventType.name}');
//                         log('FetchVideoDetailData>> Save continue watching video_duration ${sprefs.getString('video_duration')}');
//
//                         update();
//                       }
//
//                     }
//                   }
//                   else if(event.betterPlayerEventType ==BetterPlayerEventType.finished){
//                     log('FetchVideoDetailData>> Save continue watching Clear>> ');
//                     sprefs.remove("video_duration");
//                     sprefs.remove("video_duration_bar");
//                     sprefs.remove("video_Cat_Id");
//                     sprefs.remove("video_Title");
//                     log(sprefs.getString("video_duration").toString());
//
//                     log(sprefs.getString("video_Cat_Id").toString());
//                     log(sprefs.getString("video_Title").toString());
//
//                     betterPlayerController.pause();
//                     update();
//                   }
//                   // if (event.betterPlayerEventType == BetterPlayerEventType.controlsHiddenStart) {
//                   //
//                   //   videoVisable.value = true;
//                   //   update();
//                   //
//                   // }
//                   if(event.betterPlayerEventType == BetterPlayerEventType.controlsHiddenEnd){
//                     videoVisable.value = false;
//                     update();
//                   }
//                   if (event.betterPlayerEventType == BetterPlayerEventType.controlsVisible) {
//
//                     videoVisable.value = true;
//                     update();
//
//                   }
//                   log('FetchVideoDetailData>> videoVisable: ${videoVisable.value}');
//
//                 });
//               }
//               catch(e){
//                 print('FetchVideoDetailData>> Excpetion: ${e.toString()}');
//               }
//
//             }
//             else{
//
//               VideoAvailableloader(true);
//               VideoDetailloader(false);
//               update();
//             }
//           }
//           videoimage.value = VideoDetaildata[0]['thumb_image'];
//           VideoDetailloader(false);
//           update();
//           refresh();
//         }
//         else if (result.statusCode == 404) {
//           var FetchSubjectData = jsonDecode(result.body);
//           VideoDetailStatusCode.value = result.statusCode;
//           VideoDetailErrorMSg.value = FetchSubjectData['message'];
//           VideoDetaildata = [];
//           VideoDetailloader(false);
//           update();
//         }
//         else if (result.statusCode == 401) {
//           var FetchSubjectData = jsonDecode(result.body);
//           VideoDetailStatusCode.value = result.statusCode;
//           VideoDetailErrorMSg.value = FetchSubjectData['message'];
//           VideoDetaildata = [];
//           VideoDetailloader(false);
//           update();
//         }
//         else {
//           VideoDetaildata = [];
//           VideoDetailloader(false);
//         }
//         update();
//         refresh();
//       }
//     } catch (e) {
//       log("FetchVideoDetailData error ........${e}");
//       VideoDetailloader(false);
//       update();
//     }
//   }
//
//   int compareTimes(String startTime, String endTime) {
//     List<String> startParts = startTime.split(':');
//     List<String> endParts = endTime.split(':');
//
//     int startHour = int.parse(startParts[0]);
//     int startMinute = int.parse(startParts[1]);
//     int startSecond = int.parse(startParts[2]);
//
//     int endHour = int.parse(endParts[0]);
//     int endMinute = int.parse(endParts[1]);
//     int endSecond = int.parse(endParts[2]);
//
//     if (startHour != endHour) {
//       return startHour - endHour;
//     } else if (startMinute != endMinute) {
//       return startMinute - endMinute;
//     } else {
//       return startSecond - endSecond;
//     }
//   }
//
//   Future<File> createFileOfPdfUrl(String url) async {
//     print("Start download file from internet!");
//     try {
//       // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
//       // final url = "https://pdfkit.org/docs/guide.pdf";
//       // final url = "http://www.pdf995.com/samples/pdf.pdf";
//       final filename = url.substring(url.lastIndexOf("/") + 1);
//       var dir;
//       if(Platform.isAndroid){
//         dir = await getApplicationDocumentsDirectory();
//       }else{
//         dir = await getLibraryDirectory();
//       }
//       log("path> ${dir.path}/ $filename");
//       File file = File("${dir.path}/$filename");
//       if (await file.exists()) {
//         update();
//         return file;
//       }else{
//         var data = await http.get(Uri.parse(url));
//         var contentLength = data.contentLength;
//         var bytes = data.bodyBytes;
//         log("contentLength>  $contentLength");
//         log("bytesLength>  ${bytes.length}");
//         File urlFile = await file.writeAsBytes(bytes);
//         print("Download files");
//         return urlFile;
//       }
//
//
//
//
//
//
//
//     } catch (e) {
//       throw Exception('Error parsing asset file!');
//     }
//   }
//
//   buttonstateUpdate(text){
//     buttonState.value = text;
//
//     log('Download>> buttonstateUpdate<< buttonstateUpdate>>'+buttonState.toString());
//     update();
//   }
//   void taskProgressCallback(TaskProgressUpdate update) {
//     log('Video_downloadlisner>> taskProgressCallback for ${update.task} with progress ${update.progress}');
//   }
//   void taskStatusCallback(TaskStatusUpdate update) {
//     log('Video_downloadlisner>> taskStatusCallback for ${update.task} with status ${update.status} and exception ${update.exception}');
//   }
//   Video_downloadlisner(videourl,taskId,name) async {
//     // at app startup, after registering listener or callback, start tracking
//
//     // see CONFIG.md - some examples shown here
//     log('Video_downloadlisner>> Start');
//     // or get record for specific task
//     final record = await FileDownloader().database.recordForId(taskId.toString());
//     log('Video_downloadlisner>> download taskss|| '+record.toString());
//     // Listen for download progress
//     if(record!=null){
//       try{
//         if(record.status==TaskStatus.complete){
//           var text = ButtonState.complete;
//           buttonstateUpdate(text);
//           progressStatus(false);
//           progress = record.progress;
//         }else if(record.status==TaskStatus.paused){
//           var text = ButtonState.resume;
//           buttonstateUpdate(text);
//           progress = record.progress<=0.0?0.0:record.progress;
//           update();
//         }
//         else {
//           var text = ButtonState.download;
//           buttonstateUpdate(text);
//           progressStatus(true);
//
//           FileDownloader().registerCallbacks(taskStatusCallback: taskStatusCallback,taskProgressCallback: taskProgressCallback);
//
//           await FileDownloader().enqueue(record.task);
//
//
//           progress = record.progress<=0.0?0.0:record.progress;
//           update();
//         }
//       }
//       catch(e){
//         log("Check Exception>> "+e.toString());
//       }
//
//     }
//     else{
//     }
//
//   }
//   void downloadButtonPressed(url, videoid,name,image) async {
//     var text = ButtonState.download;
//     buttonstateUpdate(text);
//     File file;
//     progressStatus(true);
//
//     update();
//
//
//     var dir;
//     if(Platform.isAndroid){
//       dir = await getApplicationDocumentsDirectory();
//     }else{
//       dir = await getLibraryDirectory();
//     }
//
//     file = File('${dir.path}/nprep/$name');
//     log("file>> : ${file}");
//     try{
//
//       task = DownloadTask(
//           url: url,
//           filename: "$name",
//           directory: 'nprep',
//           updates: Updates.statusAndProgress,
//           requiresWiFi: false,
//           retries: 10,
//           taskId: videoid.toString(),
//           allowPause: true,
//
//           metaData: '${image}');
//       log("percentage : $task");
//       FileDownloader().configureNotification(
//           running: TaskNotification('Downloading', ' ${name}',),
//           complete:  TaskNotification('Your download has been completed', ' ${name}'),
//           paused: TaskNotification('Your download has been paused', ' ${name}'),
//           progressBar: true
//       );
//       FileDownloader().registerCallbacks(taskStatusCallback: taskStatusCallback,taskProgressCallback: taskProgressCallback);
//
//
//       await FileDownloader().download(
//           task,
//
//           onProgress: (value) {
//             if (!value.isNegative) {
//               progress = value;
//               log("Download Progress Button >> "+progress.toString());
//
//               progressStatus(true);
//               update();
//
//             }
//
//           },
//           onStatus: (status) async {
//             log("Download Status>> "+status.toString());
//             if(status==TaskStatus.complete){
//               var text = ButtonState.complete;
//
//               var body={
//                 'id': VideoDetaildata[0]['id'].toString(),
//                 'video_path': file.path.toString(),
//                 'video_title': VideoDetaildata[0]['title'],
//                 'video_duration': VideoDetaildata[0]['video_time'],
//                 'video_Stamps': VideoDetaildata[0]['video_stamps'],
//                 'video_Notes': remotePDFpath.toString(),
//                 'video_thumb_image': Thumbimg_remotePDFpath.toString(),
//               };
//
//               log("Video Saved body"+body.toString());
//
//               final DatabaseService _databaseService = DatabaseService.instance;
//               _databaseService.addTask(VideoDetaildata[0]['title'].toString(),VideoDetaildata[0]['id'], jsonEncode(VideoDetaildata[0]['video_stamps']).toString(), remotePDFpath.toString(), file.path.toString(), Thumbimg_remotePDFpath.toString(),VideoDetaildata[0]['video_time'].toString());
//
//               log("Video Saved Api");
//               var videos_saved = "${apiUrls().videos_saved_api}$videoid";
//               var result = await apiCallingHelper().getAPICall(videos_saved, true);
//               updatecatid(videoid);
//               videolisner();
//               var data = jsonDecode(result.body);
//               toastMsg(data['message'], true);
//               VideoDetaildata[0]['is_download'] =1;
//               buttonstateUpdate(text);
//               progressStatus(false);
//               update();
//             }
//             else if (status==TaskStatus.paused){
//               var text = ButtonState.resume;
//               buttonstateUpdate(text);
//               progressStatus(true);
//               update();
//             }
//             else if (status==TaskStatus.running){
//               var text = ButtonState.download;
//               FileDownloader().configureNotification(
//
//                   running: TaskNotification('Downloading', ' ${name}'),
//                   complete:  TaskNotification('Your download has been completed', ' ${name}'),
//                   paused: TaskNotification('Your download has been paused', ' ${name}'),
//                   progressBar: true
//               );
//               buttonstateUpdate(text);
//               progressStatus(true);
//               update();
//             }
//             else if (status==TaskStatus.enqueued){
//               var text = ButtonState.download;
//               buttonstateUpdate(text);
//               progressStatus(true);
//               update();
//             }
//
//           }
//       );
//       ///--------------------///
//
//
//     }catch (e) {
//       print("Download Exception << "+e.toString());
//     }
//
//
//   }
//   // void downloadButtonPressed(url, videoid,name) async {
//   //   File file;
//   //   progressStatus(true);
//   //   progress = 0.0;
//   //   update();
//   //
//   //   final filename = url.substring(url.lastIndexOf("/") + 1);
//   //   var dir;
//   //   if(Platform.isAndroid){
//   //     dir = await getApplicationDocumentsDirectory();
//   //   }else{
//   //     dir = await getLibraryDirectory();
//   //   }
//   //
//   //   file = File('${dir.path}/$filename');
//   //   log("file>> : ${file}");
//   //   if (await file.exists()) {
//   //     progressStatus(false);
//   //     toastMsg('Already Downloaded', true);
//   //     update();
//   //   } else {
//   //     toastMsg("Do not close the app till your video is downloading.", true);
//   //     log("dir.path : ${dir.path}");
//   //     Dio dio = Dio();
//   //     dio.download(url, '${dir.path}/$filename',
//   //
//   //     onReceiveProgress: (received, total) async {
//   //       int percentage = ((received / total) * 100).floor();
//   //       progress = (percentage ?? 0) / 100;
//   //       _status = percentage.toString();
//   //       update();
//   //       log("percentage : $percentage");
//   //       log("percentage progress : $progress");
//   //       progressStatus(true);
//   //
//   //       var body = "Downloading video ${percentage}%";
//   //       createNotification(100, ((received / total) * 100).toInt(), 1,
//   //           VideoDetaildata[0]['title'], body);
//   //       if (percentage == 100) {
//   //         var body={
//   //           'id': VideoDetaildata[0]['id'].toString(),
//   //           'video_path': file.path.toString(),
//   //           'video_title': VideoDetaildata[0]['title'],
//   //           'video_duration': VideoDetaildata[0]['video_time'],
//   //           'video_Stamps': VideoDetaildata[0]['video_stamps'],
//   //           'video_Notes': remotePDFpath.toString(),
//   //           'video_thumb_image': Thumbimg_remotePDFpath.toString(),
//   //         };
//   //         createItem({
//   //           'id': VideoDetaildata[0]['id'].toString(),
//   //           'video_path': file.path.toString(),
//   //           'video_title': VideoDetaildata[0]['title'],
//   //           'video_duration': VideoDetaildata[0]['video_time'],
//   //           'video_Stamps': VideoDetaildata[0]['video_stamps'],
//   //           'video_Notes': remotePDFpath.toString(),
//   //           'video_thumb_image': Thumbimg_remotePDFpath.toString(),
//   //         });
//   //         log("Video Saved body"+body.toString());
//   //         log("Video Saved Api");
//   //         var videos_saved = "${apiUrls().videos_saved_api}$videoid";
//   //         var result = await apiCallingHelper().getAPICall(videos_saved, true);
//   //         updatecatid(videoid);
//   //         videolisner();
//   //         var data = jsonDecode(result.body);
//   //         toastMsg(data['message'], true);
//   //
//   //         progressStatus(false);
//   //         update();
//   //       }
//   //       update();
//   //     }
//   //     );
//   //   }
//   // }
//
//
//
//   void createNotification(int count, int i, int id, title, body) {
//     //show the notifications.
//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('logo');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//             onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsDarwin,
//             linux: initializationSettingsLinux);
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'progress channel', 'progress channel',
//         channelDescription: 'progress channel description',
//         channelShowBadge: false,
//         importance: Importance.max,
//         priority: Priority.high,
//         onlyAlertOnce: true,
//         showProgress: true,
//         maxProgress: count,
//         progress: i);
//     var platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     flutterLocalNotificationsPlugin
//         .show(id, title, body, platformChannelSpecifics, payload: 'item x');
//   }
//
//
// }
