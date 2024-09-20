import 'package:flutter/material.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/utils/colors.dart';

class ProfileModeText extends StatelessWidget {
  final icon_img;
  final text;
  final double imgsize;

  ProfileModeText({Key key, this.text, this.icon_img, this.imgsize});

  @override
  Widget build(BuildContext context) {
    var cwidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                icon_img,
                scale: imgsize,
                color: primary,
              ),
              SizedBox(
                width: cwidth * 0.1,
              ),
              Container(
                width: MediaQuery.of(context).size.width-150,
                child: Text(text,style: TextStyle(
                    fontSize: 18,
                    color: grey,
                    fontFamily: 'PublicSans',
                    fontWeight: FontWeight.w400,
                    ),),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}


