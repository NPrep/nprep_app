import 'package:get/get.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/src/login_page/login_page.dart';

class TokenExpairy {

  var getToken ;

  tokenExpairy(){
    getToken = Environment.apibasetoken;
    Logger_D(getToken);
    getToken.toString()== "null"?
    Get.offAll(LoginPage()):"";

  }
}