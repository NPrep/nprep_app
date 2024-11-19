import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Nphase2/Controller/VideoDetailController.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
import 'dart:math' as math;
import 'package:video_player/video_player.dart';
import 'package:n_prep/utils/colors.dart';

class CustomControlsWidget extends StatefulWidget {
  final ChewieController controller;
  final VideoPlayerController videocontroller;
  final Function(bool visbility) onControlsVisibilityChanged;
  bool hiveornot =false;
  var textdata ;
  CustomControlsWidget({
    Key key,
    this.controller,
    this.videocontroller,
    this.textdata,
    this.hiveornot,
    this.onControlsVisibilityChanged,
  }) : super(key: key);

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  Offset _tapposition;
  bool _showForwardAnimation = false;
  bool _showBackwardAnimation = false;
  bool isPlaying = false;
  String speedText = "1.0x";

  @override
  Widget build(BuildContext context) {
    // log("onControlsVisibilityChanged>> "+widget.onControlsVisibilityChanged.isBlank.toString());
    return GetBuilder<VideoDetailcontroller>(
        builder: (videoDetailcontroller) {
          return GestureDetector(
            // behavior: HitTestBehavior.translucent,
            // autofocus: true,

            onTap: (){
              if(videoDetailcontroller.videoVisable.value==true){
                videoDetailcontroller.updatevideoVisable();
              }else{
                videoDetailcontroller.updatevideoVisable();
              }
            },
            onDoubleTapDown: (details) async {
              final tapPosition = details.globalPosition;
              setState(() {
                _tapposition =tapPosition;
              });
              log("On Hit Seek tapPosition>> onDoubleTapDown>> "+_tapposition.dx.toString());


            },

            // onTapUp: (details) async {
            //   final tapPosition = details.globalPosition;
            //   setState(() {
            //     _tapposition =tapPosition;
            //   });
            //   log("On Hit Seek tapPosition>> onTapUp>> "+_tapposition.dx.toString());
            //
            //
            // },
            // onTapDown: (details) async {
            //   final tapPosition = details.globalPosition;
            //   setState(() {
            //     _tapposition =tapPosition;
            //   });
            //   log("On Hit Seek tapPosition>> onTapDown>> "+_tapposition.dx.toString());
            //
            //
            // },
            onPanDown:   (details){
              final tapPosition = details.globalPosition;
              setState(() {
                _tapposition =tapPosition;
              });
              log("On Hit Seek tapPosition>> onPanDown>> "+_tapposition.dx.toString());
            },
            onPanUpdate:   (details){
              final tapPosition = details.globalPosition;
              setState(() {
                _tapposition =tapPosition;
              });
              log("On Hit Seek tapPosition>> onPanUpdate>> "+_tapposition.dx.toString());
            },
            onDoubleTap: () async {
              log("On Hit Seek ");

              double screenWidth = MediaQuery.of(context).size.width;
              log("On Hit Seek screenWidth >> "+screenWidth.toString());
              log("On Hit Seek tapPosition >> "+_tapposition.toString());
              if (_tapposition.dx < screenWidth / 2) {
                _showBackwardAnimation = true;
                Duration videoDuration = await widget.controller.videoPlayerController.position;
                log("On Hit Seek Back"+videoDuration.toString());
                setState(() {
                  widget.controller.seekTo(Duration(seconds: videoDuration.inSeconds-10));


                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      _showBackwardAnimation = false;
                    });
                  });
                });
              }
              else {
                _showForwardAnimation = true;
                Duration videoDuration = await widget.controller.videoPlayerController.position;
                log("On Hit Seek Up "+videoDuration.toString());
                setState(() {
                  widget.controller.seekTo(Duration(
                      seconds: videoDuration.inSeconds+10));
                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      _showForwardAnimation = false;
                    });
                  });
                });
              }
            },
            child: Container(
              // color: videoDetailcontroller.videoVisable.value==true?
              // Colors.black.withOpacity(0.8):
              color: Colors.black,
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  /// VideoPlayer
                  Chewie(
                    controller: widget.controller,
                    // videoDetailcontroller.betterPlayerController_videoplayer,
                    // key:videoDetailcontroller.betterPlayerKey,
                  ),

                  _showForwardAnimation
                      ? Positioned(
                    top: 5,
                    bottom: 5,
                    right: 5,
                    child: Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:  BorderRadius.only(
                          topLeft: Radius.circular(100), // Half the height
                          bottomLeft: Radius.circular(100), // Half the height
                        ),// S
                      ),
                      width: MediaQuery.of(context).size.width*0.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            // decoration: BoxDecoration(
                            //   color: Colors.white.withOpacity(0.5),
                            // ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  '+10 Seconds',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Image.asset("assets/nprep2_images/right.gif",height: 40,width: 40,),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),

                  /// -10 sec Backward <<
                  _showBackwardAnimation
                      ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius:  BorderRadius.only(
                        topRight: Radius.circular(100), // Half the height
                        bottomRight: Radius.circular(100), // Half the height
                      ),// S
                    ),
                    width: MediaQuery.of(context).size.width*0.4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/nprep2_images/left.gif",height: 40,width: 40,),
                              SizedBox(width: 15,),
                              Text(
                                '-10 Seconds',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),

                  /// Video Visable ON/OFF
                  videoDetailcontroller.videoVisable.value==true?
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      /// Video Seek to backward 10 sec , play pause , Video Seek to forward 10 sec
                      videoDetailcontroller.isInSmallMode==false?  SizedBox(height: 50,):SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            // color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              /// Video Seek to backward 10 sec
                              videoDetailcontroller.isInSmallMode==false?InkWell(
                                onTap: () async {
                                  Duration videoDuration = await widget.videocontroller.value.position;
                                  log("On Hit Seek Back"+videoDuration.toString());
                                  setState(() {
                                    widget.controller.seekTo(Duration(seconds: videoDuration.inSeconds-10));
                                    // if (widget.controller.isPlaying()) {
                                    //   Duration rewindDuration = Duration(
                                    //       seconds: (videoDuration.inSeconds - 2));
                                    //   if (rewindDuration <
                                    //       widget.controller.videoPlayerController
                                    //           .value.duration) {
                                    //     widget.controller.seekTo(Duration(seconds: 10));
                                    //   } else {
                                    //     widget.controller.seekTo(rewindDuration);
                                    //   }
                                    // }
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    Icons.replay_10_sharp,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ):Container(),
                              /// Video Play / Pause
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (widget.controller.isPlaying)
                                      widget.controller.pause();
                                    else
                                      widget.controller.play();
                                  });

                                },
                                child:  Container(
                                  height: 50,
                                  width: 80,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: ValueListenableBuilder<VideoPlayerValue>(
                                    valueListenable: widget.videocontroller,
                                    builder: (context, value, child) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (value.isPlaying)
                                              widget.videocontroller.pause();
                                            else
                                              widget.videocontroller.play();
                                          });

                                        },
                                        child:  Container(
                                          height: 50,
                                          width: 80,

                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Icon(
                                            value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,size: 30,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              /// Video Seek to forward 10 sec
                              videoDetailcontroller.isInSmallMode==false?   InkWell(
                                onTap: () async {
                                  Duration videoDuration = await widget
                                      .controller.videoPlayerController.position;
                                  log("On Hit Seek Up "+videoDuration.toString());
                                  setState(() {
                                    widget.controller.seekTo(Duration(
                                        seconds: videoDuration.inSeconds+10));
                                    // if (widget.controller.isPlaying()) {
                                    //   Duration forwardDuration = Duration(
                                    //       seconds: (videoDuration.inSeconds + 2));
                                    //   if (forwardDuration >
                                    //       widget.controller.videoPlayerController
                                    //           .value.duration) {
                                    //     widget.controller.seekTo(Duration(seconds: 10));
                                    //     // widget.controller.pause();
                                    //   } else {
                                    //     widget.controller.seekTo(forwardDuration);
                                    //   }
                                    // }
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    Icons.forward_10_sharp,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      /// Video Play / Pause Icon , Timing Duration , Next Video , Horizontal exitFullScreen/enterFullScreen
                      videoDetailcontroller.isInSmallMode==false?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child:CustomProgressBar(controller: widget.videocontroller,videoDetailcontroller: videoDetailcontroller,hiveornot: widget.hiveornot),

                      ):Container()


                    ],
                  ):Container(),

                  videoDetailcontroller.isInSmallMode == true?Container():    Positioned(
                    top: double.parse(videoDetailcontroller.top_post.value.toString()),
                    right: double.parse(videoDetailcontroller.right_post.value.toString()),

                    child: Container(
                      // height: 35,
                      // width: 35,

                      child: Text("+91 ${sprefs.getString("mobile")}",style: TextStyle(color: grey,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child:  videoDetailcontroller.DurationMessage.value==""?Container():
                      Container(
                          color: Colors.red.withOpacity(0.5),
                          width: MediaQuery.of(context).size.width,

                          alignment: Alignment.center,
                          padding: EdgeInsets.all(0.8),
                          child:
                          Text("${videoDetailcontroller.DurationMessage.value}",
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 0.8)
                          )
                      ),
                    ),
                  ),
                  videoDetailcontroller.isInSmallMode==false?     Positioned(
                    left: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                              systemNavigationBarColor: Color(
                                  0xFFFFFFFF), // navigation bar color
                              statusBarColor: Color(
                                  0xFF64C4DA), // status bar color
                            ));
                        Get.back();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color:
                            Colors.black45.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                                Radius.circular(50))),
                        child: Icon(
                          Icons.chevron_left,
                          color: white,
                        ),
                      ),
                    ),
                  ):Container(),
                ],
              ),
            ),
          );

        }
    );
  }
