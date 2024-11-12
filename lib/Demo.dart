// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:n_prep/Controller/Setting_controller.dart';
// import 'package:n_prep/Service/Service.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
// import 'package:n_prep/constants/validations.dart';
// import 'package:n_prep/src/Nphase2/Constant/nprep_2_custom_timeline.dart';
// import 'package:n_prep/src/Nphase2/Controller/VideoSubjectController.dart';
// import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseSqflite.dart';
// import 'package:n_prep/src/Nphase2/VideoScreens/HiveSaved_video_detail_screen.dart';
// import 'package:n_prep/utils/colors.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import '../../home/bottom_bar.dart';
// import '../Constant/nprep_2_custom_timelineDownloading.dart';
// import '../Constant/nprep_2_custom_timelineVideoSave.dart';
// import 'package:background_downloader/background_downloader.dart';
//
// class SaveVideos extends StatefulWidget {
//   var title;
//   SaveVideos({this.title});
//
//   @override
//   State<SaveVideos> createState() => _SaveVideosState();
// }
//
// class _SaveVideosState extends State<SaveVideos> {
//   final DatabaseService _databaseService = DatabaseService.instance;
//   Videosubjectcontroller videosubjectcontroller = Get.put(Videosubjectcontroller());
//   List<TaskRecord> records = [];
//   List<String> selectedItems = []; // Store selected item ids
//   bool isSelectionMode = false;
//   bool loadingData = true;
//   StreamController<TaskProgressUpdate> updateStream = StreamController();
//   Timer timer;
//
//   @override
//   void initState() {
//     super.initState();
//     videosubjectcontroller.FetchSubjectData();
//     timer = Timer.periodic(Duration(seconds: 2), (timer) {
//       getHiveData();
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     timer.cancel();
//   }
//
//   getHiveData() async {
//     await _databaseService.getTasks();
//     await FileDownloader().trackTasks();
//     records = await FileDownloader().database.allRecords();
//     setState(() {
//       loadingData = false;
//     });
//   }
//
//   // Toggles the selection state for a specific item
//   void toggleSelection(String itemId) {
//     setState(() {
//       if (selectedItems.contains(itemId)) {
//         selectedItems.remove(itemId);
//       } else {
//         selectedItems.add(itemId);
//       }
//
//       // If no items are selected, exit selection mode
//       if (selectedItems.isEmpty) {
//         isSelectionMode = false;
//       }
//     });
//   }
//
//   // Deletes selected items
//   void deleteSelectedItems() {
//     setState(() {
//       records.removeWhere((item) => selectedItems.contains(item.task.taskId));
//       selectedItems.clear();
//       isSelectionMode = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BottomBar(
//               bottomindex: 3,
//             ),
//           ),
//         );
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white,
//           ),
//           centerTitle: true,
//           title: Text(
//             "Saved Videos",
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             if (isSelectionMode)
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: deleteSelectedItems,
//               ),
//           ],
//         ),
//         body: GetBuilder<Videosubjectcontroller>(
//           builder: (videosubjectcontroller) {
//             if (videosubjectcontroller.Videosubjectloader.value) {
//               return Center(child: CircularProgressIndicator(color: primary));
//             } else {
//               return loadingData
//                   ? Center(child: CircularProgressIndicator())
//                   : Container(
//                 height: size.height,
//                 child: records.isEmpty
//                     ? Center(
//                   child: Text(
//                     "You haven't downloaded any videos yet!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: records.length,
//                   itemBuilder: (context, index) {
//                     var databasevideo = records[index];
//                     var videoId = databasevideo.task.taskId;
//
//                     return GestureDetector(
//                       onLongPress: () {
//                         setState(() {
//                           isSelectionMode = true;
//                           toggleSelection(videoId);
//                         });
//                       },
//                       onTap: () {
//                         if (isSelectionMode) {
//                           toggleSelection(videoId);
//                         } else {
//                           // Regular tap action
//                           Get.to(HiveSavedVideoDetailScreen(
//                             index: index,
//                             title: databasevideo.task.metaData.split("/-/")[1],
//                           ));
//                         }
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 0),
//                             child: Nprep2CustomTimelineDownloading(
//                               step: index + 1,
//                               image: databasevideo.task.metaData.split("/-/")[0],
//                               data: databasevideo.task,
//                               downloding: databasevideo.progress <= 0.0 ? 0.1 : databasevideo.progress,
//                               status: ButtonreturnDownloadStatus(databasevideo.status),
//                               topic: databasevideo.task.metaData.split("/-/")[1],
//                               videoid: videoId,
//                             ),
//                           ),
//                           if (isSelectionMode)
//                             Positioned(
//                               top: 10,
//                               left: 10,
//                               child: Checkbox(
//                                 value: selectedItems.contains(videoId),
//                                 onChanged: (value) {
//                                   toggleSelection(videoId);
//                                 },
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   String ButtonreturnDownloadStatus(TaskStatus status) {
//     switch (status) {
//       case TaskStatus.complete:
//         return "Downloaded";
//       case TaskStatus.running:
//         return "Downloading";
//       case TaskStatus.enqueued:
//         return "Enqueued";
//       case TaskStatus.paused:
//         return "Paused";
//       case TaskStatus.canceled:
//         return "Canceled";
//       case TaskStatus.failed:
//         return "Failed";
//       default:
//         return "Not Found";
//     }
//   }
// }
