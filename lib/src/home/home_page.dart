// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// import 'package:image_pixels/image_pixels.dart';
// import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
// import 'package:n_prep/Controller/Home/HomeController.dart';
// import 'package:n_prep/Controller/Setting_controller.dart';
// import 'package:n_prep/Controller/profile/profile_controller.dart';
// // import 'package:n_prep/DEmo/demogarucustomer.dart';
// import 'package:n_prep/Service/Service.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
// import 'package:n_prep/constants/error_message.dart';
// import 'package:n_prep/constants/images.dart';
// import 'package:n_prep/constants/validations.dart';
// import 'package:n_prep/main.dart';
// import 'package:n_prep/src/home/bottom_bar.dart';
// import 'package:n_prep/utils/colors.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   SettingController settingController =Get.put(SettingController());
//
//   HomeController homeController = Get.put(HomeController());
//   AuthController authController =Get.put(AuthController());
//   ProfileController profileController = Get.put(ProfileController());
//   // List<String> options = [
//   //   'Pneumonia is an infection of the',
//   //   'Pneumonia is an infection of the',
//   //   'Pneumonia is an infection of the',
//   //   'Pneumonia is an infection of the',
//   //   // ... Add more options ...
//   // ];
//   // // Initialize with an invalid value
//   int selectedOptionIndex = -1;
//   // Initialize with an invalid value
//
//   bannerImages(imagess){
//     print("imagess...."+imagess.toString());
//     return  ImagePixels.container(
//       imageProvider: NetworkImage(imagess),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//
//         child: Image(image:NetworkImage(imagess),
//         ),
//       ),
//     );
//   }
//
//   bool isAnswer = false;
//   int correctans= 0;
//
//   @override
//   void initState() {
//     super.initState();
//     call_profile();
//     var homeUrl = apiUrls().home_api;
//     Logger_D(homeUrl);
//     homeController.HomeApi(homeUrl,true);
//     var settingUrl ="${apiUrls().setting_api}";
//     settingController.SettingData(settingUrl);
//   }
//   call_profile() async {
//
//     var profileUrl = "${apiUrls().profile_api}";
//     // Logger_D(profileUrl);
//     await profileController.GetProfile(profileUrl);
//     sprefs.setString("deviceid",profileController.profileData['data']['device_id'].toString());
//     checklogindifference();
//   }
//   checklogindifference() async {
//     authController.deviceId =  await authController.getId();
//     log("App deviceId: ${authController.deviceId}");
//     log("Server deviceId:  ${sprefs.getString("deviceid")}");
//     log("Check deviceId:  ${authController.deviceId.toString() == sprefs.getString("deviceid")}");
//     if(authController.deviceId.toString() == sprefs.getString("deviceid")){
//
//       log("You logged in");
//     }else{
//
//       log("You logged out");
//       toastMsg("You already logged in to another device. So we are logging you out.", true);
//       sprefs.clear();
//       sprefs.setBool(KEYLOGIN, false);
//       apiCallingHelper().logoutinPref();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     var cheight = MediaQuery.of(context).size.height;
//     var cwidth = MediaQuery.of(context).size.width;
//     Size size =MediaQuery.of(context).size;
//     return Scaffold(
//       // restorationId: "home_page",
//       backgroundColor: primary,
//       body: GetBuilder<SettingController>(
//           builder: (settingController) {
//             return GetBuilder<HomeController>(
//                 id: "home_page",
//                 builder: (homeContro) {
//                   if(homeContro.homeLoading.value){
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//                         Center(child: CircularProgressIndicator(color: white,)),
//                       SizedBox(height: 5,),
//                       settingController.settingData['data']['general_settings']['quotes'].length ==0?Text(""):
//                       Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
//                           color: primary,
//                           letterSpacing: 0.5,
//                           fontWeight: FontWeight.w600
//                       )),                      ],
//                     );
//                   }
//                   return  RefreshIndicator(
//                     displacement: 65,
//                     backgroundColor: Colors.white,
//                     color: primary,
//                     strokeWidth: 3,
//                     triggerMode: RefreshIndicatorTriggerMode.onEdge,
//                     onRefresh: () async {
//                       await Future.delayed(Duration(milliseconds: 1500));
//                       var homeUrl = apiUrls().home_api;
//                       Logger_D(homeUrl);
//                       homeController.HomeApi(homeUrl,true);
//                     },
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           // Text("${ sprefs.getString("quotes")}"),
//                           SizedBox(
//                             height: cheight * 0.05,
//                           ),
//                           Column(
//                             children: [
//                               Text('${homeContro.home_data['data']['module_count']} Q BLOCKS COMPLETED',
//                                   style: TextStyle(
//                                       color: white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Helvetica')),
//                               SizedBox(
//                                 height: cheight * 0.02,
//                               ),
//                               Image.asset(homeback_group,height: 120,),
//                             ],
//                           ),
//                           Container(
//                             width: cwidth,
//                             decoration: BoxDecoration(
//                                 color: white,
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(24),
//                                     topRight: Radius.circular(24))),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: cheight * 0.01,
//                                 ),
//                                 // imagessss(homeContro.home_data['data']['todayquestion']['question_attachment'].toString()),
//
//                                 homeContro.home_data['data']['banner'].length==0?Container()
//                                     :Container(
//                                     height: 100,
//                                     width: size.width*0.9,
//                                     child: Carousel(
//                                       images: [
//                                         for (int i = 0; i <homeContro.home_data['data']['banner'].length; i++)
//                                           GestureDetector(
//                                             onTap: () async {
//                                               if (!await launchUrl(Uri.parse("${homeContro.home_data['data']['banner'][i]['url']}"), mode: LaunchMode.externalApplication)) {
//                                                 throw Exception('Could not launch ');
//                                               }
//                                             },
//                                             child:   Container(
//                                               child: bannerImages(homeContro.home_data['data']['banner'][i]['image'].toString()),
//                                             ),
//                                           )
//
//
//                                         // CachedNetworkImage(
//                                         //
//                                         //   imageUrl:"http://via.placeholder.com/350x150",
//                                         //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//                                         //   errorWidget: (context, url, error) => Icon(Icons.error),
//                                         //
//                                         // ),
//                                       ],
//
//                                       dotSize: 8.0,
//                                       dotSpacing: 20.0,
//                                       dotColor: primary,
//                                       indicatorBgPadding: 5.0,
//                                       dotBgColor: Colors.transparent,
//                                       borderRadius: false,
//                                       moveIndicatorFromBottom: 100.0,
//                                       noRadiusForIndicator: true,
//                                       overlayShadow: true,
//                                       overlayShadowColors:primary,
//                                       overlayShadowSize: 0.2,
//                                       dotPosition: DotPosition.bottomCenter,
//                                     )),
//                                 SizedBox(
//                                   height: cheight * 0.02,
//                                 ),
//                                 homeContro.home_data['data']['todayquestion'].length==0?Container():
//                                 Container(
//                                   width: cwidth,
//                                   color: Colors.grey.shade100,
//                                   padding: EdgeInsets.all(16),
//                                   child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: (){
//                                             // Get.to(CustomerDetail());
//                                           },
//                                           child: Center(
//                                               child: Text(
//                                                 'MCQ of day',
//                                                 style: TextStyle(
//                                                     color: primary,
//                                                     fontFamily: 'Poppins-Regular',
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 20),
//                                               )),
//                                         ),
//                                         SizedBox(
//                                           height: cheight * 0.02,
//                                         ),
//                                         Text(
//                                             '${homeContro.home_data['data']['todayquestion']['question'].toString()=="null"?
//                                             "":homeContro.home_data['data']['todayquestion']['question'].toString()}',
//                                             style: TextStyle(
//                                                 fontFamily: 'Helvetica',
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 18,
//                                                 color: Colors.black54)),
//                                         SizedBox(
//                                           height: cheight * 0.02,
//                                         ),
//                                         homeContro.home_data['data']['todayquestion']['question_attachment']
//                                             .toString() ==
//                                             "null"
//                                             ? Container():SizedBox(height: 10),
//                                         homeContro.home_data['data']['todayquestion']['question_attachment'].toString()
//                                             ==
//                                             "null"
//                                             ? Container()
//                                             : Container(
//                                           margin: EdgeInsets.only(right: 10),
//                                           child: Image.network(
//                                               "${homeContro.home_data['data']['todayquestion']['question_attachment'].toString()}"),
//                                         ),
//
//                                         SizedBox(height: 15,),
//                                         //TODAY QUESTION LIST-----------------------//
//                                         homeContro.home_data['data']['todayquestion']['answer'].length==0?
//                                         Container():
//                                         Stack(
//                                           children: [
//                                             ListView.builder(
//
//                                               itemCount: homeContro.home_data['data']['todayquestion']['answer'].length,
//                                               // Replace 'options.length' with the actual number of options
//                                               shrinkWrap: true,
//                                               physics: NeverScrollableScrollPhysics(),
//                                               itemBuilder: (BuildContext context, int index) {
//                                                 final optionIndex = String.fromCharCode(97 +
//                                                     index); // Convert index to 'a', 'b', 'c', ...
//                                                 final optionText = homeContro.home_data['data']['todayquestion']['answer'][
//                                                 index]; // Replace 'options[index]' with your actual options
//                                                 return GestureDetector(
//                                                     onTap: () {
//                                                       homeContro.home_data['data']['todayquestion']['id'].toString()=="null"?
//                                                       Container():
//                                                       setState(() {
//                                                         var  todayUrl = apiUrls().today_question_api;
//                                                         var todayQ_Body= {
//                                                           'question_id': homeContro.home_data['data']['todayquestion']['id'].toString(),
//                                                           'answer_id': optionText['options_id'].toString(),
//                                                         };
//                                                         homeContro.TodayQuestionApi(todayUrl, todayQ_Body);
//                                                       });
//
//                                                     },
//                                                     child:Container(
//                                                       margin: EdgeInsets.symmetric(vertical: 2),
//                                                       padding: EdgeInsets.all(12),
//                                                       decoration: BoxDecoration(
//                                                         color: index == homeContro.home_data['data']['todayquestion']['currect_answer'] ? ansBackgroundColor:
//                                                         (index != homeContro.home_data['data']['todayquestion']['currect_answer'] &&
//                                                             homeContro.home_data['data']['todayquestion']['your_answer'] == index ? redBackgroundColor : Colors.white),
//                                                         border: Border.all(color: Colors.grey.shade300),
//                                                         borderRadius: BorderRadius.circular(8),
//                                                       ),
//                                                       child: Row(
//                                                         crossAxisAlignment:CrossAxisAlignment.center,
//                                                         children: [
//                                                           Container(
//                                                             decoration: BoxDecoration(
//                                                                 color: primary,
//                                                                 borderRadius:
//                                                                 BorderRadius.circular(30)),
//                                                             child: Padding(
//                                                               padding: EdgeInsets.symmetric(
//                                                                   horizontal: 12, vertical: 8),
//                                                               child: Text(
//                                                                 optionIndex.toUpperCase(),
//                                                                 style: TextStyle(
//                                                                     fontSize: 19,
//                                                                     fontWeight: FontWeight.w400,
//                                                                     fontFamily: 'Helvetica',
//                                                                     color: white),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 8),
//                                                           Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               optionText['answer'].toString()=="null"?Container():
//                                                               Container(
//                                                                 width: size.width-110,
//                                                                 child: Text(
//                                                                   optionText['answer'].toString(),
//                                                                   style: TextStyle(fontSize: 15,
//                                                                       fontFamily: 'Helvetica',
//                                                                       fontWeight: FontWeight.w600,
//                                                                       color: Colors.black54),
//                                                                 ),
//                                                               ),
//
//                                                               optionText['attachment'].toString()=="null"?Container():
//                                                               Container(
//                                                                 margin: EdgeInsets.only(top: 10),
//                                                                 alignment: Alignment.topLeft,
//                                                                 width: size.width*0.3,
//                                                                 height: size.height*0.1,
//                                                                 child: Image.network(optionText['attachment'].toString(),
//                                                                   errorBuilder: (context, error, stackTrace) {
//                                                                     return Container(
//
//                                                                       color: Colors.grey.shade300,
//                                                                       alignment: Alignment.center,
//                                                                       child: Icon(Icons.hide_image_outlined,size: 50,
//                                                                         color: Colors.grey.shade500,),
//                                                                     );
//                                                                   },),
//                                                               ),
//                                                             ],
//                                                           ),
//
//                                                         ],
//                                                       ),
//                                                     )
//                                                 );
//                                               },
//                                             ),
//                                             homeContro. todayLoading.value==true?
//                                             Positioned(
//                                                 top:10,
//                                                 bottom: 10,
//                                                 right: 10,
//                                                 left: 10,
//                                                 child: Center(child: CircularProgressIndicator())):
//                                             Container()
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         homeContro.home_data['data']['todayquestion']['your_answer']==null?Container():GestureDetector(
//                                           onTap: (){
//                                             homeContro.updatelessmore();
//                                           },
//                                           child: Container(
//
//                                               alignment: Alignment.centerLeft,
//                                               padding: EdgeInsets.only(
//                                                 left: 10,
//                                               ),
//                                               child: Text(
//                                                 homeContro.lessormore.value==true?"Hide":"See Rationale: ",
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     decoration: TextDecoration
//                                                         .underline,
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               )),
//                                         ),
//                                         homeContro.home_data['data']['todayquestion']['your_answer']==null?
//                                         Container(): homeContro.lessormore.value==true?Padding(
//                                           padding: const EdgeInsets.all(14.0),
//                                           child: Column(
//                                             children: [
//                                               homeContro.home_data['data']['todayquestion']['ans_description_attachment']
//                                                   .toString() ==
//                                                   "null"
//                                                   ? Container()
//                                                   : Image.network(
//                                                 homeContro.home_data['data']['todayquestion'][
//                                                 'ans_description_attachment']
//                                                     .toString(),
//                                               ),
//
//                                               homeContro.home_data['data']['todayquestion']['ans_description']
//                                                   .toString() ==
//                                                   "null"
//                                                   ? Container()
//                                                   : Padding(
//                                                 padding:
//                                                 const EdgeInsets.only(
//                                                     left: 8.0,
//                                                     right: 10.0,
//                                                     top: 12),
//                                                 child: Html(
//                                                   data: homeContro.home_data['data']['todayquestion'][
//                                                   'ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString()
//                                                   ,
//                                                   // defaultTextStyle: TextStyle(
//                                                   //     fontSize: 16,
//                                                   //     letterSpacing: 0.5),
//
//                                                   //           data: Text(get_data['ans_description'].toString(),
//                                                   //         textAlign: TextAlign.justify,
//                                                   //         style: TextStyle(
//                                                   //           fontSize: 14,
//                                                   //
//                                                   //           fontWeight: FontWeight.w400,
//                                                   //           fontFamily: 'Helvetica',
//                                                   //           color: black54,
//                                                   //         ),
//                                                   // ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ):Container(),
//                                         SizedBox(
//                                           height: cheight * 0.03,
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) => BottomBar(
//                                                       bottomindex: 1,
//                                                     )));
//                                           },
//                                           child: Stack(
//                                             clipBehavior: Clip.hardEdge,
//                                             children: [
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 child: Column(
//                                                   children: [
//                                                     Container(
//                                                       padding: EdgeInsets.only(left: 75,bottom: 17,top: 20),
//                                                       margin: EdgeInsets.only(bottom: 2,top: 4),
//
//                                                       width: size.width,
//                                                       // alignment: Alignment.center,
//                                                       decoration: BoxDecoration(
//                                                         color: primary,
//                                                         borderRadius: BorderRadius.circular(35),
//                                                         // border: Border.all(color: Colors.grey)
//                                                       ),
//                                                       child: Text(
//                                                         'Subject wise questions                                                               ',
//                                                         style:
//                                                         TextStyle(color: white,
//                                                             fontSize: 20,
//                                                             fontFamily: 'Helvetica',
//                                                             fontWeight: FontWeight.w400),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 child: CircleAvatar(
//                                                   radius: 32,
//                                                   backgroundColor: Colors.white,
//                                                   child: CircleAvatar(
//                                                     radius: 30,
//                                                     backgroundColor: homeCatBackgroundColor1,
//                                                     child: Image.asset(
//                                                       home_test1,
//                                                       color: white,
//                                                       height: 40,
//
//                                                     ),
//                                                   ),
//                                                 )
//                                                 ,)
//                                             ],
//                                           ),
//                                         ),
//
//                                         SizedBox(
//                                           height: cheight * 0.03,
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) => BottomBar(
//                                                       bottomindex: 2,
//                                                     )));
//                                           },
//                                           child: Stack(
//                                             clipBehavior: Clip.hardEdge,
//                                             children: [
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 child: Column(
//                                                   children: [
//                                                     Container(
//                                                       padding: EdgeInsets.only(left: 75,bottom: 17,top: 20),
//                                                       margin: EdgeInsets.only(bottom: 2,top: 4),
//
//                                                       width: size.width,
//                                                       // alignment: Alignment.center,
//                                                       decoration: BoxDecoration(
//                                                         color: primary,
//                                                         borderRadius: BorderRadius.circular(35),
//                                                         // border: Border.all(color: Colors.grey)
//                                                       ),
//                                                       child: Text(
//                                                         "Previous Year question",
//                                                         style:
//                                                         TextStyle(color: white,
//                                                             fontSize: 20,
//                                                             fontFamily: 'Helvetica',
//                                                             fontWeight: FontWeight.w400),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 child: CircleAvatar(
//                                                   radius: 32,
//                                                   backgroundColor: Colors.white,
//                                                   child: CircleAvatar(
//                                                     radius: 30,
//                                                     backgroundColor: homeCatBackgroundColor2,
//                                                     child: Image.asset(
//                                                       home_test,
//                                                       color: white,
//                                                       height: 40,
//
//                                                     ),
//                                                   ),
//                                                 )
//                                                 ,)
//                                             ],
//                                           ),
//                                         ),
//
//                                       ]),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//             );
//           }
//       ),
//     );
//   }
//
//   colorscheck(optionText) {
//
//   }
// }



import 'dart:developer';


import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/Controller/Home/HomeController.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Controller/profile/profile_controller.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../../Notification_pages/NotificationModel.dart';
import '../../Notification_pages/notification_redirect.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController;
  SettingController settingController =Get.put(SettingController());

  HomeController homeController = Get.put(HomeController());
  AuthController authController =Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  // List<String> options = [
  //   'Pneumonia is an infection of the',
  //   'Pneumonia is an infection of the',
  //   'Pneumonia is an infection of the',
  //   'Pneumonia is an infection of the',
  //   // ... Add more options ...
  // ];
  // // Initialize with an invalid value
  int selectedOptionIndex = -1;
  // Initialize with an invalid value

  bannerImages(imagess){
    print("imagess...."+imagess.toString());
    return  ImagePixels.container(
      imageProvider: NetworkImage(imagess),
      child: Container(
        width: MediaQuery.of(context).size.width,

        child: Image(image:NetworkImage(imagess),
        ),
      ),
    );
  }

  bool isAnswer = false;
  int correctans= 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();


    call_profile();
    var homeUrl = apiUrls().home_api;
    Logger_D(homeUrl);
    homeController.HomeApi(homeUrl,true);
    var settingUrl ="${apiUrls().setting_api}";
    settingController.SettingData(settingUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scrollController.animateTo(
      //   scrollController.position.maxScrollExtent,
      //   duration: Duration(seconds: 1),
      //   curve: Curves.ease,
      // );
      scrollController.jumpTo(1.10);

    });
  }
  call_profile() async {

    var profileUrl = "${apiUrls().profile_api}";
    // Logger_D(profileUrl);
    await profileController.GetProfile(profileUrl);
    sprefs.setString("deviceid",profileController.profileData['data']['device_id'].toString());
    checklogindifference();
  }
  checklogindifference() async {
    authController.deviceId =  await authController.getId();
    log("App deviceId: ${authController.deviceId}");
    log("Server deviceId:  ${sprefs.getString("deviceid")}");
    log("Check deviceId:  ${authController.deviceId.toString() == sprefs.getString("deviceid")}");
    if(authController.deviceId.toString() == sprefs.getString("deviceid")){

      log("You logged in");
    }else{

      log("You logged out");
      toastMsg("You already logged in to another device. So we are logging you out.", true);
      sprefs.clear();
      sprefs.setBool(KEYLOGIN, false);
      apiCallingHelper().logoutinPref();
    }
  }
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var cheight = MediaQuery.of(context).size.height;
    var cwidth = MediaQuery.of(context).size.width;
    Size size =MediaQuery.of(context).size;

    return Scaffold(
      // restorationId: "home_page",
      backgroundColor: primary,
      body: GetBuilder<SettingController>(
        builder: (settingController) {
          return GetBuilder<HomeController>(
              id: "home_page",
              builder: (homeContro) {
                if(homeContro.homeLoading.value){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Center(child: CircularProgressIndicator(color: white,)),
                      SizedBox(height: 5,),
                      settingController.settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                      Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                          color: white,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600
                      )),
                    ],
                  );
                }
              return  RefreshIndicator(
                displacement: 65,
                backgroundColor: Colors.white,
                color: primary,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 1500));
                  var homeUrl = apiUrls().home_api;
                  Logger_D(homeUrl);
                  homeController.HomeApi(homeUrl,true);
                },
                child: SingleChildScrollView(

                  child: Column(
                    children: [
                      // Text("${ sprefs.getString("quotes")}"),
                      SizedBox(
                        height: cheight * 0.02,
                      ),
                      Image.asset(home_group,height: 150,),

                      Container(
                        width: cwidth,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0))),
                        child: Column(
                          children: [
                            SizedBox(
                              height:orientation==Orientation.portrait? cheight * 0.01:cheight * 0.05,
                            ),
                          Container(
                              margin: EdgeInsets.only( right: 10,left: 10),
                              child: Card(
                                elevation: 5.5,
                                child: Container(
                                  height: Get.height*0.08,
                                  child: Stack(
                                    children: [
                                      homeContro.home_data['data']['is_active_gold']==true?
                                      Container(
                                        width: Get.width,
                                          height:Get.height,
                                          child: Image.asset('assets/images/gold_home_screen.png',fit: BoxFit.fill,)
                                      ):Container(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  width: size.width*0.5-50,
                                                  // color: Colors.red,

                                                  // padding: EdgeInsets.only(left: 10),
                                                  child: Text('${homeContro.home_data['data']['total_count']} BLOCKS ',
                                                      // child: Text('500 BLOCKS ',
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'PublicSans',
                                                          color:  homeContro.home_data['data']['is_active_gold']==true?Colors.black: primary)),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  width: size.width*0.5-50,
                                                  // color: Colors.red,
                                                  // padding: EdgeInsets.only(left: 10),
                                                  child: Text('COMPLETED ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'PublicSans',
                                                          color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: black54)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container( alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(top: 10,bottom: 10),width: 2,height: 50,color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: primary,),
                                          Expanded(
                                            child: Column(

                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: size.width>500?Alignment.centerRight:Alignment.centerLeft,
                                                  width: size.width*0.6-30,
                                                  // color: Colors.red,
                                                  padding: size.width>500?EdgeInsets.only(right: 10):EdgeInsets.only(left: 10),
                                                  child: RichText(text: TextSpan(
                                                      children: [
                                                        TextSpan(text:"${homeContro.home_data['data']['video_count']} ",style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'PublicSans',
                                                            color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: black54)),
                                                        TextSpan(text:" Videos Completed",style:TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'PublicSans',
                                                            color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: black54)),])),
                                                ),
                                                SizedBox(height: 3,),
                                                Container(
                                                  alignment: size.width>500?Alignment.centerRight:Alignment.centerLeft,
                                                    width: size.width*0.6-30,
                                                    // color: Colors.red,
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: RichText(text: TextSpan(
                                                        children: [
                                                          TextSpan(text:"${homeContro.home_data['data']['module_count']} ",style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: 'PublicSans',
                                                              color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: black54)),
                                                          TextSpan(text:" Q Blocks Completed",style:TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: 'PublicSans',
                                                              color:homeContro.home_data['data']['is_active_gold']==true?Colors.black: black54)),]))

                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:orientation==Orientation.portrait? 5:15,
                            ),
                            homeContro.home_data['data']['banner'].length==0?Container()
                            :Container(
                              margin: EdgeInsets.only(left: 15,right: 15),
                                height: size.width>500?250:160,
                                width: cwidth,
                                child: Carousel(
                                  images: [
                                    for (int i = 0; i <homeContro.home_data['data']['banner'].length; i++)
                                      GestureDetector(
                                        onTap: () async {
                                          if (!await launchUrl(Uri.parse("${homeContro.home_data['data']['banner'][i]['url']}"),mode: LaunchMode.externalApplication)) {
                                            throw Exception('Could not launch ');
                                          }
                                        },
                                          child: Container(
                                            child: bannerImages(homeContro.home_data['data']['banner'][i]['image'].toString(),),
                                          ),
                                        )


                                    // CachedNetworkImage(
                                    //
                                    //   imageUrl:"http://via.placeholder.com/350x150",
                                    //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                                    //
                                    // ),
                                  ],

                                  dotSize: homeContro.home_data['data']['banner'].length==1?0.0:6.0,
                                  dotSpacing: 20.0,
                                  dotColor: primary,
                                  indicatorBgPadding: 2.0,
                                  dotBgColor: Colors.transparent,
                                  borderRadius: false,
                                  moveIndicatorFromBottom: 100.0,
                                  noRadiusForIndicator: true,
                                  overlayShadow: true,
                                  overlayShadowColors:primary,
                                  overlayShadowSize: 0.2,
                                  dotPosition: DotPosition.bottomCenter,
                                )),

                            homeContro.home_data['data']['todayquestion'].length==0?Container():
                            Container(
                              width: cwidth,
                              color: Colors.grey.shade100,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        // Get.to(CustomerDetail());
                                        notification().callredirect("payload");
                                        // notification().demoarrayList();
                                        String originalString = '{day_of_week: 2, breakfast: [23], lunch: [24, 25], dinner: [28], snack: [26]}';
                                        var updatedString = originalString.replaceAll('day_of_week', '"day_of_week"');
                                        var updatedString2 = updatedString.replaceAll('breakfast', '"breakfast"');
                                        var updatedString3 = updatedString2.replaceAll('lunch', '"lunch"');
                                        var updatedString4 = updatedString3.replaceAll('dinner', '"dinner"');
                                        var updatedString5 = updatedString4.replaceAll('snack', '"snack"');
                                        //  var model =NotificationModel.fromJson(originalString);
                                       // var data =model.redirectionInfo.redirectionPage;
                                       //  var data = notificationModelFromJson(originalString);
                                        log("NotificationResponse originalString "+originalString.toString());
                                        log("NotificationResponse updatedString5 "+updatedString5.toString());
                                        // log("NotificationResponse redirectionPage "+data.redirectionInfo.redirectionPage.toString());
                                        // originalString.forEach((e){
                                        //   log(e['redirection_type'].toString());
                                        // });
                                        // var data =originalString[0]["redirection_info"];
                                        // log(data.redirectionType.toString());
                                      },
                                      child: Center(
                                          child: Text(
                                        'MCQ of Day',
                                        style: TextStyle(
                                            color: primary,
                                            fontFamily: 'Poppins-Regular',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      )),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                        '${homeContro.home_data['data']['todayquestion']['question'].toString()=="null"?
                                        "":homeContro.home_data['data']['todayquestion']['question'].toString()}',
                                        style: TextStyle(
                                            fontFamily: 'PublicSans',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.black54)),
                                    homeContro.home_data['data']['todayquestion']['question_attachment']
                                        .toString() ==
                                        "null"
                                        ? Container():SizedBox(height: 10),
                                    homeContro.home_data['data']['todayquestion']['question_attachment'].toString()
                                        ==
                                        "null"
                                        ? Container()
                                        : Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Image.network(
                                          "${homeContro.home_data['data']['todayquestion']['question_attachment'].toString()}"),
                                    ),

                                    SizedBox(height: 15,),

                                    ///TODAY QUESTION LIST-----------------------///

                                    homeContro.home_data['data']['todayquestion']['answer'].length==0?
                                    Container():ListView.builder(

                                      itemCount: homeContro.home_data['data']['todayquestion']['answer'].length,
                                      // Replace 'options.length' with the actual number of options
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        final optionIndex = String.fromCharCode(97 +
                                            index); // Convert index to 'a', 'b', 'c', ...
                                        final optionText = homeContro.home_data['data']['todayquestion']['answer'][
                                        index]; // Replace 'options[index]' with your actual options
                                        return GestureDetector(
                                            onTap: () async {
                                              if( homeContro.home_data['data']['todayquestion']['id'].toString()=="null"){

                                              }else{
                                                var  todayUrl = apiUrls().today_question_api;
                                                var todayQ_Body= {
                                                  'question_id': homeContro.home_data['data']['todayquestion']['id'].toString(),
                                                  'answer_id': optionText['options_id'].toString(),
                                                };
                                                await homeContro.TodayQuestionApi(todayUrl, todayQ_Body);
                                              }

                                              setState((){});
                                              if(index == homeContro.home_data['data']['todayquestion']['currect_answer']){
                                                log('correctAns==>');
                                              }else if(index != homeContro.home_data['data']['todayquestion']['currect_answer']&& homeContro.home_data['data']['todayquestion']['your_answer'] == index){
                                                log('IncorrectAns==>');
                                                Vibration.vibrate(amplitude: 2000,intensities: [1, 255] );
                                                HapticFeedback.selectionClick();
                                                setState(() {
                                                });
                                              }else{
                                                log('else==>');
                                              }
                                            },
                                            child:Container(
                                              margin: EdgeInsets.symmetric(vertical: 2),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: index == homeContro.home_data['data']['todayquestion']['currect_answer'] ? ansBackgroundColor:
                                                (index != homeContro.home_data['data']['todayquestion']['currect_answer'] &&
                                                    homeContro.home_data['data']['todayquestion']['your_answer'] == index ? redBackgroundColor : Colors.white),
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                        BorderRadius.circular(30)),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 12, vertical: 8),
                                                      child: Text(
                                                        optionIndex.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'PublicSans',
                                                            color: white),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      optionText['answer'].toString()=="null"?Container():
                                                      Container(
                                                        width: size.width-110,
                                                        child: Text(
                                                          optionText['answer'].toString(),
                                                          style: TextStyle(fontSize: 15,
                                                              fontFamily: 'PublicSans',
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black54),
                                                        ),
                                                      ),

                                                      optionText['attachment'].toString()=="null"?Container():
                                                      Container(
                                                        margin: EdgeInsets.only(top: 10),
                                                        alignment: Alignment.topLeft,
                                                        width: size.width*0.3,
                                                        height: size.height*0.1,
                                                        child: Image.network(optionText['attachment'].toString(),
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
                                            )
                                        );
                                      },
                                    ),
                                    // Stack(
                                    //   children: [
                                    //
                                    //    homeContro. todayLoading.value==true?
                                    //    Positioned(
                                    //         top:10,
                                    //         bottom: 10,
                                    //         right: 10,
                                    //         left: 10,
                                    //         child: Center(child: CircularProgressIndicator())):
                                    //    Container()
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    homeContro.home_data['data']['todayquestion']['your_answer']==null?Container():GestureDetector(
                                      onTap: (){
                                        homeContro.updatelessmore();
                                      },
                                      child: Container(

                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Text(
                                            homeContro.lessormore.value==true?"Hide":"See Rationale: ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                // fontSize: 16,
                                                fontSize: 18,
                                                decoration: TextDecoration
                                                    .underline,
                                                fontWeight:
                                                FontWeight.bold),
                                          )),
                                    ),
                                    homeContro.home_data['data']['todayquestion']['your_answer']==null?
                                    Container(): homeContro.lessormore.value==true?Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        children: [
                                          homeContro.home_data['data']['todayquestion']['ans_description_attachment']
                                              .toString() ==
                                              "null"
                                              ? Container()
                                              : Image.network(
                                            homeContro.home_data['data']['todayquestion'][
                                            'ans_description_attachment']
                                                .toString(),
                                          ),

                                          homeContro.home_data['data']['todayquestion']['ans_description']
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
                                              data: homeContro.home_data['data']['todayquestion'][
                                              'ans_description'].replaceAll('<p>', '').replaceAll('</p>', '').toString()
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
                                    SizedBox(
                                      height: cheight * 0.03,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BottomBar(
                                                  bottomindex: 1,
                                                )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 5),
                                        margin: EdgeInsets.only(bottom: 4,top: 4,left: 5,right: 5),
                                        alignment: Alignment.center,
                                        // width: size.width,
                                        // alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius: BorderRadius.circular(35),
                                          // border: Border.all(color: Colors.grey)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              home_test,
                                              color: white,
                                              height: 40,

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              // color: Colors.red,
                                              width: size.width*0.6,
                                              child: Text(
                                                'Subject wise question',
                                                style:
                                                TextStyle(color: white,
                                                    fontSize: 20,
                                                    fontFamily: 'PublicSans',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: cheight * 0.02,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BottomBar(
                                                  bottomindex: 2,
                                                )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 5),
                                        margin: EdgeInsets.only(bottom: 4,top: 4,left: 5,right: 5),
                                        alignment: Alignment.center,
                                        // width: size.width,
                                        // alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: drawerprimary,
                                          borderRadius: BorderRadius.circular(35),
                                          // border: Border.all(color: Colors.grey)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              home_test1,
                                              color: white,
                                              height: 40,

                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              // color: Colors.red,
                                              width: size.width*0.6,
                                              child: Text(
                                                'Previous Year question',
                                                style:
                                                TextStyle(color: white,
                                                    fontSize: 20,
                                                    fontFamily: 'PublicSans',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) => BottomBar(
                                    //               bottomindex: 1,
                                    //             )));
                                    //   },
                                    //   child: Stack(
                                    //     clipBehavior: Clip.hardEdge,
                                    //     children: [
                                    //       Container(
                                    //         padding: EdgeInsets.only(left: 75,bottom: 17,top: 20),
                                    //         margin: EdgeInsets.only(bottom: 2,top: 4),
                                    //         alignment: Alignment.center,
                                    //         width: size.width,
                                    //         // alignment: Alignment.center,
                                    //         decoration: BoxDecoration(
                                    //           color: primary,
                                    //           borderRadius: BorderRadius.circular(35),
                                    //           // border: Border.all(color: Colors.grey)
                                    //         ),
                                    //         child: Text(
                                    //           'Subject wise questions                                                               ',
                                    //           style:
                                    //           TextStyle(color: white,
                                    //               fontSize: 20,
                                    //               fontFamily: 'Helvetica',
                                    //               fontWeight: FontWeight.w400),
                                    //         ),
                                    //       ),
                                    //       Positioned(
                                    //         child: CircleAvatar(
                                    //           radius: 32,
                                    //           backgroundColor: Colors.white,
                                    //           child: CircleAvatar(
                                    //             radius: 30,
                                    //             backgroundColor: homeCatBackgroundColor1,
                                    //             child: Image.asset(
                                    //               home_test1,
                                    //               color: white,
                                    //               height: 40,
                                    //
                                    //             ),
                                    //           ),
                                    //         )
                                    //         ,)
                                    //     ],
                                    //   ),
                                    // ),
                                    //
                                    // SizedBox(
                                    //   height: cheight * 0.03,
                                    // ),
                                    // GestureDetector(
                                    //     onTap: () {
                                    //       Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) => BottomBar(
                                    //                     bottomindex: 2,
                                    //                   )));
                                    //     },
                                    //   child: Stack(
                                    //     clipBehavior: Clip.hardEdge,
                                    //     children: [
                                    //       Container(
                                    //         alignment: Alignment.center,
                                    //         child: Column(
                                    //           children: [
                                    //             Container(
                                    //               padding: EdgeInsets.only(left: 75,bottom: 17,top: 20),
                                    //               margin: EdgeInsets.only(bottom: 2,top: 4),
                                    //
                                    //               width: size.width,
                                    //               // alignment: Alignment.center,
                                    //               decoration: BoxDecoration(
                                    //                 color: primary,
                                    //                 borderRadius: BorderRadius.circular(35),
                                    //                 // border: Border.all(color: Colors.grey)
                                    //               ),
                                    //               child: Text(
                                    //                 "Previous Year question",
                                    //                 style:
                                    //                 TextStyle(color: white,
                                    //                     fontSize: 20,
                                    //                     fontFamily: 'Helvetica',
                                    //                     fontWeight: FontWeight.w400),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Positioned(
                                    //         child: CircleAvatar(
                                    //           radius: 32,
                                    //           backgroundColor: Colors.white,
                                    //           child: CircleAvatar(
                                    //             radius: 30,
                                    //             backgroundColor: homeCatBackgroundColor2,
                                    //             child: Image.asset(
                                    //               home_test,
                                    //               color: white,
                                    //               height: 40,
                                    //
                                    //             ),
                                    //           ),
                                    //         )
                                    //         ,)
                                    //     ],
                                    //   ),
                                    // ),

                                  ]),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }


}