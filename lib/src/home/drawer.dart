import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/Service/Service.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/drawer_item.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/drawer_items/about_us.dart';
import 'package:n_prep/src/drawer_items/contact_us.dart';
import 'package:n_prep/src/drawer_items/payment_history/payment_history.dart';
import 'package:n_prep/src/drawer_items/privacy_policy.dart';
import 'package:n_prep/src/drawer_items/t&c.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/login_page/login_page.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/src/profile/profile.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState(){
    super.initState();
    getdata();

  }
  @override
  Widget build(BuildContext context) {
    log("Width>> "+MediaQuery.of(context).size.width.toString());
    var width =MediaQuery.of(context).size.width;
    return Drawer(
      width:width>500?MediaQuery.of(context).size.width * 0.4: MediaQuery.of(context).size.width * 0.7,

      backgroundColor: drawer_primary,
      child: Container(
        padding: EdgeInsets.only(top: 50,bottom: 20),
        decoration: BoxDecoration(
          // color: drawer_primary,
          image: DecorationImage(
            image: AssetImage( 'assets/images/drawerbg.jpg')
          )
        ),
        child: Column(
          children: [
            Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            // MaterialPageRoute(builder: (context) => BottomBar(bottomindex : 3)));
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(Environment.profileimage.toString()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                Text('${Environment.profilename.toString().capitalize=="null"?"":
                                Environment.profilename.toString().capitalize}',
                                    style: TextStyle(fontSize: 18,
                                        fontFamily: 'PublicSans',
                                        color: black54,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.edit,size: 15,),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 5,
                        top: 8,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.grey,
                            ))),
                  ],
                )),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  DrawerItem(
                    imagename: d_payment,
                    title: 'Subscription Plans',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SubscriptionPlan()));
                    },
                  ),
                  DrawerItem(
                    imagename: d_payment,
                    title: 'Payment History',
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PaymentHistory()));
                    },
                  ),
                  // DrawerItem(
                  //   imagename: d_qbank,
                  //   title: 'Q Bank',
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => BottomBar(bottomindex : 1)));
                  //   },
                  // ),
                  // DrawerItem(
                  //   imagename: d_test,
                  //   title: 'Test Paper',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => BottomBar(bottomindex : 2)));
                  //
                  //   },
                  // ),
                  // DrawerItem(
                  //   imagename: d_cpass,
                  //   title: ' Change Password',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => ChangePassword()));
                  //   },
                  // ),
                  DrawerItem(
                    imagename: d_privacy,
                    title: 'Privacy Policy',
                    onTap: () {

                      // Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                    },
                  ),
                  DrawerItem(
                    imagename: d_about,
                    title: 'About Us',
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                  ),

                  DrawerItem(
                    imagename: d_contact,
                    title: 'Contact Us',
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ContactUs()));
                    },
                  ),
                  DrawerItem(
                    imagename: d_about,
                    title: 'Terms & Conditions',
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => TermsConditions()));
                    },
                  ),
                  // DrawerItem(
                  //   imagename: d_about,
                  //   title: 'Delete Account',
                  //   onTap: () {
                  //     showDialog(context: context, builder: (_)=> AlertDialog(
                  //       title: Text('Delete?'),
                  //       content: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text('Are you sure you want to delete account?'),
                  //       ),
                  //       actions: [
                  //         TextButton(onPressed: () async{
                  //           String AuthorizationKey = "Bearer ${Environment.apibasetoken}";
                  //           var headers = {
                  //             apiUrls().Authorization: AuthorizationKey.toString(),
                  //             apiUrls().XAPIKEY: apiUrls().XAPIVALUE,
                  //             //'Content-Type': 'multipart/form-data'
                  //           };
                  //           log("headers delete : "+headers.toString());
                  //           log("url delete : "+apiUrls().destroy_api.toString());
                  //           var _response = await http.delete(
                  //             Uri.parse(apiUrls().destroy_api),
                  //             headers: headers,
                  //
                  //           ).timeout(Duration(seconds: 10));
                  //           log("response delete : "+_response.body.toString());
                  //
                  //           if(_response.statusCode==200){
                  //             setState((){
                  //               apiCallingHelper().logoutinPref();
                  //               Fluttertoast.showToast(msg: jsonDecode(_response.body)['message']);
                  //             });
                  //           }else{
                  //             Navigator.pop(context);
                  //           }
                  //
                  //
                  //         },child: Text('Yes'),
                  //         ),
                  //         TextButton(onPressed: () {
                  //           Navigator.pop(context);
                  //         },child: Text('No'),
                  //         ),
                  //       ],
                  //
                  //     ) );
                  //
                  //   },
                  // ),
                  DrawerItem(
                    imagename:d_share,
                    title: 'Share',
                    onTap: appshare,
                  ),
                  // DrawerItem(
                  //   imagename: d_logout,
                  //   title: 'Logout',
                  //   onTap: logout,
                  // ),
                  sizebox_height_10,


                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 20.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("V ${Platform.isAndroid?apiUrls().app_version:apiUrls().ios_app_version}",style: TextStyle(color: versionColor,fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            sizebox_height_15,
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(logo,color: white,scale: 3.2,),
                ],
              ),
            ),
            sizebox_height_15,
          ],
        ),
      ),
    );
  }
  final String linkText = "https://www.example.com";

  var sharelink,sharelinkios,sharemsg;
  getdata() async {
    sharelink= await sprefs.getString("sharelink");
    sharelinkios= await sprefs.getString("sharelinkios");
    sharemsg= await sprefs.getString("sharemsg");
  }
  void appshare() {
var sharewithout =sharelink.toString();
var sharewithIOS =sharelinkios.toString();
// var shar =sharelink.split("=")[1];
var shrMsg =sharemsg.toString();

print("sharewithout......${sharewithout}");
// print("shar......${shar}");
print("shrMsg......${shrMsg}");
   Share.share("\n ${shrMsg.toString()}:\n \n PlayStore Url: ${sharewithout} \n AppStore Url: ${sharewithIOS}");
  }
}
