import 'dart:async';
import 'dart:developer';

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

class OTPRegPassword extends StatefulWidget {
  var otpController;
  var nameController;
      var emailController;
          var mobileController;
              var passwordController;
                  var cPasswordController;
                  var selectedQualification;

                  var countryId;
                  var cityId;
                  var stateid;
                  var collegeid;
                  var other;
   OTPRegPassword( {
     this.otpController,
     this.selectedQualification,
     this.nameController,
     this.emailController,
     this.mobileController,
     this.passwordController,
     this.cPasswordController,
     this.countryId,
     this.cityId,
     this.stateid,
     this.collegeid,
     this.other,

   });

  @override
  State<OTPRegPassword> createState() => _OTPRegPasswordState();
}

class _OTPRegPasswordState extends State<OTPRegPassword> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  //api calling
  AuthController authController =Get.put(AuthController());
  TextEditingController pinController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isResend = false;

  ///-----Timer-----
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer timer;



  sendOtp() async {
    if (_formKey.currentState.validate()) {
      authController.deviceId =  await authController.getId();
      var _token = await FirebaseMessaging.instance.getToken();
      print("FCM Regstration: $_token");
      var regis_url = apiUrls().register_api;
      var regiss_body ={
        'name': widget.nameController.toString(),
        'email': widget.emailController.toString(),
        'mobile':widget.mobileController.toString(),
        'password':widget.passwordController.toString(),
        'password_confirmation': widget.cPasswordController.toString(),
        'otp':pinController.text.toString(),
        'qualification':widget.selectedQualification.toString()=="null"?"":widget.selectedQualification.toString(),
        'state_id':widget.stateid.toString()=="null"?"":widget.stateid.toString(),
        'country_id':widget.countryId.toString()=="null"?"":widget.countryId.toString(),
        'city_id':widget.cityId.toString()=="null"?"":widget.cityId.toString(),
        'college':widget.collegeid.toString()=="null"?"":widget.collegeid.toString(),
        'other_qualification':widget.other.toString()=="null"?"":widget.other.toString(),
        'fcm_id': _token.toString(),
        'device_id': authController.deviceId.toString()
      };
      log('reg_body==>'+regiss_body.toString());
      authController.Register(regis_url, regiss_body,widget.mobileController,pinController.text.toString(),_token,authController.deviceId);
    }
    // if(authController.registerLoading.value){
    //   toastMsg("Registering your request, please wait....", true);
    // }else{
    //   if (_formKey.currentState.validate()) {
    //     authController.deviceId =  await authController.getId();
    //     var _token = await FirebaseMessaging.instance.getToken();
    //     print("FCM Regstration: $_token");
    //     var regis_url = apiUrls().register_api;
    //     var regiss_body ={
    //       'name': widget.nameController.toString(),
    //       'email': widget.emailController.toString(),
    //       'mobile':widget.mobileController.toString(),
    //       'password':widget.passwordController.toString(),
    //       'password_confirmation': widget.cPasswordController.toString(),
    //       'otp':pinController.text.toString(),
    //       'qualifications':widget.selectedQualification.toString(),
    //       'state_id':widget.stateid.toString(),
    //       'country_id':widget.countryId.toString(),
    //       'city_id':widget.cityId.toString(),
    //       'college':widget.collegeid.toString(),
    //       'other_qualification':widget.other.toString(),
    //     };
    //     log('reg_body==>'+regiss_body.toString());
    //     authController.Register(regis_url, regiss_body,widget.mobileController,widget.cPasswordController,_token,authController.deviceId);
    //   }
    // }


  }

  resend() {

    if(enableResend == true){
      var regis_url = apiUrls().send_otp_api;
      var regis_body ={
        'mobile': widget.mobileController.toString(),
        'is_register': "1",

      };
      authController.sentOTPRegister(
          regis_url,
          regis_body,
          widget.nameController,
          widget.selectedQualification,
          widget.emailController,
          widget.mobileController,
          widget.passwordController,
          widget.cPasswordController,
          widget.collegeid,
          widget.cityId,
          widget.countryId,
          widget.stateid,
          widget.other
      );
      setState(() {
        secondsRemaining = 60;
        enableResend = false;
        // isCounterRunning = true;



      });
      // countDownController.start();
    }

  }

  formattedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
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
  @override
  dispose(){
    focusNode.dispose();

    timer.cancel();
    super.dispose();
  }
  startResendTime(){
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();

    startResendTime();
    log('selectedQualification==>'+widget.selectedQualification.toString());
    // pinController.text = widget.otpController.toString();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
return Scaffold(
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
                                controller: pinController,
                                length: 6,

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
                                        GetBuilder<AuthController>(
                                          builder: (authController) {
                                            return Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  onPressed: authController.registerLoading.value==true?null:sendOtp,
                                                  child: Text(
                                                    authController.registerLoading.value==true?'Please wait..':'Submit'.toUpperCase(),
                                                    style: TextStyles.BtnStyle,
                                                  )),
                                            );
                                          }
                                        ),
                    // Container(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //       onPressed: LoginWithMobile,
                    //       child: Text(
                    //         authController.registerLoading.value==true?'Please wait..':'Submit'.toUpperCase(),
                    //
                    //       // 'Login'.toUpperCase(),
                    //         style: TextStyles.BtnStyle,
                    //       )),
                    // ),
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
);
    // return Scaffold(
    //   backgroundColor: primary,
    //   body: SingleChildScrollView(
    //       child: Stack(
    //     // fit: StackFit.passthrough,
    //     children: [
    //       Column(
    //         children: [
    //           SizedBox(
    //             height: size.height * .1,
    //           ),
    //           Image.asset(
    //             logo,
    //             color: white,
    //             scale:1.4,
    //           ),
    //           SizedBox(
    //             height: size.height *.1,
    //           ),
    //           Image.asset(background)
    //         ],
    //       ),
    //       Positioned(
    //           top: 320,
    //           // height: MediaQuery.of(context).size.height*0.3,
    //           child: Container(
    //             height: size.height,
    //             width: size.width,
    //             // color: Colors.red,
    //             child: Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Form(
    //                 key: _formKey,
    //                 child: Column(
    //                   // crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.all(12),
    //                       child: Column(
    //                         children: [
    //                           Row(
    //                             children: [
    //                               Text('Registration OTP'.toUpperCase(),
    //                                   style: TextStyles.loginTStyle),
    //                             ],
    //                           ),
    //                           SizedBox(
    //                             height: size.height * 0.03,
    //                           ),
    //                           Column(
    //                             children: [
    //                               Pinput(
    //                                 validator: Validations.pinputOtp,
    //                                 controller: pinController,
    //                                 length: 6,
    //
    //                                 keyboardType: TextInputType.number,
    //                                 // androidSmsAutofillMethod:
    //                                 //     AndroidSmsAutofillMethod
    //                                 //         .smsUserConsentApi,
    //                                 // listenForMultipleSmsOnAndroid: true,
    //                                 pinputAutovalidateMode:
    //                                     PinputAutovalidateMode.onSubmit,
    //                                 defaultPinTheme: defaultPinTheme,
    //                                 focusedPinTheme: defaultPinTheme.copyWith(
    //                                   decoration:
    //                                       defaultPinTheme.decoration.copyWith(
    //                                     border: Border.all(color: primary),
    //                                   ),
    //                                 ),
    //                                 errorPinTheme: defaultPinTheme.copyWith(
    //                                   decoration:
    //                                       defaultPinTheme.decoration.copyWith(
    //                                     borderRadius: BorderRadius.circular(5),
    //                                     border: Border.all(
    //                                         color: Colors
    //                                             .red), // Set the error border color to red
    //                                   ),
    //                                 ),
    //                                 inputFormatters: [
    //                                   FilteringTextInputFormatter.digitsOnly
    //                                 ],
    //                                 isCursorAnimationEnabled: true,
    //                               ),
    //
    //                               SizedBox(height: 10,),
    //                               Row(
    //                                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   GestureDetector(
    //                                     onTap: resend,
    //                                     child: Text(
    //                                       'Resend OTP',
    //                                       style: TextStyle(
    //                                           fontWeight: FontWeight.w400,
    //                                           color: enableResend==false?grey:Colors.black,
    //                                           fontSize: 16,
    //                                           fontFamily: 'Poppins-Regular'),
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     '${formattedTime(secondsRemaining)}',
    //                                     style: TextStyle(color: enableResend==true?grey:Colors.black, fontSize: 15),
    //                                   ),
    //                                   // Container(
    //                                   //  // color: Colors.red,
    //                                   //   child: CircularCountDownTimer(
    //                                   //     width: 100,
    //                                   //     height: 50,
    //                                   //     duration: 60,
    //                                   //     fillColor: Colors.transparent,strokeWidth: 0.2,
    //                                   //     ringColor: Colors.transparent,backgroundColor:Colors.transparent ,
    //                                   //     controller: countDownController,
    //                                   //     initialDuration: 0,
    //                                   //
    //                                   //     textFormat: CountdownTextFormat.MM_SS,
    //                                   //     isReverse: true,
    //                                   //     isReverseAnimation: true,
    //                                   //     isTimerTextShown: true,
    //                                   //     autoStart:true,
    //                                   //     //isCounterRunning,
    //                                   //     onStart: (){
    //                                   //
    //                                   //     },
    //                                   //     onComplete: () {
    //                                   //       print('isResend  ............. outside of setStaste${isResend}');
    //                                   //       setState(() {
    //                                   //         isResend = true;
    //                                   //         print('isResend  ............. inside of setStaste${isResend}');
    //                                   //       });
    //                                   //     },
    //                                   //
    //                                   //     textStyle: TextStyle(
    //                                   //
    //                                   //         fontWeight: FontWeight.w400,
    //                                   //         color: grey,
    //                                   //         fontSize: 16,
    //                                   //         fontFamily: 'Poppins-Regular'),
    //                                   //   ),
    //                                   // )
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //
    //                           SizedBox(
    //                             height: 15,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 5,
    //                     ),
    //                     GetBuilder<AuthController>(
    //                       builder: (authController) {
    //                         return Container(
    //                           width: double.infinity,
    //                           child: ElevatedButton(
    //                               onPressed: authController.registerLoading.value==true?null:sendOtp,
    //                               child: Text(
    //                                 authController.registerLoading.value==true?'Please wait..':'Submit'.toUpperCase(),
    //                                 style: TextStyles.BtnStyle,
    //                               )),
    //                         );
    //                       }
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ))
    //     ],
    //   )),
    // );
  }
}
