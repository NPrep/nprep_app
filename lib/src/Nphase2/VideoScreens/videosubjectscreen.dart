import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Controller/profile/profile_controller.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/src/Nphase2/Controller/VideoSubjectController.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/HiveSaved_video_detail_screen.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/Samplevideo.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/SaveVideos.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_sub_subjectscreen.dart';
import 'package:n_prep/src/Nphase3/youtubelive/Liveclasses.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
class VideoSubjectScreen extends StatefulWidget {
  const VideoSubjectScreen({Key key}) : super(key: key);

  @override
  State<VideoSubjectScreen> createState() => _VideoSubjectScreenState();
}

class _VideoSubjectScreenState extends State<VideoSubjectScreen> {
  Videosubjectcontroller videosubjectcontroller =Get.put(Videosubjectcontroller());
  ProfileController profileController = Get.put(ProfileController());


  List subject = [
    {
      "text": "Saved",
      "text2": "0/50 Videos",
      "image": "assets/nprep2_images/video.png"
    },
    {
      "text": "Sample Videos",
      "text2": "",
      "image": "assets/nprep2_images/video.png"
    },
    {
      "text": "Youtube",
      "text2": "",
      "image": "assets/nprep2_images/video.png"
    },
  ];

  bool slide = false;

  int current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,

    ]);
    call_profile();
    videosubjectcontroller.FetchSubjectData();
  }
  void _launchYouTube(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  call_profile() async {

    var profileUrl = "${apiUrls().profile_api}";
    // Logger_D(profileUrl);
    await profileController.GetProfile(profileUrl);
    sprefs.setString("deviceid",profileController.profileData['data']['device_id'].toString());

  }
  Future<AndroidBitmap<Object>> _getNotificationImage(String imageUrl) async {
    final ByteArrayAndroidBitmap bitmap = ByteArrayAndroidBitmap(
      await _downloadImage(imageUrl),
    );
    return bitmap;
  }

  Future<List<int>> _downloadImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
  Future<void> _showNotification(titles, bodys, image, payload) async {
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    var bigPictureStyleInformation;

    if (image == null) {
      bigPictureStyleInformation = BigTextStyleInformation(bodys);

    } else {

      final http.Response response = await http.get(Uri.parse(image));

      bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(response.bodyBytes)),
        // largeIcon: await _getNotificationImage(image),
        // summaryText: bodys,
        // contentTitle: titles
      );
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.high,

        // largeIcon: await _getNotificationImage(image),
        styleInformation: bigPictureStyleInformation,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    // android: androidPlatformChannelSpecifics, iOS: iosDetail);
    await flutterLocalNotificationsPlugin
        .show(0, titles, bodys, platformChannelSpecifics, payload: payload);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log("size>> videolist>> "+size.width.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // body: SingleChildScrollView(
      //   child: Container(
      //     height: size.height-120,
      //     width: size.width,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //
      //         Image.asset('assets/nprep2_images/youtube.png',
      //           height: 260,
      //           width: 220,),
      //         Text("Coming Soon",
      //           style: TextStyle(
      //               fontSize: 26,
      //               color: primary,
      //               fontWeight: FontWeight.w600
      //           ),)
      //       ],
      //     ),
      //   ),
      // ),

      body: RefreshIndicator(
        displacement: 80,
        backgroundColor:primary,
        color: white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          call_profile();
          videosubjectcontroller.FetchSubjectData();
          // getdata();
        },
        child: GetBuilder<Videosubjectcontroller>(
          builder: (videosubjectcontroller) {
            if(videosubjectcontroller.Videosubjectloader.value){
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
            else{
              return SingleChildScrollView(
                child: Container(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        // ElevatedButton(onPressed: (){
                        //   Get.to(Youtube());
                        // },
                        //     child: Text("Video page")),
                        Environment.videoduration==null?Container():   Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                          elevation: 5.8,
                            child: Container(
                              width:Get.width,
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  GestureDetector(
                                    onTap: () async {
                                      await Get.to(VideoDetailScreen(CatId: int.parse(Environment.videoCatId),VideoDuration: sprefs.getString('video_duration'),));
                                    },
                                    child: Container(
                                      // color: Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child:  Container(
                                         // color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text('Continue Watching', style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: textColor,
                                                      fontSize: 14,
                                                      letterSpacing: 0.5)
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: AutoSizeText(" ${Environment.videoTitle}",
                                                    style: TextStyle(color: primary,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 13,
                                                      letterSpacing: 0.5),maxLines: 2,),
                                                ),
                                              ),
                                              Container(
                                                child: Icon(Icons.arrow_forward_ios,color: primary,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Text(Environment.videoduration),
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 10,right: 10),
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         flex: 1,
                                  //         child: Divider(
                                  //           color:  primary,
                                  //           height: 12,
                                  //           thickness: 2.5,
                                  //           indent: 0,
                                  //           endIndent: 0,
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         flex: 1,
                                  //         child: Divider(
                                  //           color:  grey,
                                  //           height: 12,
                                  //           thickness: 2.5,
                                  //           indent: 0,
                                  //           endIndent: 0,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Environment.videoduration_bar==null?Container():    Container(
                                    // color: Colors.red,
                                    // width: size.width*0.5,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                      child: LinearProgressIndicator(
                                        value: double.parse(Environment.videoduration_bar),
                                        backgroundColor: lightPrimary,
                                        minHeight: 3,
                                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          height: 78,
                          // width:size.width>500?size.width: size.width-25,
                          width:size.width,
                          // color: Colors.red,

                          child: ListView.builder(
                              itemCount: subject.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              // clipBehavior: Clip.none,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                var subjectlistdata = subject[index];
                                return GestureDetector(
                                  onTap: (){
                                    if(subjectlistdata["text"]=="Saved"){
                                      Get.to(SaveVideos());
                                    }
                                    if(subjectlistdata["text"]=="Youtube"){
                                      _launchYouTube(videosubjectcontroller.Videosubjectdata[0]['data']['youtube_video']);
                                    }
                                    if(subjectlistdata["text"]=="Sample Videos"){
                                          var data =videosubjectcontroller.Videosubjectdata[0]['data']['sample_videos'];

                                          Get.to(
                                              Samplevideo(SampleVideoList: data.length==0?[]:data,)
                                          );
                                    }
                                  },
                                  child: Container(
                                    width:  size.width>500?280:160,
                                    alignment: Alignment.center,
                                    child: Card(
                                      elevation: 5.0,
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: size.width>500?20:10,vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset(subjectlistdata["image"].toString(),
                                              height: 30,
                                              width: 30,),
                                            sizebox_width_10,
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // Text("${size.width}"),
                                                Container(
                                                  width: size.width>500?130:90,
                                                  // color: Colors.green,
                                                  child: Text(subjectlistdata["text"].toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.5,
                                                    ),),
                                                ),
                                                sizebox_height_5,
                                                subjectlistdata["text2"]==""?Container():   Container(
                                                  width: size.width>500?130:90,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('${subjectlistdata["text2"]=="0/50 Videos"? ""
                                                      "${videosubjectcontroller.Videosubjectdata[0]['data']['saved_video_count']}/"
                                                      "${videosubjectcontroller.Videosubjectdata[0]['data']['saved_video_limit']} Videos" :subjectlistdata["text2"]}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: textColor,
                                                        letterSpacing: 0.5
                                                    ),),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        videosubjectcontroller.Videosubjectdata[0]['data']['is_session_live']=="1"?  SizedBox(height: 10,):Container(),
                        videosubjectcontroller.Videosubjectdata[0]['data']['is_session_live']=="1"?  Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Live Class",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: textColor
                                ),),
                            ],
                          ),
                        ):Container(),
                        videosubjectcontroller.Videosubjectdata[0]['data']['is_session_live']=="1"? GestureDetector(
                          onTap: (){
                            Get.to(Liveclasses());

                          },
                          child: Card(
                            elevation: 5.0,
                            // color: subjectsData['id'].toString()=="43"? white:grey,
                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color:textColor),),
                            child: Padding(
                              padding:  EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FadeInImage.memoryNetwork(
                                          height: 50,
                                          width: 55,
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Container(

                                              // color: Colors.grey.shade300,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                "assets/images/liveanimation.gif",
                                                height: 50,
                                                width: 55,
                                              ),
                                              // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                              //   color: Colors.grey.shade300,),
                                            );
                                          },
                                          placeholder: kTransparentImage,
                                          image: "assets/images/liveanimation.gif"),

                                      sizebox_width_10,
                                      Container(
                                        width: size.width-190,
                                        // color: Colors.red,
                                        child: Text(
                                          'LIVE CLASS',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(0xFF6A6E70),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // Column(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Container(
                                      //       width: size.width-120,
                                      //       // color: Colors.red,
                                      //       child: Text(
                                      //         'LIVE CLASS',
                                      //         maxLines: 2,
                                      //         overflow: TextOverflow.ellipsis,
                                      //         textAlign: TextAlign.start,
                                      //         style: TextStyle(
                                      //             color: Color(0xFF6A6E70),
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.bold),
                                      //       ),
                                      //     ),
                                      //     // sizebox_height_5,
                                      //     // Container(
                                      //     //   width: size.width-120,
                                      //     //   // color: Colors.red,
                                      //     //   child: Text(
                                      //     //     'Watch live classes',
                                      //     //     textAlign: TextAlign.justify,
                                      //     //     style: TextStyle(
                                      //     //         color: textColor,
                                      //     //         fontSize: 11,
                                      //     //         fontWeight: FontWeight.w400),
                                      //     //   ),
                                      //     // ),
                                      //   ],
                                      // ),
                                      // Image.asset("assets/images/liveanimation.gif",scale: 3.0,fit: BoxFit.fill,)

                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                ],
                              ),
                            ),
                          ),
                        ):Container(),
                        SizedBox(height: 10,),
                       ///Rapid Revision
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Rapid Revision",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: textColor
                                ),),
                            ],
                          ),
                        ),

                        ///Rapid Revision List
                        ListView.builder(
                            itemCount: videosubjectcontroller.Videosubjectdata[0]['data']['categories'].length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // controller: _scrollController,
                            itemBuilder: (_, index) {
                              var subjectsData = videosubjectcontroller.Videosubjectdata[0]['data']['categories'][index];

                              return subjectsData['id'].toString() != "43"?Container():Container(
                                margin: EdgeInsets.only(left: 5,right: 5),
                                child: GestureDetector(
                                  onTap: (){

                                    Get.to(SubSubjectScreen(showprmpt: true,showDilog: false,
                                      Catname: subjectsData['category_name'],Catparentid:subjectsData['id'] ,));

                                    // _showNotification("titles", "bodysdbjkvbsjkdbvkjsdbvjksdbvkjsbdkjvbdsjksdbjksdbvkjsdbvjksbdjkvsdbjksdbjkvsdbjkvsdbjksdbjksdbvjksdbkjsdbjksdbkjsvdbjksdbvkjsdbjksdbkjvsdbkjsbdkjbs", "https://via.placeholder.com/600x200", null);
                                    // _showNotification("titles", "bodysdbjkvbsjkdbvkjsdbvjksdbvkjsbdkjvbdsjksdbjksdbvkjsdbvjksbdjkvsdbjksdbjkvsdbjkvsdbjksdbjksdbvjksdbkjsdbjksdbkjsvdbjksdbvkjsdbjksdbkjvsdbkjsbdkjbs", null, null);

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
                                              subjectsData['image'].toString()=="null"? Image.network( '${subjectsData['image']}',
                                                  height: 50,
                                                  width: 50,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(

                                                      // color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Image.asset(
                                                        "assets/nprep2_images/LOGO.png",
                                                        // height: 20,
                                                        width: MediaQuery.of(context).size.width * 0.18,
                                                      ),
                                                      // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                                      //   color: Colors.grey.shade300,),
                                                    );
                                                  }
                                              ):
                                              FadeInImage.memoryNetwork(
                                                  height: 50,
                                                  width: 50,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Container(

                                                      // color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Image.asset(
                                                        "assets/nprep2_images/LOGO.png",
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                      // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                                      //   color: Colors.grey.shade300,),
                                                    );
                                                  },
                                                  placeholder: kTransparentImage,
                                                  image: subjectsData['image']==null?
                                                  "assets/nprep2_images/LOGO.png":
                                                  subjectsData['image'].toString()),

                                              sizebox_width_5,
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: size.width-120,
                                                    // color: Colors.red,
                                                    child: Text(
                                                      '${subjectsData['category_name']}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          color: Color(0xFF6A6E70),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  sizebox_height_5,
                                                  Container(
                                                    width: size.width-120,
                                                    // color: Colors.red,
                                                    child: Text(
                                                      '${subjectsData['attempt_categories']}/${subjectsData['total_categories']} Videos',
                                                      textAlign: TextAlign.justify,
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
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
                            }),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Subjects",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: textColor
                                ),),
                            ],
                          ),
                        ),
                        ListView.builder(
                            itemCount: videosubjectcontroller.Videosubjectdata[0]['data']['categories'].length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // controller: _scrollController,
                            itemBuilder: (_, index) {
                              var subjectsData = videosubjectcontroller.Videosubjectdata[0]['data']['categories'][index];

                              return subjectsData['id'].toString() == "43"?Container():Container(
                                margin: EdgeInsets.only(left: 5,right: 5),
                                child: GestureDetector(
                                  onTap: (){

                                    Get.to(SubSubjectScreen(showprmpt: true,showDilog: false,
                                      Catname: subjectsData['category_name'],Catparentid:subjectsData['id'] ,));

                                   // _showNotification("titles", "bodysdbjkvbsjkdbvkjsdbvjksdbvkjsbdkjvbdsjksdbjksdbvkjsdbvjksbdjkvsdbjksdbjkvsdbjkvsdbjksdbjksdbvjksdbkjsdbjksdbkjsvdbjksdbvkjsdbjksdbkjvsdbkjsbdkjbs", "https://via.placeholder.com/600x200", null);
                                    // _showNotification("titles", "bodysdbjkvbsjkdbvkjsdbvjksdbvkjsbdkjvbdsjksdbjksdbvkjsdbvjksbdjkvsdbjksdbjkvsdbjkvsdbjksdbjksdbvjksdbkjsdbjksdbkjsvdbjksdbvkjsdbjksdbkjvsdbkjsbdkjbs", null, null);

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
                                              subjectsData['image'].toString()=="null"? Image.network( '${subjectsData['image']}',
                                                  height: 50,
                                                  width: 50,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(

                                                      // color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Image.asset(
                                                        "assets/nprep2_images/LOGO.png",
                                                        // height: 20,
                                                        width: MediaQuery.of(context).size.width * 0.18,
                                                      ),
                                                      // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                                      //   color: Colors.grey.shade300,),
                                                    );
                                                  }
                                              ): FadeInImage.memoryNetwork(
                                                  height: 50,
                                                  width: 50,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Container(

                                                      // color: Colors.grey.shade300,
                                                      alignment: Alignment.center,
                                                      child: Image.asset(
                                                        "assets/nprep2_images/LOGO.png",
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                      // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                                      //   color: Colors.grey.shade300,),
                                                    );
                                                  },
                                                  placeholder: kTransparentImage,
                                                  image: subjectsData['image']==null?"assets/nprep2_images/LOGO.png":subjectsData['image'].toString()),
                                              // Image.network( '${subjectsData['image']}',
                                              //   height: 50,
                                              //   width: 50,
                                              //     errorBuilder: (context, error, stackTrace) {
                                              //       return Container(
                                              //
                                              //         // color: Colors.grey.shade300,
                                              //         alignment: Alignment.center,
                                              //         child: Image.asset(
                                              //           "assets/nprep2_images/LOGO.png",
                                              //           // height: 20,
                                              //           width: MediaQuery.of(context).size.width * 0.18,
                                              //         ),
                                              //         // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                              //         //   color: Colors.grey.shade300,),
                                              //       );
                                              //     }
                                              //     ),
                                              sizebox_width_5,
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: size.width-120,
                                                  // color: Colors.red,
                                                    child: Text(
                                                      '${subjectsData['category_name']}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          color: Color(0xFF6A6E70),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  sizebox_height_5,
                                                  Container(
                                                      width: size.width-120,
                                                    // color: Colors.red,
                                                    child: Text(
                                                      '${subjectsData['attempt_categories']}/${subjectsData['total_categories']} Videos',
                                                      textAlign: TextAlign.justify,
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
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
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }


          }
        ),
      ),
    );
  }
}
