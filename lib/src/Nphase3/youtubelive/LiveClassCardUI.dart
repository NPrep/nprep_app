import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';

class LiveClassCardUITimeLine extends StatelessWidget {



  final title;
  final remainingtime;
  final duration;
  final image;






  final int step;


  LiveClassCardUITimeLine(
      {Key key,

      this.title,
      this.remainingtime,
      this.duration,

      this.image,
      this.step,
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
          child:  Card(
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

                    padding: EdgeInsets.only(left: 6,right: 0,top: 5,bottom: 5),
                    child:
                    image==null? Container(

                      // color: Colors.red.shade300,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/nprep2_images/LOGO.png",
                        height: 75,
                        width: 115,
                      ),
                      // child: Icon(Icons.error,size: MediaQuery.of(context).size.width * 0.18,
                      //   color: Colors.grey.shade300,),
                    ):

                    FadeInImage(
                      image: NetworkImage(image),
                      placeholder: AssetImage("assets/nprep2_images/LOGO.png"),
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) => Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/nprep2_images/LOGO.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 900), // Slow fade for newly loaded images
                      fadeOutDuration: const Duration(milliseconds: 150), // Fast fade if sync loading
                      placeholderErrorBuilder: (context, error, stackTrace) => Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/nprep2_images/LOGO.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    )


                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        sizebox_height_5,
                        Container(
                          width: size.width-200,
                          // color: Colors.red,
                          margin: EdgeInsets.only(left: 9),
                          child: Text(
                            "${title}",
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
                          width: size.width-200,
                          // color: Colors.green,
                          margin: EdgeInsets.only(left: 10,bottom: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text(
                                  'Scheduled for ${DateFormat("d MMM y").format(
                                      DateTime.parse(
                                          duration.toString()))}',
                                  textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),

                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins-Regular',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400),
                                ),
                                // Text(
                                //   '${duration}Min',
                                //   textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.10, 1.20),
                                //
                                //   style: TextStyle(
                                //       fontSize: 15,
                                //       fontFamily: 'Poppins-Regular',
                                //       fontWeight: FontWeight.w500,
                                //       color: Colors.grey.shade400),
                                // ),
                              ],),


                            ],
                          ),
                        ),
                        sizebox_height_5,
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
