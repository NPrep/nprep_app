import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import  'package:http/http.dart' as http;
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/main.dart';

import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/login_page/SignInWithMobile.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import 'package:path_provider/path_provider.dart';

class apiCallingHelper{


  savedatainPref(data,bool type) async {
    sprefs.setString("login_access_token", data["data"]["access_token"].toString());
    sprefs.setString("user_id",data["data"]['user']['id'].toString());
    sprefs.setString("user_name",data['data']['user']['name'].toString());
    sprefs.setString("email",data["data"]['user']['email'].toString());
    sprefs.setString("mobile",data["data"]['user']['mobile'].toString());
    sprefs.setString("deviceid", data["data"]["user"]['device_id'].toString());
    sprefs.setString("fcm_Id", data["data"]["user"]['fcm_id'].toString());


    print("token..........."+Environment.apibasetoken.toString());
    print("userid..........."+Environment.userid.toString());
    print("diviceid..........."+Environment.deviceid.toString());
    print("fcmid..........."+Environment.fcmid.toString());
    if(type==true){
      if(data["data"]['user']['mobile'].toString()=="null"){
        Get.to(SignInWithMobile());
      }else{
        sprefs.setBool("islogin", true);
        Get.offAll(BottomBar(bottomindex: 0,));
      }

    }
    else{
      sprefs.setBool("islogin", true);
      Get.offAll(BottomBar(bottomindex: 0,));
    }


  }
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  logoutinPref() async {
    log("Delete Directory>> okk  ");
    await FirebaseAuth.instance.signOut();
     await _googleSignIn.signOut();
    var appDir;
    if(Platform.isAndroid){
      appDir = (await getApplicationDocumentsDirectory()).path;
    }else{
      appDir = (await getLibraryDirectory()).path;
    }

    // await File(appDir).delete();
    new Directory(appDir).delete(recursive: true);
    FileDownloader().database.deleteAllRecords();

    sprefs.setBool("islogin", false);
    Get.offAll(LoginPage());
    print("logout sucess ");
  }

  var _mainHeaders = {
    apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
    apiUrls().Authorization: apiUrls().AuthorizationKey,
  };

  var _subHeader = {
    apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
  };

  Future<http.Response> getAPICall(url,header) async {
    // print("get url 1: $url");
    log("get api url : $url");
    log("get api header : $header");
    log("mainHeaders for get api _mainHeaders : $_mainHeaders");
    print("mainHeaders for get api _subHeader : $_subHeader");
    print("mainHeaders for get api  : ${jsonEncode(Environment.apibasetoken)}");

    try {
      final request = http.MultipartRequest('GET', Uri.parse(url));
      request.headers.addAll(header==true?_mainHeaders:_subHeader);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      log("post statusCode : ${responsedata.statusCode.toString()}");

      log("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }catch(e){
      log("catch e :$e ");
    }
  }

  Future<http.Response> getPostAPICall(url,header) async {
    // print("get url 1: $url");
    log("mainHeaders for get api>  : $_mainHeaders");
    log("url for get api>  : $url");

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(header==true?_mainHeaders:_subHeader);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      print("post statusCode : ${responsedata.statusCode.toString()}");

      print("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }


  Future<http.Response> multipartAPICall(url, parameter,header) async {
    log("multipartAPICall url : $url");
    log("multipartAPICall parameter : $parameter");
    log("multipartAPICall header : $header");
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(parameter);
      log("multipartAPICall request : $request");

      request.headers.addAll(header==true?_mainHeaders:_subHeader);
      log("multipartAPICall request : ${ request.headers}");
      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      log("multipartAPICall statusCode : ${responsedata.statusCode.toString()}");

      log("multipartAPICall response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }catch(e){
      log("multipartAPICall exception $e");
    }
  }
  Future<http.Response> PostAPICallForTestPaper(url, parameter,header) async {
    log("PostAPICallForTestPaper url : $url");
    log("PostAPICallForTestPaper parameter : $parameter");
    log("PostAPICallForTestPaper header : $header");
    try {
      final responsedata = await http.post( Uri.parse(url),body: parameter,headers:  {
      apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
      apiUrls().Authorization: apiUrls().AuthorizationKey,
        'Content-Type': 'application/json',
      },);




      log("PostAPICallForTestPaper statusCode : ${responsedata.statusCode.toString()}");

      log("PostAPICallForTestPaper response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }catch(e){
      log("PostAPICallForTestPaper exception >> $e");
    }
  }
  Future<http.Response> PostAPICallVideo(url, parameter,header) async {
    log("PostAPICallVideo url : $url");
    log("PostAPICallVideo parameter : $parameter");
    log("PostAPICallVideo header : $header");
    try {
      final responsedata = await http.post( Uri.parse(url),body: parameter,headers:  {
      apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
      apiUrls().Authorization: apiUrls().AuthorizationKey,

      },);




      log("PostAPICallVideo statusCode : ${responsedata.statusCode.toString()}");

      log("PostAPICallVideo response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }catch(e){
      log("PostAPICallVideo exception >> $e");
    }
  }

}
class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}