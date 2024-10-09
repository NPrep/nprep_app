import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/Demo.dart';
import 'package:n_prep/Internet_Connection/internetcontroller.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_search_screen.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/videosubjectscreen.dart';
import 'package:n_prep/src/test/year_wise_testpaper.dart';

import 'package:n_prep/src/home/drawer.dart';
import 'package:n_prep/src/home/home_page.dart';
import 'package:n_prep/src/q_bank/q_bank.dart';
import 'package:n_prep/utils/colors.dart';

import '../Coupon and Buy plan/subsciption_plan.dart';
import '../profile/profile.dart';

class BottomBar extends StatefulWidget {
  var bottomindex;
  int yearwiseTabindex;

  BottomBar({
    Key key,
    this.bottomindex,
    this.yearwiseTabindex,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndexBnb = 0;
  ConnectivityController intcontrl =Get.put(ConnectivityController());
  String title = "0";
  List bodys =[];
  void getpagesid(int yearwiseTabindex) {

    bodys = [
      HomePage(),
      Qbank(),
      YWTestPaper(indexslected:yearwiseTabindex),
      // Profile(),
      VideoSubjectScreen(),
      SubscriptionPlan(pagenav: true,),
    ];
  }
  @override
  void initState() {
    getpagesid(widget.yearwiseTabindex??0);
    _currentIndexBnb = widget.bottomindex == null ? 0 : widget.bottomindex;

    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
      statusBarColor: Color(0xFF64C4DA), // status bar color
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
      statusBarColor: Color(0xFF64C4DA),// status bar color
    ));
    return WillPopScope(
      onWillPop: () async {
        if(_scaffoldKey.currentState.isDrawerOpen){
          Navigator.of(context).pop();
          return false;
        }
        if(_currentIndexBnb != 0){
          setState((){
            _currentIndexBnb = 0;
          });
          return false;
        }
        else{
          // Show the dialog box when the user presses the back button
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Do you want to exit?',
                                style: TextStyle(color: primary, fontSize: 18,fontWeight: FontWeight.w600)),
                          ),
                          // Lottie.asset('assets/images/exit.json',width: 50,height: 50,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: Text('Yes', style: TextStyle(color: primary)),
                            onPressed: () {
                              exit(0); // Close the dialog and exit
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                side: BorderSide(width: 1, color: lightPrimary)),
                          ),
                          ElevatedButton(
                            child: Text('No', style: TextStyle(color: primary)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Close the dialog and don't exit
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                side: BorderSide(width: 1, color: lightPrimary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          return false;
        }// Prevent the default back button behavior
      },
      child: GetBuilder<ConnectivityController>(
          builder: (intcontrl) {
            return
            //   intcontrl.connectionType == MConnectivityResult.wifi
            // ///Wifi Connected
            //     ?
              Scaffold(
              key: _scaffoldKey,
              appBar:AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF64C4DA), // <-- SEE HERE
                  // statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
                  // statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
                ),
                centerTitle: true,
                elevation: 0,
                toolbarHeight: 50,
                title: _currentIndexBnb == 0
                    ? Image.asset(
                  logo,
                  color: white,
                  height: 35,
                  width: 120,

                )
                    : Text(
                    _currentIndexBnb == 1
                        ? 'Qbank'
                        : _currentIndexBnb == 2
                        ? 'Tests'
                        : _currentIndexBnb == 3?'Video':'Buy Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PublicSans',
                    )),
                leading: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Image.asset("assets/images/drawar.png",scale: 4.3,),
                ),

                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(VideoSearchScreen());
                    },
                    icon: Image.asset("assets/images/searchicon.png",scale: 2.4,),)
                ],
              ),
              body:bodys[_currentIndexBnb],
              drawer: MyDrawer(),
              bottomNavigationBar: _bottomappbar(MediaQuery.of(context).size),
            );
//                 : intcontrl.connectionType == MConnectivityResult.mobile
//             ///Mobile Data Connected
//                 ?
//             ///No Internet Available
//                 :
//             Scaffold(body: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
// Image.asset("assets/nprep2_images/wifi.png",height: 120,fit: BoxFit.cover,color: primary,),
//                          SizedBox(height: 30),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Internet connection lost!',
//                         style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900, color: primary,letterSpacing: 0.8),
//                       ),
//                     ),
//
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       alignment: Alignment.center,
//
//                       child: Text(
//                         'Check your connection and try again.',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   ],
//                   ));
          }
      )
    );
  }

  Widget _bottomappbar(size) {
    return BottomAppBar(
      child: Container(
        color: white,
        width: MediaQuery.of(context).size.width / 6,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildNavBarItem('assets/images/home.png', "Home", 0),
            buildNavBarItem('assets/images/qbank.png', "Qbank", 1),
            buildNavBarItem('assets/images/test.png', "Tests", 2),
            buildNavBarItem('assets/nprep2_images/bottomyoutube.png', "Video", 3),
            buildNavBarItem('assets/nprep2_images/subscription.png', "Buy", 4),
          ],
        ),
      ),
    );
  }

  GestureDetector buildNavBarItem(String imagePath, String label, int index) {
    bool isSelected = _currentIndexBnb == index;
    Color iconColor = isSelected ? primary : Colors.grey.withOpacity(0.6);
    Color textColor = isSelected ? primary : Colors.grey.withOpacity(0.6);
    Color bgColor = Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          log("Hit");
          _currentIndexBnb = index;
        });
      },
      child: Focus(
        canRequestFocus: false,
        // ↓ Focus widget handler, change color here
        onFocusChange: (hasFocus) {
          log("loged $hasFocus");
          if (hasFocus) {
            print('Name GAINED focus');
            setState(() {
              bgColor = Colors.black54;
            });
          }
          else {
            print('Name LOST focus');

            setState(() {
              bgColor = Colors.white;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 6,
          height: 60,
          color: bgColor,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(1),
          //
          //   boxShadow: [
          //     BoxShadow(color: Colors.green, spreadRadius: 3),
          //   ],
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                scale: 3,
                color: iconColor,
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'PublicSans',
                  fontSize: 10,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
