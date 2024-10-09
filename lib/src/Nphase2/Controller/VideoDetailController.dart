import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:chewie/chewie.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:chewie/chewie.dart';
// import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/App_update/App_Mentaintion_Mood.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseVideoModel.dart';
// import 'package:n_prep/src/Nphase2/Controller/video_item.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../Envirovement/Environment.dart';
import '../../home/bottom_bar.dart';
import 'custom_controls_widget.dart';
enum ButtonState { download, cancel, pause, resume, reset,running,complete }

class VideoDetailcontroller extends GetxController {
  ///Hive

  bool isFullScreen = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

var videoVisable = false.obs;
  updatevideoVisable() {
    if (videoVisable == false) {

      videoVisable.value = true;
      update();
    } else {
      videoVisable.value = false;
      update();
    }
    log("videoVisable: " + videoVisable.value.toString());
  }





var videothumbImgUrl;

DownloadTask task;
  double progress = 0.0;
  var progressStatus = false.obs;
  Rx<ButtonState> buttonState = ButtonState.download.obs;
  var _status = "Not Downloaded";
  get status => _status;

  ///Hive End
  var VideoDetailOrintaion = false.obs;

  var VideoDetailloader = false.obs;


  var VideoAvailableloader = false.obs;
  var VideoLoadingBeforeloader = false.obs;
  var Videoplayloader = false.obs;
  var VideoDetailCatid = 0.obs;
  var VideoDetailStatusCode = 0.obs;
  var VideoDetailErrorMSg = "".obs;

  List VideoDetaildata = [];
  RxBool isInSmallMode = false.obs;
  Duration videoduration =Duration(seconds: 10,minutes: 10,hours: 10);

  GlobalKey betterPlayerKey = GlobalKey();
  GlobalKey FullPagebetterPlayerKey = GlobalKey();
  GlobalKey HivebetterPlayerKey = GlobalKey();

  //----Pdf
  String remotePDFpath = "";
  String Thumbimg_remotePDFpath = "";
  int currentPage = 0;
  int TotalPage = 0;
  int pages = 0;
  var top_post = 0.obs;
  var top_post_small = 0.obs;
  var right_post = 0.obs;
  var right_post_small = 0.obs;
  bool isReady = false;
  String errorMessage = '';
  var DurationMessage = ''.obs;
  PDFViewController controllerpdfview;
  VideoPlayerController betterPlayerController_videoplayer;
  ChewieController betterPlayerController;

  updatecatid(id) {
    VideoDetailCatid.value = id;

    update();
  }
  var dragAlignment = Alignment.bottomRight;
   AnimationController Animation_controller;
   Animation<Alignment> Animation_con;
  final Animation_spring = SpringDescription(mass: 10, stiffness: 1000, damping: 0.9);

  updateVideoOrientation() {
    if (isFullScreen) {
      // Exit full-screen mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      isFullScreen = false;
    } else {
      // Enter full-screen mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      isFullScreen = true;
    }
    update(); // Notify listeners
  }


