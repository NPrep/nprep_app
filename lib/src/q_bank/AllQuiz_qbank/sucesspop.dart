
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/src/home/bottom_bar.dart';
import 'package:n_prep/utils/colors.dart';


class PaymentDialogSuccess extends StatefulWidget {


  const PaymentDialogSuccess( {Key key, }): super(key: key);

  @override
  _PaymentDialogSuccessState createState() => _PaymentDialogSuccessState();
}

class _PaymentDialogSuccessState extends State<PaymentDialogSuccess> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child:  Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
          height: size.height*0.45,color: white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: primary,width: size.width,height: 45,alignment: Alignment.center,
                child: Text("Payment Successfull",style: TextStyle(color: Colors.grey.shade400,
                    fontSize: 15.0,fontWeight: FontWeight.w500,letterSpacing: 0.2),),
              ),
              Container(
                  alignment: Alignment.center,width: size.width,
                  margin: EdgeInsets.only(left: 40),

                  child: Image.asset("assets/LOGO.png", height:200,)

              ),
              sizebox_height_5,
              Container(
                alignment: Alignment.center,
                child: Text("Now You Can Attend Exam",style: TextStyle(color: Colors.grey.shade400,
                    fontSize: 15.0,fontWeight: FontWeight.w500,letterSpacing: 0.2),),
              ),
              sizebox_height_5,
              Container(
                color: primary,width: 150,height: 45,alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: (){
                    Get.offAll(BottomBar(bottomindex: 1,));
                  },
                    child: Text("Proceed",style: TextStyle(color: Colors.grey.shade400,
                        fontSize: 15.0,fontWeight: FontWeight.w500,letterSpacing: 0.2),),),
              ),

            ],
          )

      )
      ,
    ), onWillPop: (){
      // final dcx = Get.put(AnimalListController());
      // dcx.fetchAnimalList("");
      //Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar(bottomindex: 0,)),
      );
    })
    ;
  }
}