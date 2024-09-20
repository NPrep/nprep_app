import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/Force_update_page.dart';
import 'package:n_prep/constants/MaitainceScreen.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key key});

  @override
  State<SpalshScreen> createState() => SpalshScreenState();
}



class SpalshScreenState extends State<SpalshScreen> {

  SettingController settingController =Get.put(SettingController());



  @override
  void initState(){
    super.initState();

    toLogin();

  }

  void toLogin() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
      statusBarColor: primarysplash, // status bar color
    ));
    var settingUrl ="${apiUrls().setting_api}";
    await settingController.SettingData(settingUrl);
    log("App_version_server ${settingController.App_version_server}");
    if (double.parse(settingController.App_version_server) > (Platform.isAndroid?apiUrls().app_version:apiUrls().ios_app_version)) {
      print("force update here 1");
      var body = {
        "forceupdate": settingController.Force_update,
        "applogo":  settingController.settingData['data']['general_settings']['logo'].toString(),
        "appname":  settingController.settingData['data']['general_settings']['application_name'].toString(),
        "appurl": settingController.App_app_url_server.toString() ,
      };
      print("force update here 1 Check>> "+body.toString());
      Get.dialog(

          ForceUpdatePage(
            forceupdate: settingController.Force_update,
            applogo:  settingController.settingData['data']['general_settings']['logo'].toString(),
            appupdatetext:settingController.App_update_text_server.toString() ,
            appname:  settingController.settingData['data']['general_settings']['application_name'].toString(),
            appurl: settingController.App_app_url_server.toString() ,
          ),
      );
      // showDialog(
      //     context: context,
      //     barrierDismissible:
      //     settingController.Force_update.toString() ==apiUrls().App_force_updateNo.toString() ? false : true,
      //     builder: (_) => ForceUpdatePage(
      //       forceupdate: settingController.Force_update,
      //       applogo:  settingController.settingData['data']['general_settings']['logo'].toString(),
      //       appupdatetext:settingController.App_update_text_server.toString() ,
      //       appname:  settingController.settingData['data']['general_settings']['application_name'].toString(),
      //       appurl: settingController.App_app_url_server.toString() ,
      //     ),
      //
      // );
    }
    else if (settingController.Maitaince ==apiUrls(). App_Maintaince_updateNo) {
      print("force update here 2");
      Get.to(MaitainceScreen(
        Maitaince_text:settingController.Maitaince_text,
        applogo:  settingController.settingData['data']['general_settings']['logo'].toString(),
        appname:  settingController.settingData['data']['general_settings']['application_name'].toString(),
        appurl: settingController.settingData['data']['general_settings']['playstore_link'].toString() ,
      ));
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MaitainceScreen(
      //           Maitaince_text:Maitaince_text,
      //           applogo: jsonGetSetting['data']['front_logo'].toString(),
      //           appname: jsonGetSetting['data']['application_name'].toString(),
      //           appurl:jsonGetSetting['data']['app_url'].toString() ,maintainceupdate: Maitaince.toString(),
      //         )
      //
      //     ));

    }
    else{
      print("force update here 3");
      Timer(Duration(seconds: 3), () async {
        var sharedPref = await SharedPreferences.getInstance();
        var isLoggedIn = sharedPref.getBool("islogin");

        if (isLoggedIn != null && isLoggedIn) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => BottomBar()),
          // );
          Get.to(BottomBar());
        } else {
          print("force update here 4");
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
          Get.to(LoginPage());
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarysplash,
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // color: Colors.red,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/splashbf.png')
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10,),
            Center(child: Column(
              children: [
                Image.asset(logo,color: white,scale: 1.5),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Made with ❤️️ By ",
                    style:  TextStyle(color: Colors.white,fontSize: 18),
                    children: [
                      TextSpan(
                        text: 'AIIMS',
                        style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold),

                      ),
                      TextSpan(
                        text: 'onians',
                        style:  TextStyle(color: Colors.white,fontSize: 18),

                      ),
                    ],
                  ),
                ),
               /// Text("Made with ❤️ from AIIMSonians",style: TextStyle(color: Colors.white,fontSize: 18),),
              ],
            )),

            Image.asset('assets/images/home_group.png',scale: 1),

          ],
        ),
      )
    );
  }
}





