import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:n_prep/Controller/Category_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/src/q_bank/new_questionbank/questions_qbank.dart';
import 'package:n_prep/src/q_bank/quetions.dart';
import 'package:n_prep/src/q_bank/review.dart';
import 'package:n_prep/utils/colors.dart';

class Details extends StatefulWidget {
  final title;
  final header;
  final examid ;
  final checkstatus;
  final attempquestion;
  final completed_date;
  final created_at;
  final total_questions;
  bool pagestatus;
  Details({
    Key key,
    this.title,
    this.header,
    this.examid,
    this.checkstatus,
    this.attempquestion,
    this.completed_date,
    this.created_at,
    this.total_questions,
    this. pagestatus
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isReview = true;

  showReview() {
    setState(() {
      isReview = !isReview;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Review')));
  }



  @override
  void initState() {
    super.initState();

print("total attemp exam "+widget.attempquestion.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarHelper(
        title: "${widget.title}",
        context: context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: primary,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: GestureDetector(
                    onTap: () {
                      // showReview();
                    },
                    child: Text(
                      widget.header,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PublicSans',
                          color: white,letterSpacing: 1),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'PublicSans',
                        color: black54,
                        letterSpacing: 1)),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  widget.checkstatus != 3
                      ? Icon(
                    Icons.pause_circle_filled,
                    color: primary,
                    size: 19,
                  )
                      : Icon(
                    Icons.check_circle,
                    color: Colors.green.shade500,
                    size: 19,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width-60,
                    // color: Colors.green,
                    child: Text(
                      widget.checkstatus != 3
                          ? 'You paused this module on ${DateFormat("d").format(
                          DateTime.parse(
                              widget.created_at.toString()))}'
                          ' ${DateFormat("MMMM").format(
                          DateTime.parse(
                              widget.created_at.toString()))}'

                          : 'You completed this module on ${DateFormat("d").format(
                          DateTime.parse(
                              widget.completed_date.toString()))}'
                          ' ${DateFormat("MMMM").format(
                          DateTime.parse(
                              widget.completed_date.toString()))}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PublicSans',
                          color: black54,letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 15,left: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(
                      height: 70,
                      width: size.width*0.42,

                      decoration: BoxDecoration(
                        // color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.fromBorderSide(
                              BorderSide(color: primary, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              '${widget.total_questions.toString().length==1?"0${widget.total_questions}":widget.total_questions}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'PublicSans',
                                  color: black54),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'MCQs',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'PublicSans',
                                    color: black54),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                // width: size.width*0.25,
                                // color: primary,
                                padding:  EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.checkstatus == 3
                                      ?'Completed'
                                      : '${widget.attempquestion} Completed',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'PublicSans',
                                      color: black54,
                                      letterSpacing: 0.5),
                                ),
                              )
                              // Container(
                              //   width: size.width*0.25,
                              //   // color: primary,
                              //   child: Text(
                              //     widget.checkstatus == 3
                              //         ?'${widget.attempquestion} Completed'
                              //         : '${widget.attempquestion} Completed',
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w700,
                              //         fontFamily: 'Helvetica',
                              //         color: black54),
                              //   ),
                              // )
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.checkstatus != 3) {
                          print("attemp plus "+ ((widget.attempquestion)+1).toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => questionbank_new(
                                    examId: widget.examid,
                                    timer: false,
                                    counterindex: ((widget.attempquestion)+1),
                                    checkstatus: widget.checkstatus,
                                    pagestatus: widget.pagestatus,
                                  )));
                        }
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                    exam_Ids:widget.examid,
                                  )));
                        }

                        // Start exam or Review
                      },
                      child: Container(
                        height: 70,
                        width: size.width*0.42,

                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.fromBorderSide(
                                BorderSide(color: primary, width: 1))),
                        child: Padding(
                          padding:  EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(widget.checkstatus != 3 ? solve : review_img,
                                  scale: widget.checkstatus == 3? 2 : 2),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.checkstatus != 3 ? 'SOLVE' : 'REVIEW',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: widget.checkstatus == 3 ? 22 : 22,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'PublicSans',
                                      color: white,letterSpacing: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              if (widget.checkstatus == 3)
                Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        //restart the test

                        var reattempt_id= 1;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => questionbank_new(reattempt:
                                reattempt_id.toString(),
                                  examId: widget.examid,pagestatus: widget.pagestatus,)));
                      },
                      child: Container(
                        height: 55,
                        width: 180,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        // padding:EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Text(
                          'Reattempt Test',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PublicSans',
                              letterSpacing: 0.7,
                              color: white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
