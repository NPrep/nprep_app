import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/buy_plan.dart';
import 'package:n_prep/utils/colors.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/profile/profile_controller.dart';
// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'Nprep App Purchase';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = '1_Year';
const String _kGoldSubscriptionId = '6_Month';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class ActivePlansScreen extends StatefulWidget {
  const ActivePlansScreen({Key key});

  @override
  State<ActivePlansScreen> createState() => _ActivePlansScreenState();
}

class _ActivePlansScreenState extends State<ActivePlansScreen> {
  
  ProfileController profileController = Get.put(ProfileController());


  @override
  void initState() {
    call_profile();
    super.initState();
  }
  
  
  call_profile() async {
    var profileUrl = "${apiUrls().profile_api}";
    // Logger_D(profileUrl);
    await profileController.GetProfile(profileUrl);
    log('MyProfileData==>'+profileController.MyProfileData.toString());
  }

  
 
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;

    return Scaffold(
        appBar: AppBarHelper(
          title: 'Active Plans',
          context: context,
          fontsize: 18.0,
        ),
        body: GetBuilder<ProfileController>(
            builder: (profileController) {
              if (profileController.profileLoader.value) {
                return Center(child: CircularProgressIndicator());
              }else if(profileController.MyProfileData[0]['data']['active_subscriptions'].length==0){
                return Center(child: Text('No Data Found'));
              }else{
                return RefreshIndicator(
                  displacement: 65,
                  backgroundColor: Colors.white,
                  color: primary,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1500));
                    call_profile();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: versionColor,
                          padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                          alignment: Alignment.center,
                          child: Text("Active Plans",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
                        ),
                        SizedBox(height: 10,),
                        ListView.builder(
                          itemCount: profileController.MyProfileData[0]['data']['active_subscriptions'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var ActivePlanData = profileController.MyProfileData[0]['data']['active_subscriptions'][index];
                            return Card(
                              margin: EdgeInsets.only(left:10,right: 10,bottom: 10 ),
                              child: Container(
                                width: width,
                                // height: height*0.1,
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:EdgeInsets.only(left: 5,top: 8),
                                      child: Text(ActivePlanData['subscription_name'].toString(),style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight
                                              .w700,
                                          fontFamily: 'Helvetica',
                                          color: black54),),
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex:3,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(text: TextSpan(children: [
                                                  TextSpan(text: 'Start Date: ',style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500)),
                                                  TextSpan(text: ActivePlanData['start_date'].toString(),style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500),),
                                                ])),
                                                SizedBox(height: 3,),
                                                RichText(text: TextSpan(children: [
                                                  TextSpan(text: 'Expire Date: ',style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500)),
                                                  TextSpan(text: ActivePlanData['expire_date'].toString(),style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500),),
                                                ])),
                                                SizedBox(height: 3,),
                                                RichText(text: TextSpan(children: [
                                                  TextSpan(text: 'Purchase Date: ',style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500)),
                                                  TextSpan(text: ActivePlanData['purchse_date'].toString(),style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: Colors.grey.shade500),),
                                                ])),
                                                SizedBox(height: 20,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Text(
                                                  '\u20B9 ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: black54
                                                  ),
                                                ),
                                                Text(
                                                  " ${double.parse(
                                                      ActivePlanData['plan_price']
                                                          .toString())
                                                      .toStringAsFixed(0)}" ==
                                                      "null"
                                                      ? ""
                                                      :
                                                  "${double.parse(
                                                      ActivePlanData['plan_price']
                                                          .toString())
                                                      .toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontFamily: 'Helvetica',
                                                      color: black54),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                );
              }
            }
        )
    );
  }
  
}
