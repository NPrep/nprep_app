import 'package:flutter/material.dart';
import 'package:n_prep/utils/colors.dart';
import 'package:store_redirect/store_redirect.dart';

import '../main.dart';
import '../src/home/bottom_bar.dart';
import '../src/login_page/login_page.dart';
import 'Api_Urls.dart';


class MaitainceScreen extends StatefulWidget {
  var appurl,appname,applogo;
  var Maitaince_text,maintainceupdate;
   MaitainceScreen({Key key, this.Maitaince_text,this.applogo,this.appname,this.appurl,this.maintainceupdate}) : super(key: key);

  @override
  State<MaitainceScreen> createState() => _MaitainceScreenState();
}

class _MaitainceScreenState extends State<MaitainceScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {


        // if(widget.maintainceupdate != apiUrls().App_Maintaince_updateNo.toString()) {
        //
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //         sprefs.getBool('LoggedIn') == true
        //             ? BottomBar(
        //
        //         ) :
        //         LoginPage()),
        //   );
        //
        // }else{
        //   print("hejdkk");
        // }
      return false;

      },
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.red,
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/splashbf.png')
            )
        ),
        child: Dialog(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 300,
              width: 400,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  SizedBox(
                    height: 30,
                  ),
                  Text(widget.appname.toString(),
                    style: TextStyle(fontSize: 20.5,fontWeight: FontWeight.w600,letterSpacing: 0.2),),

                  SizedBox(
                    height: 20,
                  ),
                  Image.network(
                    widget.applogo.toString(),height: 125,width: 125,color:primary,),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                      child: Text(widget.Maitaince_text,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500),)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
