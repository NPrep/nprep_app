import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:get/get.dart';

import '../../../Envirovement/Environment.dart';
import '../../../Service/Service.dart';
import '../../../constants/Api_Urls.dart';
import '../../../constants/validations.dart';

class ReportIssueController extends GetxController{


  var token;

  Future<void> uploadImges(File image, String exam_id,String question_id,String review) async {
    var url = apiUrls().test_question_review;
    log('Url==>' + url.toString());






    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      try {
        if (image != null) {
          log('image==>' + image.toString());
          if (image != null) {
            request.files.add(await http.MultipartFile.fromPath("review_image",image.path.toString()));
          } else {
            log('Error: image1 is null.');
          }
        }
      } catch (e) {
        print('Error reading image file: $e');
      }

      // Add the 'review' parameter to the request body
      request.fields['exam_id'] = exam_id;
      request.fields['question_id'] = question_id;
      request.fields['review'] = review;

      // Set headers
      token = apiUrls().AuthorizationKey;
      log("get token : $token");
      request.headers['Authorization'] = '$token';
      request.headers[apiUrls().XAPIKEY] = apiUrls().XAPIVALUE;

      // Send the request
      var response = await http.Response.fromStream(await request.send());

      log('statusCode==>' + response.statusCode.toString());
      log('Authorization==>' + request.headers['Authorization'].toString());
      log('appxapikey==>' + request.headers[apiUrls().XAPIKEY].toString());

      if (response.statusCode == 200) {
        var uploadDataData = jsonDecode(response.body);
        log("uploadDataData==> : " + uploadDataData.toString());
         toastMsg(uploadDataData['message'], uploadDataData['status']);
         Get.back();
        update();
        print('Request successful');
      } else if (response.statusCode == 422) {
        var uploadDataData = jsonDecode(response.body);
        log("uploadDataData==> : " + uploadDataData.toString());
        //   toastMsg(uploadDataData['message'], uploadDataData['status']);
      } else if (response.statusCode == 500) {
        var uploadDataData = jsonDecode(response.body);
        log("uploadDataData==> : " + uploadDataData.toString());
        // toastMsg(uploadDataData['message'], uploadDataData['status']);
      } else {
        var uploadDataData = jsonDecode(response.body);
        log("uploadDataData==> : " + uploadDataData.toString());
        //   toastMsg(uploadDataData['message'], uploadDataData['status']);
        print('Request failed with status: ${response.statusCode}');
        update();
      }
    } catch (e) {
      log("checkOut_exception==> : " + e.toString());
    }
  }


}