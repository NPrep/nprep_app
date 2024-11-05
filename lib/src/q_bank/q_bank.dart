import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/q_bank/subcat_qbank.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Qbank extends StatefulWidget {
  const Qbank({Key key});

  @override
  State<Qbank> createState() => _QbankState();
}

class _QbankState extends State<Qbank> {
  var page = 1;
  var limit = 100;
  var perentUrl;

  CategoryController categoryController = Get.put(CategoryController());

  getdata() async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    perentUrl = apiUrls().parent_categories_api + '?' + queryString;
    print("perentUrl......" + perentUrl.toString());

    await categoryController.ParentCategoryApi(perentUrl);
    log('parentData==>'+categoryController.parentData.toString());
  }

  String catname = "hhhh";

  ontap(perent_Id, catName) {
    sprefs.setString("perent_Id", perent_Id.toString());
    sprefs.setString("catName", catName.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Subcategory(
                perentId: perent_Id.toString(),
                categoryName: catName.toString(),
                categorytype: 1,
              )),
    );
  }

  categoryImage(imagess) {
    return CachedNetworkImage(imageUrl: imagess);
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    var sheight = MediaQuery.of(context).size.height;
    var swidth = MediaQuery.of(context).size.width;
    var mediaquary=MediaQuery.of(context);
  var  scale = mediaquary.textScaleFactor.clamp(1.10, 1.10);
    return Scaffold(
        body: GetBuilder<CategoryController>(builder: (categoryController) {
      if (categoryController.parentLoader.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: CircularProgressIndicator(
              color: primary,
            )),
            SizedBox(
              height: 5,
            ),
            Get.find<SettingController>()
                        .settingData['data']['general_settings']['quotes']
                        .length ==
                    0
                ? Text("")
                : Text(
                    '"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primary,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600)),
          ],
        );
      }
      return RefreshIndicator(
        displacement: 65,
        backgroundColor: Colors.white,
        color: primary,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          // var homeUrl = apiUrls().home_api;
          // Logger_D(homeUrl);
          // homeController.HomeApi(homeUrl,true);
          getdata();
        },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: categoryController.parentData['data']['data'].length,
          itemBuilder: (context, index) {
            var perentdata =
                categoryController.parentData['data']['data'][index];
            return Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 2),
              child: GestureDetector(
                onTap: () {
                  var perentId = perentdata['id'];
                  var catName = perentdata['category_name'].toString();
                  print("perentId....${perentId}");
                  ontap(perentId, catName);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // height: sheight * .1,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.shade300,
                  //         spreadRadius: 1,
                  //         blurRadius: 0.5,
                  //       )
                  //     ]),
                  // padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              imageUrl: perentdata['image'].toString(),
                              placeholder: (context, url) => Image.asset('assets/images/NPrep.jpeg'),
                              errorWidget: (context, url,e) => Image.asset('assets/images/NPrep.jpeg'),
                            )
                        ),
                        //
                        // FadeInImage.assetNetwork(
                        //     imageErrorBuilder:(context, error, stackTrace) {
                        //       return Container(
                        //         alignment: Alignment.center,
                        //         child: Image.asset(
                        //           "assets/images/NPrep.jpeg",
                        //           height: 55,
                        //           width: MediaQuery.of(context).size.width *
                        //               0.15,
                        //         ),
                        //       );
                        //     },
                        //     placeholder: "assets/images/NPrep.jpeg",
                        //     image: perentdata['image'].toString())
                        height: 60,
                        width: 60,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: swidth - 120,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            // color: primary,
                            child: Text(
                              "${perentdata['category_name'].toString()}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'PublicSans',
                                  color: black54,
                                  // height: 1.1,
                                  letterSpacing: 0.8),
                            ),
                            ),
                            // perentdata['attempt_percentage']==0?Container():
                            LinearPercentIndicator(
                              width: swidth>500?swidth * .820:swidth * .675,
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 5.0,
                              percent: double.parse(
                                  perentdata['attempt_percentage'].toString()),
                              barRadius: Radius.circular(1),
                              progressColor: primary,
                              backgroundColor: Colors.grey[300],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${perentdata['attempt_categories'].toString()}/'
                                '${perentdata['total_categories'].toString()} Blocks Completed',
                                style: TextStyle(
                                  color: black54,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      );
    }),
        );
  }
}
