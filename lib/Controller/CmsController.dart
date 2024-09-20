import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';

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
     try{
       var result=  await apiCallingHelper().getAPICall(url,false);
       if (result != null) {
         if(result.statusCode == 200){
           about_data =jsonDecode(result.body);
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