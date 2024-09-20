import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/Force_update_page.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/MaitainceScreen.dart';
import '../src/home/bottom_bar.dart';
import '../src/login_page/login_page.dart';

class SettingController extends GetxController {
  var settingLoader = false.obs;
  var settingData;

  var App_version_server,
      App_update_text_server,
      App_app_url_server,
      Force_update,
      Maitaince,
      Maitaince_text;
  var _get_interval;
  get get_interval => _get_interval;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  SettingData(url) async {
    settingLoader(true);
    log("setting url :$url ");
    try {
      var result = await apiCallingHelper().getAPICall(url, false);
      log("body settingData :${result.body}");
      log("statusCode settingData :${result.statusCode}");

      if (result != null) {
        if (result.statusCode == 200) {
          settingData = jsonDecode(result.body);

          log("response settingData :$settingData ");
          sprefs.setString("ios_payment_show",settingData['data']['general_settings']
          ['ios_payment_button'].toString());
          log("check sprefs ios_payment_show>> "+sprefs.getString("ios_payment_show"));
          sprefs.setString("razorpay_payment_show",settingData['data']['general_settings']
          ['razorpay_payment_button'].toString());
          log("check sprefs razorpay_payment_show>> "+sprefs.getString("razorpay_payment_show"));

          _get_interval = settingData['data']['general_settings']
              ['category_question_interval'];
          sprefs.setString(
              "rezorpay_key",
              settingData['data']['general_settings']['razorpay_keyid']
                  .toString());
          sprefs.setString(
              "test_time",
              settingData['data']['general_settings']
                      ['category_question_interval']
                  .toString());
          sprefs.setString(
              "sharelink",
              settingData['data']['general_settings']['playstore_full_url']
                  .toString());
          sprefs.setString(
              "sharelinkios",
              settingData['data']['general_settings']['iosstore_full_url']
                  .toString());
          sprefs.setString(
              "sharemsg",
              settingData['data']['general_settings']['share_msg_text']
                  .toString());

          sprefs.setString("quotes",
              settingData['data']['general_settings']['quotes'].toString());
          sprefs.setString("applogo",
              settingData['data']['general_settings']['logo'].toString());
          sprefs.setString(
              "appname",
              settingData['data']['general_settings']['application_name']
                  .toString());
          sprefs.setString(
              "appurl",
              settingData['data']['general_settings']['playstore_link']
                  .toString());
          if (Platform.isAndroid) {
            App_version_server = settingData['data']['general_settings']
                    ['android_version']
                .toString();
            App_app_url_server =settingData['data']['general_settings']['playstore_link'];
          } else {
            App_version_server = settingData['data']['general_settings']
                    ['ios_version']
                .toString();
            App_app_url_server =
                settingData['data']['general_settings']['iosstore_link'];
          }


          Force_update =
              settingData['data']['general_settings']['android_force_update'];
          Maitaince =
              settingData['data']['general_settings']['maintainance_update'];
          App_update_text_server =
              settingData['data']['general_settings']['app_update_text'];
          Maitaince_text =
              settingData['data']['general_settings']['maintainance_text'];

          print("version...." + App_version_server);
          print("version....." + Maitaince.toString());
          print("get_interval envarment......" +
              sprefs
                  .getString(
                    "test_time",
                  )
                  .toString());
          print("get_interval......" + _get_interval.toString());
          print("sharelink......" + _get_interval.toString());
          print("get_interval......" + _get_interval.toString());

          settingLoader(false);
          update();
          refresh();
        }
        else if (result.statusCode == 404) {
          settingData.value = true;
          settingLoader(false);
        } else {
          settingLoader(false);
        }
        update();
        refresh();
      }
    } catch (e) {
      log("catch error ........${e}");
      settingLoader(false);
      update();
    }
  }
}
