import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:n_prep/Controller/CmsController.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/utils/colors.dart';

import '../../constants/Api_Urls.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  CmsController cmsController =Get.put(CmsController());


  bannerImages(imagess){
    print("imagess...."+imagess.toString());
    return  ImagePixels.container(
      imageProvider: NetworkImage(imagess),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.width-180,

        child: Image(image:NetworkImage(imagess),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var aboutUrl ="${apiUrls().cms_api}7";
    print("aboutUrl...."+aboutUrl.toString());
    Logger_D(aboutUrl);
    cmsController.CmsData(aboutUrl);
  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        appBar: AppBarHelper(
          context: context,
          title: 'About Us',
          showBackIcon: true,
        ),
        body: GetBuilder<CmsController>(

          builder: (controller) {
            if(controller.aboutLoader.value){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return RefreshIndicator(
                displacement: 65,
                backgroundColor: Colors.white,
                color: primary,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 1500));
                  var aboutUrl ="${apiUrls().cms_api}7";
                  print("aboutUrl...."+aboutUrl.toString());
                  Logger_D(aboutUrl);
                  cmsController.CmsData(aboutUrl);
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //
                      //     child: Image.network
                      //       ("${apiUrls().imageUrl}${cmsController.about_data['data']['image'].toString()}",
                      //         // height: 210,
                      //         width: size.width)),
                      bannerImages(cmsController.about_data['data']['image'].toString()),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                        child: Center(
                          child: Column(
                            children: [
                              Html(data:
                              cmsController.about_data['data']['cms_contant'].toString(),
                                style: {
                                  "table": Style( ),
                                  // some other granular customizations are also possible
                                  "tr": Style(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                      top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                      right: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                      left: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
                                    ),
                                  ),
                                  "th": Style(
                                    padding: EdgeInsets.all(6),
                                    backgroundColor: Colors.black,
                                  ),
                                  "td": Style(
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.topLeft,
                                  ),
                                },
                                customRenders: {
                                  tableMatcher(): tableRender(),
                                },
                                // style: {
                                //   "body": Style(
                                //     fontSize: FontSize(14.0),
                                //     fontWeight: FontWeight.w400,
                                //     fontFamily: 'Helvetica',
                                //     color: black54,
                                //     textAlign: TextAlign.justify,
                                //     letterSpacing: 0.5,
                                //     // height: 1.1
                                //   ),
                                //
                                // },
                              ),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                              // Text(
                              //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'
                              //         '.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem'
                              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                              //         'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam'
                              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'
                              //         '.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem'
                              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                              //         'Ut enim ad minim veniam, quis nostrud exercitationLorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'
                              //         '.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem'
                              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                              //         'Ut enim ad minim veniam, quis nostrud exercitationLorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'
                              //         '.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem'
                              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                              //         'Ut enim ad minim veniam, quis nostrud exercitation quaerat '
                              //         'voluptatem”',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w400,
                              //       fontFamily: 'Helvetica',
                              //       fontSize: 14,
                              //       color: black54
                              //   ), ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            }

          }
        ),
      ),
    );
  }
}
