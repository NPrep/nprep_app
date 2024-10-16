import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:n_prep/main.dart';

class Environment {

  static String get filename {
    if (kReleaseMode) {
      return '.env.prod';
    }
    return '.env.dev';
  }
  static String get apibaseurl{


    return  dotenv.env['baseurls'];
  }
  static String get imgapibaseurl{


    return  dotenv.env['imgbaseurls'];
  }
  static String get apibasetoken{

    var usepref= sprefs.getString("login_access_token");
    return usepref;
  }
  static String get videoduration{

    var usepref= sprefs.getString("video_duration");
    return usepref;
  }
  static String get videoCatId{

    var usepref= sprefs.getString("video_Cat_Id");
    return usepref;
  }
  static String get videoduration_bar{

    var usepref= sprefs.getString("video_duration_bar");
    return usepref;
  }
  static String get videoTitle{

    var usepref= sprefs.getString("video_Title");
    return usepref;
  }
  static String get userid{
    var useridpref= sprefs.getString("user_id");
    return useridpref;
  }
  static String get deviceid{
    var devicedId = sprefs.getString("deviceid");
    return devicedId;
  }
  static String get fcmid{
    var fcmId = sprefs.getString("fcm_Id");
    return fcmId;
  }

  static String get test_time{
    var testTimes = sprefs.getString("test_time");
    return testTimes;
  }

  static String get profilename{
    var profileName = sprefs.getString("user_name");
    return profileName;
  }
  static String get profileimage{
    var profileImage = sprefs.getString("user_image");
    return profileImage;
  }
  static bool get isloged_in{

    var islogin= sprefs.getBool("islogin")??false;
    return islogin;
  }

  static String get rezorpayKey{
    var rezorpaykey= sprefs.getString("rezorpay_key");
    return rezorpaykey;
  }
  static String get appLogo{
    var applogo= sprefs.getString("applogo");
    return applogo;
  }
  static String get appName{
    var appname= sprefs.getString("appname");
    return appname;
  }

  static String get appUrl{
    var appurl= sprefs.getString("appurl");
    return appurl;
  }






  static String get appname{
    return dotenv.env['appname'];
  }
  static String get appversion{
    return dotenv.env['appversion'];
  }
  static String get appstatus{
    return dotenv.env['appstatus'];
  }
  static String get apptimeout{
    return dotenv.env['apptimeout'];
  }
}
