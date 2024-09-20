import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';

class CouponsController extends GetxController{
  var couponLoader = false.obs;
  var couponlist_data ;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  CouponListData(url)async{
    couponLoader(true);
    try{
      var result=  await apiCallingHelper().getAPICall(url,true);
      if (result != null) {
        couponlist_data =jsonDecode(result.body);
        if(result.statusCode == 200){
          couponlist_data =jsonDecode(result.body);
          print("coupon data....."+couponlist_data.toString());
          couponLoader(false);
          update();
          refresh();
        }else  if(result.statusCode == 401){
          couponLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 404){
          couponLoader(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 500){
          couponLoader(false);
          update();
          refresh();
        }
      } else {
        couponLoader(false);
        update();
        refresh();
      }

    }
    catch (e){
      Logger().e("catch error ........${e}");
      couponLoader(false);
      update();
    }
  }



}