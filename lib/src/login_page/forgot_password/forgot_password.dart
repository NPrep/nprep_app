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
import 'package:n_prep/main.dart';

import 'package:n_prep/utils/colors.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  //api calling
  AuthController authController =Get.put(AuthController());




  sendOtp(){
    if(authController.forgotLoading.value){
      toastMsg("Forgoting your request, please wait....", true);
    }else{
      if (_formKey.currentState.validate()) {
        var forgot_url = apiUrls().forgotpassword_api;
        var forgot_body ={
          'mobile': authController.emailController.text,
        };


        authController.ForgotPass(forgot_url, forgot_body,skipNavigation: false);

      }
    }

  }

  bool isRegister = true;
  @override
  void initState() {
    super.initState();
    authController.emailController.clear();
    authController.emailController.text = sprefs.getString("mobile");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
          child: Stack(
            // fit: StackFit.passthrough,
            children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1,),
                  Image.asset(logo,color: white,scale: 1.5,),
                  SizedBox(height: MediaQuery.of(context).size.height * .1,),
                  Image.asset(background)
                ],
              ),
              Positioned(
                  top: 360,

                  // height: MediaQuery.of(context).size.height*0.3,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Forgot Password ?'.toUpperCase(),
                                          style: TextStyles.loginTStyle
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                  sizebox_height_15,
                                  CustomTextFormField(
                                    controller: authController.emailController,
                                    validator: Validations.validateMobile,
                                    maxLength: 25,
                                    hintText: 'Mobile No.',
                                    l_icon: Image.asset(profile_user,scale: 3.5,),
                                    keyType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    formatter:  [
                                  FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]'))
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  // Text('A OTP will be sent to your \n registered Email ID',
                                  // maxLines: 2,
                                  // textAlign: TextAlign.center,
                                  // style: TextStyle(
                                  //   fontSize: 16,
                                  //   fontWeight: FontWeight.w400,
                                  //   color: grey,
                                  // ),),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: sendOtp,

                                  child: Text('send otp'.toUpperCase(),style: TextStyles.BtnStyle,)

                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  )
              )
            ],
          )
      ),
    );
  }
}
