import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';

import '../main.dart';

class CmsController extends GetxController{
   var aboutLoader = false.obs;
   var aboutError = false.obs;
   var about_data ;

   @override
   void onReady() {
     super.onReady();
   }

   @override
   void onClose() {
     super.onClose();
   }

   CmsData(url)async{
     aboutLoader(true);
     String jsonData = sprefs.getString('privacy_data');

     if(jsonData == null){
       await getdata(url);
     }else{
       about_data = jsonDecode(jsonData);
       await getdata(url);
       aboutLoader(false);
       update();
       refresh();
     }

   }


   getdata(url)async{
     try{
       var result=  await apiCallingHelper().getAPICall(url,false);
       if (result != null) {
         if(result.statusCode == 200){
           about_data =jsonDecode(result.body);
           await sprefs.setString('privacy_data', result.body);
           aboutLoader(false);
           update();
           refresh();
         }else  if(result.statusCode == 401){
           aboutError.value = true;
           aboutLoader(false);
           update();
           refresh();
         }

       } else {
         aboutLoader(false);
         update();
         refresh();
       }

     }
     catch (e){
       Logger().e("catch error ........${e}");
       aboutLoader(false);
       update();
     }
   }



   CmsData2(url)async{
     aboutLoader(true);
     String jsonData = sprefs.getString('about_data');

     if(jsonData == null){
       await getdata2(url);
     }else{
       about_data = jsonDecode(jsonData);
       await getdata2(url);
       aboutLoader(false);
       update();
       refresh();
     }

   }


   getdata2(url)async{
     try{
       var result=  await apiCallingHelper().getAPICall(url,false);
       if (result != null) {
         if(result.statusCode == 200){
           about_data =jsonDecode(result.body);
           await sprefs.setString('about_data', result.body);
           aboutLoader(false);
           update();
           refresh();
         }else  if(result.statusCode == 401){
           aboutError.value = true;
           aboutLoader(false);
           update();
           refresh();
         }

       } else {
         aboutLoader(false);
         update();
         refresh();
       }

     }
     catch (e){
       Logger().e("catch error ........${e}");
       aboutLoader(false);
       update();
     }
   }



   CmsData3(url)async{
     aboutLoader(true);
     String jsonData = sprefs.getString('about_data');

     if(jsonData == null){
       await getdata3(url);
     }else{
       about_data = jsonDecode(jsonData);
       await getdata3(url);
       aboutLoader(false);
       update();
       refresh();
     }

   }


   getdata3(url)async{
     try{
       var result=  await apiCallingHelper().getAPICall(url,false);
       if (result != null) {
         if(result.statusCode == 200){
           about_data =jsonDecode(result.body);
           await sprefs.setString('about_data', result.body);
           aboutLoader(false);
           update();
           refresh();
         }else  if(result.statusCode == 401){
           aboutError.value = true;
           aboutLoader(false);
           update();
           refresh();
         }

       } else {
         aboutLoader(false);
         update();
         refresh();
       }

     }
     catch (e){
       Logger().e("catch error ........${e}");
       aboutLoader(false);
       update();
     }
   }

}