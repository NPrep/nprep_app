import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/app_data.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/utils/colors.dart';
// import 'package:purchases_flutter/models/customer_info_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

import 'coupon_list.dart';

const String _kSilverSubscriptionId = '1_Year';
const String _kGoldSubscriptionId = '6_Month';
const List<String> _kProductIds = <String>[
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class PlanScreen extends StatefulWidget {
  var plan_name,
      plan_price,
      plan_id,
      plan_mrp,
      plan_duration,
      plan_description,
      plan_period,
      plan_inapp_id;
  PlanScreen(
      {this.plan_name,
      this.plan_price,
      this.plan_id,
      this.plan_mrp,
      this.plan_duration,
      this.plan_description,
      this.plan_period,
      this.plan_inapp_id});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  GlobalKey<FormState> tiffinFormKey = GlobalKey<FormState>();
  final textformFiledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: grey, width: 1.0),
    borderRadius: BorderRadius.circular(5.0),
  );

  TextEditingController couponController = TextEditingController();
  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());
  String coupon_id;

  bool applybutton = false;
  bool clearbutton = false;

  getVerifyCoupon() async {
    Map<String, String> queryParams = {
      'plan_id': widget.plan_id.toString(),
      'coupon': couponController.text.toString()
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var verifyCoupon_url = apiUrls().verify_coupon_api + '?' + queryString;
    print("verifyCoupon_url...." + verifyCoupon_url.toString());

    await subscriptionController.VerifyCouponData(verifyCoupon_url);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sprefs.remove("discountprice");
    subscriptionController.callinit_fun_inapppur(widget.plan_inapp_id);
    couponController.clear();

    print("plan_name..." + widget.plan_name.toString());
    print("plan_price..." + widget.plan_price.toString());
    print("plan_id..." + widget.plan_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body:
          GetBuilder<SubscriptionController>(builder: (subscriptionController) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 0.5,
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan Name :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            '${widget.plan_name}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                        ],
                      ),
                      sizebox_height_7,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan MRP :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            '\u20B9${widget.plan_mrp}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: redBackgroundColor,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      sizebox_height_7,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan Price :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            '\u20B9${widget.plan_price}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                        ],
                      ),
                      sizebox_height_7,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan Duration :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            '${widget.plan_duration} ${int.parse(widget.plan_period) != 1 ? "Year" : "Month"}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text("Plan Description: ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                    ),
                    Container(
                      // width: size.width - 160,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.red,
                      child: Text("${widget.plan_description}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: textColor)),
                    ),

                sizebox_height_10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 10),
                        // alignment: Alignment.topLeft,
                        width: size.width * 0.65,
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
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          // if(couponController.text.isNotEmpty){
                          //   couponController.clear();
                          //   sprefs.remove("discountprice");
                          //   coupon_id="null";
                          //   setState(() {
                          //
                          //   });
                          //   // getVerifyCoupon();
                          // }else{
                          //   // getVerifyCoupon();
                          // }
                          couponController.text;
                          // subscriptionController.GetDilogssss("hell");
                          getVerifyCoupon();
                          // applybutton=true;
                          // clearbutton=false;
                          // print("applybutton...."+applybutton.toString());
                          //
                          // if(applybutton==true){
                          // print("applybutton if..."+applybutton.toString());
                          // applybutton=false;
                          // couponController.clear();
                          // clearbutton=false;
                          // }else{
                          //   applybutton=true;
                          //   print("applybutton else..."+applybutton.toString());
                          // }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              // color:  Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: primary, width: 1)),
                          child: Text(
                            "Apply",
                            style: TextStyle(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                couponController.text.isEmpty
                    ? Container()
                    : Text(
                        subscriptionController.nocoupan.value.toString(),
                        style: TextStyle(color: Colors.redAccent),
                      )
                //   onTap: (){
                //     // if(couponController.text.isNotEmpty){
                //     //   couponController.clear();
                //     //   sprefs.remove("discountprice");
                //     //   coupon_id="null";
                //     //   setState(() {
                //     //
                //     //   });
                //     //   // getVerifyCoupon();
                //     // }else{
                //     //   // getVerifyCoupon();
                //     // }
                //     couponController.clear();
                //     getVerifyCoupon();
                //
                //     setState(() {
                //     });
                //     // applybutton=true;
                //     // clearbutton=false;
                //     // print("applybutton...."+applybutton.toString());
                //     //
                //     // if(applybutton==true){
                //     // print("applybutton if..."+applybutton.toString());
                //     // applybutton=false;
                //     // couponController.clear();
                //     // clearbutton=false;
                //     // }else{
                //     //   applybutton=true;
                //     //   print("applybutton else..."+applybutton.toString());
                //     // }
                //
                //
                //
                //   },
                //   child: Container(
                //     alignment: Alignment.center,
                //
                //     padding: EdgeInsets.all(5),
                //     margin: EdgeInsets.only(right: 10),
                //
                //     decoration: BoxDecoration(
                //       // color:  Colors.grey.shade400,
                //         borderRadius:
                //         BorderRadius.circular(4),
                //         border: Border.all(
                //             color: primary, width: 1)
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.close_rounded,color:  primary,
                //         ),
                //         Text(
                //           "Clear",
                //           style: TextStyle(
                //             color:  primary,
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,),),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     GestureDetector(
                //       onTap: () async {
                //         var result= await  Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => CouponList()),
                //         );
                //         if(result!=null){
                //
                //           setState((){
                //             couponController.text = result['a'];
                //             coupon_id = result['b'];
                //             getVerifyCoupon();
                //           });
                //         }
                //       },
                //       child: Container(
                //           margin: EdgeInsets.only(right: 10),
                //           child: Text("Coupon List",
                //               style: TextStyle(
                //                 color: primary,
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w500,))),
                //     ),
                //   ],
                // ),
              ],
            ),
            Column(
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
                              "\u20B9${widget.plan_price.toString()}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                            ),
                          ],
                        ),
                        sizebox_height_10,
                        sprefs.getString("discountprice").toString() ==
                                    "null" ||
                                sprefs.getString("discountprice").toString() ==
                                    "0"
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
                                    "\u20B9${sprefs.getString("discountprice").toString()}",
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

                    var buyplanUrl = apiUrls().buy_user_plan_api;
                    var butplanBody = {
                      'plan_id': widget.plan_id.toString(),
                      couponController.text.toString() == "null"
                          ? ""
                          : "coupon": couponController.text.toString(),
                    };
                    print("buyplanUrl...." + buyplanUrl.toString());
                    print("butplanBody...." + butplanBody.toString());
                    log("razorpay_payment_show...." + sprefs.getString("razorpay_payment_show").toString());
                    // try {
                    //   CustomerInfo customerInfo =
                    //       await Purchases.purchasePackage(
                    //           offerings.current.availablePackages[0]);
                    //   appData.entitlementIsActive = customerInfo
                    //       .entitlements.all[entitlementID].isActive;
                    // } catch (e) {
                    //   print(e);
                    // }
                    // subscriptionController.productscheck.add(ProductDetails(id:"1",title: "MCQ + Notes",currencyCode: "INR",currencySymbol: "₹",description: "",price: "649.0",rawPrice: 649.0, ));
                    // subscriptionController.GetDilogssss(buyplanUrl);

                    if (Platform.isAndroid) {
                      subscriptionController.BuyPlanData(
                          buyplanUrl, butplanBody);
                    }
                    else {
                      if(sprefs.getString("razorpay_payment_show")=="1"){
                        subscriptionController.BuyPlanData(
                            buyplanUrl, butplanBody);
                      }else{
                        var generate_in_app_purchaseUrl = apiUrls().generate_in_app_purchase_api;
                        var generate_in_app_purchaseBody = {
                          'plan_id': widget.plan_id.toString(),
                          couponController.text.toString() == "null"
                              ? ""
                              :"coupon_id": couponController.text.toString(),
                          "package_id": widget.plan_inapp_id.toString(),
                        };
                        print("generate_in_app_purchaseUrl...." + generate_in_app_purchaseUrl.toString());
                        print("generate_in_app_purchaseBody...." + generate_in_app_purchaseBody.toString());
                        subscriptionController.generate_In_App_PurchaseData(generate_in_app_purchaseUrl, generate_in_app_purchaseBody);
                        subscriptionController.buy();
                      }

                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    alignment: Alignment.center,
                    height: 40,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.fromBorderSide(
                          BorderSide(color: primary, width: 1)),
                    ),
                    child: Text(
                      "Buy Subscription",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
