import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';

class SearchVideomcqcontroller extends GetxController{
 var earchVideomcqloader = false.obs;
 var category_type = 0.obs;
 List earchVideomcqdata = [];

TextEditingController searchvideomcq =TextEditingController() ;
 FetchSearchVideomcqData(search)async{
  earchVideomcqloader(true);
  update();
  Map<String, String> queryParams = {
   "search": search.toString(),
   "category_type": category_type.value.toString(),
  };
  String queryString = Uri(queryParameters: queryParams).query;
  var searchurl_api = apiUrls().search_categories_api + '?' + queryString;
  log("FetchSearchVideomcqData url :${searchurl_api} ");
  try{
   var result = await apiCallingHelper().getAPICall(searchurl_api, true);
   // settingData =jsonDecode(result.body);

   if(result != null){
    if(result.statusCode == 200){
    var FetchSubjectData =jsonDecode(result.body);

    earchVideomcqdata.clear();
    earchVideomcqdata.addAll(FetchSubjectData['data']);
    log("FetchSearchVideomcqData response :$earchVideomcqdata ");
    earchVideomcqloader(false);
     update();
     refresh();
    }
    else if(result.statusCode == 404){
     earchVideomcqdata = [];
     earchVideomcqloader(false);
    }
    else{
     earchVideomcqdata = [];
     earchVideomcqloader(false);
    }
    update();
    refresh();
   }
  }
  catch (e){
   log("FetchSearchVideomcqData error ........${e}");
   earchVideomcqloader(false);
   update();
  }
 }
 searchvideomcqUpdate(){
log(searchvideomcq.text);
earchVideomcqloader(true);
  FetchSearchVideomcqData(searchvideomcq.text);
update();
 }
 clearsearchvideomcqUpdate(){
  searchvideomcq.clear();
  FetchSearchVideomcqData("");
  update();
 }
}