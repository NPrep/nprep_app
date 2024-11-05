import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/Controller/SubscriptionController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/utils/colors.dart';

import '../../../Controller/profile/profile_controller.dart';
import '../../Coupon and Buy plan/Active_plans.dart';
import '../../Coupon and Buy plan/subsciption_plan.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {


  SubscriptionController subscriptionController =Get.put(SubscriptionController());
  ProfileController profileController = Get.put(ProfileController());
var planhistoryUrl;

  @override
  void initState() {
    super.initState();
    call_profile();
    planhistoryUrl = apiUrls().plan_history_api;
    print("planhistoryUrl....."+planhistoryUrl.toString());
    subscriptionController.PlanHistoryData(planhistoryUrl);
  }



  call_profile() async {
    var profileUrl = "${apiUrls().profile_api}";
    // Logger_D(profileUrl);
    await profileController.GetProfile(profileUrl);
    log('hhhh==>'+profileController.profileData['data']['activePlan']['subscription_name'].toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        appBar: AppBarHelper(
          context: context,
          showBackIcon: true,
          title: 'Payment History',
        ),
        body: GetBuilder<SubscriptionController>(
          builder: (planController) {
            if(planController.planLoader.value){
              return Center(child: CircularProgressIndicator());
            }
            return planController.planData['data'].length==0

                ?Center(child: Text("No data found")):
            RefreshIndicator(
              displacement: 65,
              backgroundColor: Colors.white,
              color: primary,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1500));
                  planhistoryUrl = apiUrls().plan_history_api;
                print("planhistoryUrl....."+planhistoryUrl.toString());
                subscriptionController.PlanHistoryData(planhistoryUrl);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 7,),
                   Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: Container(
                       width:Get.width,
                       height:Get.height*0.15,
                      // color: Colors.red,
                       child: Container(
                         margin: EdgeInsets.only(left: 20),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment:MainAxisAlignment.center,
                           children: [
                             profileController.profileData['data']['activePlan']==null?
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
                                 RichText(text: TextSpan(children: [
                                   TextSpan(text: 'Current Plan: ', style: TextStyle(
                                       color: primary,
                                       fontFamily: 'Poppins-Regular',
                                       fontWeight: FontWeight.w700,
                                       fontSize: 20),),
                                   TextSpan(text:  profileController.profileData['data']['activePlan']['subscription_name'].toString().capitalize, style: TextStyle(
                                       color: primary,
                                       fontFamily: 'Poppins-Regular',
                                       fontWeight: FontWeight.w700,
                                       fontSize: 18),),
                                 ])),
                             SizedBox(height: 10,),

                             profileController.profileData['data']['activePlan']==null?
                             Container():Text(
                               'Expire Date: ${profileController.profileData['data']['activePlan']['expire_date']}',
                               style: TextStyle(
                                   color: black54,
                                   fontFamily: 'Poppins-Regular',
                                   fontWeight: FontWeight.w700,
                                   fontSize: 15),
                             ),
                             SizedBox(height: 10,),
                             profileController.profileData['data']['activePlan']==null?Container():
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

                           ],
                         ),
                       ),
                     ),
                   ),
                    ListView.builder(
                      itemCount: planController.planData['data'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var payment_data= planController.planData['data'][index];
                        return Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Padding(
                              padding:  EdgeInsets.all(5.0),

                              child: Container(

                                 padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                      spreadRadius: 1, // Spread radius
                                      blurRadius: 1, // Blur radius
                                      offset: Offset(1, 1), // Offset in the form of (dx, dy)
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0,right: 5),
                                              child: Card(
                                                elevation: 3,
                                                child: Container(

                                                  child: Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Column(
                                                      children: [
                                                        Text('Plan Purchase Date',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: 'Helvetica',
                                                            fontSize: 10,
                                                            color: black54,
                                                          ),),
                                                        sizebox_height_5,
                                                        Text("${DateFormat("d").format(
                                                            DateTime.parse(
                                                                payment_data['purchse_date'].toString()))}",style: TextStyle(
                                                          color: primary,
                                                          fontSize: 35,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'Helvetica',
                                                        )),
                                                        Text("${DateFormat("MMM y").format(
                                                            DateTime.parse(
                                                                payment_data['purchse_date'].toString()))}",style: TextStyle(
                                                          color: primary,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: 'Helvetica',
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Padding(
                                              padding:  EdgeInsets.all(1.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(top: 5.0),
                                                  //   child: Row(
                                                  //     children: [
                                                  //       Text('Valid From: ',
                                                  //         style: TextStyle(color: textColor,
                                                  //             fontWeight: FontWeight.w500,
                                                  //             fontFamily: 'Helvetica',
                                                  //             fontSize: 13),),
                                                  //       Text("${DateFormat("d").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['start_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " ${DateFormat("MMM").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['start_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " ${DateFormat("y").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['start_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " To",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " ${DateFormat("d").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['expire_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " ${DateFormat("MMM").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['expire_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       Text(
                                                  //       " ${DateFormat("y").format(
                                                  //           DateTime.parse(
                                                  //               payment_data['expire_date'].toString()))}",style: TextStyle(
                                                  //           color: textColor,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontFamily: 'Helvetica',
                                                  //           fontSize: 13
                                                  //       )
                                                  //       ),
                                                  //       // Text("validity",
                                                  //       //   style: TextStyle(color: black54,
                                                  //       //       fontWeight: FontWeight.w400,
                                                  //       //       fontFamily: 'Helvetica',
                                                  //       //       fontSize: 12),),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  RichText(text: TextSpan(children:
                                                  [
                                                    TextSpan(text:'Valid From: ' ,style: TextStyle(color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13), ),
                                                    TextSpan(text:"${DateFormat("d").format(
                                                        DateTime.parse(
                                                            payment_data['start_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    ) ),
                                                    TextSpan(
                                                        text:  " ${DateFormat("MMM").format(
                                                            DateTime.parse(
                                                                payment_data['start_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),
                                                    TextSpan(
                                                        text:   " ${DateFormat("y").format(
                                                            DateTime.parse(
                                                                payment_data['start_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),
                                                    TextSpan(
                                                        text:  " To",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),
                                                    TextSpan(
                                                        text: " ${DateFormat("d").format(
                                                            DateTime.parse(
                                                                payment_data['expire_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),
                                                    TextSpan(
                                                        text:     " ${DateFormat("MMM").format(
                                                            DateTime.parse(
                                                                payment_data['expire_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),
                                                    TextSpan(
                                                        text:  " ${DateFormat("y").format(
                                                            DateTime.parse(
                                                                payment_data['expire_date'].toString()))}",style: TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Helvetica',
                                                        fontSize: 13
                                                    )
                                                    ),



                                                  ])),
                                                  SizedBox(height: 10,),
                                                  Text("${payment_data['subscription_name'].toString()}",style: TextStyle(color: black54,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Helvetica',fontSize: 16,)),
                                                  SizedBox(height: 12,),
                                                  Text('\u20B9${payment_data['plan_price'].toString()}',
                                                      style: TextStyle(color:primary,

                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: 'Helvetica',fontSize: 14))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 5,top:28,
                                child:   Container(

                              height: size.height *0.06,
                              width: size.width *0.012,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                            Positioned(
                                right: 14,top:8,
                                child: Text(int.parse(payment_data['payment_status'].toString())==0
                                    ?"Failed":"Sucess",
                                    style: TextStyle(
                                        color:
                                        int.parse(payment_data['payment_status'].toString())==0
                                            ?
                                        Colors.red:
                                        Colors.green,

                                        fontWeight: FontWeight.w500,
                                        // fontFamily: 'Helvetica',
                                        fontSize: 14
                                    )),),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}


