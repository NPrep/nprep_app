import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/drawer_items/privacy_policy.dart';
import 'package:n_prep/src/drawer_items/t&c.dart';
import 'package:n_prep/src/login_page/forgot_password/forgot_password.dart';
import 'package:n_prep/utils/colors.dart';
import '../../constants/validations.dart';
import '../Nphase2/Google_Apple_SignIn/auth.dart';
import '../registration_page/registartion_page.dart';
import 'VarifySigninMobOtp.dart';

class SignInWithMobile extends StatefulWidget {

  const SignInWithMobile({Key key});

  @override
  State<SignInWithMobile> createState() => _SignInWithMobileState();
}

class _SignInWithMobileState extends State<SignInWithMobile> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController signInMobilCtrl = TextEditingController();

  AuthController authController =Get.put(AuthController());

  String _token;
  String get token => _token;
  Future _getToken() async {
    await authController.getId();
    print("CheckCheck 1");
    try{
      print("FCM: getting...");
      // deviceId = await _getId();
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
      // FirebaseMessaging.instance.getToken().then((token){
      //   _token = token;
      // });
      _token = await FirebaseMessaging.instance.getToken();

      print("FCM: $_token");

      sprefs.setString("token", _token);
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _token = token;
      });
      print("FCM 1 : $_token");
    }catch(e){
      print("Exception : $e");
    }
    print("CheckCheck 2");
  }




  // signIn() async {
  //   if(authController.loginLoading.value){
  //     toastMsg("Logging your request, please wait....", true);
  //   }else{
  //     if (_formKey.currentState.validate()) {
  //       authController.deviceId =  await authController.getId();
  //       if(authController.deviceId.toString()!="null"){
  //         var login_url = apiUrls().login_api;
  //         var login_body ={
  //           'mobile': mobileController.text,
  //           'password': passwordController.text,
  //           'fcm_id': _token.toString(),
  //           'device_id': authController.deviceId.toString()
  //         };
  //
  //         authController.Login(login_url, login_body);
  //       }else{
  //         // toastMsg("Device id not found", true);
  //         print("Device id not found");
  //       }
  //
  //
  //
  //
  //     }
  //   }
  //
  // }

  bool isRegister = true;

  @override
  void initState() {
  log('mobileno==>'+ sprefs.getString("mobile").toString());
  if(sprefs.getString("mobile")!=null||sprefs.getString("mobile")!=""){

    signInMobilCtrl.text=sprefs.getString("mobile")=="null"?"":sprefs.getString("mobile").toString();
  }
    _getToken();
    super.initState();
    authController.loginLoading.value==false;

  }

  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    log(size.height.toString());
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: white,

        body:   Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                color: Colors.white,
                child: Image.asset(backgroundtop,width: size.width,fit: BoxFit.contain,)),

            Positioned(
              top: 70,
              child:  Image.asset(logo,color: white,scale: 1.8,),),

            Container(
              margin: EdgeInsets.only(
                left: 20,right: 20
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row(
                    //   children: [
                    //     Text('Update Phone no.'.toUpperCase(),
                    //         style: TextStyle(
                    //           color: primary,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.w600,
                    //           fontFamily:'Poppins-Regular',
                    //         )),
                    //   ],
                    // ),
                    SizedBox(height: 40,),
                    Text('Please link your phone number',style: TextStyle(
                      fontSize: 19,
                      fontFamily:'Poppins-Regular',
                      color: black54,
                      letterSpacing: -0.3,
                    ),),
                    SizedBox(height: 29,),
                    CustomTextFormField(
                      controller: signInMobilCtrl,
                      validator: Validations.validateMobile,
                      maxLength: 10,
                      hintText: 'Mobile No.',
                      l_icon: Image.asset(profile_user,scale: 3,),
                      keyType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    sizebox_height_35,

                    GestureDetector(
                      onTap: (){
                        if(_formKey.currentState.validate()){
                          var social_otpSend_url = apiUrls().Social_send_otp_api;
                          var body ={
                            'mobile':signInMobilCtrl.text.toString(),
                          };
                          log('social_otpSend_url==>'+social_otpSend_url.toString());
                          log('body==>'+body.toString());
                          authController.SignInWithmobile(social_otpSend_url,body);
                        }


                        // Get.offAll(BottomBar(bottomindex: 0,));
                        // Get.to(SignInMobileOtpScreen());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,

                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),

                        child:
                        Text("Send OTP",style: TextStyle(color: white,
                            fontSize: 17,fontWeight: FontWeight.w600),) ,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
