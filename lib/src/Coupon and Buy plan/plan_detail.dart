import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/utils/colors.dart';

import '../../Service/Service.dart';
import '../../main.dart';

const String _kSilverSubscriptionId = '1_Year';
const String _kGoldSubscriptionId = '6_Month';
const List<String> _kProductIds = <String>[
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class PlandetailScreen extends StatefulWidget {
 final plan_name;
 final plan_price;
 final plan_description;
 final plan_index;
  PlandetailScreen({Key key,this.plan_name,this.plan_description,this.plan_price,this.plan_index});

  @override
  State<PlandetailScreen> createState() => _PlandetailScreenState();
}

class _PlandetailScreenState extends State<PlandetailScreen> {

  SubscriptionController subscriptionController = Get.put(
      SubscriptionController());
  final textformFiledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: grey, width: 1.0),
    borderRadius: BorderRadius.circular(5.0),
  );
  var subscriptions_apiUrl;
  TextEditingController couponController = TextEditingController();
  int selectedItemIndex = -1;
  var planid ;
  var plan_inapp_id ;
  var plan_price_amt ;
  @override
  void initState() {
    super.initState();
    couponController.clear();
    plan_price_amt =widget.plan_price;
    log('planname==>'+widget.plan_name.toString());
    log('plan_price_amt==>'+plan_price_amt.toString());
    log('plan_price_plan_index==>'+widget.plan_index.toString());
    trackdata();
    getdataCall();
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

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);
      final result = jsonDecode(responsedata.body);

      if (responsedata.statusCode == 200) {
        var msg = result;
        // Fluttertoast.showToast(msg: msg.toString());
        print(msg);
      }

      print("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }


      trackdata()async{
    var trackUrl = apiUrls().track_sub;
    var updateBody = {
      'username': sprefs.getString("user_name"),
      'email': sprefs.getString("email"),
      'phone_number' : sprefs.getString("mobile"),
      'package' : widget.plan_price.toString()
    };
    print("updateBody......" + updateBody.toString());
    multipartAPICall(trackUrl, updateBody);
  }


  getdataCall() async {
    subscriptionController.discountedPrice = 0.0;

    subscriptions_apiUrl = apiUrls().subscriptions_api;
    print("subscriptions_apiUrl....." + subscriptions_apiUrl.toString());
    await subscriptionController.SubscriptionsData(subscriptions_apiUrl);
    log('SubscriptionsData==>'+subscriptionController.subscriptionData.toString());
    log('SubscriptionsData length==>'+subscriptionController.subscriptionData['data'][widget.plan_index]['subscriptions'].length.toString());
    if(subscriptionController.subscriptionData['data'][widget.plan_index]['subscriptions'].length>0){
      selectedItemIndex = 0;
      var subscription_data = subscriptionController.subscriptionData['data'][widget.plan_index]['subscriptions'][selectedItemIndex];

      planid = subscription_data['id'];
      plan_inapp_id = subscription_data['package_id'];
      plan_price_amt = subscription_data['plan_price'].toString();
      subscriptionController. callinit_fun_inapppur(plan_inapp_id);
      setState(() {
        subscriptionController.UpdatePlanDetail(widget.plan_name,plan_price_amt.toString());
      });
    }

  }
  getVerifyCoupon() async {
    Map<String, String> queryParams = {
      'plan_id': planid.toString(),
      'coupon': couponController.text.toString()
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var verifyCoupon_url = apiUrls().verify_coupon_api + '?' + queryString;
    print("verifyCoupon_url...." + verifyCoupon_url.toString());

    await subscriptionController.VerifyCouponData(verifyCoupon_url);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;
    var mediaquary=MediaQuery.of(context);
    var scale = mediaquary.textScaleFactor.clamp(1.10, 1.20);
    return Scaffold(
        appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          '${widget.plan_name}',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
        body: GetBuilder<SubscriptionController>(
            builder: (subscriptionController) {
              if (subscriptionController.subsLoader.value) {
                return Center(child: CircularProgressIndicator());
              }
           return Column(
             children: [
               Card(
                 elevation: 5.8,
                 child: Container(
                   width:width,
                   child: MediaQuery(
                     child: Container(
                       margin: EdgeInsets.only(left: 10,top: 10,right: 10),
                       child:  Html(
                         data:widget.plan_description,

                         // " ${subscription_datas['description']
                         //     .toString()}" ==
                         //     "null"
                         //     ? ""
                         //     :
                         // "${subscription_datas['description']
                         //     .toString()}",
                         style: {
                           "body": Style(fontSize: FontSize(16.0)),
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
                     ),
                     data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                   ),
                 ),
               ),
               // var subscription_datas = subscriptionController.subscriptionData['data'][index];
               SizedBox(height: 10,),
               MediaQuery(
                 child: Container(
                   margin: EdgeInsets.only(left: 20),
                   alignment: Alignment.centerLeft,
                   child: Text(
                     'Choose your plan duration',
                     style: TextStyle(
                         fontSize: 15,

                         fontWeight: FontWeight.w600,),
                   ),
                 ),
                 data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
               ),


               Expanded(
                 flex: 1,
                 child: ListView.builder(
                 itemCount: subscriptionController.subscriptionData['data'][widget.plan_index]['subscriptions'].length,
                 // shrinkWrap: true,
                 physics: AlwaysScrollableScrollPhysics(),
                 itemBuilder: (BuildContext context, int index) {
                 var subscription_data = subscriptionController.subscriptionData['data'][widget.plan_index]['subscriptions'][index];
                 print("subscription_data....." + subscription_data.toString());
                 return
                   Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Stack(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 2.5),
                         child: GestureDetector(
                           onTap: (){
                             setState(() {

                              selectedItemIndex = index;
                              planid = subscription_data['id'];
                              plan_inapp_id = subscription_data['package_id'];
                              plan_price_amt = subscription_data['plan_price'].toString();
                              subscriptionController.UpdatePlanDetail(widget.plan_name,plan_price_amt.toString());
                              subscriptionController. callinit_fun_inapppur(plan_inapp_id);


                             });
                           },
                           child: Card(
                             elevation: 4.5,
                             child: Container(
                               // decoration: BoxDecoration(
                               //   border: Border.all(color: primary),
                               //   borderRadius: BorderRadius.circular(10)
                               // ),
                                 // margin: EdgeInsets.symmetric(
                                 //     horizontal: 10,vertical: 10),
                                 child: Container(
                                   margin: EdgeInsets.symmetric(
                                       horizontal: 10,vertical: 10),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Expanded(
                                           child: Container(child: Icon(selectedItemIndex==index?Icons.check_circle:Icons.circle_outlined,color: primary,))),
                                       Expanded(
                                         flex: 3,
                                         child: Container(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment
                                                 .start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                             children: [

                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment
                                                     .start,
                                                 children: [
                                                   MediaQuery(
                                                     child: Text(
                                                       '${subscription_data['period_duration']
                                                           .toString() == "null"
                                                           ? ""
                                                           : subscription_data['period_duration']
                                                           .toString()}'
                                                           ' ${int.parse(
                                                           subscription_data['plan_duration']
                                                               .toString()) == 1
                                                           ? "Month Validity"
                                                           : "Year Validity"}',
                                                       style: TextStyle(
                                                           fontSize: 15,
                                                           // fontStyle: FontStyle.italic,
                                                           fontWeight: FontWeight
                                                               .w800,
                                                           fontFamily: 'Helvetica',
                                                           color: Colors.black),
                                                     ),
                                                     data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

                                                   ),
                                                 ],
                                               ),
                                               SizedBox(height: 10,),
                                               MediaQuery(
                                                 child: Text(
                                                   'Valid till ${subscription_data['expire_date']
                                                       .toString() == "null"
                                                       ? ""
                                                       : DateFormat("d MMM yyy").format(DateTime.parse(subscription_data['expire_date'])).toString()}',
                                                   style: TextStyle(
                                                       fontSize: 12,
                                                       // fontStyle: FontStyle.italic,
                                                       fontWeight: FontWeight
                                                           .w800,
                                                       fontFamily: 'Helvetica',
                                                       color: Colors.grey.shade600),
                                                 ),
                                                 data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                       Expanded(
                                         flex: 2,
                                         child: Container(
                                           margin: EdgeInsets.only(right: 10),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.end,
                                             crossAxisAlignment: CrossAxisAlignment.end,
                                             children: [
                                               sizebox_height_7,
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.end,
                                                 children: [
                                                   MediaQuery(
                                                     child: Text(
                                                       '\u20B9 ',
                                                       style: TextStyle(
                                                           fontSize: 20,
                                                           fontWeight: FontWeight
                                                               .w700,
                                                           fontFamily: 'Helvetica',
                                                           color: black54
                                                       ),
                                                     ),
                                                     data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

                                                   ),
                                                   MediaQuery(
                                                     child: Text(
                                                       " ${double.parse(
                                                           subscription_data['plan_price']
                                                               .toString())
                                                           .toStringAsFixed(0)}" ==
                                                           "null"
                                                           ? ""
                                                           :
                                                       "${double.parse(
                                                           subscription_data['plan_price']
                                                               .toString())
                                                           .toStringAsFixed(0)}",
                                                       style: TextStyle(
                                                           fontSize: 20,
                                                           fontWeight: FontWeight
                                                               .w700,
                                                           fontFamily: 'Helvetica',
                                                           color: black54),
                                                     ),
                                                     data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

                                                   )
                                                 ],
                                               ),
                                               sizebox_height_7,
                                               MediaQuery(
                                                 child: Text(
                                                   '\u20B9${ subscription_data['mrp_price']}',
                                                   style: TextStyle(
                                                       fontSize: 12,
                                                       fontWeight: FontWeight.w500,
                                                       color: redBackgroundColor,
                                                       decoration: TextDecoration.lineThrough),
                                                 ),
                                                 data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

                                               ),


                                               SizedBox(height: 5,),
                                               // GestureDetector(
                                               //   onTap: () {
                                               //     Navigator.push(context,
                                               //         MaterialPageRoute(
                                               //             builder: (context) =>
                                               //                 PlanScreen(
                                               //                   plan_price: double
                                               //                       .parse(
                                               //                       subscription_data['plan_price']
                                               //                           .toString())
                                               //                       .toStringAsFixed(
                                               //                       0),
                                               //                   plan_name: subscription_data['plan_title']
                                               //                       .toString(),
                                               //                   plan_id: subscription_data['id']
                                               //                       .toString(),
                                               //                   plan_mrp: subscription_data['mrp_price']
                                               //                       .toString(),
                                               //                   plan_duration: subscription_data['period_duration']
                                               //                       .toString(),
                                               //                   plan_description: subscription_data['description']
                                               //                       .toString(),
                                               //                   plan_period: subscription_data['plan_duration'].toString(),
                                               //                   plan_inapp_id: subscription_data['package_id'].toString(),
                                               //
                                               //                 )));
                                               //
                                               //   },
                                               //   child: Container(
                                               //     // width: 120,
                                               //     // height: 40,
                                               //     decoration: BoxDecoration(
                                               //         color: primary,
                                               //         borderRadius: BorderRadius
                                               //             .circular(
                                               //             18)),
                                               //     child:Padding(
                                               //         padding: EdgeInsets.symmetric(
                                               //             horizontal: 16,
                                               //             vertical: 8),
                                               //         child: Text(
                                               //           subscriptionController
                                               //               .buyplanLoader.value ==
                                               //               false
                                               //               ||
                                               //               selectedIndex != index
                                               //               ? 'Buy Now'
                                               //               : "Loading..",
                                               //           style: TextStyle(
                                               //               fontWeight: FontWeight
                                               //                   .w700,
                                               //               fontFamily: 'Helvetica',
                                               //               fontSize: 18,
                                               //               color: white),
                                               //         )
                                               //
                                               //     ),
                                               //   ),
                                               // ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 )),
                           ),
                         ),
                       ),

                       subscription_data['is_recomended']==1? Image.asset("assets/nprep2_images/recmmended.png",height: 40,):Container(),
                     ],
                   ),
                 );


                 }),
               ),
               sizebox_height_10,
               MediaQuery(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Expanded(
                       flex: 5,
                       child: Container(
                         padding: EdgeInsets.only(left: 8, right: 10),

                         child: TextFormField(
                           controller: couponController,
                           autovalidateMode: AutovalidateMode.onUserInteraction,
                           // readOnly: true,
                           decoration: InputDecoration(
                               enabledBorder: textformFiledBorder,
                               focusedBorder: textformFiledBorder,
                               border: textformFiledBorder,
                               errorBorder: textformFiledBorder,
                               isDense: true,
                               // constraints: BoxConstraints(maxHeight: 30,minHeight: 30),
                               suffixIcon: couponController.text.isEmpty
                                   ? null
                                   : IconButton(
                                 onPressed: () {
                                   couponController.clear();
                                   subscriptionController.discountedPrice = 0.0;
                                   getVerifyCoupon();

                                   setState(() {});
                                 },
                                 icon: Icon(Icons.clear),
                               ),
                               focusedErrorBorder: textformFiledBorder,
                               contentPadding: EdgeInsets.only(
                                   top: 10, left: 10, bottom: 10),
                               hintText: "Apply coupons",
                               hintStyle: TextStyle(
                                 color: Colors.grey.shade500,
                                 fontSize: 12,
                                 fontWeight: FontWeight.w400,
                               )),

                           // validator: (value) {
                           //   if (value.isEmpty) {
                           //     return "Please Apply Coupon";
                           //   } else {
                           //     return null;
                           //   }
                           // }
                         ),
                       ),
                     ),
                     Expanded(
                       flex: 2,
                       child: GestureDetector(
                         onTap: () {

                           getVerifyCoupon();

                         },
                         child: Container(
                           alignment: Alignment.center,
                           padding: EdgeInsets.all(10),
                           margin: EdgeInsets.only(right: 10),
                           decoration: BoxDecoration(
                             // color:  Colors.grey.shade400,
                               borderRadius: BorderRadius.circular(4),
                               border: Border.all(color: primary, width: 1)),
                           child: Text(
                             "Apply",
                             style: TextStyle(
                               color: primary,
                               fontSize: 14,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       ),
                     )
                   ],
                 ),
                 data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

               ),
               SizedBox(
                 height: 10,
               ),
               couponController.text.isEmpty
                   ? Container()
                   : Text(
                 subscriptionController.nocoupan.value.toString(),
                 style: TextStyle(color: Colors.redAccent),
               ),
               MediaQuery(
                 child: Column(
                   children: [
                     Card(
                       elevation: 3,
                       color: Colors.grey.shade200,
                       margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Container(
                         padding: EdgeInsets.only(
                             left: 20, right: 20, bottom: 15, top: 15),
                         margin: EdgeInsets.only(left: 10, right: 10),
                         // color: Colors.grey.shade200,
                         width: size.width,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Plan Price:",
                                   style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500,
                                       color: textColor),
                                 ),
                                 Text(
                                   "\u20B9${plan_price_amt.toString()}",
                                   style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500,
                                       color: textColor),
                                 ),
                               ],
                             ),
                             sizebox_height_10,
                             subscriptionController.discountedPrice == 0.0
                                 ? Container()
                                 : Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Discounted price:",
                                   style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500,
                                       color: textColor),
                                 ),
                                 Text(
                                   "\u20B9${subscriptionController.discountedPrice}",
                                   style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w500,
                                       color: textColor),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: () async {
                         bool temp = sprefs.getBool("is_internet");
                         if(!temp){
                           toastMsg("Please Check Your Internet Connection", true);
                         }
                         // subscriptionController.GetDilogssss(true);
                            if(selectedItemIndex!= -1){
                                var buyplanUrl = apiUrls().buy_user_plan_api;
                                var butplanBody = {
                                  'plan_id': planid.toString(),
                                  couponController.text.toString() == "null" ? ""
                                      : "coupon": couponController.text.toString(),
                                };
                                if(subscriptionController.discountedPrice == 0.0){
                                  subscriptionController.UpdatePlanDetail(widget.plan_name,plan_price_amt.toString());

                                }else{
                                  subscriptionController.UpdatePlanDetail(widget.plan_name,subscriptionController.discountedPrice.toString());

                                }
                                print("buyplanUrl...." + buyplanUrl.toString());
                                print("butplanBody...." + butplanBody.toString());
                                print("razorpay_payment_show...." + sprefs.getString("razorpay_payment_show").toString());

                                      if(subscriptionController.buyplanLoader==true){
                                        toastMsg("Please wait... ", true);
                                      }
                                      else{
                                        if (Platform.isAndroid) {
                                          // subscriptionController.buyplanLoader.value = true;
                                          setState(() {

                                          });
                                          subscriptionController.BuyPlanData(
                                              buyplanUrl, butplanBody);
                                        }
                                        else {
                                          if(sprefs.getString("razorpay_payment_show")=="1"){
                                            subscriptionController.BuyPlanData(
                                                buyplanUrl, butplanBody);
                                          }
                                          else{
                                            var generate_in_app_purchaseUrl = apiUrls().generate_in_app_purchase_api;
                                            var generate_in_app_purchaseBody = {
                                              'plan_id': planid.toString(),
                                              couponController.text.toString() == "null"
                                                  ? ""
                                                  :"coupon_id": couponController.text.toString(),
                                              "package_id": plan_inapp_id.toString(),
                                            };

                                            print("generate_in_app_purchaseUrl...." + generate_in_app_purchaseUrl.toString());
                                            print("generate_in_app_purchaseBody...." + generate_in_app_purchaseBody.toString());
                                            subscriptionController.generate_In_App_PurchaseData(generate_in_app_purchaseUrl, generate_in_app_purchaseBody);
                                            subscriptionController.buy();
                                          }
                                        }
                                      }

                            }
                            else{
                              toastMsg("Select Plan First", false);
                            }

                       },
                       child: Container(
                         margin: EdgeInsets.only(bottom: 30, left: 10, right: 10),
                         alignment: Alignment.center,
                         height: 40,
                         width: size.width,
                         decoration: BoxDecoration(
                           color: primary,
                           borderRadius: BorderRadius.circular(5),
                           border: Border.fromBorderSide(
                               BorderSide(color: primary, width: 1)),
                         ),
                         child: subscriptionController.buyplanLoader==true?
                         const CupertinoActivityIndicator(color: Colors.white):
                         Text(
                           "Buy Subscription",
                           style: TextStyle(
                               color: white,
                               fontWeight: FontWeight.w600,
                               fontSize: 16),
                         ),
                       ),
                     )
                   ],
                 ),
                 data: MediaQuery.of(context).copyWith(textScaleFactor: scale),

               )
             ],
           );
            }
        )
    );
  }
}
