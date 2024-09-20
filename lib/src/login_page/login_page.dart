import 'dart:developer';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/drawer_items/privacy_policy.dart';
import 'package:n_prep/src/drawer_items/t&c.dart';
import 'package:n_prep/src/login_page/forgot_password/forgot_password.dart';
import 'package:n_prep/src/registration_page/registration_otp.dart';
import 'package:n_prep/utils/colors.dart';
import '../../constants/validations.dart';
import '../Nphase2/Google_Apple_SignIn/auth.dart';
import '../registration_page/registartion_page.dart';
import 'SignInWithMobile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  AuthController authController =Get.put(AuthController());
  bool obscureText = true;

// Toggles the password show status

  void toggle() {
    setState((){
      obscureText = !obscureText;
    });
  }
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




  signIn() async {
    if(authController.loginLoading.value){
      toastMsg("Logging your request, please wait....", true);
    }else{
      if (_formKey.currentState.validate()) {
        authController.deviceId =  await authController.getId();
        if(authController.deviceId.toString()!="null"){
          var login_url = apiUrls().login_api;
          var login_body ={
            'mobile': mobileController.text,
            'password': passwordController.text,
            'fcm_id': _token.toString(),
            'device_id': authController.deviceId.toString()
          };

          authController.Login(login_url, login_body,false);
        }else{
          // toastMsg("Device id not found", true);
          print("Device id not found");
        }




      }
    }

  }
  MobilesignIn() async {
    if(authController.loginLoading.value){
      toastMsg("Logging your request, please wait....", true);
    }else{
      if (_formKey.currentState.validate()) {
        authController.deviceId =  await authController.getId();
        if(authController.deviceId.toString()!="null"){
          var login_url = apiUrls().MobileSendOTP_api;
          var login_body ={
            'mobile': mobileController.text,
          };

          authController.MobileSendOTP(login_url, login_body,false);
        }else{
          // toastMsg("Device id not found", true);
          print("Device id not found");
        }




      }
    }

  }
  bool isRegister = true;

  @override
  void initState() {
    // TODO: implement initState
    _getToken();

    super.initState();
    authController.loginLoading.value==false;

  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    Size size =  MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    var mediaquary=MediaQuery.of(context);

    var scale = mediaquary.textScaleFactor.clamp(0.1, 0.9);

    log(size.height.toString());
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: white,

      body:      MediaQuery(
        child: GetBuilder<AuthController>(
            builder: (authController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12,right: 12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            Padding(padding: EdgeInsets.only(left: 12,right: 12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Login'.toUpperCase(),style: TextStyles.loginTStyle
                                      ),
                                    ],
                                  ),
                                  sizebox_height_15,
                                  CustomTextFormField(
                                    controller: mobileController,
                                    validator: Validations.validateMobile,
                                    maxLength: 10,
                                    hintText: 'Mobile No.',
                                    l_icon: Image.asset(profile_user,scale: 3,),
                                    keyType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  // sizebox_height_15,
                                  // CustomTextFormField(
                                  //   controller: passwordController,
                                  //   validator: Validations.validatePassword,
                                  //
                                  //   maxLength: 12,
                                  //   hintText: 'Password',
                                  //   l_icon: Image.asset(password_icon,scale: 3,),
                                  //   keyType: TextInputType.visiblePassword,
                                  //   textInputAction: TextInputAction.done,
                                  //   obscure: obscureText,
                                  //   suffix: IconButton(
                                  //     icon: obscureText==true?Icon(Icons.visibility_off,size: 16,)
                                  //         :Icon(Icons.visibility,size: 16),
                                  //     onPressed: (){
                                  //       toggle();
                                  //     },
                                  //   ),
                                  // ),
                                  sizebox_height_10,
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         //way to forgot password
                                  //         Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) => ForgotPassword()));
                                  //       },
                                  //       child: Text('Forgot Password?',
                                  //           style: TextStyles.header),
                                  //     ),
                                  //   ],
                                  // ),
                                  sizebox_height_10,
                                ],
                              ),
                            ),
                            sizebox_height_5,
                            GestureDetector(
                              onTap: (){
                                MobilesignIn();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: size.width,
                                height:orientation==Orientation.portrait?height*0.055 :height*0.13,

                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),

                                child:
                                authController.loginLoading.value==true?Container(
                                  // height:30,

                                    width: size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Center(
                                              child: CircularProgressIndicator(color: white,strokeWidth: 3.0,)
                                          ),
                                          height: 20.0,
                                          width: 20.0,
                                        ),
                                        SizedBox(width: 15,),
                                        Text("Please wait..",style: TextStyle(color: white),)
                                      ],
                                    )
                                ):
                                Text("SUBMIT",style: TextStyle(color: white,letterSpacing: 0.8,
                                    fontSize: 17,fontWeight: FontWeight.w600),) ,
                              ),
                            ),
                            sizebox_height_10,
                            // RichText(
                            //   text: TextSpan(
                            //     text: "Don't have an account ? ",
                            //     style:  TextStyles.loginB1Style,
                            //     children: [
                            //       TextSpan(
                            //         text: 'Register',
                            //         style:  TextStyles.loginB2Style,
                            //         recognizer: TapGestureRecognizer()
                            //           ..onTap = () {
                            //             // Get.to(OTPRegPassword(nameController:"nameController",emailController: "emailController",mobileController: "mobileController",passwordController: "passwordController",cPasswordController: "cPasswordController"));
                            //
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) =>  RegistrationPage(),
                            //               ),
                            //             );
                            //           },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Platform.isIOS?Container():  sizebox_height_20,
                            Platform.isIOS?Container(): Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 50,height:2,color: Colors.grey.shade700.withOpacity(0.8),),
                                Container(alignment:Alignment.center,width: 50,child: Text("Or",style: TextStyle(color: Colors.grey.shade700.withOpacity(0.8)),)),
                                Container(width: 50,height:2,color: Colors.grey.shade700.withOpacity(0.8),),
                              ],),
                            sizebox_height_20,
                            Platform.isIOS?Container(): GestureDetector(
                              onTap: () async {
                                log('hh==>');

                                // Get.to(SignInWithMobile());
                                if(authController.googleloginLoading.value==false){

                                  authController.updatelogin();

                                  await AuthMethods().signInWithGoogle(context);

                                  authController.googleloginLoading.value=false;
                                  setState(() {

                                  });
                                }else{
                                  toastMsg("Please wait...", true);
                                }

                              },
                              child: Container(
                                height:orientation==Orientation.portrait?height*0.055 :height*0.13,
                                margin: EdgeInsets.symmetric(horizontal: 50.0),
                                child: Material(
                                  elevation: 10.0,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(color: Colors.black.withOpacity(0.8)),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: authController.googleloginLoading.value==true?
                                    Container(
                                      // height:30,

                                      width: size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Center(
                                                  child: CircularProgressIndicator(color: primary,strokeWidth: 3.0,)
                                              ),
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                            SizedBox(width: 15,),
                                            Text("Please wait..")
                                          ],
                                        )
                                    ):Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 25,
                                            width: 25,
                                            child: Image.asset("assets/nprep2_images/google.png")),
                                        SizedBox(
                                          width: 20.0,
                                        ),

                                        Center(
                                          child: Text(
                                            "Sign in with Google",
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.8),
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     AuthMethods().signInWithApple();
                            //   },
                            //   child: Container(
                            //     margin: EdgeInsets.symmetric(horizontal: 10.0),
                            //     child: Material(
                            //       elevation: 10.0,
                            //       borderRadius: BorderRadius.circular(30),
                            //       child: Container(
                            //         padding:
                            //         EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                            //         decoration: BoxDecoration(
                            //             color: primary,
                            //             borderRadius: BorderRadius.circular(30)),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: [
                            //             Container(
                            //                 height: 25,
                            //                 width: 25,
                            //                 child: Image.asset("assets/nprep2_images/apple.png")),
                            //             SizedBox(
                            //               width: 30.0,
                            //             ),
                            //             Center(
                            //               child: Text(
                            //                 "Sign in with Apple",
                            //                 style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 17.0,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,

                  child: Padding(
                    padding: EdgeInsets.only(left: size.height*0.05,right:size.height*0.05 ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "By continuing, you agree with ",
                        style:  TextStyle(
                          fontSize: 12,
                          color: grey,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Condition',
                            style: TextStyle(
                              fontSize: 12,
                              color: primary,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsConditions(),
                                  ),
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              fontSize: 12,
                              color: grey,
                              fontWeight: FontWeight.w400,
                            ),

                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: primary,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPolicy(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,)

              ],
            );
          }
        ),
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

      ),
    );
  }
}
