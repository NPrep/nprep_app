import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Nphase2/Constant/nprep_2_custom_timeline.dart';


import 'package:n_prep/src/Nphase2/Controller/VideoSubjectController.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/HiveSaved_video_detail_screen.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


import '../../home/bottom_bar.dart';
import '../Constant/nprep_2_custom_timelineDownloading.dart';
import '../Constant/nprep_2_custom_timelineVideoSave.dart';




class SaveVideos extends StatefulWidget {
  var title;
  SaveVideos({this.title});


  @override
  State<SaveVideos> createState() => _SaveVideosState();
}


class _SaveVideosState extends State<SaveVideos> {
  final DatabaseService _databaseService = DatabaseService.instance;


  Videosubjectcontroller videosubjectcontroller =Get.put(Videosubjectcontroller());
  List<TaskRecord> records = [];
  List<int> selectedItems = []; // Store selected item ids
  List TotalDownload =[];
  bool loadingdata =true;
  var progressbar=0.0;
  bool isSelectionMode = false;
  StreamController<TaskProgressUpdate> updateStream = StreamController();
  Timer timer ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    videosubjectcontroller.FetchSubjectData();


    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      getHiveData();
    });
  }

  void toggleSelection(int itemId) {
    setState(() {
      if (selectedItems.contains(itemId)) {
        selectedItems.remove(itemId);
      } else {
        selectedItems.add(itemId);
      }

      // If no items are selected, exit selection mode
      if (selectedItems.isEmpty) {
        isSelectionMode = false;
      }
    });
  }


  void deleteSelectedItems() async{
    for(int i=0;i<selectedItems.length;i++){
      var data = videodatatasks[i];
      log("onPressed ${data}");
      File file =File(data.videopath);
      log("onPressed 1");
      File file2 =File(data.videonotes);
      log("onPressed 2");
      if (await file.exists()) {
        await file.delete();
        await file2.delete();
      }
      log("onPressed 3");
      var videos_saved ="${apiUrls().videos_unsaved_api}${data.videokey}";
      // await apiCallingHelper().getAPICall(videos_saved, true);
      log("onPressed 4");
      var result = await apiCallingHelper().getAPICall(videos_saved, true);
      log("onPressed 5");
      var datas =jsonDecode(result.body);
      log("onPressed 6");
      toastMsg(datas['message'], true);
      final DatabaseService _databaseService = DatabaseService.instance;


      _databaseService.deleteTask(data.id);
      log("onPressed 7");
      log("onPressed 8");
      FileDownloader().database.deleteRecordWithId(data.videokey.toString());
      FileDownloader().cancelTasksWithIds([data.videokey.toString()]);
      log("onPressed 9");
    }
    setState(() {
      selectedItems.clear();
      isSelectionMode = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  Map<String, double> progressMap = {};


  getHiveData() async {

    var temp = await sprefs.get("progress");

    if(temp != null){
      setState(() {
        progressbar= temp;
      });
    }
    await _databaseService.getTasks();




    await FileDownloader().trackTasks();
    records = await FileDownloader().database.allRecords();
    TotalDownload.clear();
    loadingdata=false;
    setState(() {
    });


    records.forEach((element) {
      // log('getHiveelement.status>> ${returnDownloadStatus(element.status)}');
      log('getHiveelement.element>> ${element.toString()}');
      log('getHiveelement.progress>> ${element.progress.toString()}');
      if(returnDownloadStatus(element.status)=="Downloading"){
        TotalDownload.add("Downloading");
      }else if(returnDownloadStatus(element.status)=="canceled"){
        TotalDownload.add("canceled");
      }
      else{
        TotalDownload.add("Downloaded");
      }
    });


  }


  returnDownloadStatus(status) {
    var returnState;
    if (status == TaskStatus.complete) {
      returnState = "Downloaded";
    } else if (status == TaskStatus.running) {
      returnState = "Downloading";
    } else if (status == TaskStatus.enqueued) {
      returnState = "enqueued";
    } else if (status == TaskStatus.paused) {
      returnState = "Downloading";
    } else if (status == TaskStatus.canceled) {
      returnState = "canceled";
    } else if (status == TaskStatus.waitingToRetry) {
      returnState = "waitingToRetry";
    } else if (status == TaskStatus.notFound) {
      returnState = "notFound";
    } else if (status == TaskStatus.failed) {
      returnState = "failed";
    } else {
      returnState = "Not Found";
    }
    return returnState;
  }
  ButtonreturnDownloadStatus(status) {
    var returnState;
    if (status == TaskStatus.complete) {
      returnState = "Downloaded";
    } else if (status == TaskStatus.running) {
      returnState = "Downloading";
    } else if (status == TaskStatus.enqueued) {
      returnState = "enqueued";
    } else if (status == TaskStatus.paused) {
      returnState = "paused";
    } else if (status == TaskStatus.canceled) {
      returnState = "canceled";
    } else if (status == TaskStatus.waitingToRetry) {
      returnState = "waitingToRetry";
    } else if (status == TaskStatus.notFound) {
      returnState = "notFound";
    } else if (status == TaskStatus.failed) {
      returnState = "failed";
    } else {
      returnState = "Not Found";
    }
    return returnState;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                bottomindex: 3,
              )),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (isSelectionMode)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: deleteSelectedItems,
              ),
          ],
          iconTheme: IconThemeData(
            color: Colors.white, // Change the icon color here
          ),
          centerTitle: true,
          title: Text(
            "Saved Videos",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GetBuilder<Videosubjectcontroller>(
            builder: (videosubjectcontroller) {
              if (videosubjectcontroller.Videosubjectloader.value) {
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
                    Get.find<SettingController>()
                        .settingData['data']['general_settings']['quotes']
                        .length ==
                        0
                        ? Text("Refreshing...")
                        : Text(
                        '"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600)),
                  ],
                );
              }
              else {
                return loadingdata==true?Center(child: CircularProgressIndicator()):
                Container(
                  height: size.height,
                  child: records.length==0?


                  Center(
                      child: Text(
                        "You haven't downloaded any videos yet! ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,


                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8),
                      )):
                  SingleChildScrollView(
                    child: Column(
                      children: [


                        TotalDownload.contains("Downloading")?
                        TotalDownload.contains("canceled")?Container():Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25,top: 20,bottom: 20),
                              child: Text(
                                "Downloading",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8),
                              ),
                            ),
                          ],
                        ):Container(),
                        ListView.builder(
                            itemCount: records.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var databasevideo = records[index];
                              // log("databasevideo>> " + databasevideo.toString());
                              return
                                databasevideo.status.toString()=="TaskStatus.complete" ?
                                Container():databasevideo.status.toString()=="TaskStatus.canceled"?Container():
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: Nprep2CustomTimelineDownloading(
                                          step: index + 1,
                                          image: databasevideo.task.metaData.split("/-/")[0],
                                          data:databasevideo.task,
                                          downloding: databasevideo.progress<=0.0?progressbar:databasevideo.progress,
                                          status: ButtonreturnDownloadStatus(databasevideo.status),
                                          topic: databasevideo.task.metaData.split("/-/")[1],
                                          videoid:  databasevideo.task.taskId,
                                        ),
                                      ),
                                    ),
                                  ],
                                );




                            }),
                        // videoItems.length
                        videodatatasks.length  == 0?Container():Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25,top: 20,bottom: 20),
                              child: Text(
                                "Downloaded",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8),
                              ),
                            ),
                          ],
                        ),
                        // videoItems.length
                        videodatatasks.length  == 0?TotalDownload.contains("Downloading")?Container():TotalDownload.contains("canceled")?Container():Container(
                          height: 600,
                          child: Center(
                              child: Text(
                                "You haven't downloaded any videos yet! ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,


                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8),
                              )),
                        )
                            :Column(
                          children: [
                            TotalDownload.contains("Downloading")?
                            Container():Padding(
                              padding: const EdgeInsets.fromLTRB(35, 15, 5, 5),
                              child: Text(
                                'You have downloaded ${videodatatasks.length} out of ${videosubjectcontroller.Videosubjectdata[0]['data']['saved_video_limit']} Videos',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                            ),
                            SingleChildScrollView(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: videodatatasks.length,


                                  // videoItems.length
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // var data = videoItems[index];
                                    var data = videodatatasks[index];
                                    var videoId = data.videokey;

                                    return GestureDetector(
                                      onLongPress: () {
                                        print("hello ${selectedItems}");
                                        setState(() {
                                          isSelectionMode = true;
                                          toggleSelection(index);
                                        });
                                      },
                                      onTap: () {
                                        if(isSelectionMode){
                                          print("hello ${selectedItems}");
                                          print("${[0].contains(index)}");
                                          toggleSelection(index);
                                        }else{
                                          Get.to(HiveSavedVideoDetailScreen(
                                            index: index,
                                            title: data.videotitle,
                                          ));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          if (isSelectionMode)
                                            Checkbox(
                                              value: selectedItems.contains(index),
                                              onChanged: (value) {
                                                toggleSelection(index);
                                              },
                                            ),
                                          Container(
                                            margin: EdgeInsets.only(right: 0),
                                            child: Nprep2CustomTimelineVideoSave(
                                              step: index + 1,
                                              image: data.videothumbimage,
                                              isLast: true,
                                              showimage: true,
                                              isFirst: true,
                                              width: isSelectionMode
                                                  ? MediaQuery.of(context).size.width-50
                                                  : MediaQuery.of(context).size.width,
                                              mcq: data.videoduration,
                                              topic: data.videotitle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}