  updatevideoscreen() {
    if (isInSmallMode == false) {
      isInSmallMode.value = true;
      update();
    } else {
      isInSmallMode.value = false;

      update();
    }
    log("ismallmode: " + isInSmallMode.value.toString());
  }
  void runAnimation(Offset velocity, Size size) {

    log("runAnimation");
    Animation_con = Animation_controller.drive(
      AlignmentTween(
        begin: dragAlignment,
        end: Alignment.center,
      ),
    );
    final simulation = SpringSimulation(
      Animation_spring, 0, 0.0,
      _normalizeVelocity(velocity, size),
    );
    update();
    Animation_controller.animateWith(simulation);
  }
  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizedVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );

    return normalizedVelocity.distance;
  }
  @override
  void onReady() {
    super.onReady();
    TimerForrandom();
  }
  Timer _timer ;
  TimerForrandom(){
    // videoDetailcontroller.isInSmallMode == true
  _timer =  Timer.periodic(Duration(seconds: 10), (timer) {
      top_post.value= random.nextInt(200);
      right_post.value= random.nextInt(300);
      top_post_small.value= random.nextInt(80);
      right_post_small.value= random.nextInt(10);

      update();
    });

}
  opendilog() {
    if (sprefs.getBool("updateshowpop") == false ||
        sprefs.getBool("updateshowpop") == null) {
      Get.dialog(MyDialog());
    } else {}
  }





  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  List<Task> _downloadTasks;
  /// Process the user tapping on a notification by printing a message
  void myNotificationTapCallback(Task task, NotificationType notificationType) {
    debugPrint(
        'Tapped notification $notificationType for taskId ${task.taskId}');
  }

  @override
  void dispose() {
    Get.delete<VideoDetailcontroller>();
    _timer.cancel();
    betterPlayerController.dispose();
    betterPlayerController_videoplayer.dispose();
    super.dispose();
  }

  // Method to show labels based on current playback position
  void _showLabels(time) {
    // Duration currentPosition = event.parameters['duration'];
    Duration currentPosition;
    if(Videoplayloader.value==true){
      currentPosition = betterPlayerController.videoPlayerController.value.position;
    }else{
      currentPosition = _parseTime(VideoDetaildata[0]['video_stamps'][0]["time"]);
    }
     var videoLabels =VideoDetaildata[0]['video_labels'];
    log("To Show label videoLabels ${videoLabels}");
    for (var labelData in videoLabels) {
      Duration startTime = _parseTime(labelData['start_time']);
      Duration endTime = _parseTime(labelData['end_time']);

      if (currentPosition >= startTime && currentPosition < endTime) {
        // Display label
        DurationMessage.value=labelData['label'];
       // log("To Show label  ${DurationMessage.value}");
        update();
        break;

      }else{
        DurationMessage.value="";
        update();
      }
    }
  }

