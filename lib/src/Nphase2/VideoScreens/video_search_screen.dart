import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/src/Nphase2/Constant/textstyles_constants.dart';
import 'package:n_prep/src/Nphase2/Controller/SearchVideoMCQController.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
import 'package:n_prep/src/q_bank/subcat_qbank.dart';
import 'package:n_prep/utils/colors.dart';


class VideoSearchScreen extends StatefulWidget {
  VideoSearchScreen();

  @override
  State<VideoSearchScreen> createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen>with SingleTickerProviderStateMixin {
  CategoryController categoryController = Get.put(CategoryController());
   TabController tabController;
   SearchVideomcqcontroller searchVideomcqcontroller=Get.put(SearchVideomcqcontroller());
  List<Map<String,dynamic>> Data=[
    {
  "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/video_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/bulb_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/bulb_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
    {
      "icon":"assets/nprep2_images/watch_icon.png",
      "text" : "Brain tumours ",
      "text2" : "Radiology Revision - 5 E6,5 Revision Videos"
    },
  ];
  attempt_test_api(sab_cat_id, context, perentId, cat_name) async {
    if(categoryController.attempLoader.value ){
      // toastMsg("You allready selected blocks category, please wait....", true);
    }else{
      Map<String, String> queryParams = {
        'category_id': sab_cat_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var attempUrl = apiUrls().test_attempt_api + '?' + queryString;
      print("attempUrl......" + attempUrl.toString());

      await categoryController.AttemptTestApi(
        attempUrl, context, perentId, cat_name,false);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchVideomcqcontroller.earchVideomcqdata.clear();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      print('my index is' + tabController.index.toString());
      print('my searchvideomcq text' + searchVideomcqcontroller.searchvideomcq.text.toString());
      searchVideomcqcontroller.category_type.value =tabController.index;
      searchVideomcqcontroller.FetchSearchVideomcqData(searchVideomcqcontroller.searchvideomcq.text);
    });
    // searchVideomcqcontroller.FetchSearchVideomcqData(searchVideomcqcontroller.searchvideomcq.text);
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var height=size.height;

    return DefaultTabController(
      length: 4,
      child: GetBuilder<SearchVideomcqcontroller>(
        builder: (searchVideomcqcontroller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: Icon(Icons.chevron_left,size: 30,color: white,),
              ),
              actions: [
               GestureDetector(
                    onTap: (){
                      searchVideomcqcontroller.searchvideomcqUpdate();
                    },
                    child: Icon(Icons.search,color:white)),
                SizedBox(width: 10,),
                searchVideomcqcontroller.searchvideomcq.text.isEmpty?Container():   GestureDetector(
                    onTap: (){
                      searchVideomcqcontroller.clearsearchvideomcqUpdate();
                    },child: Icon(Icons.close,color:white )),
                // Icon(Icons.search,color:white)
                SizedBox(width: 10,)
              ],
              centerTitle: true,
              title:  Container(
                margin: EdgeInsets.only(left: 5),
                child: CustomTextFormField(
                  // validator: Validations.validatePassword,

                onButtonSave: (v){
                  log("OnButton Save");
                  searchVideomcqcontroller.searchvideomcqUpdate();
                },
                  status_cursor: true,
                  bordersinput:UnderlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                    // borderSide: BorderSide.none,
                    borderSide: BorderSide(
                        width: 1, color: Colors.white),


                  ),
                  hinttextstyle: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.w500,
                      color: Colors.white38
                  ),
                  styles: TextStyle(
                      fontSize: 15,fontWeight: FontWeight.w500,
                      color: white
                  ),
                  hintText: 'Search Videos/MCQ',
                  controller: searchVideomcqcontroller.searchvideomcq,
                  // l_icon: Image.asset(password_icon,scale: 2.8,),
                  textInputAction: TextInputAction.next,

                  keyType: TextInputType.visiblePassword,
                  // obscure: obscureText,
                  // suffix: IconButton(
                  //   icon: obscureText==true?Icon(Icons.visibility_off,size: 16,):Icon(Icons.visibility,size: 16),
                  //   onPressed: (){
                  //     toggle();
                  //   },
                  // ),
                ),
              ),

              backgroundColor: primary,
              bottom: TabBar(
                controller: tabController,
                labelColor: white,
                isScrollable: false,
                labelStyle: AppbarTabLableTextyle,
                dragStartBehavior: DragStartBehavior.start,
                indicatorColor: white,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'QBank'),
                  Tab(text: 'Videos'),
                ],
              ),
            ),

