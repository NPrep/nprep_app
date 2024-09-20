import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:image_fade/image_fade.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Nprep2CustomTimelineDownloading extends StatefulWidget {



  final topic;
  var downloding =null;
  final status;
  final image;

  final examstatus;
  final int step;
  var attemptdate;
var data;
var videoid;
  Nprep2CustomTimelineDownloading(
      {Key key,


      this.topic,
      this.downloding,
      this.status,
      this.image,
      this.examstatus,
      this.step,
        this.attemptdate,
        this.videoid,
      this.data});

  @override
  State<Nprep2CustomTimelineDownloading> createState() => _Nprep2CustomTimelineDownloadingState();
}

class _Nprep2CustomTimelineDownloadingState extends State<Nprep2CustomTimelineDownloading> {
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
  var width = size.width;
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
          child: Text(widget.step.toString(),style: TextStyle(color: white,
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

                        padding: EdgeInsets.all(6),



                        child:  Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          child: Image.network(widget.image),

                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sizebox_height_5,
                            Container(
                              width: size.width-220,
                            padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "${widget.topic}",
                                maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,

                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.w500,
                                    color: black54),
                              ),
                            ),
                            sizebox_height_10,
                            LinearPercentIndicator(
                                  width: width > 500
                                      ? width * .820
                                      : width * .600,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  animationDuration: 500,
                                  lineHeight: 5.0,
                                  percent: widget.downloding,
                                  barRadius: Radius.circular(1),
                                  progressColor: primary,
                                  backgroundColor: Colors.grey[300],
                                ),
                            sizebox_height_10,
                            Container(
                                width: size.width-175,
// color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('${widget.status} ${widget.status=='Downloaded'?"":"${((widget.downloding * 100).floor()).toString()+'%'}"}',
                                              style: TextStyle(
                                                color: black54,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 12,
                                              ),
                                        ),
                                     ),
                                    GestureDetector(
                                      onTap: (){
                                        if(widget.status=="Downloading"){
                                          FileDownloader().pause(widget.data);
                                        }else if(widget.status=="paused"){
                                          FileDownloader().resume(widget.data);
                                        }else{

                                        }
                                      },
                                      child: Container(
                                          child: widget.status=="Downloading"?Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:BorderRadius.circular(100),
                                              border:  Border.all(color: primary),
                                              // color: Color(0xfff7a363),
                                            ),
                                            child: Text("Pause"),
                                          ):Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(100),
                                            border:  Border.all(color: primary),
                                                // color: Color(0xfff7a363),
                                              ),
                                              child: Text("Resume"))
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            sizebox_height_10,
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            log("DurationHIT>> onTap");
                            Future.delayed(const Duration(seconds: 1)).then((val) {
                              log("DurationHIT>> database");
                               FileDownloader().database.deleteRecordWithId(widget.videoid);
                              setState(() {

                              });
                            });
                            log("DurationHIT>> cancel");
                            FileDownloader().cancelTasksWithIds([widget.videoid]);


                            setState(() {

                            });
                          },
                          child: Icon(Icons.delete,color: primary,))

                    ],
                  ),
                ),
              ),


            ],
          ),
        )
      ],
    );
  }
}
