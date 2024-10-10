import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/login_page/forgot_password/reset_password.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import 'package:n_prep/src/profile/profile.dart';
import 'package:n_prep/src/registration_page/registration_otp.dart';
import 'package:path_provider/path_provider.dart';

import '../../src/login_page/VarifySigninMobOtp.dart';
import '../../src/login_page/verify_mobile_OTP.dart';
import '../../src/registration_page/registartion_page.dart';

class AuthController extends GetxController{

  var loginLoading = false.obs;
  var googleloginLoading = false.obs;


  var login_data;



  var registerLoading = false.obs;
  var mobprofileLoading = false.obs;
  var register_data;

  var changePassLoading = false.obs;
  var changePass_data;

  var forgotLoading = false.obs;
  var forgotPass_data;

  var resetLoading = false.obs;
  var resetPass_data;


  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  var deviceId;
  var fcm_token;

  Future<String> getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      sprefs.setString("deviceId",iosInfo.identifierForVendor.toString());
      return iosInfo.identifierForVendor; // unique ID on iOS
    } else {

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print("androidDeviceInfo.androidId : "+androidDeviceInfo.id.toString());
      sprefs.setString("deviceId",androidInfo.id.toString());
      return androidInfo.id; // unique ID on Android
    }
  }

  var NotregisteredmobileNo;

  updatelogin(){
  googleloginLoading(true);
  update();
}
  Stopupdatelogin(){
    googleloginLoading(false);
    log('googleloginLoading1==>'+googleloginLoading.value.toString());
    update();
  }
  Login(url,parameter,bool type)async{
    loginLoading(true);
    logoutallsection();
    // deviceId = await _getId();
    print("deviceId--->>> " + deviceId.toString());
    // [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: FileSystemException: Cannot delete file, path = '/data/user/0/com.n_prep.medieducation/cache' (OS Error: Is a directory, errno = 21)
    // messaging = FirebaseMessaging.instance;
    // await messaging.getToken().then((value) {
    //   fcm_token = value;
    //   print("FCM Token " + fcm_token);
    // });
    update();
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      log('body==>'+parameter.toString());

      // toastMsg("${result.statusCode}", false);
      if (result != null) {
        if(result.statusCode == 200){

         login_data =jsonDecode(result.body);
          // var msg= login_data['message'];

         var msg = jsonDecode(result.body).toString();
        // toastMsg(msg.toString(),false);
         print("messagetrue..."+msg.toString());
          apiCallingHelper().savedatainPref(login_data,type);
          loginLoading(false);
         googleloginLoading(false);
         print("Name..."+login_data['data']['user']['name'].toString());
         print("image..."+login_data['data']['user']['image'].toString());
         // sprefs.setString("deviceid",login_data['data']['user']['device_id']);
         sprefs.setString("user_name",login_data['data']['user']['name']);
         sprefs.setString("user_image",login_data['data']['user']['image']);
          // sprefs.setBool(KEYLOGIN,true);
          // Get.to(BottomBar());

          // sprefs.setBool(KEYLOGIN,true);

          // Logger().d("login succesfull");

          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          login_data =jsonDecode(result.body);
          var msg = "You haven't registered yet. Please register";
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          NotregisteredmobileNo=parameter['mobile'];
          log('NotregisteredmobileNo==>$NotregisteredmobileNo');
          Get.to(RegistrationPage(NotRegisteredNumber: NotregisteredmobileNo,));
          loginLoading(false);
          googleloginLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 403){
          login_data =jsonDecode(result.body);

          await FirebaseAuth.instance.signOut();
          await _googleSignIn.signOut();

          var msg = login_data['message'];
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          log('NotregisteredmobileNo==>'+NotregisteredmobileNo.toString());
          loginLoading(false);
          googleloginLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 422){
          login_data =jsonDecode(result.body);
          var msg = login_data['message'];
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          loginLoading(false);
          googleloginLoading(false);
          update();
          refresh();
        }

      } else {
        loginLoading(false);
        googleloginLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      loginLoading(false);
      googleloginLoading(false);
      update();
    }
  }
  MobileSendOTP(url,parameter,bool type)async{
    loginLoading(true);
    logoutallsection();
    // deviceId = await _getId();
    print("deviceId--->>> " + deviceId.toString());
    // [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: FileSystemException: Cannot delete file, path = '/data/user/0/com.n_prep.medieducation/cache' (OS Error: Is a directory, errno = 21)
    // messaging = FirebaseMessaging.instance;
    // await messaging.getToken().then((value) {
    //   fcm_token = value;
    //   print("FCM Token " + fcm_token);
    // });
    update();
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      log('Response==> '+result.body.toString());

      if (result != null) {
        if(result.statusCode == 200){
          // response : {"status":true,"message":"Enter OTP recived on your mobile.!!","data":"119614"}


          Get.to(VerifyMobileOTP(mobileNo:  parameter['mobile'],));

          loginLoading(false);

          update();
          refresh();
        }
        else  if(result.statusCode == 404){

          var login_data =jsonDecode(result.body);
          var msg = login_data['message'];
          NotregisteredmobileNo=parameter['mobile'];
          log('NotregisteredmobileNo==>$NotregisteredmobileNo');
          Get.to(RegistrationPage(NotRegisteredNumber: NotregisteredmobileNo,));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>  RegistrationPage(),
          //   ),
          // );
          toastMsg(msg.toString(),true);
          loginLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 422){
          var login_data =jsonDecode(result.body);
          var msg = login_data['message'];
          // Get.to(VerifyMobileOTP(mobileNo:  parameter['mobile'],));
          toastMsg(msg.toString(),true);
          loginLoading(false);
          update();
          refresh();
        }


      } else {
        loginLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      loginLoading(false);
      update();
    }
  }
  logoutallsection() async {
    log("Delete Directory>> ");
    var appDir;
    if(Platform.isAndroid){
      appDir = (await getApplicationDocumentsDirectory()).path;
    }else{
      appDir = (await getLibraryDirectory()).path;
    }
  // await File(appDir).delete();
  new Directory(appDir).delete(recursive: true);
  // Hive.box<VideoItem>('video_items').clear();
    FileDownloader().database.deleteAllRecords();

}
  Register(url,parameter,mobileController,passwordController,_token,deviceId)async{
    registerLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      if (result != null) {
        if(result.statusCode == 200){
          register_data =jsonDecode(result.body);
          var msg= register_data['message'];
          toastMsg(msg.toString(),false);
          registerLoading(false);
          // Get.offAll(LoginPage());
          // var login_url = apiUrls().MobileLoginOTP_api;
          // var login_body ={
          //   'mobile': mobileController.toString(),
          //   // 'password': passwordController.toString(),
          //   'otp':passwordController.toString(),
          //   'fcm_id': _token.toString(),
          //   'device_id': deviceId.toString()
          // };

          // log("login body...${login_body}");
          // Get.find<AuthController>().Login(login_url, login_body,false);

          login_data =jsonDecode(result.body);
          // var msg= login_data['message'];

          // var msg = jsonDecode(result.body).toString();
          // toastMsg(msg.toString(),false);
          print("messagetrue..."+msg.toString());
          apiCallingHelper().savedatainPref(login_data,false);
          loginLoading(false);
          googleloginLoading(false);
          print("Name..."+login_data['data']['user']['name'].toString());
          print("image..."+login_data['data']['user']['image'].toString());
          // sprefs.setString("deviceid",login_data['data']['user']['device_id']);
          sprefs.setString("user_name",login_data['data']['user']['name']);
          sprefs.setString("user_image",login_data['data']['user']['image']);

          update();
          refresh();
        }else  if(result.statusCode == 422){
          register_data =jsonDecode(result.body);
          toastMsg(register_data['message'].toString(), true);
          if( register_data['error'].containsKey("mobile")==true){
            var modifiedString = register_data['error']['mobile'].toString().
            replaceAll('[', '').replaceAll(']', '');
            toastMsg(modifiedString.toString(), true);
          } else if(register_data['error'].containsKey("email")==true){
            var modifiedString = register_data['error']['email'].toString().
            replaceAll('[', '').replaceAll(']', '');
            toastMsg(modifiedString.toString(), true);
          }
          // toastMsg(msg.toString(),true);
          loginLoading(false);
          registerLoading(false);
          update();
          refresh();
        }

      } else {
        registerLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      registerLoading(false);
      update();
    }
  }
  ProfileMobileRegister(url,parameter)async{
    registerLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);
      if (result != null) {
        if(result.statusCode == 200){
          register_data =jsonDecode(result.body);
          var msg= register_data['message'];
          toastMsg(msg.toString(),false);
          registerLoading(false);
          // Get.offAll(BottomBar(bottomindex: 3,));
          Get.offAll(Profile());
          update();
          refresh();
        }else  if(result.statusCode == 401){
          register_data =jsonDecode(result.body);
          toastMsg(register_data['message'].toString(), true);
          if( register_data['error'].containsKey("mobile")==true){
            var modifiedString = register_data['error']['mobile'].toString().
            replaceAll('[', '').replaceAll(']', '');
            toastMsg(modifiedString.toString(), true);
          } else if(register_data['error'].containsKey("email")==true){
            var modifiedString = register_data['error']['email'].toString().
            replaceAll('[', '').replaceAll(']', '');
            toastMsg(modifiedString.toString(), true);
          }
          // toastMsg(msg.toString(),true);
          registerLoading(false);
          update();
          refresh();
        }else  if(result.statusCode == 422){
          register_data =jsonDecode(result.body);
          toastMsg(register_data['message'].toString(), true);
          registerLoading(false);
          update();
        }

      } else {
        registerLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      registerLoading(false);
      update();
    }
  }

  ///for sign-in with mobile no.....
  var signinWithmobLoading = false.obs;
  TextEditingController pinputOtpCtrl = TextEditingController();
  SignInWithmobile(url,parameter)async{
    signinWithmobLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);
      log('body==>'+parameter['mobile'].toString());
      if (result != null) {
        if(result.statusCode == 200){
          var  SigninWithMobdata =jsonDecode(result.body);
          log('SigninWithMobdata==>'+SigninWithMobdata.toString());
          log('Otp==>'+SigninWithMobdata['data'].toString());
         // pinputOtpCtrl.text=SigninWithMobdata['data'];
         //  toastMsg(SigninWithMobdata['message'], SigninWithMobdata['status']);
         //  toastMsg("Please enter OTP received on your mobile", SigninWithMobdata['status']);
          signinWithmobLoading(false);
          Navigator.push(
            Get.context,
            MaterialPageRoute(builder: (context) => SignInMobileOtpScreen(mobileNo:parameter['mobile'].toString() ,)),
          );
         // Get.to(SignInMobileOtpScreen(mobileNo:parameter['mobile'].toString() ,));
          log('Otp222==>'+SigninWithMobdata['data'].toString());
          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          var  SigninWithMobdata =jsonDecode(result.body);
          toastMsg(SigninWithMobdata['message'], SigninWithMobdata['status']);
          signinWithmobLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 422){
          var  SigninWithMobdata =jsonDecode(result.body);
          toastMsg(SigninWithMobdata['message'], SigninWithMobdata['status']);
          signinWithmobLoading(false);
          update();
          refresh();
        }

      } else {
        var  SigninWithMobdata =jsonDecode(result.body);
        toastMsg(SigninWithMobdata['message'], SigninWithMobdata['status']);
        signinWithmobLoading(false);
        update();
        refresh();
      }
    }
    catch (e){

      update();
    }
  }

  ///verify sign-in mobile otp data....
  var otpVerifyLoading = false.obs;
  SignOtpVerify(url,parameter)async{
    otpVerifyLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);
      log('body==>'+parameter['mobile'].toString());
      if (result != null) {
        if(result.statusCode == 200){
          var  SigninverifyOtpdata =jsonDecode(result.body);
          sprefs.setBool("islogin", true);
          log('SigninverifyOtpdata==>'+SigninverifyOtpdata.toString());
          toastMsg(SigninverifyOtpdata['message'], SigninverifyOtpdata['status']);
          otpVerifyLoading(false);

          Get.offAll(BottomBar(bottomindex: 0,));

          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          var  SigninverifyOtpdata =jsonDecode(result.body);
          log('SigninverifyOtpdata==>'+SigninverifyOtpdata.toString());
          toastMsg(SigninverifyOtpdata['message'], SigninverifyOtpdata['status']);
          otpVerifyLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 422){
          var  SigninverifyOtpdata =jsonDecode(result.body);
          log('SigninverifyOtpdata==>'+SigninverifyOtpdata.toString());
          toastMsg(SigninverifyOtpdata['message'], SigninverifyOtpdata['status']);
          otpVerifyLoading(false);
          update();
          refresh();
        }

      } else {
        var  SigninverifyOtpdata =jsonDecode(result.body);
        log('SigninverifyOtpdata==>'+SigninverifyOtpdata.toString());
        toastMsg(SigninverifyOtpdata['message'], SigninverifyOtpdata['status']);
        otpVerifyLoading(false);
        update();
        refresh();
      }
    }
    catch (e){

      update();
    }
  }

