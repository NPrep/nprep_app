
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/store_config.dart';
import 'package:n_prep/splash_screen.dart';

import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:n_prep/utils/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Local_Database/database.dart';
import 'Notification_pages/notification_redirect.dart';
/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';
String KEYLOGIN = "login";
SharedPreferences sprefs;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  print(message.notification.toString());
  print(message.notification.title);
  print(message.notification.body);
  log(message.data.toString());
  var title = message.notification.title;
  var body = message.notification.body;
  if (message.notification != null) {
    //No need for showing Notification manually.
    //For BackgroundMessages: Firebase automatically sends a Notification.
    //If you call the flutterLocalNotificationsPlugin.show()-Methode for
    //example the Notification will be displayed twice.
    _showNotification(title,body,message.notification.android.imageUrl,message.data.toString());
  }

}
Future<void> _showNotification(titles,bodys,image,payload) async {
  // const AndroidNotificationDetails androidPlatformChannelSpecifics =
  var bigPictureStyleInformation;
  if(image==null){
    bigPictureStyleInformation = BigTextStyleInformation(bodys);
  }else{
    final http.Response response = await http.get(Uri.parse(image));

    bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)));
  }
  var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.high,
      styleInformation: bigPictureStyleInformation,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true);
  const DarwinNotificationDetails iosNotificationDetails =
  DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );


  // android: androidPlatformChannelSpecifics, iOS: iosDetail);
  var platformChannelSpecifics = NotificationDetails(
    iOS: iosNotificationDetails,
    android: androidPlatformChannelSpecifics, );
  // android: androidPlatformChannelSpecifics, iOS: iosDetail);
  await flutterLocalNotificationsPlugin.show(0, titles, bodys, platformChannelSpecifics, payload:payload );
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  print("notificationTapBackground :${notificationResponse.payload} ");
}

void onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  log('onDidReceiveLocalNotification');
  log('notification details payload: $title');
  log(title);
  log(body);
  print(payload);



}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String payload = notificationResponse.payload;
  // if (notificationResponse.payload != null) {
  //   debugPrint('notification payload: $payload');
  // }
  print("onDidReceiveNotificationResponse : ");
  try{
    notification().callredirect(payload);

  }catch(e){
    log("NotificationResponse Exception :> "+e.toString());
  }
  log("onDidReceiveNotificationResponse :> ");


}

var box ;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  ///for initialise hive db.....
log("On run >> main.dart");

  sprefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: Environment.filename);
  await Firebase.initializeApp();
  // activate tracking at the start of your app
  await FileDownloader().trackTasks();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
    statusBarColor: Color(0xFF64C4DA), // status bar color
  ));
  if (Platform.isIOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // StoreConfig(
    //   store: Store.googlePlay,
    //   apiKey: googleApiKey,
    // );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("On run >> MyApp StatefulWidget");
    var initializationSettingsAndroid = new AndroidInitializationSettings('logo');

     DarwinInitializationSettings initializationSettingsDarwin =const DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,

      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
     );

     LinuxInitializationSettings initializationSettingsLinux =const LinuxInitializationSettings(defaultActionName: 'Open notification');

     InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,);

    _requestPermissions();
    registerForegroundMessageHandler();
    initializeDB();
  }


  Future<void> initializeDB() async {
    await DatabaseHelper().initializeDatabase(); // Ensure database is created
    // You can now perform insertions or queries
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      setState(() {
     var   _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  Future<void> _showNotification(titles,bodys,image,payload) async {
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    var bigPictureStyleInformation;
    var IOSbigPictureStyleInformation;
    if(image==null){
      bigPictureStyleInformation = BigTextStyleInformation(bodys);
      if(Platform.isIOS){

        IOSbigPictureStyleInformation=  DarwinNotificationDetails();
      }
    }else{
      final http.Response response = await http.get(Uri.parse(image));

      bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)));

        if(Platform.isIOS){
          // Create an image name
          final dir = await getTemporaryDirectory();
          var filename = '${dir.path}/image.png';

          // Save to filesystem
          final file = File(filename);
          await file.writeAsBytes(response.bodyBytes);
          IOSbigPictureStyleInformation=  DarwinNotificationDetails(
              attachments: [DarwinNotificationAttachment(filename)]);
        }

    }
    var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.high,
        styleInformation: bigPictureStyleInformation,
        priority: Priority.high,
        icon: "logo",
        color: primary,
        colorized: true,
        ticker: 'ticker',
        playSound: true);
    var IOSPlatformChannelSpecifics =  IOSbigPictureStyleInformation;
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,iOS: IOSPlatformChannelSpecifics );
    // android: androidPlatformChannelSpecifics, iOS: iosDetail);
    await flutterLocalNotificationsPlugin
        .show(0, titles, bodys, platformChannelSpecifics, payload:payload );
  }
  void registerForegroundMessageHandler() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      log(" --- foreground message received ---");
      log(remoteMessage.notification.toString());
      log(remoteMessage.notification.title);
      log(remoteMessage.notification.body);
      log(remoteMessage.data.toString());
      var title = remoteMessage.notification.title;
      var body = remoteMessage.notification.body;
      var image = remoteMessage.notification.android.imageUrl;
      log("image >> "+image.toString());
     _showNotification(title,body,image,remoteMessage.data.toString());
      // Get.snackbar(title,body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("onMessageOpenedApp: $message");



    });

  }
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: Environment.appname,
      debugShowCheckedModeBanner:
      Environment.appstatus == "Development" ? true : false,
      // theme: AppTheme.lightTheme,
      theme: ThemeData(
       fontFamily: 'PublicSans',
        accentColor: primary,
        primaryColor: primary,
        primarySwatch: myFavoriteColor

      ),
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      // debugShowCheckedModeBanner: false,
      home: SpalshScreen(),
      // home: MyApps(),
    );
  }
}