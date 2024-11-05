import 'package:flutter/material.dart';

import 'Local_Database/database.dart';
import 'Models/Videos.dart';

class Demo extends StatefulWidget {
  const Demo({key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {

  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    loadVideos();
    getcategory();
  }

  getcategory() async {
    // Create an instance of DatabaseHelper
    var dbHelper = DatabaseHelper();

    // Call fetchChildCategories using the instance
    }


  loadVideos() async {
    _videos = await DatabaseHelper().getVideos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Videos")),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_videos[index].title),
            subtitle: Text(_videos[index].videoTime),
          );
        },
      ),
    );
  }
}
