import 'package:flutter/material.dart';
import 'package:n_prep/main.dart';

import '../utils/colors.dart'; // Import necessary packages





class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
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
        height: 350,
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
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text(
                "Warning", // Display warning text
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            SizedBox(height: 10), // SizedBox with a height of 10
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text(
                "These videos are a copyright of NPrep. Any attempts to record or distribute the video will initiate a legal procedure without a prior warning.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Checkbox(
                  value: checked,
                  onChanged: (changedValue) {
                    checked = changedValue; // Update checked value
                    sprefs.setBool("updateshowpop", checked);
                    update(); // Update UI
                  },
                ),
                Text("Don't show this again", style: TextStyle(
                  color: Colors.black,
                ),), // Display checkbox label
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog
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
                  "Continue", // Display continue button text
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
