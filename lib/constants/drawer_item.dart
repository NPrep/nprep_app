import 'package:flutter/material.dart';
import 'package:n_prep/utils/colors.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String imagename; // Icon name instead of IconData
  final Function onTap;

  const DrawerItem({
    Key key,
    this.title,
    this.imagename,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image image;
    if (imagename != null) {
      image = Image.asset(
        imagename,

        color: Colors.white, // Set the icon color
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // color: primary,
        child: Column(
          children: [
            Container(
              color: primary.withOpacity(0),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 5,
              ),
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                        imagename,
                        scale: 2,
                      ) ??
                      SizedBox.shrink(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'PublicSans',
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
