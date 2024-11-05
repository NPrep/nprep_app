import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import '../../Service/Service.dart';
import '../../constants/images.dart';
import '../../constants/validations.dart';
import '../../utils/colors.dart';

class RegistrationPage extends StatefulWidget {
  final NotRegisteredNumber;
  const RegistrationPage({Key key,this.NotRegisteredNumber});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController cPasswordController = TextEditingController();
  TextEditingController jobQualiCtrl = TextEditingController();
  TextEditingController collegeCtrl = TextEditingController();
  TextEditingController otherCtrl = TextEditingController();
  AuthController authController =Get.put(AuthController());

  ///for Country,City,State....
  var urlCountry, urlState, urlCity;

  Future<void> getCountry(url, id, name) async {
    selectCountry_id = "99";
    selectCountry = "India";
    getState(urlState + selectCountry_id.toString(),
        null, null);
    setState(() {

    });
    // print("get url url: $url");
    // print("get id id: $id");
    // print("get name name: $name");
    // var _mainHeaders = {
    //   apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
    //   apiUrls().Authorization: apiUrls().AuthorizationKey,
    // };
    // try {
    //   final request = http.MultipartRequest('GET', Uri.parse(url));
    //   request.headers.addAll(_mainHeaders);
    //
    //   http.StreamedResponse responses = await request.send();
    //
    //   var responsedata = await http.Response.fromStream(responses);
    //
    //   print("response body...." + responsedata.toString());
    //   final result = jsonDecode(responsedata.body.toString());
    //
    //   if (responsedata.statusCode == 200) {
    //     var msg = result['message'];
    //     // Fluttertoast.showToast(msg: msg.toString());
    //
    //     setState(() {
    //       countryList.clear();
    //       countryList.addAll(result['data']);
    //       print("countryList...." + countryList.toString());
    //       if (id != null) {
    //         selectCountry_id = id;
    //         selectCountry = name;
    //         var urlState1 = apiUrls().state_api + "${selectCountry_id}";
    //         print("urlState......." + urlState1.toString());
    //         // selectState= profileController.profileData['data']['state'].toString();
    //         // selectState_id= profileController.profileData['data']['state_id'].toString();
    //
    //         // getState(
    //         //     urlState1,
    //         //     profileController.profileData['data']['state_id'],
    //         //     profileController.profileData['data']['state']);
    //
    //         print("selectCountry_id....if.." + selectCountry_id.toString());
    //         print("selectCountry....if.." + selectCountry.toString());
    //         setState(() {});
    //       } else {
    //
    //       }
    //     });
    //   }
    //   else if (responsedata.statusCode == 404) {
    //     var msg = result['message'];
    //     Fluttertoast.showToast(msg: msg.toString());
    //   }
    // } on SocketException {
    //   throw FetchDataException('No Internet connection');
    // } on TimeoutException {
    //   throw FetchDataException('Something went wrong, try again later');
    // }
  }

