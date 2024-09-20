import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';

class CustomTimeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final topic;
  final mcq;
  final status;
  final image;
  final label;
  final noofattemp;
  final  questionnoofattemp;
  final examstatus;
  final Color labelColor;
  final int step;

  const CustomTimeline(
      {Key key,
      this.isFirst,
      this.isLast,
      this.topic,
      this.mcq,
      this.status,
      this.image,
      this.noofattemp,
      this. questionnoofattemp,
      this.examstatus,
      this.labelColor,
      this.step,
      this.label});

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
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.fromBorderSide(
                  //         BorderSide(color: Colors.grey.shade200, width: 1))),
                  child: Row(

                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                          child:FadeInImage.assetNetwork(
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(

                                  // color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/nprep2_images/LOGO.png",
                                    height: 55,
                                    width: MediaQuery.of(context).size.width * 0.15,
                                  ),
                                  // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                                  //   color: Colors.grey.shade300,),
                                );
                              },
                            height: 60,
                            width: 60,
                            placeholder: "assets/nprep2_images/LOGO.png",
                            image: image.toString())
                        // child:   Image.network(image,
                        //   fit: BoxFit.cover,
                        //   height: MediaQuery.of(context).size.height *0.08,
                        //   width: MediaQuery.of(context).size.width * 0.18,),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sizebox_height_5,
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  width: size.width-173,

                                  // color: Colors.red,
                                  // margin: EdgeInsets.only(top: 3),
                                  child: Text(
                                   "${topic}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.w500,
                                        color: black54),
                                  ),
                                ),
                                // sizebox_height_10,
                                // sizebox_width_10,
                                // label=="FREE"?Container():
                                // Container(
                                //   padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.rectangle,
                                //       borderRadius: BorderRadius.all(Radius.circular(5)),
                                //       border: Border.all(width: 0.5,color: Colors.grey)
                                //   ),
                                //   child: Text(label,
                                //       style:
                                //       TextStyle(fontSize: 11,color: Colors.grey.shade600)),
                                // ),
                              ],
                            ),
                            sizebox_height_5,
                            Container(
                              width: size.width-147,
                              // color: Colors.red,
                              margin: EdgeInsets.only(right: 5,bottom: 2),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${mcq} MCQs',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.w500,
                                        color: noofattemp==0?Colors.grey:Colors.green.shade300),
                                  ),
                                  noofattemp==0?   Container():SizedBox(height: 8,),
                                  noofattemp==0?   Container(): Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(status,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'PublicSans',
                                              fontWeight: FontWeight.w700,
                                              color: black54)),
                                      questionnoofattemp<mcq?SizedBox(width: 5,):Container(),
                                      questionnoofattemp==mcq?Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade500,
                                        size: 19,
                                      ):
                                      questionnoofattemp<mcq?
                                      Icon(
                                        Icons.pause_circle,
                                        color: primary,
                                        size: 19,
                                      )
                                          :Container()
                                    ],
                                  ),
                                  sizebox_height_5,

                                ],
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
                child:  label.toString()!="1"?Container():
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
              )
            ],
          ),
        )
      ],
    );
  }
}
