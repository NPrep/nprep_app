import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/Shimmer/Shimmer.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/src/q_bank/custom_timeline.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../constants/Api_Urls.dart';
import 'package:dio/dio.dart';


class Subcategory extends StatefulWidget {
  var perentId;
  var categoryName;
  int categorytype;


  Subcategory({this.perentId,this.categoryName, this.categorytype});
  @override
  State<Subcategory> createState() => _SubcategoryState();
}



class _SubcategoryState extends State<Subcategory> with SingleTickerProviderStateMixin {

  // GetxModuleController getxModuleController = Get.put(GetxModuleController());


  CategoryController categoryController = Get.put(CategoryController());

  TabController _controller;
  ItemScrollController _scrollControllernew = ItemScrollController();
  ScrollController _scrollControllerlist = ScrollController();


  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      print('my index is' + _controller.index.toString());

      updatedata();
    });
    getdata();

  }


  getdata() async {
    Map<String, String> queryParams = {
      'parent_id': widget.perentId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var childUrl = apiUrls().child_categories_api + '?' + queryString;
    print("childUrl......" + childUrl.toString());
    // Get.find<CategoryController>().ChildCategoryApi(childUrl);
    await categoryController.ChildCategoryApi(childUrl,int.parse(widget.perentId));
  }

  updatedata() async {
    Map<String, String> queryParams = {
      'parent_id': widget.perentId.toString(),
      "status": _controller.index.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var childUrl = apiUrls().child_categories_api + '?' + queryString;
    print("update child cate......" + childUrl.toString());

    Get.find<CategoryController>().ChildCategoryApi(childUrl,int.parse(widget.perentId));
    // await categoryController.ChildCategoryApi(childUrl);
  }


  attempt_test_api(sab_cat_id, context, perentId, cat_name) async {
    if(categoryController.attempLoader.value ){
      // toastMsg("You allready selected blocks category, please wait....", true);
    }else{
      var temp = sprefs.getBool("is_internet");
      if(!temp) {
        toastMsg("Please Check Your Internet Connection", true);
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

  }

  scrolledddd(selectindex) {
    print("check scroll : "+selectindex.toString());
    try{
      // myScrollController.jumpTo(double.parse(selectindex.toString()));
      // _scrollControllernew.animateScroll(offset: 100, duration: Duration(seconds: 1));
      // _scrollControllernew.jumpTo(index: selectindex,);
      _scrollControllernew.scrollTo(index: selectindex,duration: Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }catch(e){
      print("check scroll : "+e.toString());
    }


    // _scrollController.animateTo(
    //   selectindex * 100.0,
    //   // Multiply by item height to scroll to the correct position
    //   duration: Duration(milliseconds: 500),
    //   // Adjust the duration as per your preference
    //   curve: Curves.easeInOut, // Adjust the scroll animation curve as per your preference
    // );
  }

  var _tabs =[
    // 'Demo',
    'All',
    "Unattempted",

 ];
  // "Paused",
  // "Completed",
  var cat_name;
  Map<String, dynamic> selectedItem;

  void onItemSelected(item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          if(widget.categorytype==1){
            final CancelToken cancelToken = CancelToken();
            cancelToken.cancel("Canceled by user.");
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
              statusBarColor: Color(0xFF64C4DA), // status bar color
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomBar(
                    bottomindex: 1,
                  )),
            );
          }else{
            return true;
          }

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.categoryName.toString() == "null" ? "" :
              widget.categoryName.toString(),
              style: TextStyle(color: white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PublicSans',
                  letterSpacing: 0.8),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                if(widget.categorytype==1){
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                    statusBarColor: Color(0xFF64C4DA), // status bar color
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomBar(
                          bottomindex: 1,
                        )),
                  );
                }else{
                      Get.back();
                }
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: [

              GetBuilder<CategoryController>(
                  builder: (categoryContro) {
                    if (categoryContro.childLoader.value) {
                      return CircularProgressIndicator();
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () async {
                          // final RelativeRect position = buttonMenuPosition(context);
                          showMenu(context: context,
                                constraints:  BoxConstraints.expand(
                                    width: 200, height: categoryContro.second_levelCount==1?60:categoryContro.second_levelCount==2?110:200),
                              position: RelativeRect.fromLTRB(10, 80, 2, 0),
                              items:
                          List.generate( categoryContro.childdata[0]['second_level'].length, (index1){
                           return PopupMenuItem<int>(
                              value: index1,
                              onTap: (){
                                scrolledddd(index1);
                              },
                              child:  Column(
                                         crossAxisAlignment: CrossAxisAlignment
                                             .start,
                                         children: [
                                           Text(
                                             categoryContro
                                                 .childdata[0]['second_level'][index1]['category_name']
                                                 .toString(),
                                             style: TextStyle(
                                               fontSize: 15,
                                               fontWeight: FontWeight.bold,
                                               fontFamily: 'Roboto',
                                             ),
                                           ),

                                           Text(
                                             "${categoryContro
                                                 .childdata[0]['second_level']
                                             [index1]['total_categories']
                                                 .toString()} blocks",
                                             style: TextStyle(
                                               fontSize: 13,
                                               fontWeight: FontWeight.w500,
                                               color: grey,
                                               fontFamily: 'Roboto',
                                             ),
                                           ),
                                           sizebox_height_10,
                                         ],
                                       ),
                            );
                          })

                          );



                          // await showMenu(
                          //   context: context,
                          //
                          //   constraints: const BoxConstraints.expand(
                          //       width: 200, height: 200),
                          //   position: RelativeRect.fromLTRB(10, 80, 2, 0),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.all(
                          //           Radius.circular(10.0))
                          //   ),
                          //
                          //   items: List.generate(
                          //     categoryContro.childdata[0]['second_level'].length, (index1) =>
                          //       PopupMenuItem(
                          //         value: index1,
                          //
                          //         child: GestureDetector(
                          //           onTap: scrolledddd(index1),
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment
                          //                 .start,
                          //             children: [
                          //               Text(
                          //                 categoryContro
                          //                     .childdata[0]['second_level'][index1]['category_name']
                          //                     .toString(),
                          //                 style: TextStyle(
                          //                   fontSize: 15,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontFamily: 'Roboto',
                          //                 ),
                          //               ),
                          //
                          //               Text(
                          //                 "${categoryContro
                          //                     .childdata[0]['second_level']
                          //                 [index1]['total_categories']
                          //                     .toString()} modules",
                          //                 style: TextStyle(
                          //                   fontSize: 13,
                          //                   fontWeight: FontWeight.w500,
                          //                   color: grey,
                          //                   fontFamily: 'Roboto',
                          //                 ),
                          //               ),
                          //               sizebox_height_10,
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //   ),
                          //   elevation: 8.0,
                          // ).then((value) {
                          //   if (value != null) print(value);
                          // });



                        },
                        child: Row(
                          children: [
                            Container(height: 30,width: 50,color: primary,),
                            Icon(
                              Icons.format_list_bulleted,
                              color: white,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              )

            ],
            bottom: TabBar(

              controller: _controller,
              labelColor: white,
              // labelPadding: EdgeInsets.zero,
              labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
              // dragStartBehavior: DragStartBehavior.start,

              // physics: ScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // onTap: tabbarotap(),
              isScrollable: false,

              labelPadding: EdgeInsets.only(left: 10, right: 5),
              tabs: _tabs
                  .map((label) => Padding(
                padding:
                const EdgeInsets.only(right: 10),
                child: Tab(text: "$label"),
              ))
                  .toList(),
            )
            ),

          body: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // AllListscrollDemo(),
              AllListscroll(),
              AllPausedList(),
              // AllCompletedList(),
              // AllNewList(),

            ],
          ),

        ),
      ),
    );
  }


  double itemExtent = 0.0;


  // Widget AllList() {
  //   return GetBuilder<CategoryController>(
  //       builder: (categoryContro) {
  //
  //         if (categoryContro.childLoader.value) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           return RefreshIndicator(
  //             displacement: 80,
  //             backgroundColor:primary,
  //             color: white,
  //             strokeWidth: 3,
  //             triggerMode: RefreshIndicatorTriggerMode.onEdge,
  //             onRefresh: () async {
  //               await Future.delayed(Duration(milliseconds: 1500));
  //               getdata();
  //             },
  //             child: LayoutBuilder(
  //                 builder: (BuildContext context,
  //                     BoxConstraints constraints) {
  //                   // Calculate itemExtent dynamically based on the available constraints
  //                   // itemExtent = constraints.maxHeight * 0.1;
  //                   return categoryContro.childdata.length==0?Center(child: Text("No Category Found")):
  //                   ListView.builder(
  //                     controller: _scrollController,
  //                     scrollDirection: Axis.vertical,
  //                     // physics: PageScrollPhysics(),
  //                     itemCount: categoryContro.childdata[0]['third_level'].length,
  //                     itemBuilder: (context, index) {
  //                       var cat = categoryContro.childdata[0]['third_level'][index];
  //
  //                       return Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.only(left: 5),
  //                               padding: EdgeInsets.only(top: 8.0,left: 8),
  //                               child: Text(
  //                                 cat['category_name'].toUpperCase() ?? "",
  //                                 style: TextStyle(
  //                                   fontSize: 16.5,
  //                                   color: black54,
  //                                   fontWeight: FontWeight.w500,
  //                                   fontFamily: 'Poppins-Regular',
  //                                 ),
  //                               ),
  //                             ),
  //                             Column(
  //                                 children: (cat['sub_category'] as List).map((
  //                                     data) {
  //                                   final subcategoryIndex = (cat['sub_category'] as List)
  //                                       .indexOf(data) + 1;
  //                                   return GestureDetector(
  //                                     onTap: () async {
  //                                       // if(data['fee_type']==1){
  //                                       //   toastMsg("msg", true);
  //                                       // }
  //
  //                                       var sabcatid = data['id'];
  //                                       var cate_names = data['category_name'];
  //                                       var perent_id = cat['category_name'];
  //
  //                                       print("sabcatid......"+sabcatid.toString());
  //                                       print("cate_names......"+cate_names.toString());
  //                                       print("perent_id......"+perent_id.toString());
  //                                       await attempt_test_api(
  //                                           sabcatid, context, perent_id,
  //                                           cate_names);
  //                                     },
  //                                     child: CustomTimeline(
  //                                       step: subcategoryIndex,
  //                                       image: data['image'],
  //                                       isLast: true,
  //                                       isFirst: true,
  //                                       mcq: data['attempt_questions'],
  //                                       topic: data['category_name'],
  //                                       status: data['attempt_questions']
  //                                           .toString() +
  //                                           "/" +
  //                                           data['total_questions'].toString(),
  //                                       label: data['fee_type'],
  //                                       labelColor: data['label'].toString() ==
  //                                           'FREE'
  //                                           ? Colors.orange
  //                                           : Colors.indigo.shade700,
  //                                     ),
  //                                   );
  //                                 }).toList())
  //                           ]);
  //                     },
  //                   );
  //                 }
  //             ),
  //           );
  //         }
  //       });
  // }
  // Widget AllListscrollDemo() {
  //   return GetBuilder<CategoryController>(
  //       builder: (categoryContro) {
  //
  //         if (categoryContro.childLoader.value) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           return RefreshIndicator(
  //             displacement: 80,
  //             backgroundColor:primary,
  //             color: white,
  //             strokeWidth: 3,
  //             triggerMode: RefreshIndicatorTriggerMode.onEdge,
  //             onRefresh: () async {
  //               await Future.delayed(Duration(milliseconds: 1500));
  //               getdata();
  //             },
  //             child: categoryContro.childdata.length==0?Center(child: Text("No Category Found")):
  //             ScrollConfiguration(
  //               behavior: _ScrollbarBehavior(),
  //               child: ScrollablePositionedList.builder(
  //
  //                 itemScrollController: _scrollControllernew,
  //                 itemCount:  categoryContro.childdata[0]['third_level'].length,
  //                 itemBuilder: (context, index) {
  //                   var cat = categoryContro.childdata[0]['third_level'][index];
  //                   return  Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           margin: EdgeInsets.only(left: 5),
  //                           padding: EdgeInsets.only(top: 8.0,left: 8),
  //                           child: Text(
  //                             cat['category_name'].toUpperCase() ?? "",
  //                             style: TextStyle(
  //                               fontSize: 16.5,
  //                               color: black54,
  //                               fontWeight: FontWeight.w500,
  //                               fontFamily: 'Poppins-Regular',
  //                             ),
  //                           ),
  //                         ),
  //                         ListView.builder(
  //                           controller: _scrollControllerlist,
  //                           shrinkWrap: true,
  //                           physics:NeverScrollableScrollPhysics(),
  //                           itemCount: cat['sub_category'].length,
  //                             itemBuilder: (context,indexxx){
  //                               var data=  cat['sub_category'][indexxx];
  //                           return GestureDetector(
  //                             onTap: () async {
  //                               // if(data['fee_type']==1){
  //                               //   toastMsg("msg", true);
  //                               // }
  //
  //                               var sabcatid = data['id'];
  //                               var cate_names = data['category_name'];
  //                               var perent_id = cat['category_name'];
  //
  //                               print("sabcatid......"+sabcatid.toString());
  //                               print("cate_names......"+cate_names.toString());
  //                               print("perent_id......"+perent_id.toString());
  //                               // Positioned(
  //                               //     right: 5,left: 5,top: 5,
  //                               //     child: Column(
  //                               //       mainAxisAlignment: MainAxisAlignment.center,
  //                               //       children: [
  //                               //         CircularProgressIndicator(),
  //                               //       ],
  //                               //     ))
  //                               // categoryContro.attempLoader.value ?
  //
  //                               await attempt_test_api(
  //                                   sabcatid, context, perent_id,
  //                                   cate_names);
  //
  //
  //                             },
  //                             child: Container(
  //                               margin: EdgeInsets.only(right: 10),
  //                               child: CustomTimeline(
  //                                 step: indexxx,
  //                                 image: data['image'],
  //                                 isLast: true,
  //                                 isFirst: true,
  //                                 mcq: data['total_questions'],
  //                                 noofattemp:data['total_attempt_test'] ,
  //                                 questionnoofattemp: data['attempt_questions'] ,
  //                                 examstatus:data['exam_status'] ,
  //                                 topic: data['category_name'],
  //                                 status: data['attempt_questions']
  //                                     .toString() +
  //                                     "/" +
  //                                     data['total_questions'].toString(),
  //                                 label: data['fee_type'],
  //                                 labelColor: data['label'].toString() ==
  //                                     'FREE'
  //                                     ? Colors.orange
  //                                     : Colors.indigo.shade700,
  //                               ),
  //                             ),
  //                           );
  //                         })
  //
  //                       ]);
  //                 },
  //               ),
  //             ),
  //           );
  //         }
  //       });
  // }

  Widget AllListscroll() {
    return GetBuilder<CategoryController>(
        builder: (categoryContro) {

          if (categoryContro.childLoader.value) {
            return Center(child: ShimmerScreen());
          } else {
            return RefreshIndicator(
              displacement: 80,
              backgroundColor:primary,
              color: white,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1500));
                getdata();
              },
              child: categoryContro.childdata.length==0?
              Center(child: Text("No Category Found")):
              ScrollablePositionedList.builder(

                itemScrollController: _scrollControllernew,
                itemCount:  categoryContro.childdata[0]['third_level'].length,
                itemBuilder: (context, index) {
                  var cat = categoryContro.childdata[0]['third_level'][index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.only(top: 8.0,left: 8),
                          child: Text(
                         cat['category_name'].toUpperCase() ?? "",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                        ),
                        Column(
                            children: (cat['sub_category'] as List).map((
                                data) {
                              final subcategoryIndex = (cat['sub_category'] as List)
                                  .indexOf(data) + 1;
                              return GestureDetector(
                                onTap: () async {
                                  // if(data['fee_type']==1){
                                  //   toastMsg("msg", true);
                                  // }

                                  var sabcatid = data['id'];
                                  var cate_names = data['category_name'];
                                  var perent_id = cat['category_name'];

                                  print("sabcatid......"+sabcatid.toString());
                                  print("cate_names......"+cate_names.toString());
                                  print("perent_id......"+perent_id.toString());
                                  // Positioned(
                                  //     right: 5,left: 5,top: 5,
                                  //     child: Column(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         CircularProgressIndicator(),
                                  //       ],
                                  //     ))
                                  // categoryContro.attempLoader.value ?

                                  await attempt_test_api(
                                      sabcatid, context, perent_id,
                                      cate_names);


                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: CustomTimeline(
                                    step: subcategoryIndex,
                                    image: data['image'],
                                    isLast: true,
                                    isFirst: true,
                                    mcq: data['total_questions'],
                                    noofattemp:data['total_attempt_test'] ,
                                    questionnoofattemp: data['attempt_questions'] ,
                                    examstatus:data['exam_status'] ,
                                    topic: data['category_name'],
                                    status: data['attempt_questions']
                                        .toString() +
                                        "/" +
                                        data['total_questions'].toString(),
                                    label: data['fee_type'],
                                    labelColor: data['label'].toString() ==
                                        'FREE'
                                        ? Colors.orange
                                        : Colors.indigo.shade700,
                                  ),
                                ),
                              );
                            }).toList())
                      ]);
                },
              ),
            );
          }
        });
  }
  Widget AllPausedList() {
    return GetBuilder<CategoryController>(
        builder: (categoryContro) {
          if (categoryContro.childLoader.value) {
            return Center(child: ShimmerScreen());
          } else {
            return RefreshIndicator(
              displacement: 80,
              backgroundColor:primary,
              color: white,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1500));
                updatedata();
              },
              child: categoryContro.childdata[0]['third_level'].length==0?
              Center(child: Text('Way to Go! You are set to Smash this subject in the Exam',textAlign: TextAlign.center,style: TextStyle(
                fontSize: 14,fontWeight: FontWeight.w400,
              ),)):
              ScrollablePositionedList.builder(
                itemScrollController: _scrollControllernew,
                itemCount:  categoryContro.childdata[0]['third_level'].length,
                itemBuilder: (context, index) {
                  var cat = categoryContro.childdata[0]['third_level'][index];
                  // var header_data =  categoryContro.childdata[0]['third_level'][index]['sub_category'][index];
                  // print("header_data....."+header_data.toString());
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header_data['exam_status'] ==2?
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            cat['category_name'].toUpperCase() ?? "",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                        ),

                        Column(
                            children: (cat['sub_category'] as List).map((data) {
                              final subcategoryIndex = (cat['sub_category'] as List)
                                  .indexOf(data) + 1;
                              return
                                GestureDetector(
                                  onTap: () async {
                                    var sabcatid = data['id'];
                                    var cate_names = data['category_name'];
                                    var perent_id = cat['category_name'];

                                    await attempt_test_api(
                                        sabcatid, context, perent_id, cate_names);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: CustomTimeline(
                                      step: subcategoryIndex,
                                      image: data['image'],
                                      isLast: true,
                                      isFirst: true,
                                      mcq: data['total_questions'],
                                      noofattemp:data['total_attempt_test'] ,
                                      questionnoofattemp: data['attempt_questions'] ,
                                      examstatus:data['exam_status'] ,
                                      topic: data['category_name'],
                                      status: data['attempt_questions']
                                          .toString() +
                                          "/" +
                                          data['total_questions'].toString(),
                                      label: data['fee_type'],
                                      labelColor: data['label'].toString() ==
                                          'FREE'
                                          ? Colors.orange
                                          : Colors.indigo.shade700,
                                    ),
                                  )
                                );
                            }).toList())
                      ]);
                },
              ),
            );
          }
        }
    );
  }

  Widget AllCompletedList() {
    return GetBuilder<CategoryController>(
        builder: (categoryContro) {
          if (categoryContro.childLoader.value) {
            return Center(child: ShimmerScreen());
          } else {
            return RefreshIndicator(
              displacement: 80,
              backgroundColor:primary,
              color: white,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1500));
                updatedata();
              },
              child:  ScrollablePositionedList.builder(
                itemScrollController: _scrollControllernew,
                itemCount:  categoryContro.childdata[0]['third_level'].length,
                itemBuilder: (context, index) {
                  var cat = categoryContro.childdata[0]['third_level'][index];
                  // var header_data =  categoryContro.childdata[0]['third_level'][index]['sub_category'][index];


                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // int.parse(header_data['exam_status'].toString()) ==3?
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            cat['category_name'].toUpperCase() ?? "",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                        ),
                        // :Container(),
                        // cat['sub_category'].length==0?Container():
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cat['sub_category'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, indexx) {
                              var data = cat['sub_category'][indexx];
                              return GestureDetector(
                                onTap: () async {
                                  var sabcatid = data['id'];
                                  var cate_names = data['category_name'];
                                  var perent_id = cat['category_name'];

                                  await attempt_test_api(
                                      sabcatid, context, perent_id, cate_names);
                                },
                                child: CustomTimeline(
                                  step: indexx,
                                  image: data['image'],
                                  isLast: true,
                                  isFirst: true,
                                  mcq: data['attempt_questions'],
                                  topic: data['category_name'],
                                  status: data['attempt_questions'].toString() +
                                      "/" + data['total_questions'].toString(),
                                  label: data['fee_type'],
                                  labelColor: data['label'].toString() == 'FREE'
                                      ? Colors.orange
                                      : Colors.indigo.shade700,
                                ),
                              );
                            })

                      ]);
                },
              ),
            );
          }
        });
  }


  Widget AllNewList() {
    return GetBuilder<CategoryController>(
        builder: (categoryContro) {
          if (categoryContro.childLoader.value) {
            return Center(child: ShimmerScreen());
          } else {
            return RefreshIndicator(
              displacement: 80,
              backgroundColor:primary,
              color: white,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1500));
                updatedata();
              },
              child:  ScrollablePositionedList.builder(
                itemScrollController: _scrollControllernew,
                itemCount:  categoryContro.childdata[0]['third_level'].length,
                itemBuilder: (context, index) {
                  var cat = categoryContro.childdata[0]['third_level'][index];
                  // var header_data =  categoryContro.childdata[0]['third_level'][index]['sub_category'][index];
               //   print("header_data.sub_category...." + cat.toString());
               //   print("header_data.sub_category...." + cat.toString());

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            cat['category_name'].toUpperCase() ?? "",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: black54,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins-Regular',
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cat['sub_category'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, indexx) {
                              var data = cat['sub_category'][indexx];
                              return GestureDetector(
                                onTap: () async {
                                  var sabcatid = data['id'];
                                  var cate_names = data['category_name'];
                                  var perent_id = cat['category_name'];

                                  await attempt_test_api(
                                      sabcatid, context, perent_id, cate_names);
                                },
                                child: CustomTimeline(
                                  step: indexx,
                                  image: data['image'],
                                  isLast: true,
                                  isFirst: true,
                                  mcq: data['attempt_questions'],
                                  topic: data['category_name'],
                                  status: data['attempt_questions'].toString() +
                                      "/" +
                                      data['total_questions'].toString(),
                                  label: data['fee_type'],
                                  labelColor: data['label'].toString() == 'FREE'
                                      ? Colors.orange
                                      : Colors.indigo.shade700,
                                ),
                              );
                            })
                        // Column(
                        //     children: (cat['sub_category'] as List).map((data) {
                        //       final subcategoryIndex = (cat['sub_category'] as List).indexOf(data) + 1;
                        //       return
                        //       GestureDetector(
                        //         onTap: () async {
                        //
                        //           var sabcatid = data['id'];
                        //           var cate_names = data['category_name'];
                        //           var perent_id =  cat['category_name'];
                        //
                        //           await attempt_test_api(sabcatid,context,perent_id,cate_names);
                        //
                        //         },
                        //         child: CustomTimeline(
                        //           step: subcategoryIndex,
                        //           image: data['image'],
                        //           isLast: true,
                        //           isFirst: true,
                        //           mcq: data['attempt_questions'],
                        //           topic: data['category_name'],
                        //           status: data['attempt_questions'].toString()+"/"+data['total_questions'].toString(),
                        //           label: data['fee_type'],
                        //           labelColor: data['label'].toString() == 'FREE' ?Colors.orange : Colors.indigo.shade700  ,
                        //         ),
                        //       );
                        //     }).toList())
                      ]);
                },
              ),
            );
          }
        });
  }
}
class _ScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(child: child, controller: details.controller);
  }
}