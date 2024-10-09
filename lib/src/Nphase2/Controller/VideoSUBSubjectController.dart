import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';

import '../../../Local_Database/database.dart';
import '../../../main.dart';

class VideoSubsubjectcontroller extends GetxController{
 var VideoSubsubjectloader = false.obs;
 List VideoSubsubjectdata = [];
 var catparentId=0.obs;
 var catparentstatus=0.obs;
 updateFetchSubSubjectData(index){
   catparentstatus.value =index;
  update();
  FetchSubSubjectData();

 }
 FetchSubSubjectData()async {
  VideoSubsubjectloader(true);
  update();
  refresh();
  bool jsonData = await sprefs.getBool('is_internet');

  if (jsonData) {
   Map<String, String> queryParams = {
    "parent_id": catparentId.value.toString(),
    "status": catparentstatus.value == 0 ? "" : catparentstatus.value == 1
        ? ""
        : catparentstatus.value.toString(),
    "pause_status": catparentstatus.value == 1 ? "1" : "0",
   };
   String queryString = Uri(queryParameters: queryParams).query;
   var child_video_categories_api = apiUrls().child_video_categories_api + '?' +
       queryString;

   log("FetchSubSubjectData url :${child_video_categories_api} ");
   try {
    var result = await apiCallingHelper().getAPICall(
        child_video_categories_api, true);
    // settingData =jsonDecode(result.body);

    if (result != null) {
     if (result.statusCode == 200) {
      var FetchSubjectData = jsonDecode(result.body);
      log("FetchSubSubjectData response :$FetchSubjectData ");
      VideoSubsubjectdata.clear();
      VideoSubsubjectdata.add(FetchSubjectData['data']);
      VideoSubsubjectloader(false);
      update();
      refresh();
     }
     else if (result.statusCode == 404) {
      var FetchSubjectData = jsonDecode(result.body);
      VideoSubsubjectdata.clear();
      VideoSubsubjectdata.add(FetchSubjectData['data']);
      VideoSubsubjectloader(false);
     }
     else {
      VideoSubsubjectdata = [];
      VideoSubsubjectloader(false);
     }
     update();
     refresh();
    }
   }
   catch (e) {
    log("FetchSubSubjectData error ........${e}");
    VideoSubsubjectloader(false);
    update();
   }
  } else {
   var dbHelper = DatabaseHelper();

   // Call fetchChildCategories using the instance
   var data = await dbHelper.fetchChildCategories(catparentId.value.toInt());
   VideoSubsubjectdata.clear();
   await VideoSubsubjectdata.add(data['data']);
   await Future.delayed(Duration(seconds: 1));
   VideoSubsubjectloader(false);
   update();
   refresh();
  }
 }
}