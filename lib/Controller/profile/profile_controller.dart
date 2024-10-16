import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/profile/profile.dart';

import '../../Service/TokenExpairy.dart';

class ProfileController extends GetxController{

  var profileLoader = false.obs;
  var profileError = false.obs;
  var profileData ;

  var updateProfileLoader = false.obs;
  var updateProfileError = false.obs;
  var updateProfileData ;


  TextEditingController user_name = TextEditingController();
  TextEditingController user_number = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_city = TextEditingController();
  TextEditingController user_state = TextEditingController();

  TextEditingController otherQualiCltrl = TextEditingController();





  File pickfile;
  var imgpath;
  ImagePicker _picker = ImagePicker();
  // get pickfile =>_pickfile;
imagenull(){
  pickfile=null;
  update();
  refresh();
}
  Future getFromGallery() async {
    PickedFile pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100);
    if (pickedFile != null) {
      pickfile = File(pickedFile.path);
      imgpath=pickfile.toString();
      update();
      refresh();
      print("pick file form gellary" + pickfile.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var profileUrl = "${apiUrls().profile_api}";

List MyProfileData=[];

  GetProfile(url)async{
    profileLoader(true);
    getdata(url);

    String jsonData = sprefs.getString('profile_data');

    if(jsonData == null){
      await getdata(url);
    }else{
      MyProfileData.add(jsonDecode(jsonData));
      profileLoader(false);
      await getdata(url);
      update();
      refresh();
    }
  }

  getdata(url)async{
    try{
      var result = await apiCallingHelper().getAPICall(url, true);
      if(result != null){
        if(result.statusCode == 200){
          profileData =jsonDecode(result.body);
          await sprefs.setString('profile_data', result.body);
          MyProfileData.clear();
          MyProfileData.add(profileData);
          log('MyProfileData==>'+MyProfileData.toString());
          log('ProfileData==>'+profileData.toString());
          // Logger().d("profileData ........${profileData}");
          user_name.text = profileData['data']['name'];
          user_number.text = profileData['data']['mobile'];
          user_email.text = profileData['data']['email'];
          otherQualiCltrl.text = profileData['data']['other_qualification'];

          sprefs.setString("email",profileData['data']['email'].toString());
          sprefs.setString("mobile",profileData['data']['mobile'].toString());
          sprefs.setString("user_name", profileData['data']['name']);
          sprefs.setString("user_image", profileData['data']['image']);
          print("user name .....${sprefs.getString("user_name")}");
          print("user image .....${sprefs.getString("user_image")}");
          profileLoader(false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){
          profileError.value = true;
          profileLoader(false);
        }
        else if(result.statusCode == 401){
          TokenExpairy().tokenExpairy();
          profileLoader(false);
        }
        else{
          profileLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      profileLoader(false);
      update();
    }
  }

  UpdateProfile(url,parameter)async{
    updateProfileLoader(true);
    try{
      var result = await apiCallingHelper().multipartAPICall(url,parameter, true);
      if(result != null){
        if(result.statusCode == 200){
          updateProfileData =jsonDecode(result.body);
          Logger().d("updateProfileData ........${updateProfileData}");
          updateProfileLoader(false);

         await GetProfile(profileUrl);
          var msg = updateProfileData['message'];
          // toastMsg(msg.toString(),false);
          update();
          refresh();
        }
        else if(result.statusCode == 404){
          updateProfileError.value = true;
          updateProfileLoader(false);
        }
        else{
          updateProfileLoader(false);
        }
        update();
        refresh();
      }
    }
    catch (e){
      Logger().e("catch error ........${e}");
      updateProfileLoader(false);
      update();
    }
  }
}