import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:n_prep/Controller/Exam_Controller.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/main.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScoreListScreen extends StatefulWidget {
  var exam_id;
  bool today =false;
   ScoreListScreen({this.exam_id,this.today});

  @override
  State<ScoreListScreen> createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  String imagePath;
  static GlobalKey previewContainer = GlobalKey();
  SettingController settingController =Get.put(SettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallLeadershipApi();
  }
  CallLeadershipApi() async {

    var url =apiUrls().Exam_leadership_api+widget.exam_id.toString();
    await Get.find<ExamController>().GetExamScore(url);
    var settingUrl ="${apiUrls().setting_api}";
    await settingController.SettingData(settingUrl);

  }
  @override
  Widget build(BuildContext context) {
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay noon = TimeOfDay(hour: 12, minute: 0);

    return RepaintBoundary(
      key:previewContainer ,
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder<ExamController>(
            builder: (examController)
            {
              if (examController.examScoreLoader.value) {
                return Center(child: CircularProgressIndicator());
              } else{
                return Column(
                  children: [
                      // Text(widget.today.toString()+"g"),
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          // color: Colors.red,
                          padding: EdgeInsets.all(0.8),
                          child: Stack(
                            clipBehavior: Clip.none,

                            children: [
                              Image.asset(
                                "assets/nprep2_images/golden_top.png", height: 250,),
                              Positioned(
                                  top: 10,
                                  left: 55,
                                  right: 40,
                                  bottom: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Text("Predicted Rank", style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),),
                                      Text(examController.examScore_data[0]["rank_range"], style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 20)),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,

                          child:  GestureDetector(
                              onTap: (){
                                print("HIIIIII");
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios)),
                        )

                      ],
                    ),
                    GestureDetector(
                        onTap: () async {
                          // Capture the screenshot
                          try {

                            // Add a delay to ensure that the widget is fully rendered
                            await Future.delayed(Duration(seconds: 1));

                            // Capture the screenshot
                            final boundary = previewContainer.currentContext.findRenderObject() as RenderRepaintBoundary;
                            final image = await boundary.toImage();
                            final byteData = await image.toByteData(format: ImageByteFormat.png);
                            final pngBytes = byteData.buffer.asUint8List();

                            // Get the application documents directory
                            final directory = await getApplicationDocumentsDirectory();
                            imagePath = '${directory.path}/screenshot${Random()}.png';
                            print('screenShotPath==> $imagePath');
                            setState(() {

                            });
                            // Write the screenshot to a file
                            final imgFile = File(imagePath);
                            await imgFile.writeAsBytes(pngBytes);
                            Share.shareFiles(['${imagePath}'], text: 'Your Rank');

                            print('Screenshot saved at: $imagePath');
                          } catch (e) {
                            print('Error capturing screenshot: $e');
                          }

                        },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(Icons.share),
                                SizedBox(width: 5,),
                                Text("Share this screenshot")
                              ]
                            )
                    ),
                    Expanded(
                      child: currentTime.hour >= noon.hour && currentTime.minute >= noon.minute ?
                         ListView.builder(
                          itemCount: 9,
                          // itemCount: examController.examScore_data[0]['max_rank'],
                          itemBuilder: (context,index){
                            return index<=2?
                            Card(elevation:5.8,child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: index==0?Image.asset("assets/nprep2_images/1st.png",height: 50,):
                                      index==1?Image.asset("assets/nprep2_images/2nd.png",height: 50,):index==2?Image.asset("assets/nprep2_images/3rd.png",height: 50,):Text(index.toString())
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['name'].toString() ,
                                            style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['city'].toString() +", "+
                                            jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['state'].toString() ,
                                            style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Text("Marks".capitalizeFirst ,
                                        //   style: TextStyle(
                                        //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                        // ),
                                        Text(
                                          jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['marks'].toString()+"%" ,
                                          style: TextStyle(color: Colors.black54, fontSize: 12,letterSpacing: 1.8,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                )):(index)==6?
                            examController.examScore_data[0]["your_rank_info"]==null?Container():
                            Card(elevation:8.8,child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Rank".capitalizeFirst ,
                                          style: TextStyle(
                                              letterSpacing: 1.8,color: Colors.black, fontSize: 13,fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          examController.examScore_data[0]["your_rank"].toString() ,
                                          style: TextStyle(color: Colors.black54, fontSize: 16,fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text(
                                        jsonDecode(examController.examScore_data[0]["your_rank_info"])['name'].toString() ,
                                        style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                     Container(
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text(
                                        jsonDecode(examController.examScore_data[0]["your_rank_info"])['city'].toString()=="null"?"India":  jsonDecode(examController.examScore_data[0]["your_rank_info"])['city'].toString() +", "+
                                            jsonDecode(examController.examScore_data[0]["your_rank_info"])['state'].toString() ,
                                        style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text("Marks".capitalizeFirst ,
                                    //   style: TextStyle(
                                    //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                    // ),
                                    Text(
                                      jsonDecode(examController.examScore_data[0]["your_rank_info"])['marks'].toString()+" %" ,
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1.8,fontSize: 12,fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ],
                            )):
                            Card(child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Container(

                                color: Colors.white.withOpacity(0.8),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/nprep2_images/winnercup.png",height: 50,)
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            "name",
                                            style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            examController.examScore_data[0]['your_rank'].toString(),
                                            style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Text("Marks".capitalizeFirst ,
                                        //   style: TextStyle(
                                        //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                        // ),
                                        Text(
                                          examController.examScore_data[0]['your_rank'].toString() +" %",
                                          style: TextStyle(color: Colors.black54, fontSize: 12,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));

                      }):
                          widget.today==true?

                              Center(child:Text("Rank will be available after\n12 PM ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w800,
                                  fontSize: 18,letterSpacing: 2.8))):ListView.builder(
                              itemCount: 9,
                              // itemCount: examController.examScore_data[0]['max_rank'],
                              itemBuilder: (context,index){
                                return index<=2?
                                Card(elevation:5.8,child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: index==0?Image.asset("assets/nprep2_images/1st.png",height: 50,):
                                        index==1?Image.asset("assets/nprep2_images/2nd.png",height: 50,):index==2?Image.asset("assets/nprep2_images/3rd.png",height: 50,):Text(index.toString())
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['name'].toString() ,
                                            style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['city'].toString() +", "+
                                                jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['state'].toString() ,
                                            style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Text("Marks".capitalizeFirst ,
                                        //   style: TextStyle(
                                        //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                        // ),
                                        Text(
                                          jsonDecode(examController.examScore_data[0][index==0?'rank_1':index==1?"rank_2":index==2?"rank_3":""])['marks'].toString()+"%" ,
                                          style: TextStyle(color: Colors.black54, fontSize: 12,letterSpacing: 1.8,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                )):(index)==6?
                                examController.examScore_data[0]["your_rank_info"]==null?Container():
                                Card(elevation:8.8,child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Rank".capitalizeFirst ,
                                            style: TextStyle(
                                                letterSpacing: 1.8,color: Colors.black, fontSize: 13,fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            examController.examScore_data[0]["your_rank"].toString() ,
                                            style: TextStyle(color: Colors.black54, fontSize: 16,fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0]["your_rank_info"])['name'].toString() ,
                                            style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: Text(
                                            jsonDecode(examController.examScore_data[0]["your_rank_info"])['city'].toString()=="null"?"India":  jsonDecode(examController.examScore_data[0]["your_rank_info"])['city'].toString() +", "+
                                                jsonDecode(examController.examScore_data[0]["your_rank_info"])['state'].toString() ,
                                            style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Text("Marks".capitalizeFirst ,
                                        //   style: TextStyle(
                                        //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                        // ),
                                        Text(
                                          jsonDecode(examController.examScore_data[0]["your_rank_info"])['marks'].toString()+" %" ,
                                          style: TextStyle(color: Colors.black54, letterSpacing: 1.8,fontSize: 12,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                )):
                                Card(child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                  child: Container(

                                    color: Colors.white.withOpacity(0.8),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset("assets/nprep2_images/winnercup.png",height: 50,)
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.6,
                                              child: Text(
                                                "name",
                                                style: TextStyle(color: black54, fontSize: 16,fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.6,
                                              child: Text(
                                                examController.examScore_data[0]['your_rank'].toString(),
                                                style: TextStyle(color: Colors.black38, fontSize: 12,fontWeight: FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Text("Marks".capitalizeFirst ,
                                            //   style: TextStyle(
                                            //       letterSpacing: 1.8,color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                                            // ),
                                            Text(
                                              examController.examScore_data[0]['your_rank'].toString() +" %",
                                              style: TextStyle(color: Colors.black54, fontSize: 12,fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));

                              }),
                    ),
                    SizedBox(height: 10,),

                    (currentTime.hour >= noon.hour && currentTime.minute >= noon.minute) || widget.today==false?
                    Text(" Out of "+examController.examScore_data[0]["max_rank"].toString(), style: TextStyle(

                        fontWeight: FontWeight.w900, fontSize: 18,letterSpacing: 2.8)):Container(),
                    (currentTime.hour >= noon.hour && currentTime.minute >= noon.minute) || widget.today==false?
                     SizedBox(height: 10,):Container(),

                    (currentTime.hour >= noon.hour && currentTime.minute >= noon.minute) || widget.today==false?
                     RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Have any query? ",
                        style:  TextStyles.loginB1Style,
                        children: [
                          TextSpan(
                            text: 'Whatsapp us ',
                            style: TextStyle(
                              fontSize: 16,
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // GetDilogssss("sucessmsg");
                                var phoneNumber =settingController.settingData['data']['general_settings']['phone'].toString();
                                openWhatsApp(phoneNumber);
                              },
                          ),
                          TextSpan(
                            text: 'for assistance. ',
                            style: TextStyles.loginB1Style,

                          ),
                        ],
                      ),
                    ):Container(),
                    SizedBox(height: 20,),
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }
  void openWhatsApp(String phoneNumber) async {
    print(" oo $phoneNumber");
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
