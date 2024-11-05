import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:math' as math;

import 'package:background_downloader/background_downloader.dart';
// import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:n_prep/App_update/App_Mentaintion_Mood.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Nphase2/Constant/Video_questions_qbank.dart';
import 'package:n_prep/src/Nphase2/Controller/VideoDetailController.dart';
import 'package:n_prep/src/Nphase2/Controller/custom_controls_widget.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/detail.dart';
import 'package:n_prep/src/q_bank/new_questionbank/questions_qbank.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';

import '../Constant/VideoMcqdetail.dart';
import 'package:screen_protector/screen_protector.dart';

import '../Constant/download_file.dart';

class VideoDetailScreen extends StatefulWidget {
  var CatId;
  var VideoDuration;

  VideoDetailScreen({
    this.CatId,
    this.VideoDuration,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoDetailScreenState();
  }
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with TickerProviderStateMixin {
  TabController tabController;

  // SimplePip pip=SimplePip();
  SettingController settingController = Get.put(SettingController());
  VideoDetailcontroller videoDetailcontroller = Get.put(VideoDetailcontroller());

  bool _showForwardAnimation = false;
  bool _showBackwardAnimation = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
      getdata();
      // getvideoFlag();

      tabController = TabController(length: 3, vsync: this);
      log('pages==>'+videoDetailcontroller.pages.toString());
  }

  @override
  void dispose() {

    videoDetailcontroller.betterPlayerController.dispose();
    videoDetailcontroller.betterPlayerController_videoplayer.dispose();
    videoDetailcontroller.Animation_controller.dispose();
    super.dispose();
  }

  getdata()async {
        videoDetailcontroller.videothumbImgUrl2="";
        videoDetailcontroller.Videoplayloader.value=false;
        videoDetailcontroller.Animation_controller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        );
        videoDetailcontroller.DurationMessage.value = "";

        videoDetailcontroller.updatecatid(widget.CatId);
        videoDetailcontroller.FetchVideoDetailData(widget.VideoDuration);
  }

  getvideoFlag() async {
    if(Platform.isAndroid){
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }else{
      await ScreenProtector.protectDataLeakageWithBlur();
      await ScreenProtector.preventScreenshotOn();
    }

    // _controller.play();
  }

  var currentAlignment = Alignment.topCenter;

  var minVideoHeight = 100.0;
  var minVideoWidth = 150.0;

  var maxVideoHeight = 200.0;

// This is an arbitrary value and will be changed when layout is built.
  var maxVideoWidth = 250.0;

  var currentVideoHeight = 200.0;
  var currentVideoWidth = 200.0;