///for job/qualification data get....
  List qualificationData=[];
  var qualificationLoding = false.obs;
  getQualificationList() async {
    qualificationData.clear();
    qualificationLoding(true);
    var qualificationUrl = apiUrls().qualifications;
    var result = await apiCallingHelper().getAPICall(qualificationUrl, true);
    if(result.statusCode == 200){
      var FetchQualiFicationData = jsonDecode(result.body);
      log("FetchQualiFicationData==> :$FetchQualiFicationData ");
      qualificationData.add(FetchQualiFicationData['data']);

    }else{

    }
  }

  ///for Collages data get....
  List collagesData=[];
  var collagesLoding = false.obs;
  getcollagesList(cityId) async {
    collagesData.clear();
    collagesLoding(true);
    var collages_url = apiUrls().collages_url+"${cityId}";
    log("collages_url==> :"+collages_url.toString());
    var result = await apiCallingHelper().getAPICall(collages_url, false);
    if(result.statusCode == 200){
      var FetchQualiFicationData = jsonDecode(result.body);
      log("FetchQualiFicationData==> :$FetchQualiFicationData ");
      collagesData.addAll(FetchQualiFicationData['data']);

    }
  }





  sentOTPProfile(url,parameter)async{
    mobprofileLoading(false);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      if (result != null) {
        var  register_data =jsonDecode(result.body);
        if(result.statusCode == 200){

          var msg= register_data['data'];
          // toastMsg(msg.toString(),false);
          mobprofileLoading(true);
          update();
          refresh();
        }else  if(result.statusCode == 422){
          register_data =jsonDecode(result.body);
          // if( register_data['error'].containsKey("mobile")==true){
          //   var modifiedString = register_data['error']['mobile'].toString().
          //   replaceAll('[', '').replaceAll(']', '');
          //   toastMsg(modifiedString.toString(), true);
          // } else if(register_data['error'].containsKey("email")==true){
          //   var modifiedString = register_data['error']['email'].toString().
          //   replaceAll('[', '').replaceAll(']', '');
          //   toastMsg(modifiedString.toString(), true);
          // }
          // toastMsg(msg.toString(),true);
          mobprofileLoading(false);
          update();
          refresh();
        }else{
          mobprofileLoading(false);
          var msg= register_data['message'];
          toastMsg(msg.toString(),true);
          update();
        }

      } else {
        mobprofileLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      mobprofileLoading(false);
      update();
    }
  }

  sentOTPRegister(url,parameter,nameController,_selectedQualification,emailController,mobileController,
      passwordController,cPasswordController,collegeid,cityId,countryId,stateid, other)async{
    registerLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      log("ontaplog>> "+result.statusCode.toString());
      if (result != null) {
        var  register_data =jsonDecode(result.body);
        if(result.statusCode == 200){

          var msg= register_data['data'];
          // toastMsg(msg.toString(),false);
          registerLoading(false);
          Get.to(OTPRegPassword(otpController: msg,selectedQualification:_selectedQualification ,nameController:nameController,emailController: emailController,mobileController: mobileController,
              passwordController: passwordController,cPasswordController: cPasswordController,collegeid:collegeid ,cityId: cityId,countryId: countryId,stateid:stateid ,other:other ,));
          update();
          refresh();
        }else  if(result.statusCode == 422){
          register_data =jsonDecode(result.body);
          // if( register_data['error'].containsKey("mobile")==true){
          //   var modifiedString = register_data['error']['mobile'].toString().
          //   replaceAll('[', '').replaceAll(']', '');
          //   toastMsg(modifiedString.toString(), true);
          // } else if(register_data['error'].containsKey("email")==true){
          //   var modifiedString = register_data['error']['email'].toString().
          //   replaceAll('[', '').replaceAll(']', '');
          //   toastMsg(modifiedString.toString(), true);
          // }
          // toastMsg(msg.toString(),true);
          loginLoading(false);
          registerLoading(false);
          update();
          refresh();
        }else{
          var msg= register_data['message'];
          toastMsg(msg.toString(),true);
          registerLoading(false);
          update();
        }

      } else {
        registerLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      registerLoading(false);
      update();
    }
  }
  ChangePass(url,parameter)async{
    changePassLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);
      changePass_data =jsonDecode(result.body);
      print('changePass_data ...............${changePass_data}');

      if (result != null) {
        if(result.statusCode == 200){
          changePass_data =jsonDecode(result.body);
          var msg= changePass_data['message'];
          toastMsg(msg.toString(),false);
          changePassLoading(false);
          Get.back();
          update();
          refresh();
        }else  if(result.statusCode == 401){
          changePass_data =jsonDecode(result.body);
          print("changePass_data${changePass_data.toString()}");
          if(changePass_data['error']==""){
            toastMsg(changePass_data['message'].toString(), true);
          }
          else if( changePass_data['error'].containsKey("old_password")==true)
          {
            var modifiedString = changePass_data['error']['old_password'].toString();
            toastMsg(modifiedString.toString(), true);
          } else if(changePass_data['error'].containsKey("con_new_password")==true)
          {
            var modifiedString = changePass_data['error']['con_new_password'].toString();
            toastMsg(modifiedString.toString(), true);

            toastMsg(modifiedString.toString(), true);
          }
           else if(changePass_data['error'].containsKey("password")==true)
           {
             var modifiedString = changePass_data['error']['password'].toString();
             toastMsg(modifiedString.toString(), true);

             toastMsg(modifiedString.toString(), true);
           }

          // toastMsg(msg.toString(),true);
          changePassLoading(false);
          update();
          refresh();
        }

      } else {
        changePassLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      changePassLoading(false);
      update();
    }
  }

  ForgotPass(url,parameter, {bool skipNavigation = false})async{
    forgotLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);

      forgotPass_data =jsonDecode(result.body);
      print('changePass_data ...............${forgotPass_data}');

      if (result != null) {
        if(result.statusCode == 200){
          forgotPass_data =jsonDecode(result.body);
          var msg= forgotPass_data['message'];
          // pinController.text = forgotPass_data['data'].toString();
          toastMsg(msg.toString(),false);
          forgotLoading(false);

          if (!skipNavigation) {
            Get.to(ResetPassword());
          }
          update();
          refresh();
        }else  if(result.statusCode == 401){
          forgotPass_data =jsonDecode(result.body);
          print('   result..........');

          toastMsg(forgotPass_data['message'].toString(),true);
          forgotLoading(false);
          update();
          refresh();
        }

      } else {
        forgotLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      forgotLoading(false);
      update();
    }
  }

  ResetPass(url,parameter)async{
    resetLoading(true);
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,true);

      print('resetPass_data ...............${resetPass_data}');

      if (result != null) {
        if(result.statusCode == 200){
          resetPass_data =jsonDecode(result.body);
          var msg= resetPass_data['message'];
          print('   message........${msg}..');
          toastMsg(msg.toString(),false);
          resetLoading(false);
          Get.to(LoginPage());
          update();
          refresh();
        }else  if(result.statusCode == 401){
          resetPass_data =jsonDecode(result.body);
          toastMsg(resetPass_data['message'].toString(),true);

          resetLoading(false);
          update();
          refresh();
        }

      } else {
        resetLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      resetLoading(false);
      update();
    }
  }
  LoginWithMobile(url,parameter)async{

    resetLoading(true);
    logoutallsection();
    // deviceId = await _getId();
    print("deviceId--->>> " + deviceId.toString());
    // [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: FileSystemException: Cannot delete file, path = '/data/user/0/com.n_prep.medieducation/cache' (OS Error: Is a directory, errno = 21)
    // messaging = FirebaseMessaging.instance;
    // await messaging.getToken().then((value) {
    //   fcm_token = value;
    //   print("FCM Token " + fcm_token);
    // });
    update();
    try{
      var result=  await apiCallingHelper().multipartAPICall(url, parameter,false);
      log('body==>'+parameter.toString());

      // toastMsg("${result.statusCode}", false);
      if (result != null) {
        if(result.statusCode == 200){

          login_data =jsonDecode(result.body);
          // var msg= login_data['message'];

          var msg = jsonDecode(result.body).toString();
          // toastMsg(msg.toString(),false);
          print("messagetrue..."+msg.toString());
          apiCallingHelper().savedatainPref(login_data,false);
          resetLoading(false);
          print("Name..."+login_data['data']['user']['name'].toString());
          print("image..."+login_data['data']['user']['image'].toString());
          // sprefs.setString("deviceid",login_data['data']['user']['device_id']);
          sprefs.setString("user_name",login_data['data']['user']['name']);
          sprefs.setString("user_image",login_data['data']['user']['image']);
          // sprefs.setBool(KEYLOGIN,true);
          //     Get.to(BottomBar());

          //  sprefs.setBool(KEYLOGIN,true);

          // Logger().d("login succesfull");

          update();
          refresh();
        }
        else  if(result.statusCode == 401){
          login_data =jsonDecode(result.body);
          var msg = "You haven't registered yet. Please register";
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          NotregisteredmobileNo=parameter['mobile'];
          log('NotregisteredmobileNo==>$NotregisteredmobileNo');
          Get.to(RegistrationPage(NotRegisteredNumber: NotregisteredmobileNo,));
          resetLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 403){
          login_data =jsonDecode(result.body);

          await FirebaseAuth.instance.signOut();
          await _googleSignIn.signOut();

          var msg = login_data['message'];
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          log('NotregisteredmobileNo==>'+NotregisteredmobileNo.toString());
          resetLoading(false);
          update();
          refresh();
        }
        else  if(result.statusCode == 422){
          login_data =jsonDecode(result.body);
          var msg = login_data['message'];
          print("message..."+msg.toString());
          toastMsg(msg.toString(),true);
          resetLoading(false);
          update();
          refresh();
        }

      } else {
        resetLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      resetLoading(false);
      update();
    }
  }
}