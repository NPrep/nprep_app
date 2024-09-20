import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';

import 'LeadershipScore.dart';

class AllCommonTest_TimeLine extends StatelessWidget {


  final topic;
  final mcq;
  final duration;
  final examid;


  final fee_type;
  final datetype;



  final int step;


  AllCommonTest_TimeLine(
      {Key key,

      this.topic,
      this.examid,
      this.mcq,
      this.duration,
      this.datetype,

      this.step,
      this.fee_type,
 });

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Timeline(

      anchor: IndicatorPosition.center,
      separatorBuilder: (_, __) =>
          SizedBox(height: TimelineTheme.of(context).itemGap),
      isLeftAligned: true,
      altOffset: Offset(1, 1),
      indicatorSize: 17,
      events: [
        TimelineEventDisplay(

          forceLineDrawing: true,
          indicator: CircleAvatar(
          backgroundColor: primary,
          child: Text(step.toString(),style: TextStyle(color: white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins-Regular',
              fontSize: 10),
          )),
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
                        padding:  EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sizebox_height_5,
                            Container(
                              width: size.width-170,
                             // color: Colors.red,
                              margin: EdgeInsets.only(left: 9),
                              child: Text(
                                "${topic}",
                                maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                                textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.w500,
                                    color: black54),
                              ),
                            ),
                            sizebox_height_5,
                            Container(
                              width: size.width-170,
                               // color: Colors.green,
                              margin: EdgeInsets.only(left: 10,bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Text(
                                      'MCQs ${mcq} • ',
                                      textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),

                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400),
                                    ),
                                    Text(
                                      '${duration}Min',
                                      textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),

                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400),
                                    ),
                                  ],),


                                ],
                              ),
                            ),
                            sizebox_height_5,
                          ],
                        ),
                      ),
                      datetype==null?Container(): Text("${DateFormat("d MMM").format(
                          DateTime.parse(
                              datetype.toString()))}",style: TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Helvetica',
                      )),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: fee_type.toString()=="2"?Container():
              Container(
                padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 0.5,color: Colors.grey)
                ),
                child:  Text("Pro",
                    textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),

                    style:
                    TextStyle(fontSize: 10,color: Colors.grey.shade600,)),

              ),
              ),


            ],
          ),
        )
      ],
    );
  }
}