  Future<void> getState(url, id, name) async {
    // print("url for state  :"+url.toString());
    // print("id  :"+id.toString());
    // print("name  :"+name.toString());

    var _mainHeaders = {
      apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
      apiUrls().Authorization: apiUrls().AuthorizationKey,
    };
    try {
      final request = http.MultipartRequest('GET', Uri.parse(url));
      request.headers.addAll(_mainHeaders);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      print("response body...." + responsedata.toString());
      final result = jsonDecode(responsedata.body);
      print("result....." + result.toString());
      if (responsedata.statusCode == 200) {
        setState(() {
          stateList.addAll(result['data']);
          print("stateList...." + stateList.toString());
          if (id != null) {
            selectState_id = id.toString();
            selectState = name.toString();
            print("selectState_id..." + selectState_id.toString());

            var urlCity1 = apiUrls().city_api + "${selectState_id}";

            print("urlCity1......." + urlCity1.toString());

            // getCity(urlCity1, profileController.profileData['data']['city_id'],
            //     profileController.profileData['data']['city']);
          } else {}
        });
      } else if (responsedata.statusCode == 422) {
        var msg = result['message'];
        // Fluttertoast.showToast(msg: msg.toString());
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<void> getCity(url, id, name) async {
    print("url for city  :" + url.toString());
    print("id city :" + id.toString());
    print("name city :" + name.toString());
    var _mainHeaders = {
      apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
      apiUrls().Authorization: apiUrls().AuthorizationKey,
    };
    try {
      final request = http.MultipartRequest('GET', Uri.parse(url));
      request.headers.addAll(_mainHeaders);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      print("response body...." + responsedata.toString());
      final result = jsonDecode(responsedata.body);
      print("result....." + result.toString());
      if (responsedata.statusCode == 200) {
        // stateList.clear();
        cityList.clear();
        setState(() {
          cityList.addAll(result['data']);
          print("cityList...." + cityList.toString());
          if (id.toString() != "null") {
            selectCity = name.toString();
            selectCity_id = id.toString();
          } else {}
        });
      } else if (responsedata.statusCode == 404) {
        // var msg = result['message'];
        // Fluttertoast.showToast(msg: msg.toString());
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  var getstate, getstate_id;
  var getcity, getcity_id;
  var selectCountry;
  var selectCountry_id;
  List countryList = [];

  var selectState;
  var selectState_id;
  List stateList = [];

  var selectCity;
  var selectCity_id;
  List cityList = [];





  var qualificationId;
  var collegeId;
  register() {
    if (_formKey.currentState.validate()) {

if(authController.registerLoading.value){
  toastMsg("Otp is sending to your ${mobileController.text}, please wait....", true);
}
else{
  var regis_url = apiUrls().send_otp_api;
  var regis_body ={
    'mobile': mobileController.text,
    'is_register': "1",

  };
  authController.sentOTPRegister(regis_url, regis_body,nameController.text,qualificationId,emailController.text,mobileController.text,
      "null","null",collegeId,selectCity_id.toString(),selectCountry_id.toString(), selectState_id.toString(),otherCtrl.text);

}

  }
  }

  String _selectedQualification;
  String selectCollege;
  @override
  void initState() {
    urlCountry = apiUrls().country_api.toString();
    urlState = apiUrls().state_api;
    urlCity = apiUrls().city_api;
    getCountry(urlCountry, null, null);
    if(widget.NotRegisteredNumber!=null){
      mobileController.text=widget.NotRegisteredNumber.toString();
      log('NotRegisteredNumber==>'+widget.NotRegisteredNumber.toString());
    }else{
      mobileController.text;
    }
    getQualificationData();
    super.initState();
  }

  getQualificationData() async {
  await  authController.getQualificationList();
  log('getQualificationList==>'+authController.qualificationData.toString());

  setState(() {

  });
  }
  getCollagesData(selectCity) async {
    await  authController.getcollagesList(selectCity);
    log('collagesData==>'+authController.collagesData.toString());
    log('collagesData1==>'+authController.collagesData[0].toString());

    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        // extendBody: true,
        backgroundColor: white,
        // backgroundColor: primary,
        // body: SingleChildScrollView(
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: [
        //       Column(
        //
        //         children: [
        //           Image.asset(backfull,),
        //           // SizedBox(
        //           //   height: MediaQuery.of(context).size.height * .1,
        //           // ),
        //           // Image.asset(
        //           //   logo,
        //           //   color: white,
        //           //   scale: 1.5,
        //           // ),
        //           // SizedBox(
        //           //   height: MediaQuery.of(context).size.height * .1,
        //           // ),
        //
        //           // Container(
        //           //   // For adjustment of bottom (It useful when error comes from all fields
        //           //   width:  MediaQuery.of(context).size.width,
        //           //   height: 50,
        //           // )
        //         ],
        //       ),
        //       Positioned(
        //         top: 50,
        //         child: Container(
        //           alignment: Alignment.center,
        //           child: Image.asset(
        //           logo,
        //           color: white,
        //           scale: 1.5,
        //       ),
        //         ),),
        //       Positioned(
        //           top: checksize(size.height),
        //
        //           // height: MediaQuery.of(context).size.height*0.3,
        //           child: Container(
        //             height: MediaQuery.of(context).size.height,
        //             width: MediaQuery.of(context).size.width,
        //             // color: Colors.white,
        //             child: Padding(
        //               padding: const EdgeInsets.all(16.0),
        //               child: Form(
        //                 key: _formKey,
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.all(12.0),
        //                       child: Column(
        //                         children: [
        //                           Row(
        //                             children: [
        //                               Text('Register'.toUpperCase(),
        //                                   style: TextStyles.loginTStyle),
        //                             ],
        //                           ),
        //                           SizedBox(
        //                             height: MediaQuery.of(context).size.height * 0.01,
        //                           ),
        //                           CustomTextFormField(
        //                             keyType: TextInputType.name,
        //                             l_icon: Image.asset(profile_user,scale: 2.8,),
        //                             hintText: 'Name',
        //                             maxLength: 25,
        //                             validator: Validations.validateName,
        //                             controller: nameController,
        //                             textInputAction: TextInputAction.next,
        //                           ),
        //                           sizebox_height_15,
        //                           CustomTextFormField(
        //                             keyType: TextInputType.phone,
        //                             l_icon: Image.asset(profile_phone,width: 22,height: 24,color: primary,),
        //                             hintText: 'Mobile No.',
        //                             maxLength: 10,
        //                             validator: Validations.validateMobile,
        //                             controller: mobileController,
        //                             textInputAction: TextInputAction.next,
        //                           ),
        //                           sizebox_height_15,
        //                           CustomTextFormField(
        //                             textInputAction: TextInputAction.next,
        //                             controller: emailController,
        //                             validator: Validations.validateEmail,
        //                             maxLength: 25,
        //                             hintText: 'Email',
        //                             l_icon: Image.asset(profile_email,scale: 3,color: primary,),
        //                             keyType: TextInputType.emailAddress,
        //                           ),
        //                           sizebox_height_15,
        //                           CustomTextFormField(
        //                             textInputAction: TextInputAction.next,
        //                             controller: passwordController,
        //                             keyType: TextInputType.visiblePassword,
        //                             obscure: true,
        //                             l_icon: Image.asset(password_icon,scale: 3,),
        //                             hintText: 'Password',
        //                             maxLength: 12,
        //                             validator: Validations.validatePassword,
        //                           ),
        //                           sizebox_height_15,
        //                           CustomTextFormField(
        //                             textInputAction: TextInputAction.done,
        //                             controller: cPasswordController,
        //                             keyType: TextInputType.visiblePassword,
        //                             obscure: true,
        //                             l_icon: Image.asset(password_icon,scale: 3,),
        //                             hintText: 'Confirm Password',
        //                             maxLength: 12,
        //                             validator: (value) =>
        //                                 Validations.validateConfirmPassword(
        //                                   passwordController.text,
        //                                   value,
        //                                 ),  ),
        //                           SizedBox(
        //                             height: MediaQuery.of(context).size.height * 0.05,
        //                           ),
        //                           Container(
        //                             width: double.infinity,
        //                             child: ElevatedButton(
        //                                 onPressed: () {
        //                                   register();
        //                                 },
        //                                 child: Text(
        //                                   'Sign up'.toUpperCase(),
        //                                   style: TextStyles.BtnStyle,
        //                                 )),
        //                           ),
        //                           SizedBox(
        //                             height: MediaQuery.of(context).size.height * 0.01,
        //                           ),
        //                           Padding(
        //                             padding: const EdgeInsets.only(bottom: 20),
        //                             child: RichText(
        //                               text: TextSpan(
        //                                 text: "Already Have Account ? ",
        //                                 style:  TextStyles.loginB1Style,
        //                                 children: [
        //                                   TextSpan(
        //                                     text: 'Login',
        //                                     style: TextStyles.loginB2Style,
        //                                     recognizer: TapGestureRecognizer()
        //                                       ..onTap = () {
        //                                         Navigator.push(
        //                                           context,
        //                                           MaterialPageRoute(
        //                                             builder: (context) => LoginPage(),
        //                                           ),
        //                                         );
        //                                       },
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //
        //
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ))
        //     ],
        //   ),
        // ),
        body:  SingleChildScrollView(

          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      color: Colors.white,
                      child: Image.asset(backgroundtop,width: size.width,)),
                  Positioned(
                    top: 60,
                    child:  Image.asset(logo,color: white,scale: 1.4,),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Register'.toUpperCase(),
                                    style: TextStyles.loginTStyle),
                              ],
                            ),
                            sizebox_height_20,
                            CustomTextFormField(
                              keyType: TextInputType.name,
                              l_icon: Image.asset(profile_user,scale: 2.8,),
                              hintText: 'Name',
                              maxLength: 50,
                              validator: Validations.validateName,
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                            ),
                            sizebox_height_15,
                            CustomTextFormField(
                              keyType: TextInputType.phone,
                              l_icon: Image.asset(profile_phone,width: 22,height: 24,color: primary,),
                              hintText: 'Mobile No.',
                              maxLength: 10,
                              validator: Validations.validateMobile,
                              controller: mobileController,
                              textInputAction: TextInputAction.next,
                            ),
                            sizebox_height_15,
                            CustomTextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: Validations.validateEmail,
                              hintText: 'Email',
                              l_icon: Image.asset(profile_email,scale: 3,color: primary,),
                              keyType: TextInputType.emailAddress,
                            ),
                            sizebox_height_15,
                            // CustomTextFormField(
                            //   textInputAction: TextInputAction.next,
                            //   controller: passwordController,
                            //   keyType: TextInputType.visiblePassword,
                            //   obscure: true,
                            //   l_icon: Image.asset(password_icon,scale: 3,),
                            //   hintText: 'Password',
                            //   maxLength: 20,
                            //   validator: Validations.validatePassword,
                            // ),
                            // sizebox_height_15,
                            // CustomTextFormField(
                            //   textInputAction: TextInputAction.done,
                            //   controller: cPasswordController,
                            //   keyType: TextInputType.visiblePassword,
                            //   obscure: true,
                            //   l_icon: Image.asset(password_icon,scale: 3,),
                            //   hintText: 'Confirm Password',
                            //   maxLength: 20,
                            //   validator: (value) => Validations.validateConfirmPassword(
                            //         passwordController.text, value,
                            //       ),  ),
                            sizebox_height_10,
                            /// SELECT COUNTRY DROPDOWN HERE ======
                            // Row(
                            //   children: [
                            //     Image.asset(country_icon,scale: 11,),
                            //     // Icon(
                            //     //   Icons.location_city_outlined,
                            //     //   size: 22,
                            //     //   color: primary,
                            //     // ),
                            //     Expanded(
                            //       child: Padding(
                            //         padding: EdgeInsets.only(left: 11.0),
                            //         child: DropdownButtonFormField(
                            //           decoration: InputDecoration(
                            //             contentPadding: EdgeInsets.only(left: 5, right: 5),
                            //           ),
                            //           dropdownColor: white,
                            //           value: selectCountry,
                            //           hint: Text(
                            //             'Select Country',
                            //             style:TextStyles.HintStyle,
                            //           ),
                            //           isExpanded: true,
                            //           onChanged: (value) {
                            //             setState(() {
                            //               selectCountry = value;
                            //               print("selectCountry check on changv....." +
                            //                   selectCountry.toString());
                            //             });
                            //           },
                            //           // onSaved: (value) {
                            //           //   setState(() {
                            //           //     selectCountry_id = value;
                            //           //   });
                            //           // },
                            //           // validator: (value) {
                            //           //   if (value == null) {
                            //           //     return "Please Select Country";
                            //           //   } else {
                            //           //     return null;
                            //           //   }
                            //           // },
                            //           items: countryList.map((val) {
                            //             return DropdownMenuItem(
                            //               onTap: () {
                            //                 selectCountry = val['name'];
                            //                 selectCountry_id = val['id'];
                            //                 print("selectCountry_id....." +
                            //                     selectCountry_id.toString());
                            //                 print("selectCountry....." +
                            //                     selectCountry.toString());
                            //
                            //                 stateList.clear();
                            //                 cityList.clear();
                            //                 selectState_id = null;
                            //                 selectState = null;
                            //
                            //                 selectCity = null;
                            //                 selectCity_id = null;
                            //                 getState(urlState + selectCountry_id.toString(),
                            //                     null, null);
                            //                 setState(() {
                            //                   print("urlState+selectCountry_id...." +
                            //                       urlState +
                            //                       selectCountry_id.toString());
                            //                 });
                            //               },
                            //               value: val['name'].toString(),
                            //               child: Text(
                            //                 val['name'].toString(),
                            //                 //style: TextStyle(color: grey),
                            //               ),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            sizebox_height_10,
                            /// SELECT STATE FOR HERE DROPDOWN.......
                            Row(
                              children: [
                                Image.asset(country_icon,scale: 11,),
                                Expanded(
                                  // flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                                      ),
                                      dropdownColor: white,
                                      value: selectState,
                                      hint: Text(
                                        'Select State',
                                        style:TextStyles.HintStyle,
                                      ),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          selectState = value;
                                          print("on chngae ....." + selectState_id.toString());
                                        });
                                      },
                                      // onSaved: (value) {
                                      //   setState(() {
                                      //     selectCountry_id = value;
                                      //   });
                                      // },
                                      // validator: (value) {
                                      //   if (value == null) {
                                      //     return "Please Select State";
                                      //   } else {
                                      //     return null;
                                      //   }
                                      // },
                                      items: stateList.map((val) {
                                        return DropdownMenuItem(
                                          onTap: () {
                                            selectState = val['name'];
                                            selectState_id = val['id'];
                                            print("selectState....." + selectState.toString());
                                            print("selectState_id....." +
                                                selectState_id.toString());

                                            cityList.clear();
                                            selectCity = null;
                                            selectCity_id = null;
                                            getCity(urlCity + selectState_id.toString(), null,
                                                null);
                                            // setState((){
                                            //
                                            // });
                                          },
                                          value: val['name'],
                                          child: Text(
                                            val['name'].toString(),
                                            //style: TextStyle(color: grey),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 25.0,right: 25),
                            //   child: DropdownButtonFormField(
                            //     decoration: InputDecoration(
                            //       contentPadding: EdgeInsets.only(
                            //           left: 5, right: 5),),
                            //     dropdownColor: white,
                            //     value: selectState_id,
                            //     hint: Text(
                            //       'Select State',
                            //       style: hintProfileStyle,
                            //     ),
                            //     isExpanded: true,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         selectState = value;
                            //       });
                            //     },
                            //     onSaved: (value) {
                            //       setState(() {
                            //         selectState = value;
                            //       });
                            //     },
                            //     validator: (value) {
                            //       if (value==null) {
                            //         return "Please Select State";
                            //       } else {
                            //         return null;
                            //       }
                            //     },
                            //     items: stateList.map((val) {
                            //       return DropdownMenuItem(
                            //         onTap: () {
                            //           selectState = val['name'].toString();
                            //           selectState_id = val['id'].toString();
                            //
                            //           print("selectState_id....."+selectState_id.toString());
                            //           print("urls selectState_id............"+urlCity+selectState_id);
                            //
                            //
                            //           cityList.clear();
                            //           selectCity= "null";
                            //           selectCity_id= "null";
                            //           setState((){
                            //             getCity(urlCity+selectState_id,"null","null");
                            //           });
                            //
                            //         },
                            //         value: val['id'].toString(),
                            //         child: Text(val['name'].toString(),
                            //           //style: TextStyle(color: grey),
                            //         ),
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                            sizebox_height_10,
                            /// SELECT CITY FOR HERE DROPDOWN.......
                            Row(
                              children: [
                                Image.asset(country_icon,scale: 11,),
                                Expanded(
                                  // flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                                      ),
                                      dropdownColor: white,
                                      value: selectCity,
                                      hint: Text(
                                        'Select City',
                                        style:TextStyles.HintStyle,
                                      ),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          selectCity = value;
                                        });
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          selectCity = value;
                                        });
                                      },
                                      // validator: (value) {
                                      //   if (value == null) {
                                      //     return "Please Select City";
                                      //   } else {
                                      //     return null;
                                      //   }
                                      // },
                                      items: cityList.map((val) {
                                        return DropdownMenuItem(
                                          onTap: () {
                                            selectCity = val['name'].toString();
                                            selectCity_id = val['id'].toString();
                                            collegeCtrl.clear();
                                            print("selectCity....." + selectCity.toString());
                                            print("selectCity_id....." +
                                                selectCity_id.toString());
                                            print("urls selectCity_id............" +
                                                urlCity +
                                                selectCity_id);
                                            getCity(urlCity + selectCity_id, null, null);
                                            getCollagesData(selectCity_id.toString());
                                            // setState((){
                                            //
                                            // });
                                          },
                                          value: val['name'].toString(),
                                          child: Text(
                                            val['name'].toString(),
                                            //style: TextStyle(color: grey),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            CustomTextFormField(
                              suffix:IconButton(icon:Image.asset('assets/images/down_arrow.png',scale: 4,),
                                onPressed:
                                    () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Select College'),
                                        content: Container(
                                          width: double.minPositive,
                                          child:  authController.collagesData.length==0?Center(child: Text('No Data Found!!')):
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: authController.collagesData.length,
                                            itemBuilder: (context, index) {
                                              // collegeId = authController.collagesData[0].keys.elementAt(index);
                                              final college = authController.collagesData[index];
                                              return ListTile(
                                                title: Text(college['college_name'].toString()),
                                                onTap: () {
                                                  setState(() {
                                                    collegeId = college['id'];
                                                    selectCollege = college['college_name'].toString();
                                                    collegeCtrl.text = selectCollege;
                                                    log('value==>'+collegeCtrl.text.toString());
                                                    print('Tapped index: $collegeId');
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              readonly: true,

                              textInputAction: TextInputAction.done,
                              controller: collegeCtrl,
                              l_icon: Image.asset(colege_icon,scale: 20,),
                              hintText: 'Select College',
                              //maxLength: 20,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select College'),
                                      content: Container(
                                        width: double.minPositive,
                                        child:  authController.collagesData.length==0?Center(child: Text('No Data Found!!')):
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: authController.collagesData.length,
                                          itemBuilder: (context, index) {
                                            // collegeId = authController.collagesData[0].keys.elementAt(index);
                                            final college = authController.collagesData[index];
                                            return ListTile(
                                              title: Text(college['college_name'].toString()),
                                              onTap: () {
                                                setState(() {
                                                  collegeId = college['id'];
                                                  selectCollege = college['college_name'].toString();
                                                  collegeCtrl.text = selectCollege;
                                                  log('value==>'+collegeCtrl.text.toString());
                                                  print('Tapped index: $collegeId');
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );

                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              // validator: Validations.validateCollege,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                            CustomTextFormField(
                              suffix:IconButton(icon:Image.asset('assets/images/down_arrow.png',scale: 3,),
                              onPressed:() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select Qualification'),
                                      content: Container(
                                        width: double.minPositive,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: authController.qualificationData[0].length,
                                          itemBuilder: (context, index) {
                                            final qualification = authController.qualificationData[0][(index + 1).toString()];
                                            return ListTile(
                                              title: Text(qualification),
                                              onTap: () {
                                                setState(() {
                                                  qualificationId = authController.qualificationData[0].keys.elementAt(index);

                                                  _selectedQualification = qualification;
                                                  jobQualiCtrl.text = _selectedQualification;
                                                  log('value==>'+jobQualiCtrl.text.toString());
                                                  print('Tapped index: $qualificationId');
                                                  otherCtrl.clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              ),
                              readonly: true,
                              textInputAction: TextInputAction.done,
                              controller: jobQualiCtrl,
                              l_icon: Image.asset(job_icon,scale: 11,),
                              hintText: 'Job/Qualifications',
                              //maxLength: 20,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select Qualification'),
                                      content: Container(
                                        width: double.minPositive,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: authController.qualificationData[0].length,
                                          itemBuilder: (context, index) {
                                            final qualification = authController.qualificationData[0][(index + 1).toString()];
                                            return ListTile(
                                              title: Text(qualification),
                                              onTap: () {
                                                setState(() {
                                                  qualificationId = authController.qualificationData[0].keys.elementAt(index);

                                                  _selectedQualification = qualification;
                                                  jobQualiCtrl.text = _selectedQualification;
                                                  log('value==>'+jobQualiCtrl.text.toString());
                                                  print('Tapped index: $qualificationId');
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              // validator: Validations.validateJobQualification,
                              ),
                            sizebox_height_15,
                            qualificationId=='7'?
                            CustomTextFormField(
                              textInputAction: TextInputAction.next,
                              controller: otherCtrl,
                              // validator: Validations.validateOther,
                              hintText: 'Other',
                              l_icon: Image.asset(profile_phone,scale: 3,color: primary,),
                            ):Container(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            GetBuilder<AuthController>(
                              builder: (authController) {
                                return Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {

                                          if(authController.registerLoading.value){
                                            toastMsg("Otp is sending to your ${mobileController.text}, please wait....", true);
                                          }
                                          else{
                                            var regis_url = apiUrls().send_otp_api;
                                            var regis_body ={
                                              'mobile': mobileController.text,
                                              'is_register': "1",

                                            };
                                            authController.sentOTPRegister(regis_url, regis_body,nameController.text,qualificationId,emailController.text,mobileController.text,
                                                "null","null",collegeId,selectCity_id.toString(),selectCountry_id.toString(), selectState_id.toString(),otherCtrl.text);

                                          }

                                        }
                                      },
                                      child: Text(
                                        'Sign up'.toUpperCase(),
                                        style: TextStyles.BtnStyle,
                                      )),
                                );
                              }
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Padding(
                              padding:  EdgeInsets.only(bottom: 5),
                              child: RichText(
                                text: TextSpan(
                                  text: "Already Have Account ? ",
                                  style:  TextStyles.loginB1Style,
                                  children: [
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyles.loginB2Style,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

