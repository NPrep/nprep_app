import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/Controller/Coupon_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/utils/colors.dart';

class CouponList extends StatefulWidget {
  const CouponList({ Key key});

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  CouponsController couponController = Get.put(CouponsController());

  @override
  void initState(){
    super.initState();
    var couponlistUrl = apiUrls().couponlist_api;
    couponController.CouponListData(couponlistUrl);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarHelper(
        title: 'Coupon List',
        context: context,
        fontsize: 18.0,
      ),
      body: GetBuilder<CouponsController>(
        builder: (couponContro) {
          if(couponContro.couponLoader.value){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Center(child: CircularProgressIndicator(color: white,)),
                SizedBox(height: 5,),
                Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                    color: primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600
                )),
              ],
            );
          }
          return ListView.builder(
              itemCount: couponContro.couponlist_data['data'].length,
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var getcouponsdata =  couponContro.couponlist_data['data'][index];
                return Container(
                  // height: 150,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5.0,
                    child: Padding(
                      padding:  EdgeInsets.only(left: 15.0,right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text("${getcouponsdata['name'].toString()}",
                            style: TextStyle(
                                fontSize: 16,fontWeight: FontWeight.bold,color: primary
                            ),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: size.width*0.7,
                                  child: Text("${getcouponsdata['code'].toString()}")),
                              GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: getcouponsdata['code'].toString()))
                                        .then((value) {
                                      //only if ->
                                      // Fluttertoast.showToast(
                                      //     msg:
                                      //     "Coupon code ${getcouponsdata['code'].toString()} copied successfully");

                                      Navigator.pop(context, {
                                        "a":"${getcouponsdata['code'].toString()}",
                                      "b":"${getcouponsdata['id'].toString()}"
                                    });
                                    });
                                  },
                                  child: Icon(Icons.copy,color: grey,size: 22,)

                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('Valid Till: ',
                                style: TextStyle(color: textColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Helvetica',
                                    fontSize: 13),),
                              Text("${DateFormat("d").format(
                                  DateTime.parse(
                                      getcouponsdata['start_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" ${DateFormat("MMM").format(
                                  DateTime.parse(
                                      getcouponsdata['start_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" ${DateFormat("y").format(
                                  DateTime.parse(
                                      getcouponsdata['start_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" To",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" ${DateFormat("d").format(
                                  DateTime.parse(
                                      getcouponsdata['end_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" ${DateFormat("MMM").format(
                                  DateTime.parse(
                                      getcouponsdata['end_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                              Text(" ${DateFormat("y").format(
                                  DateTime.parse(
                                      getcouponsdata['end_date'].toString()))}",style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Helvetica',
                                  fontSize: 13
                              )),
                            ],
                          ),
                          sizebox_height_5,
                          // Text("coupon discription"),
                          SizedBox(height: 10,),
                          // Text("Validate At: ${getcouponsdata.endDate.toString() == "null"?"":getcouponsdata.endDate.toString()}")
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
      ),
    );
  }
}
