import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/src/Nphase2/Constant/textstyles_constants.dart';
import 'package:n_prep/src/Nphase3/Controller/liveclasscontroller.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Livevideodetail extends StatefulWidget {
  var  videoid;
  var  videourl;
   Livevideodetail({this.videoid,this.videourl});

  @override
  State<Livevideodetail> createState() => _LivevideodetailState();
}

class _LivevideodetailState extends State<Livevideodetail> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Liveclasscontroller liveclasscontroller  =Get.put(Liveclasscontroller());
  @override
  void initState() {
    // TODO: implement initState

    liveclasscontroller.videoid.value=widget.videoid.toString();
    liveclasscontroller.YoutubePlayercalling(widget.videourl);
    GetdataCalling();
    super.initState();
  }
GetdataCalling(){
    var url = apiUrls().live_classes_api +"/"+widget.videoid.toString()+"/"+"messages";
    log("live_classes_messages_Url==>" + url.toString());
  liveclasscontroller.GetliveclassCommentApi(url);

}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    liveclasscontroller.disposeall();
  }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          if(orientation == Orientation.landscape){

            return   GetBuilder<Liveclasscontroller>(
                builder: (liveclasscontroller) {
                  return SafeArea(
                    child: Scaffold(
                      body:  YoutubePlayer(
                        controller: liveclasscontroller.youtubeplayerController,
                        liveUIColor: primary,
                      ),
                    ),
                  );
                }
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  onPressed: (){
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      systemNavigationBarColor: Color(0xFFFFFFFF), // navigation bar color
                      statusBarColor: Color(0xFF64C4DA), // status bar color
                    ));
                    Get.back();
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => BottomBar(
                    //         bottomindex: 3,
                    //       )),
                    // );
                  },
                  icon: Icon(Icons.chevron_left,size: 30,color: white,),
                ),

                centerTitle: true,
                title: Text("Live Video ",style: AppbarTitleTextyle,),
                backgroundColor: primary,

              ),
              body: Column(
                children: [

                    YoutubePlayerBuilder (

                      player: YoutubePlayer(
                        controller: liveclasscontroller.youtubeplayerController,
                        liveUIColor: primary,

                      ),
                      builder: (context,player) => player,
                    ),
                    GetBuilder<Liveclasscontroller>(
                      builder: (liveclasscontroller) {
                        return ListView.builder(
                          // controller: liveclasscontroller.scrollcontroller,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: liveclasscontroller.liveclasscommentlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              final reversedIndex = liveclasscontroller.liveclasscommentlist.length - 1 - index;
                              var data =liveclasscontroller.liveclasscommentlist[reversedIndex];

                              return data['is_pin']==1?Container(
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 20.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 10  horizontally
                                        5.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: Card(
                                  // elevation: 5.8,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Container(child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.grey,// Image radius
                                          backgroundImage: NetworkImage(data['user_image']),
                                        ),
                                      ),
                                      SizedBox(width: 1,),
                                      Container(
                                        // width: MediaQuery.of(context).size.width*0.3-5,
                                        // color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(data['user_name'],style: TextStyle(fontSize: 16,letterSpacing: 1.0,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.7-50,
                                        // color: Colors.green,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(data['message'],style: TextStyle(fontSize: 15,letterSpacing: 1.0,fontWeight: FontWeight.w600),),
                                        ),
                                      ),
                                      Transform.rotate(
                                          angle: 50 * math.pi / 180,child: Icon(Icons.push_pin,size: 18,))
                                    ],
                                  ),),
                                ),
                              ):Container();
                            }
                        );
                      }
                  ),
                    Expanded(
                      child: GetBuilder<Liveclasscontroller>(
                          builder: (liveclasscontroller) {
                          return ListView.builder(
                            controller: liveclasscontroller.scrollcontroller,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: liveclasscontroller.liveclasscommentlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              final reversedIndex = liveclasscontroller.liveclasscommentlist.length - 1 - index;
                              var data =liveclasscontroller.liveclasscommentlist[reversedIndex];
                                return Container(child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.grey,// Image radius
                                        backgroundImage: NetworkImage(data['user_image']),
                                      ),
                                    ),
                                    SizedBox(width: 1,),
                                    // Container(
                                    //   // width: MediaQuery.of(context).size.width*0.3-5,
                                    //   // color: Colors.red,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(5.0),
                                    //     child: Text(data['user_name'],style: TextStyle(fontSize: 14,letterSpacing: 1.0,fontWeight: FontWeight.bold),),
                                    //   ),
                                    // ),
                                    SizedBox(width: 2,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      // color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: RichText(
                                          text: new TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(text: '${data['user_name']}',style:  TextStyle(fontSize: 13,fontWeight: FontWeight.bold,backgroundColor: data['sender_type']=="1"?Colors.yellow.shade600:Colors.black54.withOpacity(0.0))),
                                              new TextSpan(text: "  "+data['message'], style:  TextStyle(fontSize: 13,letterSpacing: 0.5,fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        )

                                        // Text("${data['user_name'] }  "+data['message'],style: TextStyle(fontSize: 13,letterSpacing: 0.5,fontWeight: FontWeight.w600),),
                                      ),
                                    ),
                                  ],
                                ),);
                            }
                          );
                        }
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: _sendMessageArea(),
                    ),
                ],
              ),
            );
          }

      }
    );
  }
  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      color: Colors.white,
      child: Form(
        key: formkey,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                controller: liveclasscontroller.sendmessageController,
                cursorColor: primary,
                validator: ((value) {
                  if (value.isEmpty) {
                    return "Text area not be blank";
                  }
                  return null;
                }),
                decoration: InputDecoration.collapsed(
                  hintText: "Type something....",
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: primary,
              onPressed: () {
                if (formkey.currentState.validate()) {
                  var Sendmsg = liveclasscontroller.sendmessageController.text;
                  var url = apiUrls().live_classes_api +"/"+widget.videoid.toString()+"/"+"comment";
                  var body ={"comment":Sendmsg};
                  FocusScope.of(context).unfocus();
                  liveclasscontroller.SendCommentApiFun(url, body);
                }

              },
            ),
            Container(width: 5),
          ],
        ),
      ),
    );
  }
}