  categoryImage(imagess) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image(
          image: NetworkImage(imagess),
          fit: BoxFit.contain,
          height: 80,
          width: 100,
        )
    );
  }

  CategoryController categoryController = Get.put(CategoryController());
  attempt_test_api(sab_cat_id, perentId, cat_name) async {
    if (categoryController.attempLoader.value) {
      // toastMsg("You allready selected blocks category, please wait....", true);
    } else {
      Map<String, String> queryParams = {
        'category_id': sab_cat_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var attempUrl = apiUrls().test_attempt_api + '?' + queryString;
      print("attempUrl......" + attempUrl.toString());
      try{
        var result=  await apiCallingHelper().getAPICall(attempUrl,true);
        if (result != null) {
          if(result.statusCode == 200){
          var  attempTestData =jsonDecode(result.body);
          var  _checkexamid = attempTestData['data']['id'];
          var  _checkstatus = attempTestData['data']['exam_status'];
           var   _totalattempt_que = attempTestData['data']['attempt_questions'];
            var total_que = attempTestData['data']['total_questions'];
            var completed_date = attempTestData['data']['completed_date'];
            var created_at = attempTestData['data']['created_at'];
            if(_checkstatus==3){
              log("check status> 3");
              Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: "Foo"),
                    builder: (BuildContext context) => VideoMcqDetails(
                      title: cat_name.toString(),
                      header :perentId.toString(),
                      examid :_checkexamid.toString(),
                      checkstatus: _checkstatus,
                      attempquestion:_totalattempt_que ,
                      total_questions:total_que ,
                      completed_date: completed_date,
                      created_at:  created_at,
                      pagestatus: true,
                    )),
              );
              // Get.to(VideoMcqDetails(
              //   title: cat_name.toString(),
              //   header :perentId.toString(),
              //   examid :_checkexamid.toString(),
              //   checkstatus: _checkstatus,
              //   attempquestion:_totalattempt_que ,
              //   total_questions:total_que ,
              //   completed_date: completed_date,
              //   created_at:  created_at,
              //   pagestatus: true,
              // ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             Details(
              //               title: cat_name.toString(),
              //               header :perentId.toString(),
              //               examid :_checkexamid.toString(),
              //               checkstatus: _checkstatus,
              //               attempquestion:_totalattempt_que ,
              //               total_questions:total_que ,
              //               completed_date: completed_date,
              //               created_at:  created_at,
              //               pagestatus: true,
              //             )));
            }
            else if(_checkstatus==2){
              log("check status> 2");
              Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: "Foo"),
                    builder: (BuildContext context) => VideoMcqDetails(
                      title: cat_name.toString(),
                      header :perentId.toString(),
                      examid :_checkexamid.toString(),
                      checkstatus: _checkstatus,
                      attempquestion:_totalattempt_que ,
                      total_questions:total_que ,
                      completed_date: completed_date,
                      created_at:  created_at,
                      pagestatus: true,
                    )),
              );
              // Get.to(VideoMcqDetails(
              //   title: cat_name.toString(),
              //   header :perentId.toString(),
              //   examid :_checkexamid.toString(),
              //   checkstatus: _checkstatus,
              //   attempquestion:_totalattempt_que ,
              //   total_questions:total_que ,
              //   completed_date: completed_date,
              //   created_at:  created_at,
              //   pagestatus: true,
              // ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             Details(
              //               title: cat_name.toString(),
              //               header :perentId.toString(),
              //               examid :_checkexamid.toString(),
              //               checkstatus: _checkstatus,
              //               attempquestion:_totalattempt_que ,
              //               total_questions:total_que ,
              //               completed_date: completed_date,
              //               created_at:  created_at,
              //               pagestatus: true,
              //             )));
            }
            else{
              log("check status> 1");
              // Get.to(Videoquestionbank_new(counterindex: 1,
              //   examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,));
              Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: "Foo"),
                    builder: (BuildContext context) => Videoquestionbank_new(counterindex: 1,
                      examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,)),
              );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             questionbank_new(counterindex: 1,
              //               examId: _checkexamid.toString(),checkstatus: _checkstatus,pagestatus:true ,)));
            }
          }
          else  if(result.statusCode == 404){
            var   attempTestData =jsonDecode(result.body);
            toastMsg(attempTestData['message'], true);


          }
          else  if(result.statusCode == 401){
            var   attempTestData =jsonDecode(result.body);
            toastMsg(attempTestData['message'], true);
          }

        } else {
          toastMsg("Not Verified", true);
        }
      }
      on SocketException {
        throw FetchDataException('No Internet connection');

      } on TimeoutException {
        throw FetchDataException('Something went wrong, try again later');
      }
    }
  }

  Widget uicall(){
    beforevideodatatasks.forEach((e){
      log("<<<id>>>"+e.videokey.toString());
      log("<<<id  "+videoDetailcontroller.VideoDetaildata[0]['id'].toString());
      if(e.videokey!=videoDetailcontroller.VideoDetaildata[0]['id']){
        return  Image.asset(
          "assets/nprep2_images/download.png",
          color: primary,
          height: 15,
          width: 15,
        );
      }
      else{
        return e.videokey.toString()==videoDetailcontroller.VideoDetaildata[0]['id'].toString()?
        Container(
          height: 20,
          width: 20,
          color: Colors.red,
          // child: CircularPercentIndicator(
          //   radius: 15.0,
          //   lineWidth: 5.0,
          //   percent: 0.5,
          //   center: videoDetailcontroller.buttonState==ButtonState.resume?
          //   Icon(
          //     Icons.play_arrow,
          //     color: primary,
          //     size: 12,
          //   ):
          //   Icon(
          //     Icons.pause,
          //     color: primary,
          //     size: 12,
          //   ),
          //   progressColor: primary,
          // ),
        ):
        Container( height: 20,
          width: 20,
          color: Colors.green,);
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var sheight = MediaQuery.of(context).size.height;
    var swidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
        //   statusBarColor: Color(0xFF64C4DA), // status bar color
        // ));
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        if(isPlaying){
          dispose();
        }
        Get.back();
        return true;
      },
      child: OrientationBuilder(
          builder: (context, orientation) {
            log("orientation> "+orientation.toString());
            // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //   systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
            //   statusBarColor: Color(0xFF020202), // status bar color
            // ));
            if(orientation == Orientation.landscape){

              return   GetBuilder<VideoDetailcontroller>(
                  builder: (videoDetailcontroller) {
                  return SafeArea(
                    child: Scaffold(

                      body: Container(
                        height: size.height,
                        width: size.width,
                        // aspectRatio: 16 / 9,
                        // child: Container(
                        //   color: Colors.red,
                        // ),
                        child:videoDetailcontroller.VideoAvailableloader.value==true?Container(
                          alignment: Alignment.center,
                          child: Text("No Video Available"),
                        ):
                        CustomControlsWidget(controller:videoDetailcontroller.betterPlayerController ,videocontroller: videoDetailcontroller.betterPlayerController_videoplayer,)

                      ),
                    ),
                  );
                }
              );
            }
            else{
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(0.0),
                    child: AppBar(

                      backgroundColor: Color(0xFF020202),
                      iconTheme: IconThemeData(color: Colors.white),
                    ),
                  ),
                  body: GetBuilder<VideoDetailcontroller>(
                      builder: (videoDetailcontroller) {
                        if (videoDetailcontroller.VideoDetailloader.value){
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

                              settingController.settingData['data']['general_settings']['quotes'].length == 0
                                  ? Text("")
                                  : Text(
                                  '"${settingController.settingData['data']['general_settings']['quotes'][random.nextInt(settingController.settingData['data']['general_settings']['quotes'].length)].toString()}"',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primary,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600)),

                            ],
                          );
                        }
                        else {
                          return videoDetailcontroller.VideoDetailStatusCode == 401 ||
                              videoDetailcontroller.VideoDetailStatusCode == 404
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width,
                                child: Text(
                                  '${videoDetailcontroller.VideoDetailErrorMSg}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              // Center(child: CircularProgressIndicator(color: primary,)),
                              SizedBox(
                                height: 5,
                              ),
                              settingController.settingData['data']['general_settings']['quotes'].length == 0
                                  ? Text("")
                                  : Text(
                                  '"${settingController.settingData['data']['general_settings']['quotes'][random.nextInt(settingController.settingData['data']['general_settings']['quotes'].length)].toString()}"',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primary,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                              :
                          videoDetailcontroller.isInSmallMode == true
                              ? Stack(
                                  children: [
                                    PDFView(

                                      filePath: videoDetailcontroller.remotePDFpath,
                                      enableSwipe: true,

                                      swipeHorizontal: false,
                                      autoSpacing: true,
                                      pageFling: false,
                                      pageSnap: true,
                                      defaultPage: videoDetailcontroller
                                          .currentPage,
                                      fitPolicy: FitPolicy.WIDTH,
                                      fitEachPage: true,
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
                                            child: Transform.rotate(
                                                angle:
                                                180 * math.pi / 100,
                                                child: Icon(
                                                  Icons.code,
                                                  size: 25,
                                                  color: Colors.black,
                                                )),
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

                                              CustomControlsWidget(controller:videoDetailcontroller.betterPlayerController ,videocontroller: videoDetailcontroller.betterPlayerController_videoplayer,),

                                              Positioned(
                                                  top: double.parse(videoDetailcontroller.top_post_small.value.toString()),
                                                  right: double.parse(videoDetailcontroller.right_post_small.value.toString()),
                                                  child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: 10,
                                        left: 20,
                                        child: IconButton(
                                          onPressed: (){
                                            videoDetailcontroller.betterPlayerController.play();
                                          },
                                          icon: Icon(Icons.play_arrow,size: 100,color: Colors.grey,),
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
                              )
                              : Column(
                            children: [
                              // SizedBox(
                              //   height: statusBarHeight,
                              // ),
                              ///Video Player
                                            // Text("Videoplayloader "+videoDetailcontroller.Videoplayloader.value.toString()),
                                            // Text("VideoAvailableloader "+videoDetailcontroller.VideoAvailableloader.value.toString()),
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: videoDetailcontroller.Videoplayloader.value == false
                                    ? GestureDetector(
                                  onTap: () async {
                                    if (!videoDetailcontroller.VideoAvailableloader.value) {
                                      String url = sprefs.getString("video_url");
                                      await videoDetailcontroller.videoplayerstart(url);
                                      videoDetailcontroller.betterPlayerController.play(); // Starts video playback when tapped
                                      setState(() {
                                        isPlaying = true; // Sets the state to update the UI when the video starts playing
                                      });
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      // Thumbnail image
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: videoDetailcontroller.videothumbImgUrl2.toString() == "null"
                                                ? AssetImage(
                                              "assets/nprep2_images/video.png",
                                            )
                                                : NetworkImage(videoDetailcontroller.videothumbImgUrl2),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      // Black dullness effect
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.black.withOpacity(0.5), // Adjust the opacity for dullness
                                      ),
                                      // Play icon or loading indicator
                                      videoDetailcontroller.VideoLoadingBeforeloader.value == true
                                          ? Center(
                                        child: CircularProgressIndicator(strokeWidth: 1.5),
                                      )
                                          : Center(
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : videoDetailcontroller.VideoAvailableloader.value == true
                                    ? Container(
                                  alignment: Alignment.center,
                                  child: Text("No Video Available"),
                                )
                                    : CustomControlsWidget(
                                  controller: videoDetailcontroller.betterPlayerController,
                                  videocontroller: videoDetailcontroller.betterPlayerController_videoplayer,
                                ),
                              ),


                              ///Readmore
                              sizebox_height_10,
                              GetBuilder<VideoDetailcontroller>(
                                builder: (videoDetailcontroller) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      sizebox_width_10,
                                      Expanded(
                                        flex: 10,
                                        child: ReadMoreText(
                                          videoDetailcontroller.VideoDetaildata[0]['title'],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: black54,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          trimLines: 1,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Read More',
                                          trimExpandedText: ' || Show Less',
                                          moreStyle: TextStyle(
                                              color: primary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          lessStyle: TextStyle(
                                              color: primary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                      ///Old Download
                                      Expanded(
                                        flex: 5,
                                        child: GestureDetector(
                                          onTap: () async {
                                            log("is_download>> " +videoDetailcontroller .VideoDetaildata[0]['is_download'].toString()); ///1 downladed///0 Download pending
                                            // videoItems.length
                                            final DatabaseService dbHelper = DatabaseService.instance;

                                           await dbHelper.getTasks();

                                            // log("tasks.length> "+videodatatasks.length.toString());
                                            if (videodatatasks==null|| videodatatasks.length<=10) {
                                              if (videoDetailcontroller.VideoDetaildata[0]['is_download'] ==1) {
                                                toastMsg('Already Downloaded', false);
                                              } else {
                                                if (videoDetailcontroller.progressStatus ==false ) {
                                                  videoDetailcontroller.downloadButtonPressed(
                                                      videoDetailcontroller.VideoDetaildata[0]['video_attachment'],
                                                      videoDetailcontroller.VideoDetaildata[0]['id'],
                                                      videoDetailcontroller .VideoDetaildata[0]['title'],
                                                       videoDetailcontroller .VideoDetaildata[0]['video_time'],
                                                       videoDetailcontroller .VideoDetaildata[0]['video_stamps'],
                                                       videoDetailcontroller .remotePDFpath,
                                                       videoDetailcontroller .Thumbimg_remotePDFpath,
                                                      videoDetailcontroller .VideoDetaildata[0]['thumb_image'],
                                                    );
                                                }
                                                else {
                                                    log(">>>>>>>>>>"+videoDetailcontroller.buttonState.toString());
                                                    log(">>>>>>>>>>"+ButtonState.download.toString());
                                                    if( videoDetailcontroller.buttonState==ButtonState.pause){
                                                      FileDownloader().pause(videoDetailcontroller.task);
                                                    }else if(videoDetailcontroller.buttonState==ButtonState.resume){
                                                      FileDownloader().resume(videoDetailcontroller.task);
                                                    }else if(videoDetailcontroller.buttonState==ButtonState.download){
                                                      FileDownloader().pause(videoDetailcontroller.task);
                                                    }
                                                    toastMsg('Please Wait video is downloading', false);


                                                }
                                              }
                                            }
                                            else {
                                              toastMsg('Not allow more than 10 videos ',false);
                                            }
                                          },
                                          child: videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1?
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: primary,
                                            size: 25,
                                          ):videoDetailcontroller.progressdownloadStatus == false?
                                          videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1? Icon(
                                            Icons.check_circle_rounded,
                                            color: primary,
                                            size: 25,
                                          ):
                                          // Container( height: 20,
                                          //   width: 20,
                                          //   color: Colors.green,)
                                          Image.asset(
                                            "assets/nprep2_images/download.png",
                                            color: primary,
                                            height: 15,
                                            width: 15,
                                          )
                                              :
                                          CircularPercentIndicator(
                                            radius: 15.0,
                                            lineWidth: 5.0,
                                            percent:
                                            videoDetailcontroller.progress,
                                            center: videoDetailcontroller.buttonState==ButtonState.resume ?
                                            Icon(
                                              Icons.play_arrow,
                                              color: primary,
                                              size: 12,
                                            ):
                                            Icon(
                                              Icons.pause,
                                              color: primary,
                                              size: 12,
                                            ),
                                            progressColor: primary,
                                          )
                                          // videoDetailcontroller.progressStatus == false?
                                          // videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1?
                                          // Icon(
                                          //   Icons.check_circle_rounded,
                                          //   color: primary,
                                          //   size: 25,
                                          // ):
                                          // videoDetailcontroller.progressdownloadStatus == false ?
                                          // Image.asset(
                                          //   "assets/nprep2_images/download.png",
                                          //   color: primary,
                                          //   height: 15,
                                          //   width: 15,
                                          // ):
                                          // CircularPercentIndicator(
                                          //   radius: 15.0,
                                          //   lineWidth: 5.0,
                                          //   percent:
                                          //   videoDetailcontroller.progress,
                                          //   center: videoDetailcontroller.buttonState==ButtonState.resume ?
                                          //   Icon(
                                          //     Icons.play_arrow,
                                          //     color: primary,
                                          //     size: 12,
                                          //   ):
                                          //   Icon(
                                          //     Icons.pause,
                                          //     color: primary,
                                          //     size: 12,
                                          //   ),
                                          //   progressColor: primary,
                                          // )
                                          // : videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1?
                                          // Icon(
                                          //   Icons.check_circle_rounded,
                                          //   color: primary,
                                          //   size: 25,
                                          // ):
                                          //
                                          // CircularPercentIndicator(
                                          //   radius: 15.0,
                                          //   lineWidth: 5.0,
                                          //   percent:
                                          //   videoDetailcontroller.progress,
                                          //   center: videoDetailcontroller.buttonState.value==ButtonState.resume ?Icon(
                                          //     Icons.play_arrow,
                                          //     color: primary,
                                          //     size: 12,
                                          //   ):videoDetailcontroller.buttonState.value==ButtonState.complete?Icon(Icons.refresh,color: primary,
                                          //     size: 12,):Icon(
                                          //     Icons.pause,
                                          //     color: primary,
                                          //     size: 12,
                                          //   ),
                                          //   progressColor: primary,
                                          // ),
                                        ),
                                      )
                                      ///New Download
                                      // Container(
                                      //     // height: 20,
                                      //     width: 20,
                                      //     margin: EdgeInsets.only(right: 25),
                                      //     child: GestureDetector(
                                      //           onTap: () async {
                                      //        log("is_download>> " +videoDetailcontroller .VideoDetaildata[0]['is_download'].toString()); ///1 downladed///0 Download pending
                                      //        // videoItems.length
                                      //        final DatabaseService _databaseService = DatabaseService.instance;
                                      //
                                      //        await _databaseService.getDatabase();
                                      //        var getTasksdata =_databaseService.getTasks();
                                      //        var beforegetTasksdata =_databaseService.beforegetTasks();
                                      //
                                      //        log("beforevideodatatasks.length> "+beforevideodatatasks.toString());
                                      //        if (videodatatasks==null|| videodatatasks.length<=10) {
                                      //          if (videoDetailcontroller.VideoDetaildata[0]['is_download'] ==1) {
                                      //                 toastMsg('Already Downloaded', false);
                                      //          }
                                      //          else {
                                      //            if(beforevideodatatasks==null){
                                      //              downloadfile().downloadHiveButtonPressed
                                      //                (
                                      //                videoDetailcontroller.VideoDetaildata[0]['video_attachment'],
                                      //                videoDetailcontroller.VideoDetaildata[0] ['id'],
                                      //                videoDetailcontroller .VideoDetaildata[0]['title'],
                                      //                videoDetailcontroller .VideoDetaildata[0]['video_time'],
                                      //                videoDetailcontroller .VideoDetaildata[0]['video_stamps'],
                                      //                videoDetailcontroller .remotePDFpath,
                                      //                videoDetailcontroller .Thumbimg_remotePDFpath,
                                      //                videoDetailcontroller .VideoDetaildata[0]['thumb_image'],
                                      //              );
                                      //            }else{
                                      //              beforevideodatatasks.forEach((e){
                                      //                log("beforevideodatatasks>>>>>"+e.toString());
                                      //                if(e.videokey==videoDetailcontroller.VideoDetaildata[0]['id']){
                                      //                  log(">>>>>>>>>>"+videoDetailcontroller.buttonState.toString());
                                      //                  log(">>>>>>>>>>"+ButtonState.download.toString());
                                      //                  // if( videoDetailcontroller.buttonState==ButtonState.pause){
                                      //                  //   FileDownloader().pause(videoDetailcontroller.task);
                                      //                  // }else if(videoDetailcontroller.buttonState==ButtonState.resume){
                                      //                  //   FileDownloader().resume(videoDetailcontroller.task);
                                      //                  // }else if(videoDetailcontroller.buttonState==ButtonState.download){
                                      //                  //   FileDownloader().pause(videoDetailcontroller.task);
                                      //                  // }
                                      //                  toastMsg('Please Wait video is downloading', false);
                                      //                }
                                      //                else{
                                      //                  downloadfile().downloadHiveButtonPressed
                                      //                    (
                                      //                    videoDetailcontroller.VideoDetaildata[0]['video_attachment'],
                                      //                    videoDetailcontroller.VideoDetaildata[0] ['id'],
                                      //                    videoDetailcontroller .VideoDetaildata[0]['title'],
                                      //                    videoDetailcontroller .VideoDetaildata[0]['video_time'],
                                      //                    videoDetailcontroller .VideoDetaildata[0]['video_stamps'],
                                      //                    videoDetailcontroller .remotePDFpath,
                                      //                    videoDetailcontroller .Thumbimg_remotePDFpath,
                                      //                    videoDetailcontroller .VideoDetaildata[0]['thumb_image'],
                                      //                  );
                                      //                }
                                      //              });
                                      //            }
                                      //
                                      //
                                      //
                                      //             // if (videoDetailcontroller .progressStatus ==false) {
                                      //             //   downloadfile().downloadHiveButtonPressed
                                      //             //       (
                                      //             //         videoDetailcontroller.VideoDetaildata[0]['video_attachment'],
                                      //             //         videoDetailcontroller.VideoDetaildata[0] ['id'],
                                      //             //         videoDetailcontroller .VideoDetaildata[0]['title'],
                                      //             //         videoDetailcontroller .VideoDetaildata[0]['video_time'],
                                      //             //         videoDetailcontroller .VideoDetaildata[0]['video_stamps'],
                                      //             //         videoDetailcontroller .remotePDFpath,
                                      //             //         videoDetailcontroller .Thumbimg_remotePDFpath,
                                      //             //         videoDetailcontroller .VideoDetaildata[0]['thumb_image'],
                                      //             //       );
                                      //             //  }
                                      //             // else {
                                      //             //   log(">>>>>>>>>>"+videoDetailcontroller.buttonState.toString());
                                      //             //   log(">>>>>>>>>>"+ButtonState.download.toString());
                                      //             //   if( videoDetailcontroller.buttonState==ButtonState.pause){
                                      //             //     FileDownloader().pause(videoDetailcontroller.task);
                                      //             //   }else if(videoDetailcontroller.buttonState==ButtonState.resume){
                                      //             //     FileDownloader().resume(videoDetailcontroller.task);
                                      //             //   }else if(videoDetailcontroller.buttonState==ButtonState.download){
                                      //             //     FileDownloader().pause(videoDetailcontroller.task);
                                      //             //   }
                                      //             //   toastMsg('Please Wait video is downloading', false);
                                      //             //
                                      //             //
                                      //             // }
                                      //          }
                                      //       }
                                      //       else {
                                      //         toastMsg('Not allow more than 10 videos ',false);
                                      //       }
                                      //     },
                                      //           child:
                                      //           videoDetailcontroller.VideoDetaildata[0]['is_download'] == 1?
                                      //                    Icon(
                                      //                     Icons.check_circle_rounded,
                                      //                     color: primary,
                                      //                     size: 25,
                                      //                   )
                                      //                   // Container(color: Colors.yellow,height: 20,width: 20,)
                                      //                    :beforevideodatatasks==null?
                                      //                    Image.asset(
                                      //                      "assets/nprep2_images/download.png",
                                      //                      color: primary,
                                      //                      height: 15,
                                      //                      width: 15,
                                      //                    )
                                      //                   // Container(color: Colors.yellow,height: 20,width: 20,)
                                      //                    :
                                      //                   CircularPercentIndicator(
                                      //                     radius: 15.0,
                                      //                     lineWidth: 5.0,
                                      //                     percent: videoDetailcontroller.progress,
                                      //                     center:videoDetailcontroller.buttonState==ButtonState.resume ?
                                      //                       Icon(
                                      //                         Icons.play_arrow,
                                      //                         color: primary,
                                      //                         size: 8,
                                      //                       ):
                                      //                       Icon(
                                      //                       Icons.pause,
                                      //                       color: primary,
                                      //                       size: 8,
                                      //                     ),
                                      //                     progressColor: primary,
                                      //                   )
                                      //
                                      //     ),
                                      // ),


                                    ],
                                  );
                                }
                              ),

                             // GestureDetector(
                             //    onTap: (){
                             //
                             //      videoDetailcontroller.adddata();
                             //    },
                             //    child: Text("Add Data")),

                              Divider(
                                thickness: 1,
                                height: 30,
                                color: grey,
                                indent: 0,
                                endIndent: 0,
                              ),

                              ///TabBar
                              TabBar(
                                indicatorColor: primary,
                                indicatorWeight: 3,
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
                                      'Notes ${videoDetailcontroller.pages==0?"": '(${
                                            videoDetailcontroller.pages
                                          })'}',
                                      style: TextStyle(
                                        color: black54,
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Blocks',
                                      style: TextStyle(
                                        color: black54,
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),

                              ///TabBar View
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    /// Video Stamp
                                    videoDetailcontroller
                                        .VideoDetaildata[0]['video_stamps'].length == 0
                                        ? Container(
                                        alignment: Alignment.center,
                                        // margin: EdgeInsets.only(top: 200),
                                        child: Text("No Stamps Found"))
                                        : ListView.builder(
                                        itemCount: videoDetailcontroller
                                            .VideoDetaildata[0]
                                        ['video_stamps']
                                            .length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                        AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context,index) {
                                          var Tablistdata =videoDetailcontroller.VideoDetaildata[0]['video_stamps'][index];

                                          return GestureDetector(
                                            onTap: () {
                                              videoDetailcontroller.betterPlayerController.seekTo(Duration(
                                                  hours: int.parse(
                                                      Tablistdata['time']
                                                          .toString()
                                                          .split(":")[0]),
                                                  minutes: int.parse(
                                                      Tablistdata['time']
                                                          .toString()
                                                          .split(":")[1]),
                                                  seconds: int.parse(
                                                      Tablistdata['time']
                                                          .toString()
                                                          .split(
                                                          ":")[2])));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(0.8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                        size.width *
                                                            0.10,
                                                        child:videoDetailcontroller.VideoAvailableloader.value==true?Image.asset(
                                                          "assets/nprep2_images/timer.png",
                                                          height: 20,
                                                          width: 20,
                                                        ):
                                                        videoDetailcontroller.showColorLabels(Tablistdata['time'].toString()
                                                            ,videoDetailcontroller.VideoDetaildata[0]['video_stamps'].length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:videoDetailcontroller.VideoDetaildata[0]['video_stamps']
                                                            [index+1]['time'])==true?Icon(Icons.pause):
                                                        Image.asset(
                                                          "assets/nprep2_images/timer.png",
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                      ),
                                                      sizebox_width_5,
                                                      Text(
                                                        Tablistdata[
                                                        'time']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                            black54,
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
                                                              color:videoDetailcontroller.VideoAvailableloader.value==true?black54:videoDetailcontroller.showColorLabels(Tablistdata['time'].toString()
                                                                  ,videoDetailcontroller.VideoDetaildata[0]['video_stamps'].length==(index+1)?videoDetailcontroller.videoduration.toString().split(".")[0]:videoDetailcontroller.VideoDetaildata[0]['video_stamps']
                                                                  [index+1]['time'])==true?
                                                              primary:black54,
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

                                    /// Video PDF
                                    videoDetailcontroller.VideoDetaildata[0]
                                    ['pdf_attachment'] ==
                                        null
                                        ? Container(
                                      // margin: EdgeInsets.only(top: 80),
                                        child: Center(
                                            child: Text("No PDF Found")))
                                        : Stack(
                                            children: [
                                              PDFView(

                                                filePath: videoDetailcontroller.remotePDFpath,
                                                enableSwipe: true,

                                                swipeHorizontal: false,
                                                autoSpacing: true,
                                                pageFling: false,
                                                pageSnap: true,
                                                defaultPage: videoDetailcontroller.currentPage,
                                                fitPolicy: FitPolicy.WIDTH,
                                                fitEachPage: true,
                                                preventLinkNavigation:false, // if set to true the link is handled in flutter
                                                onRender: (_pages) {
                                                  setState(() {
                                                    videoDetailcontroller.pages = _pages;
                                                    videoDetailcontroller
                                                        .isReady = true;
                                                  });
                                                },
                                                onError: (error) {
                                                  setState(() {
                                                    videoDetailcontroller
                                                        .errorMessage =
                                                        error.toString();
                                                  });
                                                  print("Check pdf path>> " +
                                                      error.toString());
                                                },
                                                onPageError: (page, error) {
                                                  setState(() {
                                                    videoDetailcontroller
                                                        .errorMessage =
                                                    '$page: ${error.toString()}';
                                                  });
                                                  print(
                                                      'Check >> Error PDF > $page: ${error.toString()}');
                                                },
                                                onViewCreated: (PDFViewController pdfViewController) {
                                                  // videoDetailcontroller
                                                  //     .controllerpdfview
                                                  //     .complete(
                                                  //     pdfViewController);
                                                },
                                                onLinkHandler: (String uri) {
                                                  print('goto uri: $uri');
                                                },
                                                onPageChanged:
                                                    (int page, int total) {
                                                  print(
                                                      'page change: $page/$total');
                                                  setState(() {
                                                    videoDetailcontroller.currentPage = page;
                                                    videoDetailcontroller.TotalPage = total;
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
                                                      child: Transform.rotate(
                                                          angle:
                                                          180 * math.pi / 100,
                                                          child: Icon(
                                                            Icons.code,
                                                            size: 25,
                                                            color: Colors.black,
                                                          )),
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

                                    /// Video Blocks
                                    videoDetailcontroller.VideoDetaildata[0]['video_relates'].length ==
                                        0
                                        ? Container(
                                      // margin: EdgeInsets.only(top: 80),
                                        child: Center(
                                            child: Text("No Blocks Found")))
                                        : ListView.builder(
                                        itemCount: videoDetailcontroller.VideoDetaildata[0]
                                        ['video_relates'].length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:AlwaysScrollableScrollPhysics(),
                                        itemBuilder:(BuildContext context, index) {
                                          var Tablist2data = videoDetailcontroller.VideoDetaildata[0]
                                                            ['video_relates'][index];

                                          return Tablist2data['category_type'] == 1
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    // videoDetailcontroller.dispose();
                                                    await attempt_test_api(
                                                        Tablist2data['mcq_category']['id'] .toString(),
                                                        Tablist2data['mcq_category']['name'].toString(),
                                                        Tablist2data['mcq_category']['name'].toString());
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      // Text("MCQ"),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:BorderRadius.circular(10)),
                                                        // height: sheight * .1,
                                                        // decoration: BoxDecoration(
                                                        //     borderRadius: BorderRadius.circular(10),
                                                        //     color: white,
                                                        //     boxShadow: [
                                                        //       BoxShadow(
                                                        //         color: Colors.grey.shade300,
                                                        //         spreadRadius: 1,
                                                        //         blurRadius: 0.5,
                                                        //       )
                                                        //     ]),
                                                        // padding: EdgeInsets.all(5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                              EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(5.0),
                                                                  child: categoryImage(Environment
                                                                      .imgapibaseurl +Tablist2data['mcq_category']
                                                                      ['image'])),
                                                              height:
                                                              sheight * 0.08,
                                                              width: swidth * 0.18,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width:
                                                                  swidth -
                                                                      120,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      10,
                                                                      vertical:
                                                                      10),
                                                                  // color: primary,

                                                                  child: Text(
                                                                    Tablist2data['mcq_category']
                                                                    ['name']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: 'PublicSans',
                                                                        color: black54,
                                                                        // height: 1.1,
                                                                        letterSpacing: 0.8),
                                                                  ),
                                                                ),
                                                                // perentdata['attempt_percentage']==0?Container():

                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                                  child: Text(
                                                                    Tablist2data['mcq_category']['questions_count']
                                                                        .toString() +
                                                                        " MCQ",
                                                                    style:
                                                                    TextStyle(
                                                                      color:
                                                                      black54,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                      fontFamily:
                                                                      'Poppins-Regular',
                                                                      fontSize:
                                                                      12,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Tablist2data["mcq_category"]['fee_type'] == 2
                                                          ? Container()
                                                          : Positioned(
                                                        right: 10,
                                                        top: 5,
                                                        child:
                                                        Container(
                                                          height: 15,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                  todayTextColor),
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  4)),
                                                          child: Center(
                                                            child: Text(
                                                              "Pro",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color:
                                                                  todayTextColor,
                                                                  fontSize:
                                                                  10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                              : GestureDetector(
                                                  onTap: () async {

                                                    videoDetailcontroller.betterPlayerController.pause();
                                                    videoDetailcontroller.dispose();

                                                    try {
                                                      await Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                          context) =>
                                                              VideoDetailScreen(
                                                                  CatId: Tablist2data[
                                                                  'category_id']),
                                                        ),
                                                      );

                                                    } catch (e) {
                                                      // log("Navigation >> "+e.toString());
                                                    }
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        // height: sheight * .1,
                                                        // decoration: BoxDecoration(
                                                        //     borderRadius: BorderRadius.circular(10),
                                                        //     color: white,
                                                        //     boxShadow: [
                                                        //       BoxShadow(
                                                        //         color: Colors.grey.shade300,
                                                        //         spreadRadius: 1,
                                                        //         blurRadius: 0.5,
                                                        //       )
                                                        //     ]),
                                                        // padding: EdgeInsets.all(5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                              EdgeInsets
                                                                  .only(
                                                                left: 5,
                                                              ),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      5.0),
                                                                  child: categoryImage(
                                                                      "assets/images/NPrep.jpeg")),
                                                              height:
                                                              sheight *
                                                                  0.08,
                                                              width: swidth *
                                                                  0.18,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Container(
                                                                  width:
                                                                  swidth -
                                                                      120,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      10,
                                                                      vertical:
                                                                      10),
                                                                  // color: primary,
                                                                  child: Text(
                                                                    Tablist2data['video_category']
                                                                    ['name']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: 'PublicSans',
                                                                        color: black54,
                                                                        // height: 1.1,
                                                                        letterSpacing: 0.8),
                                                                  ),
                                                                ),
                                                                // perentdata['attempt_percentage']==0?Container():

                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                                  child: Text(
                                                                    Tablist2data['video_category']['video_time']
                                                                        .toString() +
                                                                        " Video",
                                                                    style:
                                                                    TextStyle(
                                                                      color:
                                                                      black54,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                      fontFamily:
                                                                      'Poppins-Regular',
                                                                      fontSize:
                                                                      12,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Tablist2data["video_category"]
                                                      [
                                                      'fee_type'] ==
                                                          2
                                                          ? Container()
                                                          : Positioned(
                                                        right: 10,
                                                        top: 5,
                                                        child:
                                                        Container(
                                                          height: 15,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                  todayTextColor),
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  4)),
                                                          child: Center(
                                                            child: Text(
                                                              "Pro",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color:
                                                                  todayTextColor,
                                                                  fontSize:
                                                                  10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              );
                                        }),
                                  ],
                                ),
                              ),

                              ///Button
                              GestureDetector(
                                onTap: () async {
                                  if (videoDetailcontroller.VideoDetaildata[0]
                                  ['is_attempt']
                                      .toString() ==
                                      "0") {
                                    var videos_saved =
                                        "${apiUrls().videos_attempt_api}${videoDetailcontroller.VideoDetaildata[0]['id']}";
                                    var result = await apiCallingHelper()
                                        .getAPICall(videos_saved, true);
                                    videoDetailcontroller.VideoDetaildata[0]
                                    ['is_attempt'] = 1;
                                    var data = jsonDecode(result.body);
                                    // toastMsg(data['message'], true);
                                    toastMsg("Video marked complete", true);
                                    setState(() {});
                                  } else {
                                    var videos_saved =
                                        "${apiUrls().videos_unattempt_api}${videoDetailcontroller.VideoDetaildata[0]['id']}";
                                    var result = await apiCallingHelper()
                                        .getAPICall(videos_saved, true);

                                    videoDetailcontroller.VideoDetaildata[0]
                                    ['is_attempt'] = 0;
                                    var data = jsonDecode(result.body);
                                    // toastMsg(data['message'], true);
                                    toastMsg("Video marked incomplete", true);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 20),
                                  height: 40,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: videoDetailcontroller
                                        .VideoDetaildata[0]['is_attempt']
                                        .toString() ==
                                        "0"
                                        ? Color(0xff64C4DA).withOpacity(0.9)
                                        : white,
                                    border: Border.all(color: primary),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                        videoDetailcontroller.VideoDetaildata[0]
                                        ['is_attempt']
                                            .toString() ==
                                            "0"
                                            ? "MARK COMPLETE "
                                            : "MARK INCOMPLETE ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: videoDetailcontroller
                                                .VideoDetaildata[0]
                                            ['is_attempt']
                                                .toString() ==
                                                "0"
                                                ? white
                                                : primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              );

            }
        }
      ),
    );
  }
}
