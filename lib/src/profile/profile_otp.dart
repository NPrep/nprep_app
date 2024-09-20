import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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

class OTPProfile extends StatefulWidget {

          var mobileController;

  OTPProfile( {this.mobileController});

  @override
  State<OTPProfile> createState() => _OTPProfileState();
}

class _OTPProfileState extends State<OTPProfile> {
  final _formKey = GlobalKey<FormState>();

  //api calling
  AuthController authController =Get.put(AuthController());
  TextEditingController pinController = TextEditingController();
  TextEditingController mobileControllerset = TextEditingController();
  CountDownController countDownController = CountDownController();

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

  updatesaveno() {
    if (_formKey.currentState.validate()) {
      var regis_url = apiUrls().updatemobile_api;
      var regis_body ={

        'mobile':mobileControllerset.text.toString(),

        'otp':pinController.text.toString()
      };
      authController.ProfileMobileRegister(regis_url, regis_body);
    }
  }
  sendotp() {


      var regis_url = apiUrls().send_otp_api;
      var regis_body ={
        'mobile': mobileControllerset.text.toString(),
        'is_register': "0",

      };
      authController.sentOTPProfile(regis_url, regis_body,);
      setState(() {
        isResend = false;
        // isCounterRunning = true;
      });
      // countDownController.start();


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
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return Stack(
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
                                      Text('Update Mobile'.toUpperCase(),
                                          style: TextStyles.loginTStyle),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                 authController. mobprofileLoading.value==true?Pinput(
                                    validator: Validations.pinputOtp,
                                    controller: pinController,
                                    length: 6,

                                    keyboardType: TextInputType.number,
                                    // androidSmsAutofillMethod:
                                    // AndroidSmsAutofillMethod
                                    //     .smsUserConsentApi,
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
                                  ):Container(),
                                  SizedBox(height: 15,),
                                  CustomTextFormField(
                                    controller: mobileControllerset,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please enter the mobile number';
                                      }
                                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                        return 'Please enter a valid 10-digit mobile number';
                                      }
                                      if (value==widget.mobileController) {
                                        return 'This number is already is used';
                                      }
                                      return null; // Validation passed
                                    },
                                    maxLength: 25,
                                    hintText: 'Mobile No.',
                                    l_icon: Image.asset(profile_user,scale: 3.5,),
                                    keyType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    // suffix: IconButton(icon: Icon(Icons.send),onPressed:(){
                                    //   sendotp();
                                    // } ,),
                                    formatter:  [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                    ],
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
                                  onPressed:  authController.mobprofileLoading.value==true?authController.registerLoading.value==true?null:updatesaveno:(){
                                    if(_formKey.currentState.validate()){
                                      FocusScope.of(context).unfocus();

                                      sendotp();
                                    }

                                  },
                                  child: Text(
                                    authController.mobprofileLoading.value==true?authController.registerLoading.value==true?'Please Wait..':'Update': 'Send OTP'.toUpperCase(),
                                    style: TextStyles.BtnStyle,
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
        ],
      );
            }
          )),
    );
  }
}
