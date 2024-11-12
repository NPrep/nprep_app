import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';

class Nprep2CustomTimelineVideoSave extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool showimage;
  final topic;
  final mcq;
  final status;
  final image;
  final width;
  final label;
  final noofattemp;
  final  questionnoofattemp;
  final examstatus;
  final Color labelColor;
  final int step;
  var attemptdate;

  Nprep2CustomTimelineVideoSave(
      {Key key,
      this.isFirst,
      this.isLast,
      this.showimage,
      this.topic,
      this.mcq,
        this.width,
      this.status,
      this.image,
      this.noofattemp,
      this. questionnoofattemp,
      this.examstatus,
      this.labelColor,
      this.step,
      this.label,
        this.attemptdate});

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      width: width,
      child: Timeline(

        anchor: IndicatorPosition.center,
        separatorBuilder: (_, __) =>
            SizedBox(height: TimelineTheme.of(context).itemGap),
        isLeftAligned: true,
        altOffset: Offset(1, 1),
        indicatorSize: 17,
        events: [
          TimelineEventDisplay(

            forceLineDrawing: true,
            // indicator: CircleAvatar(
            // backgroundColor: primary,
            // child: Text(step.toString(),style: TextStyle(color: white,
            //     fontWeight: FontWeight.w500,
            //     fontFamily: 'Poppins-Regular',
            //     fontSize: 10),
            // )),
            child: Stack(
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 1,
                              blurRadius: 0.5,
                            )
                          ]),

                    child: Row(

                      children: [
                        Padding(

                          padding: EdgeInsets.all(6),
                          // child:  showimage==null?
                          // image==null? Container(
                          //
                          //   // color: Colors.grey.shade300,
                          //   alignment: Alignment.center,
                          //   child: Image.asset(
                          //     "assets/images/NPrep.jpeg",
                          //     height: 55,
                          //     width: MediaQuery.of(context).size.width * 0.15,
                          //   ),
                          //   // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                          //   //   color: Colors.grey.shade300,),
                          // ): ImageFade(
                          //   image: FileImage(image),
                          //       height: MediaQuery.of(context).size.height *0.08,
                          //       width: MediaQuery.of(context).size.width * 0.18,
                          //   // slow fade for newly loaded images:
                          //   duration: const Duration(milliseconds: 900),
                          //
                          //   // if the image is loaded synchronously (ex. from memory), fade in faster:
                          //   syncDuration: const Duration(milliseconds: 150),
                          //
                          //   // supports most properties of Image:
                          //   alignment: Alignment.center,
                          //   fit: BoxFit.cover,
                          //
                          //   // shown behind everything:
                          //   placeholder: Container(
                          //
                          //     // color: Colors.grey.shade300,
                          //     alignment: Alignment.center,
                          //     child: Image.file(
                          //       image,
                          //       height: 20,
                          //       width: 20,
                          //     ),
                          //     // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                          //     //   color: Colors.grey.shade300,),
                          //   ),
                          //
                          //   // shows progress while loading an image:
                          //   loadingBuilder: (context, progress, chunkEvent) =>
                          //       Container(
                          //
                          //
                          //         // color: Colors.grey.shade300,
                          //         alignment: Alignment.center,
                          //         child: Image.asset(
                          //           "assets/images/NPrep.jpeg",
                          //           height: 20,
                          //           width: 20,
                          //         ),
                          //         // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                          //         //   color: Colors.grey.shade300,),
                          //       ),
                          //
                          //   // displayed when an error occurs:
                          //   errorBuilder: (context, error) => Container(
                          //
                          //     // color: Colors.grey.shade300,
                          //     alignment: Alignment.center,
                          //     child: Image.asset(
                          //       "assets/images/NPrep.jpeg",
                          //       height: 20,
                          //       width: 20,
                          //     ),
                          //     // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                          //     //   color: Colors.grey.shade300,),
                          //   ),
                          // ):


                          child:  Container(
                            height: 60,
                            width: 60,
                            // color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: Image.file(File(image)),
                            // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                            //   color: Colors.grey.shade300,),
                          ),
                        ),

                        Padding(
                          padding:  EdgeInsets.only(left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sizebox_height_5,
                              Container(
                                width: size.width-220,

                                // color: Colors.red,
                                // margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  "${topic}",
                                  maxLines: 2,
                                   overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,

                                      fontFamily: 'Poppins-Regular',
                                      fontWeight: FontWeight.w500,
                                      color: black54),
                                ),
                              ),
                              sizebox_height_5,
                              Container(
                                width: size.width-170,
                                // color: Colors.red,
                                margin: EdgeInsets.only(right: 0,bottom: 2),
                                child:  Text(
                                  '${mcq} Video',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Regular',
                                      fontWeight: FontWeight.w500,
                                      color: noofattemp==0?Colors.grey:Colors.green.shade300),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: label.toString()!="1"?Container():
                Container(
                  padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 0.5,color: Colors.grey)
                  ),
                  child:  Text("Pro",
                      style:
                      TextStyle(fontSize: 10,color: Colors.grey.shade600,)),
                  // child: Row(
                  //   children: [
                  //     Icon(Icons.lock,size: 9,),
                  //     Text("PRO",
                  //         style:
                  //         TextStyle(fontSize: 9,color: Colors.grey.shade600,fontWeight: FontWeight.bold)),
                  //   ],
                  // ),
                ),
                ),
                Positioned(
                  bottom: 7,
                  right: 7,
                  child: attemptdate.toString()=="null"?Container():
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade500,
                    size: 19,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
