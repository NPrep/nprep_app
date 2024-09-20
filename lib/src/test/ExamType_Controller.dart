// import 'package:get/get.dart';
//
// import '../../../Service/Service.dart';
// import '../../../constants/Api_Urls.dart';
//
// class ExamTypeController extends GetxController{
//   var testLoading = false.obs;
//   List TestData = [];
//
//   ProfileApiCalling() async {
//     testLoading.value =true;
//     TestData.clear();
//     // Map<String, String> queryParams = {
//     //   'exam_id': widget.examId.toString(),
//     //   'exam_status': widget.reattempt.toString() == "1"
//     //       ? widget.reattempt.toString()
//     //       : widget.checkstatus.toString(),
//     // };
//     // String queryString = Uri(queryParameters: queryParams).query;
//     var get_questionUrl = apiUrls().get_question_api + '?' + queryString;
//     var url=profile_url;
//     var response=  await apiCallingHelper().getAPICall(Uri.parse(url),true);
//     var responsedata = jsonDecode(response.body);
//     if(response.statusCode==200){
//       if(responsedata['status']==true){
//         log("hgg---->"+responsedata.toString());
//         TestData.add(responsedata['data']);
//         log("image------>"+TestData[0]['image'].toString());
//         log("image------>"+TestData[0]['firstname'].toString());
//         log("image------>"+TestData[0]['lastname'].toString());
//         log("data--------->${TestData.toString()}");
//         prefs!.setString('image',TestData[0]['image'].toString());
//         prefs!.setString('firstname',TestData[0]['firstname'].toString());
//         prefs!.setString('lastname',TestData[0]['lastname'].toString());
//         prefs!.getString('image');
//         prefs!.getString('firstname');
//         prefs!.getString('lastname');
//         log('lastname==>${prefs!.getString('lastname')}');
//         testLoading.value =false;
//         update();
//       }
//       else{
//         TestData =[];
//         testLoading.value =false;
//         update();
//       }
//
//     }
//   }
//
// }