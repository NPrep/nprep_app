import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:n_prep/src/Nphase2/Constant/nprep_2_custom_timeline.dart';
import 'package:n_prep/src/Nphase2/Constant/textstyles_constants.dart';
import 'package:n_prep/src/Nphase2/VideoScreens/video_detail_screen.dart';
import 'package:n_prep/utils/colors.dart';

import '../../home/bottom_bar.dart';

class Samplevideo extends StatefulWidget {
  List SampleVideoList;
   Samplevideo({this.SampleVideoList });

  @override
  State<Samplevideo> createState() => _SamplevideoState();
}

class _SamplevideoState extends State<Samplevideo> {
  categoryImage(imagess){
    return  ImagePixels.container(

      imageProvider: NetworkImage(imagess),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image(image:NetworkImage(imagess),fit: BoxFit.cover,height: 80,
          width: 100,
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.SampleVideoList.toString());
  }
  @override
  Widget build(BuildContext context) {
    var sheight = MediaQuery.of(context).size.height;
    var swidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
        //   statusBarColor: Color(0xFF64C4DA), // status bar color
        // ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                bottomindex: 3,
              )),
        );

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBar(
                      bottomindex: 3,
                    )),
              );
            },
            icon: Icon(Icons.chevron_left,size: 30,color: white,),
          ),

          centerTitle: true,
          title:  Text("${'Sample Videos'} ",style: AppbarTitleTextyle,),

          backgroundColor: primary,

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 8.0, 8.0, 8.0),
                child: Text("Try the Premium Quality from AIIMSonians without paying a single rupee!",textAlign: TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,letterSpacing: 0.8)),
              ),
              widget.SampleVideoList.length==0?
              Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Center(child: Text("No Block Found"))):
              ListView.builder(
                  itemCount: widget.SampleVideoList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    var data = widget.SampleVideoList[index];
                    return
                    GestureDetector(
                      onTap: () async {
                        await Get.to(VideoDetailScreen(CatId: data['id']));
                      },
                      child: Container(

                        margin: EdgeInsets.only(right: 0),
                        child: Nprep2CustomTimeline(
                          step: index+1,
                          image: data['thumb_image'],
                          isLast: true,
                          isFirst: true,
                          mcq: data['video_time'],
                          noofattemp:data['attempt_videos'] ,
                          questionnoofattemp: data['attempt_videos'] ,
                          examstatus:data['video_status'] ,
                          topic: data['video_title'],
                          status: data['attempt_videos']
                              .toString() +
                              "/" +
                              data['total_videos'].toString(),
                          label: data['fee_type'],
                          labelColor: data['fee_type'].toString() ==
                              '2'
                              ? Colors.orange
                              : Colors.indigo.shade700,
                        ),
                      ),
                      // child: Stack(
                      //   children: [
                      //     Card(
                      //
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)
                      //       ),
                      //       // height: sheight * .1,
                      //       // decoration: BoxDecoration(
                      //       //     borderRadius: BorderRadius.circular(10),
                      //       //     color: white,
                      //       //     boxShadow: [
                      //       //       BoxShadow(
                      //       //         color: Colors.grey.shade300,
                      //       //         spreadRadius: 1,
                      //       //         blurRadius: 0.5,
                      //       //       )
                      //       //     ]),
                      //       // padding: EdgeInsets.all(5),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //
                      //         children: [
                      //
                      //           Container(
                      //             // margin: EdgeInsets.only(left: 5,),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: ClipRRect(
                      //                 borderRadius: BorderRadius.circular(5.0), child: FadeInImage.assetNetwork(
                      //                 imageErrorBuilder: (context, error, stackTrace) {
                      //                   return Container(
                      //
                      //                     // color: Colors.grey.shade300,
                      //                     alignment: Alignment.center,
                      //                     child: Image.asset(
                      //                       "assets/nprep2_images/LOGO.png",
                      //                       height: 55,
                      //                       width: MediaQuery.of(context).size.width * 0.15,
                      //                     ),
                      //                     // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                      //                     //   color: Colors.grey.shade300,),
                      //                   );
                      //                 },
                      //                   placeholder: "assets/nprep2_images/LOGO.png",
                      //                   image: Tablist2data['thumb_image'].toString())
                      //                    // categoryImage(Tablist2data['thumb_image'])
                      //                 ),
                      //             height: sheight *0.08,
                      //             width: swidth * 0.15,
                      //           ),
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Container(
                      //                 width: swidth-120,
                      //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //                 // color: primary,
                      //                 child: Text(
                      //                   "${Tablist2data['video_title'].toString()}",
                      //                   style: TextStyle(
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.w700,
                      //                       fontFamily: 'Helvetica',
                      //                       color: black54,
                      //                       // height: 1.1,
                      //                       letterSpacing: 0.8),
                      //                 ),
                      //               ),
                      //               // perentdata['attempt_percentage']==0?Container():
                      //
                      //               Padding(
                      //                 padding: const EdgeInsets.all(10.0),
                      //                 child: Text(
                      //                   '${Tablist2data['video_duration']} min ',
                      //                   style: TextStyle(
                      //                     color: black54,
                      //                     fontWeight: FontWeight.w400,
                      //                     fontFamily: 'Poppins-Regular',
                      //                     fontSize: 12,
                      //                   ),
                      //                 ),
                      //               )
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     Tablist2data['fee_type'] == 2
                      //         ? Container()
                      //         : Positioned(
                      //       right: 10,
                      //           top: 5,
                      //           child: Container(
                      //       height: 15,
                      //       width: 30,
                      //       decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 color: todayTextColor),
                      //             borderRadius:
                      //             BorderRadius.circular(4)),
                      //       child: Center(
                      //           child: Text(
                      //             "Pro",
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 color: todayTextColor,
                      //                 fontSize: 10),
                      //           ),
                      //       ),
                      //     ),
                      //         )
                      //   ],
                      // ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
