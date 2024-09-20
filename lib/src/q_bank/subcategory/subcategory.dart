// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:n_prep/Controller/Category_Controller.dart';
// import 'package:n_prep/constants/Api_Urls.dart';
//
//
// import 'package:n_prep/constants/images.dart';
// import 'package:n_prep/src/q_bank/subcategory/getx_module_controller.dart';
//
// import 'package:n_prep/src/q_bank/subcategory/modules.dart';
// import 'package:n_prep/utils/colors.dart';
//
// class Subcategory extends StatefulWidget {
//   var perentId;
//   var categoryName;
//
//
//   Subcategory({this.perentId,this.categoryName});
//   @override
//   State<Subcategory> createState() => _SubcategoryState();
// }
//
// class _SubcategoryState extends State<Subcategory> {
//   //'assets/images/epd_img1.png'
//
//   GetxModuleController getxModuleController = Get.put(GetxModuleController());
//
//   CategoryController categoryController =Get.put(CategoryController());
//
//   var page = 1;
//   var limit = 10;
//   var childUrl;
//
//   getdata()async{
//     Map<String, String> queryParams = {
//       'parent_id':widget.perentId.toString(),
//     };
//     String queryString = Uri(queryParameters: queryParams).query;
//     childUrl = apiUrls().child_categories_api + '?' + queryString;
//     print("childUrl......"+childUrl.toString());
//
//     await categoryController.ChildCategoryApi(childUrl);
//   }
//
//   String subject = 'Embryonic Phase of\nDevelopement';
//   // for scroll item by popup
//   final ScrollController _scrollController = ScrollController();
//   String _selectedTitle = '';
//
//   void _onScroll() {
//     double offset = getxModuleController.scrollController.offset;
//     double itemHeight = 100.0; // Adjust this value according to your item's height
//
//     // Calculate the index of the currently visible item
//     int visibleIndex = (offset / itemHeight).floor();
//
//     if (visibleIndex >= 0 && visibleIndex < testData.length) {
//       getxModuleController.selectTitle(testData[visibleIndex]['title']);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getxModuleController.scrollController.addListener(_onScroll);
//     getdata();
//
//   }
//   List<Map<String, dynamic>> testData = [
//     {
//       'title': 'Embrylogy',
//       'subcat': [
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '14',
//           'label': 'FREE',
//           'status': 'completed on 12 june 2023'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': '5/15 completed'
//         },
//       ],
//     },
//     {
//       'title': 'Histology',
//       'subcat': [
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '14',
//           'label': 'FREE',
//           'status': '5/15 '
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': '5/15 completed'
//         },
//       ],
//     },
//     {
//       'title': 'Neuroanatomy',
//       'subcat': [
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '14',
//           'label': 'FREE',
//           'status': '5/15 completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': ''
//         },
//       ],
//     },
//     {
//       'title': 'Head & Neck',
//       'subcat': [
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '14',
//           'label': 'FREE',
//           'status': '5/15 completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': ''
//         },
//       ],
//     },
//     {
//       'title': 'Upper Limb',
//       'subcat': [
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '10',
//           'label': 'FREE',
//           'status': 'completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '20',
//           'label': 'PRO',
//           'status': ''
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '25',
//           'label': 'FREE',
//           'status': ' completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': '5/15 completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': '5/15 completed'
//         },
//         {
//           'image': '${subcategory}',
//           'subject': 'Embryonic Phase of\nDevelopement',
//           'mcq': '15',
//           'label': 'PRO',
//           'status': '5/15 completed'
//         },
//       ],
//     },
//   ];
//
//
//   void _handleHeaderTap(int index) {
//     double scrollOffset = getxModuleController.calculateScrollOffset(index, testData);
//     getxModuleController.scrollController.animateTo(
//       scrollOffset,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//     getxModuleController.selectTitle(testData[index]['title']); // Select the title
//     // Close the popup menu
//   }
//
//
//   showDialogsss(context){
//     return  Container(
//       height: 150,
//       width: 200,
//       child: ListView.builder(
//         itemCount: categoryController.child_map['data']['second_level'].length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (BuildContext context, int index) {
//           var second_data= categoryController.child_map['data']['second_level'][index];
//
//           return PopupMenuItem(
//             value: second_data['category_name'],
//             onTap: (){
//               _handleHeaderTap(index);
//               print(' title.......${second_data['title']}..........${index}');
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   second_data['category_name'],
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: 'Helvetica',
//                     fontWeight: FontWeight.w700,
//                     color: getxModuleController.selectedTitle.value == second_data['category_name']
//                         ? primary
//                         : Colors.black,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: Text(
//                     '${second_data['total_categories']} modules', // Count of child items
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: 'Helvetica',
//                       color: getxModuleController.selectedTitle.value == second_data['category_name']
//                           ? primary
//                           : Colors.grey,   ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     // String selectedTitle = '';
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.categoryName.toString()=="null"?"": widget.categoryName.toString(),
//             style: TextStyle(color: white,fontSize: 20,fontWeight: FontWeight.w700,fontFamily: 'Helvetica'),
//           ),
//           centerTitle: true,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Icon(Icons.arrow_back_ios, color: Colors.white),
//           ),
//           actions: [
//
//
//         GestureDetector(
//           onTap: (){
//             showDialogsss(context);
//           },
//           child: Row(
//                   children: [
//                     Icon(
//                       Icons.format_list_bulleted,
//                       color: white,
//                     ),
//                   ],
//                 ),
//         ),
//             // Padding(
//             //   padding:  EdgeInsets.only(right: 8),
//             //   child: GestureDetector(
//             //     onTap: () async {
//             //       var selectedTitle = await showMenu(
//             //         context: context,
//             //         position: RelativeRect.fromLTRB(100, 100, 0, 0),
//             //         items: categoryController.child_map['second_level'].asMap().entries.map((entry) {
//             //           final index = entry.key;
//             //           final data = entry.value;
//             //           print("dtaaaaaaaaaaaaa...${data.toString()}");
//             //           print("index......${index.toString()}");
//             //           return PopupMenuItem(
//             //             value: data['category_name'],
//             //             onTap: (){
//             //               _handleHeaderTap(index);
//             //               print(' title.......${data['title']}..........${index}');
//             //             },
//             //             child: Column(
//             //               crossAxisAlignment: CrossAxisAlignment.start,
//             //               children: [
//             //                 Text(
//             //                   data['category_name'],
//             //                   style: TextStyle(
//             //                     fontSize: 14,
//             //                     fontFamily: 'Helvetica',
//             //                     fontWeight: FontWeight.w700,
//             //                     color: getxModuleController.selectedTitle.value == data['category_name']
//             //                         ? primary
//             //                         : Colors.black,
//             //                     ),
//             //                 ),
//             //                 Padding(
//             //                   padding: const EdgeInsets.only(top: 4),
//             //                   child: Text(
//             //                     '${data['total_categories']} modules', // Count of child items
//             //                     style: TextStyle(
//             //                       fontSize: 11,
//             //                       fontWeight: FontWeight.w700,
//             //                       fontFamily: 'Helvetica',
//             //                       color: getxModuleController.selectedTitle.value == data['category_name']
//             //                           ? primary
//             //                           : Colors.grey,   ),
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           );
//             //         }).toList(),
//             //       );
//             //
//             //
//             //       if (selectedTitle != null) {
//             //         setState(() {
//             //           getxModuleController.selectTitle(selectedTitle); // Update selected title
//             //         });
//             //       }
//             //     },
//             //     child: Row(
//             //       children: [
//             //         Icon(
//             //           Icons.format_list_bulleted,
//             //           color: white,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // )
//           ],
//           bottom: TabBar(
//             labelColor: white,
//             labelPadding: EdgeInsets.zero,
//             labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
//             dragStartBehavior: DragStartBehavior.start,
//             physics: ScrollPhysics(),
//             // onTap: tabbarotap(),
//
//
//             tabs: [
//               Tab(text: 'All'),
//               Tab(text: 'Paused'),
//               Tab(text: 'Completed'),
//               Tab(text: 'Unattempted'),
//             ],
//           ),
//         ),
//         body: GetBuilder<CategoryController>(
//             builder: (categoryContro) {
//               if(categoryContro.childLoader.value){
//                 return CircularProgressIndicator();
//               }
//             return TabBarView(
//               children: [
//                 Modules(testData, _selectedTitle, widget.perentId,_scrollController),
//                 Modules(testData, _selectedTitle, widget.perentId,_scrollController),
//                 Modules(testData, _selectedTitle, widget.perentId,_scrollController),
//                 Modules(testData, _selectedTitle, widget.perentId,_scrollController),
//               ],
//             );
//           }
//         ),
//       ),
//     );
//   }
// }
