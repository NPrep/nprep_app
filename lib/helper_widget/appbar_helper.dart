import 'package:flutter/material.dart';

class AppBarHelper extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;
  final List<Widget> actions;
  final bool showBackIcon;
  final bool center;
  final fontsize;
  final bottom; // Add this parameter

  AppBarHelper(
      {this.title,
      this.context,
      this.actions,
      this.showBackIcon = true,
      this.center = false,
      this.fontsize,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: center,
      elevation: 0,
      title: Row(
        mainAxisAlignment:
            center ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          if (showBackIcon) // Check if showBackIcon is true
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          Container(
            width: MediaQuery.of(context).size.width-60,
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 17.0,fontWeight: FontWeight.w400)),
          ),
        ],
      ),
      actions: actions ?? [],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
