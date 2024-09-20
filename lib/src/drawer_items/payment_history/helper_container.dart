import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {

  final String day;
  final String monthYear;
  final String validity;
  final String planType;
  final String mrp;


  const CustomContainer({
    Key key,
    this.day,
    this.monthYear,
    this.validity,
    this.planType,
    this.mrp
  });

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.grey),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 1, // Blur radius
              offset: Offset(1, 1), // Offset in the form of (dx, dy)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Text('Purchase Plan Date',style: TextStyle(color: Colors.black87,fontSize: 8),),
                        Text(day,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 40,fontWeight: FontWeight.bold)),
                        Text(monthYear,style: TextStyle(color: Colors.black87,fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Valid Till : ',
                        style: TextStyle(color: Colors.black87,fontSize: 12),),

                      Text(validity,
                        style: TextStyle(color: Colors.black87,fontSize: 12),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(planType,style: TextStyle(color: Colors.black87,fontSize: 20,)),
                  SizedBox(height: 12,),
                  Row(

                    children: [
                      Text('\u20B9',style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14)),
                      Text(mrp,style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: size.height *0.06,
              width: size.width *0.012,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