            body: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GetBuilder<SearchVideomcqcontroller>(
                  builder: (searchVideomcqcontroller) {
                    if(searchVideomcqcontroller.earchVideomcqloader.value){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Center(child: CircularProgressIndicator(color: black54,)),
                          SizedBox(height: 5,),
                          Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                          Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                              color: primary,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600
                          )),                        ],
                      );
                    }
                    else{
                      return searchVideomcqcontroller.earchVideomcqdata.length==0?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          searchVideomcqcontroller.searchvideomcq.text.isEmpty?
                          Text("Search topics from QBank and Videos",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),):
                          Text("No result found",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),),
                          // SizedBox(height: 10,),
                          // Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                          // Text(Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString(),style: TextStyle(color: black54,),),
                        ],
                      ):
                      ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: searchVideomcqcontroller.earchVideomcqdata.length,
                          itemBuilder: (context,index){
                            var searchData =searchVideomcqcontroller.earchVideomcqdata[index];
                            return  GestureDetector(
                              onTap: () async {
                                // Get.to(VideoScreen(""));
                                if(searchData["category_type"]==1){
                                  await attempt_test_api(
                                      searchData["child_categpry"].toString(), context, searchData["category_name"].toString(),
                                      searchData["category_name"].toString());
                                }else{
                                  Get.to(VideoDetailScreen(CatId: searchData["child_categpry"]));
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: size.width*0.10,
                                          child: Image.network(searchData["image"],
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                        sizebox_width_10,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              width: size.width-100,
                                              child: Text( searchData["category_name"],
                                                style:BrainListTitleTextyle,),
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Text(searchData["parent_name"] + " - ",style:BrainListmainTitleTextyle),
                                                Text(searchData["sub_name"],style:BrainListSubTitleTextyle),
                                              ],
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      height: 20,
                                      color: grey,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                  ],
                                ),
                              ),
                            );


                          }
                      );
                    }
                  }
                ),
                GetBuilder<SearchVideomcqcontroller>(
                    builder: (searchVideomcqcontroller) {
                      if(searchVideomcqcontroller.earchVideomcqloader.value){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Center(child: CircularProgressIndicator(color: black54,)),
                            SizedBox(height: 5,),
                            Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                            Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                                color: primary,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600
                            )),                          ],
                        );
                      }
                      else{
                        return searchVideomcqcontroller.earchVideomcqdata.length==0?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            searchVideomcqcontroller.searchvideomcq.text.isEmpty?
                            Text("Search topics from QBank and Videos",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),):
                            Text("No result found",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),),
                            // SizedBox(height: 10,),
                            // Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                            // Text(Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString(),style: TextStyle(color: black54,),),
                          ],
                        ):
                        ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: searchVideomcqcontroller.earchVideomcqdata.length,
                            itemBuilder: (context,index){
                              var searchData =searchVideomcqcontroller.earchVideomcqdata[index];
                              return  GestureDetector(
                                onTap: () async {
                                  // Get.to(VideoScreen(""));
                                  await attempt_test_api(
                                      searchData["child_categpry"].toString(), context, searchData["category_name"].toString(),
                                      searchData["category_name"].toString());
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Subcategory(perentId: searchData["child_categpry"].toString(),
                                  //     categoryName: searchData["category_name"].toString(),categorytype: 2,)),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: size.width*0.10,
                                            child: Image.network(searchData["image"],
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          sizebox_width_10,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Container(
                                                width: size.width-100,
                                                child: Text( searchData["category_name"],
                                                  style:BrainListTitleTextyle,),
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Text(searchData["parent_name"] + " - ",style:BrainListmainTitleTextyle),
                                                  Text(searchData["sub_name"],style:BrainListSubTitleTextyle),
                                                ],
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                        height: 20,
                                        color: grey,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );


                            }
                        );
                      }
                    }
                ),
                GetBuilder<SearchVideomcqcontroller>(
                    builder: (searchVideomcqcontroller) {
                      if(searchVideomcqcontroller.earchVideomcqloader.value){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Center(child: CircularProgressIndicator(color: black54,)),
                            SizedBox(height: 5,),
                            Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                            Text('"${Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString()}"',textAlign: TextAlign.center, style: TextStyle(
                                color: primary,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600
                            )),                          ],
                        );
                      }
                      else{
                        return searchVideomcqcontroller.earchVideomcqdata.length==0?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            searchVideomcqcontroller.searchvideomcq.text.isEmpty?
                            Text("Search topics from QBank and Videos",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),):
                            Text("No result found",style: TextStyle(color: darkPrimary,fontWeight: FontWeight.bold),),
                            // SizedBox(height: 10,),
                            // Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length ==0?Text(""):
                            // Text(Get.find<SettingController>().settingData['data']['general_settings']['quotes'][random.nextInt(Get.find<SettingController>().settingData['data']['general_settings']['quotes'].length)].toString(),style: TextStyle(color: black54,),),
                          ],
                        ):
                        ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: searchVideomcqcontroller.earchVideomcqdata.length,
                            itemBuilder: (context,index){
                              var searchData =searchVideomcqcontroller.earchVideomcqdata[index];
                              return  GestureDetector(
                                onTap: () async {
                                  // Get.to(VideoScreen(""));

                                  Get.to(VideoDetailScreen(CatId: searchData["child_categpry"]));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: size.width*0.10,
                                            child: Image.network(searchData["image"],
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          sizebox_width_10,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Container(
                                                width: size.width-100,
                                                child: Text( searchData["category_name"],
                                                  style:BrainListTitleTextyle,),
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Text(searchData["parent_name"] + " - ",style:BrainListmainTitleTextyle),
                                                  Text(searchData["sub_name"],style:BrainListSubTitleTextyle),
                                                ],
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                        height: 20,
                                        color: grey,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              //   Container(
                              //     width: width,
                              //
                              //    // color: Colors.green,
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           children: [
                              //             Image.asset(Data[index]["icon"],height: 25,width: 25,),
                              //             Expanded(
                              //                 child: Container(
                              //                   child: Container(
                              //                     margin: EdgeInsets.only(left: 10),
                              //                     child: Column(
                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                              //                       children: [
                              //                         Padding(
                              //                           padding:EdgeInsets.only(top: height*0.005),
                              //                           child: Text("Brain tumours ",style:BrainListTitleTextyle,),
                              //                         ),
                              //                         Text("Radiology Revision - 5 E6,5 Revision Videos",style:BrainListSubTitleTextyle)
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 )),
                              //           ],
                              //         ),
                              //         Container(
                              //           margin: EdgeInsets.only(left: 20,right: 20),
                              //           child: Divider(height: 2,
                              //             color: Color(0xff9E9E9E),),
                              //         ),
                              //       ],
                              //     ),
                              //   );
                            }
                        );
                      }
                    }
                ),

              ],
            ),
          );
        }
      ),

    );
  }
}
