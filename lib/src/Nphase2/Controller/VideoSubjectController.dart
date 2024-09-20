import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';

class Videosubjectcontroller extends GetxController{
 var Videosubjectloader = false.obs;
 List Videosubjectdata = [];

 FetchSubjectData()async{
  Videosubjectloader(true);

  log("FetchSubjectData url :${apiUrls().parent_video_categories_api} ");
  try{
   var result = await apiCallingHelper().getAPICall(apiUrls().parent_video_categories_api, true);
   // settingData =jsonDecode(result.body);

   if(result != null){
    if(result.statusCode == 200){
     var FetchSubjectData =jsonDecode(result.body);
      // log("FetchSubjectData response :$FetchSubjectData ");
     Videosubjectdata.clear();
     Videosubjectdata.add(FetchSubjectData['data']);
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