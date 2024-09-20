//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:get/get.dart';
// import 'package:n_prep/Service/Service.dart';
//
// class TestController extends GetxController{
//   var attempLoader = false.obs;
//   var attempTestData;
//
//   var _checkexamid;
//   get checkexamid => _checkexamid;
//
//   var _checkstatus;
//   get checkstatus => _checkstatus;
//
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//
//   AttemptTestApi(url)async{
//     attempLoader(true);
//     try{
//       var result=  await apiCallingHelper().getAPICall(url,true);
//       if (result != null) {
//         if(result.statusCode == 200){
//           attempTestData =jsonDecode(result.body);
//           print("attempTestData......"+attempTestData.toString());
//           _checkexamid = attempTestData['data']['id'];
//           _checkstatus = attempTestData['data']['exam_status'];
//           print("_checkexamid......"+_checkexamid.toString());
//           print("_checkstatus......"+_checkstatus.toString());
//           attempLoader(false);
//           update();
//           refresh();
//         }else  if(result.statusCode == 401){
//           attempTestData =jsonDecode(result.body);
//           print("attempTestData 401......"+attempTestData.toString());
//           attempLoader(false);
//           update();
//           refresh();
//         }
//         else  if(result.statusCode == 500){
//           attempTestData =jsonDecode(result.body);
//           print("attempTestData 500......"+attempTestData.toString());
//           attempLoader(false);
//           update();
//           refresh();
//         }
//       } else {
//         attempLoader(false);
//         update();
//         refresh();
//       }
//     }
//     on SocketException {
//       throw FetchDataException('No Internet connection');
//
//     } on TimeoutException {
//       throw FetchDataException('Something went wrong, try again later');
//     }
//   }
//
//
// }