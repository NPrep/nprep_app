import 'package:flutter/material.dart';
import 'package:n_prep/utils/colors.dart';

 class CustomButtonClass extends StatelessWidget{
   final   VoidCallback loginButton;

   final String textButton;


    CustomButtonClass({
     Key key,
     this.loginButton,
     this.textButton
 });
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
   return    GestureDetector(
     onTap: loginButton,
     child: Container(
       alignment: Alignment.center,
       width: size.width,

       padding: EdgeInsets.all(9),
       decoration: BoxDecoration(
           color: primary,
           borderRadius: BorderRadius.all(Radius.circular(5))
       ),
       child: Text("${textButton.toUpperCase()}",style: TextStyle(color: white,
           fontSize: 17,fontWeight: FontWeight.w600),) ,
     ),
   );
  }
  
}