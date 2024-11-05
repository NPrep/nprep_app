import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/Nphase3/Controller/liveclasscontroller.dart';
import 'package:n_prep/src/Nphase3/youtubelive/CompletedVideoDetail.dart';
import 'package:n_prep/src/Nphase3/youtubelive/LiveClassCardUI.dart';
import 'package:n_prep/src/Nphase3/youtubelive/LiveVideoDetail.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';

import '../../Nphase2/Constant/textstyles_constants.dart';
class Liveclasses extends StatefulWidget {
   Liveclasses();

  @override
  State<Liveclasses> createState() => _LiveclassesState();
}

class _LiveclassesState extends State<Liveclasses>  with SingleTickerProviderStateMixin {
  TabController _controller;
  Liveclasscontroller liveclasscontroller  =Get.put(Liveclasscontroller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      print('my index is' + _controller.index.toString());

    });
    Getliveclassdata();
  }
  Getliveclassdata() async {

   var live_classes_Url = apiUrls().live_classes_api ;
    log("live_classes_Url==>" + live_classes_Url.toString());

    await liveclasscontroller.liveclassApiFun(live_classes_Url);


  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.10);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
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

            centerTitle: true,
            title: Text("Live Classes ",style: AppbarTitleTextyle,),
            backgroundColor: primary,
            bottom: TabBar(
              labelColor: white,
              controller: _controller,
              //labelPadding: EdgeInsets.only(right: 20),
              physics: const NeverScrollableScrollPhysics(),
              // onTap: tabbarotap(),
              isScrollable: false,
              labelStyle: AppbarTabLableTextyle,
              dragStartBehavior: DragStartBehavior.start,
              indicatorColor: white,
              tabs: [

                Tab(text: 'Live',),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              LiveWidget(),
              UpcommingWidget(),
              CompletedWidget(),



            ],
          ),
        ),
      ),
    );
  }

  LiveWidget() {
    return GetBuilder<Liveclasscontroller>(
      builder: (liveclasscontroller) {
        if(liveclasscontroller.liveclassstatus.value){
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
        }else{
          return liveclasscontroller.liveclassdata[0]['live_classes'].length==0?Center(child: Text("No live classes")):
          ListView.builder(
              itemCount: liveclasscontroller.liveclassdata[0]['live_classes'].length,
              itemBuilder: (context,index){
                var livedata=liveclasscontroller.liveclassdata[0]['live_classes'][index];
                return GestureDetector(
                  onTap: () async {
                    Get.to(Livevideodetail(videoid: livedata['id'],videourl: livedata['video_url'],));
                  },
                  child: Container(
                    // margin: EdgeInsets.only(right: 0),
                    child: LiveClassCardUITimeLine(
                      step: (index+1),
                      title: livedata['name'],
                      duration: livedata['start_time'],remainingtime: "2",image: (Environment.imgapibaseurl+livedata['thumbnail']),

                    ),
                  ),
                );
              });
        }

      }
    );
  }
  UpcommingWidget() {
    return GetBuilder<Liveclasscontroller>(
        builder: (liveclasscontroller) {
          if(liveclasscontroller.liveclassstatus.value){
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
          }else{
            return liveclasscontroller.liveclassdata[0]['upcoming_classes'].length==0?Center(child: Text("No upcoming classes")):
            ListView.builder(
                itemCount: liveclasscontroller.liveclassdata[0]['upcoming_classes'].length,
                itemBuilder: (context,index){
                  var livedata=liveclasscontroller.liveclassdata[0]['upcoming_classes'][index];
                  return GestureDetector(
                    onTap: () async {
                      // Get.to(Livevideodetail(videoid: livedata['id'],videourl: livedata['video_url'],));
                    },
                    child: Container(
                      // margin: EdgeInsets.only(right: 0),
                      child: LiveClassCardUITimeLine(
                        step: (index+1),
                        title: livedata['name'],
                        duration: livedata['start_time'],
                        remainingtime: "2",
                        image: (Environment.imgapibaseurl+livedata['thumbnail']),

                      ),
                    ),
                  );
                });
          }

        }
    );
  }
  CompletedWidget() {
    return GetBuilder<Liveclasscontroller>(
        builder: (liveclasscontroller) {
          if(liveclasscontroller.liveclassstatus.value){
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
            return liveclasscontroller.liveclassdata[0]['completed_classes'].length==0?Center(child: Text("No completed classes")):
              ListView.builder(
                itemCount: liveclasscontroller.liveclassdata[0]['completed_classes'].length,
                itemBuilder: (context,index){
                  var livedata=liveclasscontroller.liveclassdata[0]['completed_classes'][index];
                  return GestureDetector(
                    onTap: () async {
                      // log("livedata['pdf_url']>>"+Environment.imgapibaseurl.toString());
                      // log("livedata['pdf_url']>>"+livedata['pdf_url'].toString());
                      log("livedata['pdf_url']>>"+livedata['video_url'].toString());
                     await Get.to(CompletedVideoDetail(videoid: livedata['id'],pdfurl: livedata['pdf_url']==null?null:(Environment.imgapibaseurl+livedata['pdf_url']),videourl: livedata['video_url'],pdfshow: livedata['pdf_url'].toString()=="null"?false:true,));
                      setState(() {

                      });
                     },
                    child: Container(
                      // margin: EdgeInsets.only(right: 0),
                      child: LiveClassCardUITimeLine(
                        step: (index+1),
                        title: livedata['name'],
                        duration: livedata['start_time'],
                        remainingtime: "2",
                        image: (Environment.imgapibaseurl+livedata['thumbnail']),

                      ),
                    ),
                  );
                });
          }

        }
    );
  }
}


