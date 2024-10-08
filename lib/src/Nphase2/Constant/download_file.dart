import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import '../../../Service/Service.dart';
import '../../../constants/validations.dart';
import '../Controller/VideoDetailController.dart';
import '../VideoScreens/DatabaseSqflite.dart';

import 'package:n_prep/constants/Api_Urls.dart';


class downloadfile{
  DownloadTask tasks;
  double progress = 0.0;
  File file;

  void downloadHiveButtonPressed(url, videoid,name,video_time,video_stamps,remotePDFpath,Thumbimg_remotePDFpath,image) async {

    final filename = url.substring(url.lastIndexOf("/") + 1);
    var dir;
    if(Platform.isAndroid){
      dir = await getApplicationDocumentsDirectory();
    }else{
      dir = await getLibraryDirectory();
    }

    file = File('${dir.path}/$filename');
    final DatabaseService _databaseService = DatabaseService.instance;
    _databaseService.addbeforeTask(name.toString(),videoid, jsonEncode(video_stamps).toString(), remotePDFpath.toString(), file.path.toString(), Thumbimg_remotePDFpath.toString(),video_time.toString());

    try{

       tasks = DownloadTask(
          url: url,
          filename: "$filename",
          updates: Updates.statusAndProgress,
          requiresWiFi: false,
          retries: 10,
          taskId: videoid.toString(),
          allowPause: true,
          baseDirectory: BaseDirectory.applicationDocuments,
          metaData: '${image}/-/${name}');

      print("downloadButtonPressed task : $tasks");
      FileDownloader().configureNotification(
          running: TaskNotification('Downloading', ' ${name}',),
          complete:  TaskNotification('Your download has been completed', ' ${name}'),
          paused: TaskNotification('Your download has been paused', ' ${name}'),
          progressBar: true
      );


      await FileDownloader().download(
        tasks,
        onProgress: (value) {
          if (!value.isNegative) {



          }

        },
        onStatus: (status) async {
          print("Download Status>> "+status.toString());
          print("Download taskId>> "+tasks.taskId.toString());

          if(status==TaskStatus.complete){
            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.complete;
            Get.find<VideoDetailcontroller>().update();
            if (await file.exists()) {
              print('downloaded to download <video.>: ${file.path}');
            } else {
              print('Failed to download <video.>');
            }

            var body={
              'id': videoid.toString(),
              'video_path': file.path.toString(),
              'video_title': name.toString(),
              'video_duration':video_time.toString(),
              'video_Stamps': video_stamps.toString(),
              'video_Notes': remotePDFpath.toString(),
              'video_thumb_image': Thumbimg_remotePDFpath.toString(),
            };

            log("Video Saved body"+body.toString());


            _databaseService.addTask(name.toString(),videoid, jsonEncode(video_stamps).toString(), remotePDFpath.toString(), file.path.toString(), Thumbimg_remotePDFpath.toString(),video_time.toString());

            log("Video Saved Api");
            var videos_saved = "${apiUrls().videos_saved_api}$videoid";
            var result = await apiCallingHelper().getAPICall(videos_saved, true);

            var data = jsonDecode(result.body);
            toastMsg(data['message'], true);


          }
          else if (status==TaskStatus.paused){
            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.resume;
            Get.find<VideoDetailcontroller>().update();
          }
          else if (status==TaskStatus.running){

            FileDownloader().configureNotification(

                running: TaskNotification('Downloading', ' ${name}'),
                complete:  TaskNotification('Your download has been completed', ' ${name}'),
                paused: TaskNotification('Your download has been paused', ' ${name}'),
                progressBar: true
            );
            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.running;
            Get.find<VideoDetailcontroller>().update();
          }
          else if (status==TaskStatus.enqueued){

            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.enqueued;
            Get.find<VideoDetailcontroller>().update();
          }
          else if (status==TaskStatus.notFound){

            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.none;
            Get.find<VideoDetailcontroller>().update();
          }
          else if (status==TaskStatus.canceled){

            Get.find<VideoDetailcontroller>().buttonState.value=ButtonState.cancel;
            Get.find<VideoDetailcontroller>().update();
          }
        },
        onElapsedTime: (onelp)async{
          print(">> Download onelp <<"+onelp.toString());
        },
      );
      ///--------------------///


    }
    catch (e) {
      print("Download Exception << "+e.toString());
    }


  }
}