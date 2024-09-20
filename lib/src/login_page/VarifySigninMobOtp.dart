import 'dart:developer';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:pinput/pinput.dart';

import '../../constants/Api_Urls.dart';
import '../../constants/validations.dart';


class SignInMobileOtpScreen extends StatefulWidget {
final mobileNo;
  const SignInMobileOtpScreen({Key key,this.mobileNo});

  @override
  State<SignInMobileOtpScreen> createState() => _SignInMobileOtpScreenState();
}

class _SignInMobileOtpScreenState extends State<SignInMobileOtpScreen> {

  final _formKey = GlobalKey<FormState>();


  CountDownController countDownController = CountDownController();
  AuthController authController =Get.put(AuthController());
  bool obscureText = true;

// Toggles the password show status

  void toggle() {
    setState((){
      obscureText = !obscureText;
    });
  }

  bool isRegister = true;
  bool isResend = false;
  @override
  void initState() {
    log('mobile==>'+widget.mobileNo.toString());
    log('otp==>'+authController.pinputOtpCtrl.text.toString());
    super.initState();
  }
resend(){
  var social_otpSend_url = apiUrls().Social_send_otp_api;
  var body ={
    'mobile':widget.mobileNo.toString(),
  };
  log('social_otpSend_url==>'+social_otpSend_url.toString());
  log('body==>'+body.toString());
  authController.SignInWithmobile(social_otpSend_url,body);
}
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    log(size.height.toString());
    return Scaffold(
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
                  Text('Please enter OTP received on your mobile',style: TextStyle(
                    fontSize: 19,
                    fontFamily:'Poppins-Regular',
                    color: black54,
                    letterSpacing: -0.3,
                  ),),
                  SizedBox(height: 29,),
                  Pinput(
                    validator: Validations.pinputOtp,
                    controller: authController.pinputOtpCtrl,
                    length: 6,
                    keyboardType: TextInputType.number,
                    // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                    // listenForMultipleSmsOnAndroid: true,
                    pinputAutovalidateMode:
                    PinputAutovalidateMode.onSubmit,
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
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: resend,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: grey,
                              fontSize: 16,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ),
                      CircularCountDownTimer(
                        width: 40,
                        height: 40,
                        duration: 60,
                        fillColor: Colors.transparent,
                        ringColor: Colors.transparent,
                        controller: countDownController,
                        initialDuration: 0,
                        textFormat: CountdownTextFormat.MM_SS,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart:true,
                        //isCounterRunning,
                        onStart: (){

                        },
                        onComplete: () {
                          print('isResend  ............. outside of setStaste ${isResend}');
                          setState(() {
                            isResend = true;
                            print('isResend  ............. inside of setStaste${isResend}');
                          });
                        },

                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: grey,
                            fontSize: 16,
                            fontFamily: 'Poppins-Regular'),
                      )
                    ],
                  ),
                  sizebox_height_35,

                  GestureDetector(
                    onTap: (){
                      if(_formKey.currentState.validate()) {
                        var Social_otp_verify_url = apiUrls()
                            .Social_otp_verify_api;
                        var body = {
                          'mobile': widget.mobileNo.toString(),
                          'otp': authController.pinputOtpCtrl.text.toString(),
                        };
                        log('social_otpSend_url==>' +
                            Social_otp_verify_url.toString());
                        log('body==>' + body.toString());
                        authController.SignOtpVerify(
                            Social_otp_verify_url, body);
                      }
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
                      Text("Verify OTP",style: TextStyle(color: white,
                          fontSize: 17,fontWeight: FontWeight.w600),) ,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}
