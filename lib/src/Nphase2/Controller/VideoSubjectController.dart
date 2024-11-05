import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/Local_Database/database.dart';
import 'package:n_prep/Models/Videos.dart';
import 'package:n_prep/Models/Categories.dart'; // Import your Category model


import '../../../main.dart';

class Videosubjectcontroller extends GetxController{
 var Videosubjectloader = false.obs;
 List Videosubjectdata = [];

 FetchSubjectData()async{
  Videosubjectloader(true);

  log("FetchSubjectData url :${apiUrls().parent_video_categories_api} ");
  String jsonData = sprefs.getString('video_data');

  if(jsonData==null){
   await getdata();
  }else{
   var FetchSubjectData =jsonDecode(jsonData);

   Videosubjectdata.add(FetchSubjectData['data']);
   Videosubjectloader(false);
   await getdata();
   update();
   refresh();
  }
 }


 FetchAllVideos() async {
  // Show loading state
  Videosubjectloader(true);

  // Fetch data from the API
  try{
   var result = await apiCallingHelper().getAPICall(apiUrls().all_videos, true);

   if (result != null) {
    if (result.statusCode == 200) {
     var fetchedData = jsonDecode(result.body);

     // Clear existing videos in the database
     await DatabaseHelper().clearVideos();

     // Loop through the fetched videos and save them in the database
     for (var videoData in fetchedData['data']) {
      Video video = Video(
       videoMainCategory: videoData['video_main_category'],
       videoCategoryId: videoData['video_category_id'],
       title: videoData['title'],
       thumbImage: videoData['thumb_image'] ?? '',
       videoTime: videoData['video_time'],
       videoTextNotes: videoData['video_text_notes'] ?? '',
       feeType: videoData['fee_type'],
       sortId: videoData['sort_id'],
       isPublished: videoData['is_published'],
       status: videoData['status'],
      );

      // Insert the video into the database
      await DatabaseHelper().insertVideo(video);
     }

     // Hide loading state
     Videosubjectloader(false);
    }
   }
  }catch(e){
   print(e);
  }
 }


 FetchAllVideoCategories() async {
  // Show loading state (you can use a loader or any state management technique)
  Videosubjectloader(true);

  // Fetch data from the API
  try{
   var result = await apiCallingHelper().getAPICall(apiUrls().all_video_categories, true);

   // Check if the result is valid
   if (result != null) {
    if (result.statusCode == 200) {
     var fetchedData = jsonDecode(result.body);

     // Clear existing categories in the database before inserting new ones
     await DatabaseHelper().clearCategories();
     await DatabaseHelper().clearCategories();


     // Loop through the fetched categories and save them into the local database
     for (var categoryData in fetchedData['data']) {
      Category category = Category(
       id: categoryData['id'],
       slug: categoryData['slug'],
       parentId: categoryData['parent_id'],
       name: categoryData['name'],
       description: categoryData['description'],
       lecturerName: categoryData['lecturer_name'] ?? '',
       lecturerAbout: categoryData['lecturer_about'] ?? '',
       feeType: categoryData['fee_type'],
       metaTitle: categoryData['meta_title'],
       metaKeyword: categoryData['meta_keyword'],
       metaDescription: categoryData['meta_description'],
       isFeature: categoryData['is_feature'],
       image: categoryData['image'] ?? '',
       sortOrder: categoryData['sort_order'],
       status: categoryData['status'],
       deletedAt: categoryData['deleted_at'] ?? null,
       createdAt: categoryData['created_at'] ?? null,
       updatedAt: categoryData['updated_at'] ?? null,
      );

      print(category);

      // Insert the category into the database
      await DatabaseHelper().insertCategory(category);
     }

     // Hide loading state
     Videosubjectloader(false);
    }
   }
  }catch(e){
   print(e);
  }
 }


 getdata()async{
  try{
   var result = await apiCallingHelper().getAPICall(apiUrls().parent_video_categories_api, true);
   // settingData =jsonDecode(result.body);

   if(result != null){
    if(result.statusCode == 200){
     var FetchSubjectData =jsonDecode(result.body);
     // log("FetchSubjectData response :$FetchSubjectData ");
     Videosubjectdata.clear();
     Videosubjectdata.add(FetchSubjectData['data']);
     await sprefs.setString('video_data', result.body);
     Videosubjectloader(false);
     update();
     refresh();
    }
    else if(result.statusCode == 404){
     Videosubjectdata = [];
     Videosubjectloader(false);
    }
    else{
     Videosubjectdata = [];
     Videosubjectloader(false);
    }
    update();
    refresh();
   }
  }
  catch (e){
   log("FetchSubjectData error ........${e}");
   Videosubjectloader(false);
   update();
  }
 }
}