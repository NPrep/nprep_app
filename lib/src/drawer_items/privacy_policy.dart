import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:n_prep/Controller/CmsController.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/error_message.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/utils/colors.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}


class _PrivacyPolicyState extends State<PrivacyPolicy> {

  CmsController cmsController =Get.put(CmsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var aboutUrl ="${apiUrls().cms_api}9";
    print("aboutUrl...."+aboutUrl.toString());
    Logger_D(aboutUrl);
    cmsController.CmsData(aboutUrl);
  }

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


  String privacy = "We build a range of services that help millions of people daily to explore and interact with the world in new ways. Our services includeGoogle apps, sites, and devices, like Search, YouTube, and Google HomePlatforms like the Chrome browser and Android operating systemProducts that are integrated into third-party apps and sites, like ads, analytics, and embedded Google MapsYou can use our services in a variety of ways to manage your privacy.For example, you can sign up for a Google Account if you want tocreate and manage content like emails and photos, or see morerelevant search results. And you can use many Google serviceswhen you are signed out or without creating an account at all,like searching on Google or watching YouTube videos. You can alsochoose to browse the web in a private mode,like Chrome Incognito mode. And across our services,you can adjust your privacy settings to control what we collectand how your information is used.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHelper(
        title: 'Privacy Policy',
        showBackIcon: true,
        context: context,
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
                  var aboutUrl ="${apiUrls().cms_api}9";
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
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text('When you use our services, you’re trusting us with your information. We understand this is a big responsibility and work hard to protect your information and put you in control.',
      //           style: TextStyle(fontWeight: FontWeight.w400,
      //               fontFamily: 'Helvetica',
      //               fontSize: 14,
      //               color: black54),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(privacy,
      //           style: TextStyle(fontWeight: FontWeight.w400,
      //               fontFamily: 'Helvetica',
      //               fontSize: 14,
      //               color: black54),),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
