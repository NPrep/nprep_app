import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:path_provider/path_provider.dart';

import 'ReportissueController.dart';

class ReportIssueScreen extends StatefulWidget {
  final questionId;
  final examid;
final screenshot;
  const ReportIssueScreen({Key key,this.questionId,this.examid,this.screenshot});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  ReportIssueController reportIssueController=Get.put(ReportIssueController());
  TextEditingController issueCntrl = TextEditingController();
  static GlobalKey previewContainer = GlobalKey();

  @override
  void initState() {
    widget.screenshot;
   log('questionId==>'+widget.questionId.toString());
   log('examid==>'+widget.examid.toString());
   log('screenshot==>'+widget.screenshot.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;

    return RepaintBoundary(
      key:previewContainer ,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: white),
          title: Text('Report Issue',style: TextStyle(color: white),),
          centerTitle: true,
          backgroundColor:primary2,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              Padding(
             padding:EdgeInsets.only(top: height*0.06),
             child: TextFormField(
               controller: issueCntrl,
               decoration: InputDecoration(
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(5),
                 ),
                 hintStyle: TextStyle(color: grey.withOpacity(0.6)),
                 hintText: 'Please use the “Report issue” button to report a potential factual error or a feedback.',
               ),
               maxLines: 3,
               maxLength: 150,
             ),
           ),
              SizedBox(height: 20,),
              Expanded(
                child: InkWell(
                  onTap:(){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: double.infinity,
                            child: Image.file(
                              File(widget.screenshot),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: width,
                    height: size.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                    Image.file(
                      File(widget.screenshot),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: width,
                height: height*0.06,
                child: ElevatedButton(
                    onPressed: (){
                      log('screenshot==>'+widget.screenshot.toString());
                      log('examid==>'+widget.examid.toString());
                      log('questionId==>'+widget.questionId.toString());
                      log('issueCntrl==>'+issueCntrl.text.toString());
                      if(issueCntrl.text.isNotEmpty){
                        reportIssueController.uploadImges(File(widget.screenshot),widget.examid.toString(),widget.questionId.toString(),issueCntrl.text);
                      }else{
toastMsg("Please Write Some Query", true);
                      }

                    },
                    child: Text('Report', style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins-Regular',
                      color: white,
                    ),)
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
  ///for pick up screenshot from gallary....
  File _image;

  Future getImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }



}
