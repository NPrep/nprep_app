import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/src/Coupon%20and%20Buy%20plan/subsciption_plan.dart';

import '../utils/colors.dart'; // Import necessary packages





class MyDialogSub extends StatefulWidget {
  @override
  _MyDialogSubState createState() => _MyDialogSubState();
}

class _MyDialogSubState extends State<MyDialogSub> {
  bool checked = false; // Initialize checked value

  void update() {
    setState(() {}); // Update UI
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Column(
          children: [
            SizedBox(height: 10), // SizedBox with a height of 10
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/nprep2_images/no_video_copyright.png",
                height: 80,
              ),
            ),
           // SizedBox with a height of 10
          SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text(
                "Oops.. You have subscribed for \nRapid Revision.\n\nGet NPrep Gold Plan to \naccess these videos.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog
                Get.to(SubscriptionPlan());
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primary, // Set button color
                ),
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  "Buy Subscription", // Display continue button text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // SizedBox with a height of 10
          ],
        ),
      ),
    );
  }
}
