import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScreen extends StatelessWidget {

  const ShimmerScreen({key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
        itemBuilder: (context,index){
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],  // Base grey color
        highlightColor: Colors.grey[100],  // Lighter grey for shimmer
        child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width-20,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(  // Custom grey gradient
              colors: [
                Colors.grey[300],
                Colors.grey[200],
                Colors.grey[100],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      );
    });
  }
}
