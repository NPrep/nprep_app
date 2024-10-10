import 'dart:async';

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

class ResetPassword extends StatefulWidget {

  const ResetPassword( {Key key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  //api calling
  AuthController authController =Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  // TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  Timer _timer;
  int _duration = 60;
  var email;
  bool isResend = false;
  bool isCounterRunning = false;
  bool isRegister = true;
  bool obscureText = true;
  bool confirmobscureText = true;

// Toggles the password show status

  void toggle() {
    setState((){
      obscureText = !obscureText;
    });
  }
  void confirmtoggle() {
    setState((){
      confirmobscureText = !confirmobscureText;
    });
  }

  sendOtp() {
    if (_formKey.currentState.validate()) {
      var reset_url = apiUrls().resetPassword_api;
      var reset_body ={
        'mobile': authController.emailController.text,
        'motp':  authController.pinController.text,
        'password':  passwordController.text,
        'password_confirmation':  cPasswordController.text,
      };
      Logger().d("chnage passsword url......${reset_url}\n${reset_body}");

      authController.ResetPass(reset_url, reset_body);
    }
  }

  resend() {

    if(isResend == true){
      var resend_url = apiUrls().forgotpassword_api;
      var resend_body = {
        'mobile': authController.emailController.text,
      };
      authController.ForgotPass(resend_url, resend_body,skipNavigation: true);
      setState(() {
        isResend = false;
        // isCounterRunning = true;
      });
    }

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

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_duration > 0) {
        setState(() {
          _duration--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResend = true;
        });
        print('Timer completed, isResend: $isResend');
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  void initState() {
    super.initState();
    startTimer();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
          child: Stack(
        // fit: StackFit.passthrough,
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height * .1,
              ),
              Image.asset(
                logo,
                color: white,
                scale:1.4,
              ),
              SizedBox(
                height: size.height *.1,
              ),
              Image.asset(background)
            ],
          ),
          Positioned(
              top: 320,
              // height: MediaQuery.of(context).size.height*0.3,
              child: Container(
                height: size.height,
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
                                  Text('Reset Password ?'.toUpperCase(),
                                      style: TextStyles.loginTStyle),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Column(
                                children: [
                                  Pinput(
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
                                      Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          formatTime(_duration),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'Poppins-Regular',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              CustomTextFormField(
                                textInputAction: TextInputAction.next,
                                controller: passwordController,
                                keyType: TextInputType.visiblePassword,
                                // obscure: true,
                                l_icon: Image.asset(
                                  password_icon,
                                  scale: 3,
                                ),
                                hintText: 'Password',
                                maxLength: 12,
                                validator: Validations.validatePassword,
                                obscure: obscureText,
                                suffix: IconButton(
                                  icon: obscureText==true?Icon(Icons.visibility_off,size: 16,):Icon(Icons.visibility,size: 16),
                                  onPressed: (){
                                    toggle();
                                  },
                                ),
                              ),
                              sizebox_height_15,

                              CustomTextFormField(
                                textInputAction: TextInputAction.done,
                                controller: cPasswordController,
                                keyType: TextInputType.visiblePassword,
                                l_icon: Image.asset(
                                  password_icon,
                                  scale: 3,
                                ),
                                hintText: 'Confirm Password',
                                maxLength: 12,
                                validator: (value) =>
                                    Validations.validateConfirmPassword(
                                  passwordController.text,
                                  value,
                                ),
                                obscure: confirmobscureText,
                                suffix: IconButton(
                                  icon: confirmobscureText==true?Icon(Icons.visibility_off,size: 16,):Icon(Icons.visibility,size: 16),
                                  onPressed: (){
                                    confirmtoggle();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
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
                              onPressed: sendOtp,
                              child: Text(
                                'Submit'.toUpperCase(),
                                style: TextStyles.BtnStyle,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      )),
    );
  }
}