// Method to show labels based on current playback position
  bool showColorLabels(time,end_time) {
    // Duration currentPosition = event.parameters['duration'];
    // log("To Show label startTime ${time}");
    // log("To Show label endTime ${end_time}");

    Duration currentPosition;
    if(Videoplayloader.value==true){
    currentPosition = betterPlayerController.videoPlayerController.value.position;
    }else{
    currentPosition = _parseTime(VideoDetaildata[0]['video_stamps'][0]["time"]);
    }

    Duration startTime = _parseTime(time);
    Duration endTime = _parseTime(end_time);

    if (currentPosition >= startTime && currentPosition < endTime) {
      // Display label
      _showLabels(time);
      // update();
      return true;

    }else{
      // DurationMessage.value="";
      // update();
      return false;
    }
  }


  // Method to parse time string to Duration object
  Duration _parseTime(String timeString) {
    List<String> parts = timeString.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }
  videoplayerstart(videoplayerUrl) async {
    Videoplayloader(false);
    VideoDetailloader(false);
    VideoLoadingBeforeloader(true);
    update();
    if(videoplayerUrl != null){
      final response =await http.head(Uri.parse('${videoplayerUrl}'));
      log("FetchVideoDetailData>> statusCode :${response.statusCode} ");

      if (response.statusCode == 200) {

        betterPlayerController_videoplayer = VideoPlayerController.networkUrl(
          Uri.parse(videoplayerUrl),
        );
        await betterPlayerController_videoplayer.initialize();

        betterPlayerController = ChewieController(
            videoPlayerController: betterPlayerController_videoplayer,
            autoPlay: false,
            looping: false,
            allowMuting: false,
            fullScreenByDefault: false,
            showControls: false
        );
        betterPlayerController.play();
        Videoplayloader(true);
        VideoLoadingBeforeloader(false);
        VideoAvailableloader(false);

        update();
      }
      else{
        Videoplayloader(false);
        VideoLoadingBeforeloader(false);
        VideoAvailableloader(true);
        update();
      }
    }
    else{
      Videoplayloader(false);
      VideoLoadingBeforeloader(false);
      VideoAvailableloader(true);
      update();
    }
  }



  FetchVideoDetailData(Pausevideoduration) async {
    var temp = await sprefs.getBool("is_internet");
    if(temp){
      VideoDetailloader(true);

      VideoAvailableloader(false);
      Map<String, String> queryParams = {
        "category_id": VideoDetailCatid.value.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var videourl_api = apiUrls().videos_deatil_api + '?' + queryString;
      log("FetchVideoDetailData>> url :${videourl_api} ");
      try {
        var result = await apiCallingHelper().getAPICall(videourl_api, true);

        if (result != null) {
          if (result.statusCode == 200) {
            var FetchSubjectData = jsonDecode(result.body);
            // log("FetchVideoDetailData response :$FetchSubjectData ");
            VideoDetaildata.clear();
            VideoDetaildata.add(FetchSubjectData['data']);
            var pdfurl = "${VideoDetaildata[0]['pdf_attachment']}";
            var thumbImgurl = "${VideoDetaildata[0]['thumb_image']}";
            videothumbImgUrl=thumbImgurl;
            update();
            log("FetchVideoDetailData>> pdf :${pdfurl} ");
            print("FetchVideoDetailData>>>> image :${thumbImgurl} ");


            var videoplayerUrl = VideoDetaildata[0]['video_attachment'];
            videoplayerstart(videoplayerUrl);
            if(VideoDetaildata[0]['pdf_attachment']!=null){
              await createFileOfPdfUrl(pdfurl).then((f) async {
                remotePDFpath = f.path;
                log("FetchVideoDetailData>> remotePDFpath >> " + remotePDFpath.toString());



                // pages= int.parse(controllerpdfview.getPageCount().toString());
                update();
              });
            }
            if(VideoDetaildata[0]['thumb_image']!=null){
              await createFileOfPdfUrl(thumbImgurl).then((f) {
                Thumbimg_remotePDFpath = f.path;
                log("FetchVideoDetailData>> Thumbimg >> " + Thumbimg_remotePDFpath.toString());
                update();
              });
            }


            var videoId = VideoDetaildata[0]['id'];
            var videoTitle = VideoDetaildata[0]['title'];
            log("FetchVideoDetailData>> videoplayerUrl :$videoplayerUrl ");
            Video_downloadlisner(videoplayerUrl,videoId,videoTitle);

            opendilog();
            update();
            refresh();
          }
          else if (result.statusCode == 404) {
            var FetchSubjectData = jsonDecode(result.body);
            VideoDetailStatusCode.value = result.statusCode;
            VideoDetailErrorMSg.value = FetchSubjectData['message'];
            VideoDetaildata = [];
            VideoDetailloader(false);
            update();
          }
          else if (result.statusCode == 401) {
            var FetchSubjectData = jsonDecode(result.body);
            VideoDetailStatusCode.value = result.statusCode;
            VideoDetailErrorMSg.value = FetchSubjectData['message'];
            VideoDetaildata = [];
            VideoDetailloader(false);
            update();
          }
          else {
            VideoDetaildata = [];
            VideoDetailloader(false);
          }
          update();
          refresh();
        }
      } catch (e) {
        log("FetchVideoDetailData error ........${e}");
        VideoDetailloader(false);
        update();
      }
    }else{
      VideoDetailloader(true);
      update();
      refresh();
      Get.offAll(BottomBar(bottomindex: 3,));
      toastMsg("No Internet Connected with No Internet Available", true);
    }
  }



  Future<File> createFileOfPdfUrl(String url) async {
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      // final url = "http://www.pdf995.com/samples/pdf.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var dir;
      if(Platform.isAndroid){
        dir = await getApplicationDocumentsDirectory();
      }else{
        dir = await getLibraryDirectory();
      }
      log("path> ${dir.path}/ $filename");
      File file = File("${dir.path}/$filename");
      if (await file.exists()) {
        update();
        return file;
      }else{
        var data = await http.get(Uri.parse(url));
        var contentLength = data.contentLength;
        var bytes = data.bodyBytes;
        log("contentLength>  $contentLength");
        log("bytesLength>  ${bytes.length}");
        File urlFile = await file.writeAsBytes(bytes);
        print("Download files");
        return urlFile;
      }







    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
  }

  buttonstateUpdate(text){
    buttonState.value = text;

    log('Download>> buttonstateUpdate<< buttonstateUpdate>>'+buttonState.toString());
    update();
  }
  void taskProgressCallback(TaskProgressUpdate update) {
    log('Video_downloadlisner>> taskProgressCallback for ${update.task} with progress ${update.progress}');
  }
  void taskStatusCallback(TaskStatusUpdate update) {
    log('Video_downloadlisner>> taskStatusCallback for ${update.task} with status ${update.status} and exception ${update.exception}');
  }
  Video_downloadlisner(videourl,taskId,name) async {
    // at app startup, after registering listener or callback, start tracking

    // see CONFIG.md - some examples shown here
    log('Video_downloadlisner>> Start');
    // or get record for specific task
    final record = await FileDownloader().database.recordForId(taskId.toString());
    log('Video_downloadlisner>> download taskss|| '+record.toString());
    // Listen for download progress
    if(record!=null){
      try{
        if(record.status==TaskStatus.complete){
          var text = ButtonState.complete;
          buttonstateUpdate(text);
          progressStatus(false);
          progress = record.progress;
        }
        else if(record.status==TaskStatus.paused){
          var text = ButtonState.resume;
          buttonstateUpdate(text);
          progress = record.progress<=0.0?0.0:record.progress;
          update();
        }
        else if(record.status==TaskStatus.canceled){
          var text = ButtonState.cancel;
          buttonstateUpdate(text);
          progressStatus(false);
          progress = 0.0;
          update();
        }
        else if(record.status==TaskStatus.failed){

          progressStatus(false);
          progress = 0.0;
          update();
        }
        else if(record.status==TaskStatus.enqueued){

          progressStatus(false);
          progress = 0.0;
          update();
        }
        else if(record.status==TaskStatus.notFound){

          progressStatus(false);
          progress = 0.0;
          update();
        }
        else {
          var text = ButtonState.download;
          buttonstateUpdate(text);
          progressStatus(true);

          FileDownloader().registerCallbacks(taskStatusCallback: taskStatusCallback,taskProgressCallback: taskProgressCallback);

          await FileDownloader().enqueue(record.task);


          progress = record.progress<=0.0?0.0:record.progress;
          update();
        }
      }
      catch(e){
        log("Check Exception>> "+e.toString());
      }

    }
    else{
      progressStatus(false);
      progress = 0.0;
      update();
    }

  }
  void downloadButtonPressed(url, videoid,name,image) async {
    var text = ButtonState.download;
    buttonstateUpdate(text);
    File file;


    update();

    final filename = url.substring(url.lastIndexOf("/") + 1);
    var dir;
    if(Platform.isAndroid){
      dir = await getApplicationDocumentsDirectory();
    }else{
      dir = await getLibraryDirectory();
    }

    file = File('${dir.path}/$filename');
    log("file>> : ${file}");

    try{

      task = DownloadTask(
          url: url,
          filename: "$filename",
          updates: Updates.statusAndProgress,
          requiresWiFi: false,
          retries: 10,
          taskId: videoid.toString(),
          allowPause: true,
          baseDirectory: BaseDirectory.applicationDocuments,
          metaData: '${image}/-/${name}');
      progressStatus(true);
      log("downloadButtonPressed task : $task");
      FileDownloader().configureNotification(
          running: TaskNotification('Downloading', ' ${name}',),
          complete:  TaskNotification('Your download has been completed', ' ${name}'),
          paused: TaskNotification('Your download has been paused', ' ${name}'),
          progressBar: true
      );
      FileDownloader().registerCallbacks(taskStatusCallback: taskStatusCallback,taskProgressCallback: taskProgressCallback);


      await FileDownloader().download(
          task,
          onProgress: (value) {
            if (!value.isNegative) {
              progress = value;
              log("Download Progress Button >> "+progress.toString());

              progressStatus(true);
              update();

            }

          },
          onStatus: (status) async {
            log("Download Status>> "+status.toString());
            if(status==TaskStatus.complete){
              if (await file.exists()) {
                print('downloaded to download <video.>: ${file.path}');
              } else {
                print('Failed to download <video.>');
              }
              var text = ButtonState.complete;

              var body={
                'id': VideoDetaildata[0]['id'].toString(),
                'video_path': file.path.toString(),
                'video_title': VideoDetaildata[0]['title'],
                'video_duration': VideoDetaildata[0]['video_time'],
                'video_Stamps': VideoDetaildata[0]['video_stamps'],
                'video_Notes': remotePDFpath.toString(),
                'video_thumb_image': Thumbimg_remotePDFpath.toString(),
              };

              log("Video Saved body"+body.toString());

              final DatabaseService _databaseService = DatabaseService.instance;
              _databaseService.addTask(VideoDetaildata[0]['title'].toString(),VideoDetaildata[0]['id'], jsonEncode(VideoDetaildata[0]['video_stamps']).toString(), remotePDFpath.toString(), file.path.toString(), Thumbimg_remotePDFpath.toString(),VideoDetaildata[0]['video_time'].toString());

              log("Video Saved Api");
              var videos_saved = "${apiUrls().videos_saved_api}$videoid";
              var result = await apiCallingHelper().getAPICall(videos_saved, true);
              updatecatid(videoid);
              var data = jsonDecode(result.body);
              toastMsg(data['message'], true);
              VideoDetaildata[0]['is_download'] =1;
              buttonstateUpdate(text);
              progressStatus(false);
              update();
            }
            else if (status==TaskStatus.paused){
              var text = ButtonState.resume;
              buttonstateUpdate(text);
              progressStatus(true);
              update();
            }
            else if (status==TaskStatus.running){
              var text = ButtonState.download;
              FileDownloader().configureNotification(

                  running: TaskNotification('Downloading', ' ${name}'),
                  complete:  TaskNotification('Your download has been completed', ' ${name}'),
                  paused: TaskNotification('Your download has been paused', ' ${name}'),
                  progressBar: true
              );
              buttonstateUpdate(text);
              progressStatus(true);
              update();
            }
            else if (status==TaskStatus.enqueued){
              var text = ButtonState.download;
              buttonstateUpdate(text);
              progressStatus(true);
              update();
            }

          },
          onElapsedTime: (onelp)async{
            print("Download onelp << "+onelp.toString());
          },


      );
      ///--------------------///


    }catch (e) {
      print("Download Exception << "+e.toString());
    }


  }

  // void downloadButtonPressed(url, videoid,name) async {
  //   File file;
  //   progressStatus(true);
  //   progress = 0.0;
  //   update();
  //
  //   final filename = url.substring(url.lastIndexOf("/") + 1);
  //   var dir;
  //   if(Platform.isAndroid){
  //     dir = await getApplicationDocumentsDirectory();
  //   }else{
  //     dir = await getLibraryDirectory();
  //   }
  //
  //   file = File('${dir.path}/$filename');
  //   log("file>> : ${file}");
  //   if (await file.exists()) {
  //     progressStatus(false);
  //     toastMsg('Already Downloaded', true);
  //     update();
  //   } else {
  //     toastMsg("Do not close the app till your video is downloading.", true);
  //     log("dir.path : ${dir.path}");
  //     Dio dio = Dio();
  //     dio.download(url, '${dir.path}/$filename',
  //
  //     onReceiveProgress: (received, total) async {
  //       int percentage = ((received / total) * 100).floor();
  //       progress = (percentage ?? 0) / 100;
  //       _status = percentage.toString();
  //       update();
  //       log("percentage : $percentage");
  //       log("percentage progress : $progress");
  //       progressStatus(true);
  //
  //       var body = "Downloading video ${percentage}%";
  //       createNotification(100, ((received / total) * 100).toInt(), 1,
  //           VideoDetaildata[0]['title'], body);
  //       if (percentage == 100) {
  //         var body={
  //           'id': VideoDetaildata[0]['id'].toString(),
  //           'video_path': file.path.toString(),
  //           'video_title': VideoDetaildata[0]['title'],
  //           'video_duration': VideoDetaildata[0]['video_time'],
  //           'video_Stamps': VideoDetaildata[0]['video_stamps'],
  //           'video_Notes': remotePDFpath.toString(),
  //           'video_thumb_image': Thumbimg_remotePDFpath.toString(),
  //         };
  //         createItem({
  //           'id': VideoDetaildata[0]['id'].toString(),
  //           'video_path': file.path.toString(),
  //           'video_title': VideoDetaildata[0]['title'],
  //           'video_duration': VideoDetaildata[0]['video_time'],
  //           'video_Stamps': VideoDetaildata[0]['video_stamps'],
  //           'video_Notes': remotePDFpath.toString(),
  //           'video_thumb_image': Thumbimg_remotePDFpath.toString(),
  //         });
  //         log("Video Saved body"+body.toString());
  //         log("Video Saved Api");
  //         var videos_saved = "${apiUrls().videos_saved_api}$videoid";
  //         var result = await apiCallingHelper().getAPICall(videos_saved, true);
  //         updatecatid(videoid);
  //         videolisner();
  //         var data = jsonDecode(result.body);
  //         toastMsg(data['message'], true);
  //
  //         progressStatus(false);
  //         update();
  //       }
  //       update();
  //     }
  //     );
  //   }
  // }

  void createNotification(int count, int i, int id, title, body) {
    //show the notifications.
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel', 'progress channel',
        channelDescription: 'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: count,
        progress: i);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: 'item x');
  }


}