//   ProgressBar _progressBar() {
//     return ProgressBar(
//       bufferedBarColor: Colors.red,
// // timeLabelType: TimeLabelType.totalTime,
//
//       timeLabelLocation: TimeLabelLocation.none,
//       thumbRadius: 4.5,
//       barHeight: 5,
// // progressBarColor: Colors.red,
//       baseBarColor: Colors.grey.shade400,
//
//       thumbGlowColor: lightPrimary.withOpacity(0.2),
//       progress: widget.controller.videoPlayerController.value.position,
//       buffered: Duration(milliseconds: widget.controller.videoPlayerController.value.buffered.length),
//       total: widget.videocontroller.value.duration,
//       onSeek: (duration) {
//         print('User selected a new time: $duration');
//         widget.controller.seekTo(duration);
//       },
//       onDragUpdate: (details) {
//         debugPrint('${details.timeStamp}, ${details.localPosition}');
//         widget.controller.seekTo(details.timeStamp);
//         print('User selected a onDragUpdate time:');
//       },
//
//       // barHeight: _barHeight,
//       // baseBarColor: _baseBarColor,
//       // progressBarColor: _progressBarColor,
//       // bufferedBarColor: _bufferedBarColor,
//       // thumbColor: _thumbColor,
//       // thumbGlowColor: _thumbGlowColor,
//       // barCapShape: _barCapShape,
//       // thumbRadius: _thumbRadius,
//       // thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
//       // timeLabelLocation: _labelLocation,
//       // timeLabelType: _labelType,
//       // timeLabelTextStyle: _labelStyle,
//       // timeLabelPadding: _labelPadding,
//     );
//   }
  void _showCustomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.speed),
                title: Text('Playback speed',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: () {
                  // Implement 'Add to Playlist' functionality
                  Navigator.pop(context);
                  _showPlaybackSpeedDialog(context);
                },
              ),

              // Add more list tiles for additional menu options
            ],
          ),
        );
      },
    );
  }
  void _showPlaybackSpeedDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          padding: EdgeInsets.all(16),
          // color: Colors.red,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Playback Speed'),
              ListTile(
                title: Text('0.5x'),
                onTap: () {
                  setState(() {
                    speedText = "0.5x";
                  });
                  widget.videocontroller.setPlaybackSpeed(0.5); // Set playback speed
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.0x'),
                onTap: () {
                  setState(() {
                    speedText = "1.0x";
                  });
                  // widget.controller.setSpeed(1.0); // Set playback speed
                  widget.videocontroller.setPlaybackSpeed(1.0); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.25x'),
                onTap: () {
                  setState(() {
                    speedText = "1.25x";
                  });
                  // widget.controller.setSpeed(1.25); // Set playback speed
                  widget.videocontroller.setPlaybackSpeed(1.25); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.5x'),
                onTap: () {
                  setState(() {
                    speedText = "1.5x";
                  });
                  // widget.controller.setSpeed(1.5); // Set playback speed
                  widget.videocontroller.setPlaybackSpeed(1.5); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('2.0x'),
                onTap: () {
                  setState(() {
                    speedText = "2.0x";
                  });
                  // widget.controller.setSpeed(2.0); // Set playback speed
                  widget.videocontroller.setPlaybackSpeed(2.0); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );

  }
  _CustomControlsWidgetState();
}


class CustomProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  VideoDetailcontroller videoDetailcontroller;
  bool hiveornot;
  CustomProgressBar({this.controller,this.videoDetailcontroller,this.hiveornot});

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {

  String speedText = "1.0x";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      /// Video Play / Pause Icon ,
                      Icon(value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,color: Colors.grey,),
                      SizedBox(width: 10,),
                      /// Timing Duration
                      Text("${value.position.toString().split(".")[0]} / ${value.duration.toString().split(".")[0]}",style: TextStyle(color: Colors.grey),),
                    ],
                  ),

                  // widget.controller.videoPlayerController.value.position.toString().split(".")[0]==widget.controller.videoPlayerController.value.duration.toString().split(".")[0]
                  // ?
                  //     Container(
                  //       width: 30,
                  //         height: 30,
                  //         decoration: BoxDecoration(
                  //             color: Colors.white54,
                  //           borderRadius: BorderRadius.circular(22)
                  //         ),
                  //
                  //         child: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.white,))
                  //     :
                  Row(
                    children: [
                      /// Next Video
                      value.position.toString().split(".")[0]==value.duration.toString().split(".")[0]
                          ?
                      widget.hiveornot==true?Container():
                      widget.videoDetailcontroller.VideoDetaildata[0]['next_video_category']==null?Container():
                      GestureDetector(
                        onTap: () async {
                          log("Hit Next Video");
                          try{
                            widget.controller.pause();

                            await  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => VideoDetailScreen(CatId: widget.videoDetailcontroller.VideoDetaildata[0]['next_video_category'])),
                            );
                            widget.videoDetailcontroller.dispose();

                          }catch(e){
                            log("Hit NextNavigator Exception> "+e.toString());
                          }

                          // Get.off(VideoDetailScreen(CatId: videoDetailcontroller.VideoDetaildata[0]['next_video_category']));
                        },
                        child: Container(
                          // width: 30,
                            height: 30,
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white54.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)
                            ),

                            child: Text("Next Video",style: TextStyle(color: primary),)),
                      ):Container(),
                      /// Horizontal exitFullScreen/enterFullScreen
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.videoDetailcontroller.isInSmallMode==false? widget.videoDetailcontroller.VideoLoadingBeforeloader.value!=true?
                                GestureDetector(
                                    onTap: (){
                                      _showPlaybackSpeedDialog(context);
                                    },
                                    child: Container(
                                      // height: 30,
                                      // width: 50,
                                      color: Colors.black.withOpacity(0.0),

                                      child: Text(speedText,style: TextStyle(color: Colors.white),),
                                      // child: Icon(Icons.more_vert,color: Colors.white,size: 23,)
                                    )):Container(): Container(),
                                SizedBox(width: 15), // Optional spacing between elements
                                Icon(
                                  // widget.controller.value.isFullScreen
                                  //     ? Icons.fullscreen_exit
                                  //     :
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                       widget.videoDetailcontroller.updateVideoOrientation();
                      },
                      ),
                    ],
                  )
                ],
              ),
            ),

            ProgressBar(
              bufferedBarColor: primary.withOpacity(0.2),
// timeLabelType: TimeLabelType.totalTime,

              timeLabelLocation: TimeLabelLocation.none,
              thumbRadius: 4.5,
              barHeight: 5,
// progressBarColor: Colors.red,
              baseBarColor: Colors.grey.shade200,

              thumbGlowColor: lightPrimary.withOpacity(0.2),

              onDragUpdate: (details) {
                debugPrint('${details.timeStamp}, ${details.localPosition}');
                widget.controller.seekTo(details.timeStamp);
                print('User selected a onDragUpdate time:');
              },

              // barHeight: _barHeight,
              // baseBarColor: _baseBarColor,
              // progressBarColor: _progressBarColor,
              // bufferedBarColor: _bufferedBarColor,
              // thumbColor: _thumbColor,
              // thumbGlowColor: _thumbGlowColor,
              // barCapShape: _barCapShape,
              // thumbRadius: _thumbRadius,
              // thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
              // timeLabelLocation: _labelLocation,
              // timeLabelType: _labelType,
              // timeLabelTextStyle: _labelStyle,
              // timeLabelPadding: _labelPadding,
              progress: value.position,
              buffered: value.buffered.isNotEmpty ? value.buffered.last.end : Duration.zero,
              total: value.duration,
              onSeek: (duration) {
                print('User selected a new time: $duration');

                widget.controller.seekTo(duration);
              },
              timeLabelTextStyle: TextStyle(color: Colors.white),
              progressBarColor: primary,
              thumbColor: primary,
            ),
          ],
        );
      },
    );
  }

  void _showPlaybackSpeedDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          padding: EdgeInsets.all(16),
          // color: Colors.red,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Playback Speed'),
              ListTile(
                title: Text('0.5x'),
                onTap: () {
                  setState(() {
                    speedText = "0.5x";
                  });
                  widget.controller.setPlaybackSpeed(0.5); // Set playback speed
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.0x'),
                onTap: () {
                  setState(() {
                    speedText = "1.0x";
                  });
                  // widget.controller.setSpeed(1.0); // Set playback speed
                  widget.controller.setPlaybackSpeed(1.0); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.25x'),
                onTap: () {
                  setState(() {
                    speedText = "1.25x";
                  });
                  // widget.controller.setSpeed(1.25); // Set playback speed
                  widget.controller.setPlaybackSpeed(1.25); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('1.5x'),
                onTap: () {
                  setState(() {
                    speedText = "1.5x";
                  });
                  // widget.controller.setSpeed(1.5); // Set playback speed
                  widget.controller.setPlaybackSpeed(1.5); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('2.0x'),
                onTap: () {
                  setState(() {
                    speedText = "2.0x";
                  });
                  // widget.controller.setSpeed(2.0); // Set playback speed
                  widget.controller.setPlaybackSpeed(2.0); // Set playback speed

                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );

  }
}
