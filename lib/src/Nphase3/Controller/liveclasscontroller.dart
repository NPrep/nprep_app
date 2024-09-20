import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

class Liveclasscontroller extends GetxController{

  ///Detail
  PDFViewController controller;
  final ScrollController scrollcontroller = ScrollController();
  Timer timer;
  TextEditingController sendmessageController = TextEditingController();
  YoutubePlayerController youtubeplayerController;
  YoutubePlayerController detailyoutubeplayerController;
  List liveclasscommentlist=[];
  List completeclasscommentlist=[];
  RxBool liveclasscommentstatus= false.obs;
  RxBool completeclasscommentstatus= false.obs;
  RxBool sendcommentstatus= false.obs;
  var  videoid ="0".obs;
  var  indexPage =0.obs;
  var  pages =0.obs;
  disposeall(){
    timer.cancel();
    youtubeplayerController.dispose();
    scrollcontroller.dispose();
  }
  compdisposeall(){

    detailyoutubeplayerController.dispose();
    scrollcontroller.dispose();
  }
  void scrollcontrollerDown() {
    scrollcontroller.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    update();
  }
  YoutubePlayercalling(url){
    youtubeplayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url).toString(),

        flags: YoutubePlayerFlags(
        isLive: true,
        autoPlay: true,
        useHybridComposition: true,
        showLiveFullscreenButton: true,

    ),
    );

  }
  deatilYoutubePlayercalling(url){
    detailyoutubeplayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url).toString(),

      flags: YoutubePlayerFlags(
        isLive: false,
        autoPlay: true,
        useHybridComposition: true,
        showLiveFullscreenButton: true,

      ),
    );


  }
  CallingTimerfunction(){

    timer = Timer.periodic(const Duration(seconds: 1), ((timer) {
      GetliveApendCommentApi();
    }));
  }
  GetliveApendCommentApi() async {
    var date= liveclasscommentlist.length==0?"2024-07-27 00:00:00":liveclasscommentlist.last['gmt_date'];

    var url = apiUrls().live_classes_api +"/"+videoid.toString()+"/"+"messages/upcoming?last_comment=${date.toString()}";
    log("gmt_date>> "+date.toString());
    var result = await apiCallingHelper().getAPICall(url, true);
    if(result.statusCode ==200){
      var data =jsonDecode(result.body);
      if(data['status']==true){
        liveclasscommentlist.addAll(data['data']);
        log("GetliveApendCommentApi>> "+liveclasscommentlist.toString());
        update();
      }
    }


  }
  GetliveclassCommentApi(url) async {
    liveclasscommentstatus(true);
    var result = await apiCallingHelper().getAPICall(url, true);
    if(result.statusCode ==200){
      var data =jsonDecode(result.body);

      liveclasscommentlist.clear();
      liveclasscommentlist.addAll(data['data']);
      log("liveclasscommentlist>> "+liveclasscommentlist.toString());
      CallingTimerfunction();
      liveclasscommentstatus(false);
      update();
      refresh();
    }else if(result.statusCode == 404){
      liveclasscommentlist.clear();
      liveclasscommentlist = [];
      liveclasscommentstatus(false);
      update();
      refresh();
    }
    else{
      liveclasscommentlist.clear();
      liveclasscommentlist = [];
      liveclasscommentstatus(false);
      update();
      refresh();
    }

  }
  ComleteliveclassComment(url) async {
    completeclasscommentstatus(true);
    var result = await apiCallingHelper().getAPICall(url, true);
    if(result.statusCode ==200){
      var data =jsonDecode(result.body);

      completeclasscommentlist.clear();
      completeclasscommentlist.addAll(data['data']);
      log("completeclasscommentlist>> "+completeclasscommentlist.toString());

      completeclasscommentstatus(false);
      update();
      refresh();
    }else if(result.statusCode == 404){
      completeclasscommentlist.clear();
      completeclasscommentlist = [];
      completeclasscommentstatus(false);
      update();
      refresh();
    }
    else{
      completeclasscommentlist.clear();
      completeclasscommentlist = [];
      completeclasscommentstatus(false);
      update();
      refresh();
    }

  }
  SendCommentApiFun(url,msg) async {
    sendcommentstatus(true);
    var result = await apiCallingHelper().PostAPICallVideo(url, msg,true);

    sendmessageController.clear();
    scrollcontrollerDown();
    sendcommentstatus(false);
    update();
    refresh();

  }


  ///Listing
  List liveclassdata =[];
  RxBool liveclassstatus= false.obs;
  liveclassApiFun(url) async {
    liveclassstatus(true);
    var result = await apiCallingHelper().getAPICall(url, true);
    if(result.statusCode ==200){
      var data =jsonDecode(result.body);

      liveclassdata.clear();
      liveclassdata.add(data['data']);
      log("liveclassdata>> "+liveclassdata.toString());
      liveclassstatus(false);
      update();
      refresh();
    }else if(result.statusCode == 404){
      liveclassdata.clear();
      liveclassdata = [];
      liveclassstatus(false);
      update();
      refresh();
    }
    else{
      liveclassdata.clear();
      liveclassdata = [];
      liveclassstatus(false);
      update();
      refresh();
    }
   
  }
}