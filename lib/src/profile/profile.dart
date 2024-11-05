import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/profile/profile_controller.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/src/drawer_items/change_password.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/profile/helper_profile.dart';
import 'package:n_prep/src/profile/profile_otp.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:http/http.dart' as http;

import '../../Envirovement/Environment.dart';
import '../Coupon and Buy plan/Active_plans.dart';

class Profile extends StatefulWidget {
  const Profile({Key key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profileController = Get.put(ProfileController());

  final _formKey = GlobalKey<FormState>();
  bool isEditMode = false;
  var urlCountry, urlState, urlCity;

  Future<void> getCountry(url, id, name) async {
    print("get url url: $url");
    print("get id id: $id");
    print("get name name: $name");
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
      final result = jsonDecode(responsedata.body.toString());

      if (responsedata.statusCode == 200) {
        var msg = result['message'];
        // Fluttertoast.showToast(msg: msg.toString());

        setState(() {
          countryList.clear();
          countryList.addAll(result['data']);
          print("countryList...." + countryList.toString());
          if (id != null) {
            selectCountry_id = id;
            selectCountry = name;
            var urlState1 = apiUrls().state_api + "${selectCountry_id}";
            print("urlState......." + urlState1.toString());
            // selectState= profileController.profileData['data']['state'].toString();
            // selectState_id= profileController.profileData['data']['state_id'].toString();
            getState(
                urlState1,
                profileController.profileData['data']['state_id'],
                profileController.profileData['data']['state']);
            print("selectCountry_id....if.." + selectCountry_id.toString());
            print("selectCountry....if.." + selectCountry.toString());
            setState(() {});
          } else {}
        });
      } else if (responsedata.statusCode == 404) {
        var msg = result['message'];
        Fluttertoast.showToast(msg: msg.toString());
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
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

            getCity(urlCity1, profileController.profileData['data']['city_id'],
                profileController.profileData['data']['city']);
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

  getData() async {
    print("check  for if condition " + profileController.profileData['data']['country'].toString());
    sprefs.setString("email",profileController.profileData['data']['email'].toString());
    sprefs.setString("mobile",profileController.profileData['data']['mobile'].toString());
    sprefs.setString("deviceid",profileController.profileData['data']['device_id'].toString());
    urlCountry = apiUrls().country_api;
    if (profileController.profileData['data']['country'].toString() != "null") {
      // selectState= profileController.profileData['data']['state'].toString();
      // selectState_id= profileController.profileData['data']['state_id'].toString();

      print("check  for if condition ");
      print("check  for if country " +
          profileController.profileData['data']['country'].toString());
      print("check  for if country_id " +
          profileController.profileData['data']['country_id'].toString());

      // selectCity=profileController.profileData['data']['city'].toString();
      //
      // selectCity_id = profileController.profileData['data']['city_id'].toString();
      await getCountry(
          urlCountry,
          profileController.profileData['data']['country_id'],
          profileController.profileData['data']['country']);
    } else {
      print("check  for  condition else ");
      await getCountry(urlCountry, null, null);
    }
  }

  call_profile() async {
    var profileUrl = "${apiUrls().profile_api}";
    // Logger_D(profileUrl);
    await profileController.GetProfile(profileUrl);
    getData();
  }

  var _mainHeaders = {
    apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
    apiUrls().Authorization: apiUrls().AuthorizationKey,
  };

  Future<void> multipartAPICall(url, parameter) async {
    print("post url : $url");
    print("post parameter : $parameter");
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(parameter);

      request.headers.addAll(_mainHeaders);

      if (profileController.pickfile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image', profileController.pickfile.path));
      } else {}

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);
      print("response body...." + responsedata.toString());
      final result = jsonDecode(responsedata.body);

      if (responsedata.statusCode == 200) {
        var msg = result['message'];
        // Fluttertoast.showToast(msg: msg.toString());
        var profileUrl = "${apiUrls().profile_api}";
        await profileController.GetProfile(profileUrl);
        Get.offAll(BottomBar( bottomindex: 3,));
      }

      print("post statusCode : ${responsedata.statusCode.toString()}");

      print("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  edit() {
    if (isEditMode == false) {
      setState(() {
        isEditMode = true;
      });
    } else {
      setState(() {
        isEditMode = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    urlCountry = apiUrls().country_api.toString();
    urlState = apiUrls().state_api;
    urlCity = apiUrls().city_api;
    profileController.imagenull();
    // setState((){});
    call_profile();
    // getData();
  }
  void logout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),
            child: AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 500), () async {
                      sprefs.clear();
                      sprefs.setBool(KEYLOGIN, false);
                      apiCallingHelper().logoutinPref();


                      //
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    }); // Perform logout operation
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('No'),
                ),
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    var cheight = MediaQuery.of(context).size.height;
    var cwidth = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.10);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
      child: Scaffold(
        body: GetBuilder<ProfileController>(builder: (profileContro) {
          if (profileContro.profileLoader.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          // color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        child: isEditMode == false
                            ? ProfileMode(profileContro)
                            : EditMode(profileContro),
                      )
                    ],
                  ),
                  Positioned(
                    left: 30,
                    right: 30,
                    top: 90,
                    child: Card(
                      elevation: 0.3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.18,
                        height: 130,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                      onTap:
                                          // isEditMode == false ?

                                          edit,
                                      // : getImageFromCamera(ImageSource.gallery,
                                      child: Icon(
                                        isEditMode == false
                                            ? Icons.edit_calendar_outlined
                                            : Icons.photo_library_outlined,
                                        color: Colors.grey,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  // padding:  EdgeInsets.only(bottom: 20,),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${profileContro.profileData['data']['name'].toString().capitalize}',
                                    style: TextStyle(
                                        color: grey,
                                        fontFamily: 'PublicSans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      left: size.width * .35,
                      // right: 50,
                      top: 50,
                      // bottom: 50,
                      child: GestureDetector(
                          onTap: () {
                            if (isEditMode == false) {
                            } else {
                              profileController.getFromGallery();
                            }
                          },
                          child: Container(
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: profileContro.pickfile != null
                                    ? FileImage(File(profileContro.pickfile.path))
                                    : NetworkImage(profileContro
                                        .profileData['data']['image']
                                        .toString()),
                                //fit: BoxFit.cover,
                              ),
                              border: Border.all(width: 1.5, color: Colors.white),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          )
                          // child:Container(
                          //
                          // decoration: BoxDecoration(
                          // // image:  DecorationImage(
                          // //   image: profileContro.pickfile != null
                          // //       ? FileImage(File(profileContro.pickfile.path),scale: 2)
                          // //       : NetworkImage(profileContro.profileData['data']['image'].toString() ),
                          // //   fit: BoxFit.cover,
                          // // ),
                          // border: Border.all(
                          // width: 1.5,
                          // color: Colors.white
                          // ),
                          // borderRadius: BorderRadius.circular(100),
                          // ),
                          // child: CircleAvatar(
                          // radius: 60,
                          // backgroundImage: profileContro.pickfile != null
                          // ? FileImage(File(profileContro.pickfile.path),)
                          //     : NetworkImage(profileContro.profileData['data']['image'].toString()),
                          // ),
                          // )

                          )),
                  Positioned(
                    left: 10,
                    top: 50,
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
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color:
                            Colors.black45.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                                Radius.circular(50))),
                        child: Icon(
                          Icons.chevron_left,
                          color: white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  ProfileMode(profileContro) {
    profileContro.pickfile == null;
    return RefreshIndicator(
      displacement: 150,
      backgroundColor: Colors.white,
      color: white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        call_profile();
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            children: [
               profileContro.profileData['data']['activePlan']==null?
               GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubscriptionPlan()));
                },
                child: Text(
                  "Buy a new plan".capitalize,

                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: primary,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ):
               Text(
                profileContro.profileData['data']['activePlan']['subscription_name'].toString().capitalize,
                style: TextStyle(
                    color: primary,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
               SizedBox(height: 10,),
               profileContro.profileData['data']['activePlan']==null?
               Container():
               GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ActivePlansScreen()));
                },
                child: Text(
                  "active plan".capitalize,

                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: primary,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
               SizedBox(height: 10,),
               profileContro.profileData['data']['activePlan']==null?
               Container():Text(
                'Expire Date: ${profileContro.profileData['data']['activePlan']['expire_date']}',
                style: TextStyle(
                    color: black54,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
               SizedBox(height: 10,),

               Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            profile_phone,
                            scale: 3,
                            color: primary,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            // color: Colors.blue,
                            child: Text(
                              profileContro.profileData['data']['mobile']??"",
                              style: TextStyle(
                                fontSize: 18,
                                color: grey,
                                fontFamily: 'PublicSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(OTPProfile(
                            mobileController: profileContro.profileData['data']
                                ['mobile'],
                          ));
                        },
                        child: Container(
                          width: 45,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: primary),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Edit'),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //     onTap: (){
                      //       // var regis_url = apiUrls().send_otp_api;
                      //       // var regis_body ={
                      //       //   'mobile': profileContro.profileData['data']['mobile'].toString(),
                      //       //   'is_register': "1",
                      //       //
                      //       // };
                      //       Get.to(OTPProfile(mobileController: profileContro.profileData['data']['mobile'],));
                      //     },
                      //     child: Icon(Icons.edit))
                    ],
                  ),
                ),
               SizedBox(height: 10,),
               ProfileModeText(
                  text:
                      '${profileContro.profileData['data']['email'].toString()}',
                  icon_img: profile_email,
                  imgsize: 3,
                ),
               ProfileModeText(
                  text:'${profileContro.profileData['data']['country'].toString() == "null" ? "Select Country" :  profileContro.profileData['data']['city']+", " +profileContro.profileData['data']['state'] +", "+profileContro.profileData['data']['country'].toString()+"." }',
                  icon_img: profile_country,
                  imgsize: 3,
                ),
               ProfileModeText(
                text:
                '${(profileContro.profileData['data']['other_qualification']??"Qualification").toString()}',
                icon_img: profile_country,
                imgsize: 3,
              ),
              // ProfileModeText(
              //     text:
              //         '${profileContro.profileData['data']['state'] == null ? "Select State" : profileContro.profileData['data']['state'].toString()}',
              //     icon_img: profile_state,
              //     imgsize: 8),
              // ProfileModeText(
              //   text:
              //       '${profileContro.profileData['data']['city'].toString() == "null" ? "Select City" : profileContro.profileData['data']['city'].toString()}',
              //   icon_img: profile_city,
              //   imgsize: 20,
              // ),
               sizebox_height_5,
               GestureDetector(
                onTap: () {
                logout();
                },
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 14,
                        color: primary,
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
               sizebox_height_10,
               GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (_)=> MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

                    child: AlertDialog(
                      title: Text('Delete?'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Are you sure you want to delete account?'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async{
                          String AuthorizationKey = "Bearer ${Environment.apibasetoken}";
                          var headers = {
                            apiUrls().Authorization: AuthorizationKey.toString(),
                            apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
                            //'Content-Type': 'multipart/form-data'
                          };
                          log("headers delete : "+headers.toString());
                          log("url delete : "+apiUrls().destroy_api.toString());
                          var _response = await http.delete(
                            Uri.parse(apiUrls().destroy_api),
                            headers: headers,

                          ).timeout(Duration(seconds: 10));
                          log("response delete : "+_response.body.toString());

                          if(_response.statusCode==200){
                            setState((){
                              apiCallingHelper().logoutinPref();
                              Fluttertoast.showToast(msg: jsonDecode(_response.body)['message']);
                            });
                          }else{
                            Navigator.pop(context);
                          }


                        },child: Text('Yes'),
                        ),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },child: Text('No'),
                        ),
                      ],

                    ),
                  ) );
                },
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    color: primary,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 14,
                        color: white,
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  EditMode(profileContro) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'EDIT PROFILE',
                  style: TextStyle(
                    color: primary,
                    fontSize: 17,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            CustomTextFormField(
              l_icon: Image.asset(
                profile_user,
                width: 19,
              ),
              maxLength: 25,
              keyType: TextInputType.name,
              hintText: 'Your Name',
              controller: profileController.user_name,
              validator: Validations.validateName,
            ),
            sizebox_height_15,
            // CustomTextFormField(
            //   l_icon: Image.asset(profile_phone,width: 19,height: 24,),
            //   maxLength: 25,
            //   keyType: TextInputType.number,
            //   hintText: 'Mobile No.',
            //   controller: profileController.user_number,
            //   validator: Validations.validateMobile,
            //   textInputAction: TextInputAction.next,
            // ),
            // sizebox_height_15,
            CustomTextFormField(
              l_icon: Image.asset(
                profile_email,
                width: 19,
              ),
              // maxLength: 25,
              keyType: TextInputType.emailAddress,
              hintText: 'Email',
              controller: profileController.user_email,
              validator: Validations.validateEmail,
            ),

            sizebox_height_10,
            /// SELECT COUNTRY DROPDOWN HERE ======

            Row(
              children: [
                Icon(
                  Icons.location_city_outlined,
                  size: 25,
                  color: primary,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      dropdownColor: white,
                      value: selectCountry,
                      hint: Text(
                        'Select Country',
                        style: hintProfileStyle,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectCountry = value;
                          print("selectCountry check on changv....." +
                              selectCountry.toString());
                        });
                      },
                      // onSaved: (value) {
                      //   setState(() {
                      //     selectCountry_id = value;
                      //   });
                      // },
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Country";
                        } else {
                          return null;
                        }
                      },
                      items: countryList.map((val) {
                        return DropdownMenuItem(
                          onTap: () {
                            selectCountry = val['name'];
                            selectCountry_id = val['id'];
                            print("selectCountry_id....." +
                                selectCountry_id.toString());
                            print("selectCountry....." +
                                selectCountry.toString());

                            stateList.clear();
                            cityList.clear();
                            selectState_id = null;
                            selectState = null;

                            selectCity = null;
                            selectCity_id = null;
                            getState(urlState + selectCountry_id.toString(),
                                null, null);
                            setState(() {
                              print("urlState+selectCountry_id...." +
                                  urlState +
                                  selectCountry_id.toString());
                            });
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
                ),
              ],
            ),
            sizebox_height_10,

            /// SELECT STATE FOR HERE DROPDOWN.......

            Row(
              children: [
                Icon(
                  Icons.location_city_outlined,
                  size: 25,
                  color: primary,
                ),
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
                        style: hintProfileStyle,
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
                      validator: (value) {
                        if (value == null) {
                          return "Please Select State";
                        } else {
                          return null;
                        }
                      },
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
                Icon(
                  Icons.location_city_outlined,
                  size: 25,
                  color: primary,
                ),
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
                        style: hintProfileStyle,
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
                      validator: (value) {
                        if (value == null) {
                          return "Please Select City";
                        } else {
                          return null;
                        }
                      },
                      items: cityList.map((val) {
                        return DropdownMenuItem(
                          onTap: () {
                            selectCity = val['name'].toString();
                            selectCity_id = val['id'].toString();
                            print("selectCity....." + selectCity.toString());
                            print("selectCity_id....." +
                                selectCity_id.toString());
                            print("urls selectCity_id............" +
                                urlCity +
                                selectCity_id);
                            getCity(urlCity + selectCity_id, null, null);
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
            sizebox_height_50,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState.validate()) {
                        var updateUrl = apiUrls().updateprofile_api;
                        var updateBody = {
                          'name': profileController.user_name.text,
                          'email': profileController.user_email.text,
                          // 'mobile': profileController.user_number.text,
                          'country_id': selectCountry_id.toString(),
                          'state_id': selectState_id.toString(),
                          'city_id': selectCity_id.toString()
                        };
                        print("updateBody......" + updateBody.toString());
                        multipartAPICall(updateUrl, updateBody);

                        isEditMode = false;

                        // Future.delayed(Duration(seconds: 1), () {
                        //   // textClear(); // Call the function after a delay of 1 second
                        // });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                    ),
                    child: Text(
                      'Change'.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                //CANCLE BUTTON
                Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: () {
                      profileController.imagenull();
                      isEditMode = false;
                      setState(() {
                        isEditMode = false;
                      });
                      // textClear();
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
