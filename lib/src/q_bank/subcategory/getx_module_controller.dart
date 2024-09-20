 import 'package:flutter/material.dart';
import 'package:get/get.dart';

 class GetxModuleController extends GetxController {
   ScrollController scrollController = ScrollController();
   RxString selectedTitle = ''.obs;
   // Calculate the total height based on the index
   double calculateScrollOffset(int index, List<Map<String, dynamic>> testData) {
     double totalHeight = 0.0;

     for (int i = 0; i < index; i++) {
       Map<String, dynamic> category = testData[i];
       totalHeight += _calculateCategoryHeight(category);
       print("totalHeight......${totalHeight}");
     }

     return totalHeight;
   }

   double _calculateCategoryHeight(Map<String, dynamic> category) {
     double headerHeight = 60.0; // Assuming each header is 60 pixels tall
     double itemHeight = 100.0; // Default item height

     // You can adjust itemHeight based on your content within the category
     double categoryItemsHeight = category['subcat'].length * itemHeight;
     print("categoryItemsHeight......${categoryItemsHeight.toString()}");
     return headerHeight + categoryItemsHeight;
   }
   void selectTitle(String title) {
     selectedTitle.value = title;
   }
 }
