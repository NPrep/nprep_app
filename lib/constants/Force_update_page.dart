
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:n_prep/Envirovement/Environment.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import '../main.dart';
import '../src/home/bottom_bar.dart';
import '../src/login_page/login_page.dart';
import 'Api_Urls.dart';


class ForceUpdatePage extends StatefulWidget {
  var forceupdate,appurl,appname,applogo,appupdatetext;
   ForceUpdatePage({this.forceupdate,this.applogo,this.appname,this.appurl,this.appupdatetext}) ;

  @override
  State<ForceUpdatePage> createState() => _ForceUpdatePageState();
}

class _ForceUpdatePageState extends State<ForceUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return   WillPopScope(

      onWillPop: () async {
        var sharedPref = await SharedPreferences.getInstance();
        if (widget.forceupdate.toString() !=apiUrls().App_force_updateNo.toString()) {
          print("object");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
        } else {
          return false;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
        }

      },

      child: Dialog(

        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 300,
            width: 400,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                SizedBox(
                  height: 20,
                ),
                Text(widget.appname.toString(),
                  style: TextStyle(fontSize: 20.5,fontWeight: FontWeight.w600,letterSpacing: 0.2),),

                SizedBox(
                  height: 10,
                ),
                Image.network(
                  widget.applogo.toString(),height: 105,width: 115,color: primary,),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10),
                  child: Text(widget.appupdatetext.toString(),
                  textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.5,fontWeight: FontWeight.w400,letterSpacing: 0.2),),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {

                      // var shar = widget.appurl.split("=")[1];
                      // print("shar....."+shar.toString());
                      StoreRedirect.redirect(
                          androidAppId:widget.appurl.toString(),
                        iOSAppId: widget.appurl.toString()
                      );
                    },
                    child: Text(Platform.isAndroid?"Go To Play Store":"Go To App Store",style: TextStyle(fontSize: 12.5,color: Colors.white,fontWeight: FontWeight.w400,letterSpacing: 0.2))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
