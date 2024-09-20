import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/src/q_bank/subcategory/getx_module_controller.dart';

import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';
import 'package:n_prep/utils/colors.dart';

import '../custom_timeline.dart';
import '../detail.dart';

class Modules extends StatefulWidget {
  List testData;
  String selectedTitle;
  String main_subject;
  final ScrollController scrollController;

  Modules(
    this.testData, this.selectedTitle, this.main_subject,this.scrollController,

      {
    Key key,
  });

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {

  GetxModuleController getxModuleController =Get.put(GetxModuleController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: getxModuleController.scrollController,
      scrollDirection: Axis.vertical,
      // physics: PageScrollPhysics(),
      itemCount: widget.testData.length,
      itemBuilder: (context, index) {
        var cat = widget.testData[index];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cat['title'].toUpperCase() ?? "",
              style: TextStyle(
                  fontSize: 16.5,
                color: black54,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins-Regular',
              ),
            ),
          ),
          Column(
              children: (cat[' '] as List).map((data) {
                final subcategoryIndex = (cat['subcat'] as List).indexOf(data) + 1;

                return GestureDetector(
              onTap: () {
                // add the condition of checking subscibed or not subscribed
                //if subscibed than add condition here
                //else jump on this  SubscriptionPlan(
                if (data['label'].toString() == 'FREE') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Details(title: data['subject'],header :widget.main_subject)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionPlan()));
                }
              },
              child: CustomTimeline(
                step: subcategoryIndex,
                image: data['image'],
                isLast: true,
                isFirst: true,
                mcq: data['mcq'],
                topic: data['subject'],
                status: data['status'],
                label: data['label'],
                labelColor: data['label'].toString() == 'FREE' ?Colors.orange : Colors.indigo.shade700  ,
              ),
            );
          }).toList())
        ]);
      },
    );
  }
}
