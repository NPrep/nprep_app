import 'dart:developer';


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/buy_plan.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/plan_detail.dart';
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


import '../home/bottom_bar.dart';
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


class SubscriptionPlan extends StatefulWidget {
  bool pagenav;
  SubscriptionPlan({Key key,this.pagenav});


  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}


class _SubscriptionPlanState extends State<SubscriptionPlan> {


  SubscriptionController subscriptionController = Get.put(
      SubscriptionController());
  var subscriptions_apiUrl;


  // Razorpay _razorpay;
  var selectedIndex;


  @override
  void initState() {
    super.initState();
    var settingUrl ="${apiUrls().setting_api}";
    settingController.SettingData(settingUrl);
    subscriptions_apiUrl = apiUrls().subscriptions_api;
    print("subscriptions_apiUrl....." + subscriptions_apiUrl.toString());
    subscriptionController.SubscriptionsData(subscriptions_apiUrl);
    log('SubscriptionsData==>'+subscriptionController.subscriptionData.toString());
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  SettingController settingController =Get.put(SettingController());
  String mainString = "gold";
  @override
  Widget build(BuildContext context) {
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.20);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight:widget.pagenav==true?0:AppBar().preferredSize.height,
          automaticallyImplyLeading: false,
          // centerTitle: center,
          elevation: 0,


          title: widget.pagenav==true?Container(): Row(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.offAll(BottomBar(bottomindex: 0,));


                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),


              Container(
                width: MediaQuery.of(context).size.width-60,
                child: Text("Subscription Plans",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 17.0,fontWeight: FontWeight.w400)),
              ),
            ],
          ),


        ),
        body: WillPopScope(


          onWillPop: () async {
            Get.offAll(BottomBar(bottomindex: 0,));
            return true;


          },
          child: GetBuilder<SubscriptionController>  (
              builder: (subscriptionController) {
                if (subscriptionController.subsLoader.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  displacement: 65,
                  backgroundColor: Colors.white,
                  color: primary,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1500));
                    subscriptions_apiUrl = apiUrls().subscriptions_api;
                    subscriptionController.SubscriptionsData(
                        subscriptions_apiUrl);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MediaQuery(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: versionColor,
                            padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                            alignment: Alignment.center,
                            child: Text("Choose a plan according \n to your preference.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
                          ),
                          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                        ),
                        SizedBox(height: 10,),
                        ListView.builder(
                          itemCount: subscriptionController.subscriptionData['data'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var subscription_datas = subscriptionController.subscriptionData['data'][index];
                            print("subscription_data....." + subscription_datas.toString());
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8.2,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 18,vertical: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                MediaQuery(
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                  child: Container(
                                                    width: 150, // Set the desired width here
                                                    child: Text(
                                                      subscription_datas['name'].toString() == "null" ? "" : subscription_datas['name'].toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                subscription_datas['name']==null?Container():subscription_datas['name'].contains("GOLD") ? Image.asset("assets/nprep2_images/gold.gif",height: 25,):Container(),
                                              ],
                                            ),
                                            SizedBox(height: 12,),
                                            Container(
                                              // color: Colors.red,
                                              // padding: EdgeInsets.only(left: 15.0),
                                              width: MediaQuery.of(context).size.width-200,
                                              child: MediaQuery(
                                                child: Html(
                                                  data:subscription_datas['description'],


                                                  style: {
                                                    "table": Style( ),
                                                    // some other granular customizations are also possible
                                                    "tr": Style(
                                                      border: Border(
                                                        bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                        left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                                      ),
                                                    ),
                                                    "p": Style(
                                                      fontSize: FontSize.xxSmall,


                                                    ),
                                                    "th": Style(
                                                      padding: EdgeInsets.all(6),
                                                      backgroundColor: Colors.black,
                                                    ),
                                                    "td": Style(
                                                      padding: EdgeInsets.all(2),
                                                      alignment: Alignment.topLeft,
                                                    ),
                                                    "pr": Style(
                                                      // fontSize: 12,
                                                        fontSize:FontSize.small ,
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: 'PublicSans',
                                                        color: black54),
                                                  },
                                                  customRenders: {
                                                    tableMatcher(): tableRender(),
                                                  },
                                                  // style: TextStyle(
                                                  //     fontSize: 12,
                                                  //
                                                  //     fontWeight: FontWeight.w400,
                                                  //     fontFamily: 'Helvetica',
                                                  //     color: black54),
                                                ),
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                MediaQuery(
                                                  child: Text(
                                                    '\u20B9 ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54
                                                    ),
                                                  ),
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                ),
                                                MediaQuery(
                                                  child: Text(
                                                    " ${subscription_datas['price']==null?"":
                                                    double.parse(subscription_datas['price'].toString())
                                                        .toStringAsFixed(0)}" =="null"? ""
                                                        :"${subscription_datas['price']==null?"":double.parse(
                                                        subscription_datas['price']
                                                            .toString())
                                                        .toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        fontFamily: 'PublicSans',
                                                        color: black54),
                                                  ),
                                                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            GestureDetector(
                                              onTap: () async {
                                                var settingUrl ="${apiUrls().setting_api}";
                                                await settingController.SettingData(settingUrl);
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                                    PlandetailScreen(
                                                      plan_name: subscription_datas['name'].toString(),
                                                      plan_description:subscription_datas['description'].toString(),
                                                      plan_price: subscription_datas['price'].toString(),
                                                      plan_index: index,
                                                    )));
                                              },
                                              child: MediaQuery(
                                                child: Container(
                                                  // width: 120,
                                                  // height: 40,
                                                  decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          18)),
                                                  child:Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      child: Text(
                                                        subscriptionController
                                                            .buyplanLoader.value ==
                                                            false
                                                            ||
                                                            selectedIndex != index
                                                            ? 'Buy Now'
                                                            : "Loading..",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w700,
                                                            fontFamily: 'PublicSans',
                                                            fontSize: 18,
                                                            color: white),
                                                      )


                                                  ),
                                                ),
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),




                        SizedBox(height: 15,),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Have any query? ",
                            style:  TextStyles.loginB1Style,
                            children: [
                              TextSpan(
                                text: 'Whatsapp us ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // GetDilogssss("sucessmsg");
                                    var phoneNumber =settingController.settingData['data']['general_settings']['phone'].toString();
                                    openWhatsApp(phoneNumber);
                                  },
                              ),
                              TextSpan(
                                text: 'for assistance. ',
                                style: TextStyles.loginB1Style,


                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                );
              }
          ),
        )
    );
  }


  void openWhatsApp(String phoneNumber) async {
    print(" oo $phoneNumber");
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}



