
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:pinput/pinput.dart';

import '../../Service/Service.dart';
import '../../main.dart';

class VerifyMobileOTP extends StatefulWidget {
var mobileNo;
   VerifyMobileOTP({this.mobileNo});

  @override
  State<VerifyMobileOTP> createState() => _VerifyMobileOTPState();
}

class _VerifyMobileOTPState extends State<VerifyMobileOTP> {
  final _formKey = GlobalKey<FormState>();

  //api calling
  AuthController authController =Get.put(AuthController());


  int secondsRemaining = 30;

  bool isResend = false;
  Timer timer;
  String _token;
  String get token => _token;
  Future _getToken() async {
    await authController.getId();
    print("CheckCheck 1");
    try{
      print("FCM: getting...");

      _token = await FirebaseMessaging.instance.getToken();

      print("FCM: $_token");

      sprefs.setString("Fcmtoken", _token);
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _token = token;
      });
      print("FCM 1 : $_token");
    }catch(e){
      print("Exception : $e");
    }
    print("CheckCheck 2");
  }
// Toggles the password show status



  LoginWithMobile() async {
    authController.deviceId =  await authController.getId();

    if (_formKey.currentState.validate()) {
      var reset_url = apiUrls().MobileLoginOTP_api;
      var reset_body ={
        'mobile': widget.mobileNo.toString(),
        'otp':  authController.pinController.text,
        'fcm_id': _token.toString(),
        'device_id': authController.deviceId.toString()
      };
      Logger().d("chnage passsword url......${reset_url}\n${reset_body}");

      authController.LoginWithMobile(reset_url, reset_body);
    }
  }

  resend() async {

    if(isResend == true){
      var login_url = apiUrls().MobileSendOTP_api;
      var login_body = {
        'mobile': widget.mobileNo.toString(),
      };
   await apiCallingHelper().multipartAPICall(login_url, login_body,false);
      setState(() {
        secondsRemaining = 30;
        isResend = false;

        // isCounterRunning = true;
      });

    }

  }
  @override
  dispose(){
    focusNode.dispose();
    timer.cancel();
    super.dispose();
  }



  final defaultPinTheme = PinTheme(
    width: 75,
    height: 60,

    textStyle: TextStyle(
      fontSize: 22,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey)),
  );
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          isResend = true;
        });
      }
    });
    _getToken();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          // fit: StackFit.passthrough,
          children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                    color: Colors.white,
                    child: Image.asset(backgroundtop,width: size.width,fit: BoxFit.contain,)),
                Positioned(
                  top: 70,
                  child:  Image.asset(logo,color: white,scale: 1.8,),),
              ],
            ),
            Container(
              height: size.height-350,
              width: size.width,
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Enter OTP',
                                    style: TextStyles.loginTStyle),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Column(
                              children: [
                                Pinput(
                                  focusNode: focusNode,
                                  validator: Validations.pinputOtp,
                                  controller: authController.pinController,
                                  length: 4,

                                  keyboardType: TextInputType.number,
                                  // androidSmsAutofillMethod:AndroidSmsAutofillMethod.smsUserConsentApi,
                                  // listenForMultipleSmsOnAndroid: true,
                                  pinputAutovalidateMode:PinputAutovalidateMode.onSubmit,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                    defaultPinTheme.decoration.copyWith(
                                      border: Border.all(color: primary),
                                    ),
                                  ),
                                  errorPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                    defaultPinTheme.decoration.copyWith(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors
                                              .red), // Set the error border color to red
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  isCursorAnimationEnabled: true,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Didn't receive the OTP? ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: grey,
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    GestureDetector(
                                      onTap: resend,
                                      child: Text(
                                        isResend==true?"Resend":'Resend in ${secondsRemaining}s',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: primary,
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Regular'),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: LoginWithMobile,
                            child: Text(
                              'Login'.toUpperCase(),
                              style: TextStyles.BtnStyle,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),

        Positioned(
          top:35,
          left: 10,
          child: GestureDetector(
            onTap: () {
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(
                    systemNavigationBarColor: Color(
                        0xFFFFFFFF), // navigation bar color
                    statusBarColor: Color(
                        0xFF64C4DA), // status bar color
                  ));
              Get.back();
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color:
                  Colors.black45.withOpacity(0.0),
                  borderRadius: BorderRadius.all(
                      Radius.circular(50))),
              child: Icon(
                Icons.chevron_left,
                color: white,
                size: 30,
              ),
            ),
          ),
        )
          ],
        ),
      ),
    );
  }
}
