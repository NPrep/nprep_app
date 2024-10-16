import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Controller/CmsController.dart';
import 'package:n_prep/Controller/Setting_controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/IconsData.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';



class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final String phoneNumber = '9456373921';
  final String emailAddress = 'Mail@example.com';
  final String whatsapp = '8852911910';

  CmsController cmsController =Get.put(CmsController());

  SettingController settingController =Get.put(SettingController());

  makePhoneCall(String phoneNumber) async {

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // ignore: deprecated_member_use
    await launch(launchUri.toString());
  }

  void launchEmailSubmission(emailpath) async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: emailpath.toString(),
        query: ''
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void openWhatsApp(String phoneNumber) async {
    print(" oo $phoneNumber");
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var aboutUrl ="${apiUrls().cms_api}3";
    // print("aboutUrl...."+aboutUrl.toString());
    // Logger_D(aboutUrl);
    // cmsController.CmsData(aboutUrl);
    var settingUrl ="${apiUrls().setting_api}";
    settingController.SettingData(settingUrl);
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.10, 1.10)),

      child: Scaffold(
        appBar: AppBarHelper(
          title: 'Contact Us',
          context: context,
          showBackIcon: true,
        ),
        body: GetBuilder<SettingController>(
          builder: (settingContro) {
            if(settingContro.settingLoader.value){
              return Center(child: CircularProgressIndicator());
            }
            else {
              return SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GetBuilder<CmsController>(
                        builder: (cmsController) {
                          if(cmsController.aboutLoader.value){
                            return CircularProgressIndicator();
                          }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/contactimg.png",scale: 2.9,)
                        );
                      }
                    ),

                    Padding(
                      padding:EdgeInsets.only(top: Get.height*0.18),
                      child: ContactContainer(
                        title: "Call us",
                        // title: "${settingController.settingData['data']['general_settings']['phone'].toString()}",
                        iconName: 'phone',
                        onTap: () {
                          var phoneNumber =settingController.settingData['data']['general_settings']['phone'].toString();
                          makePhoneCall(phoneNumber);
                          Logger().d("phoneNumber ........${phoneNumber}");

                        },
                      ),
                    ),
                    ContactContainer(
                      // title: "${settingController.settingData['data']['general_settings']['email'].toString()}",
                      title: "Email us",
                      iconName: 'email',
                      onTap: () {
                        var emailpath = settingController.settingData['data']['general_settings']['email'].toString();
                        launchEmailSubmission(emailpath);
                      },
                    ),
                    ContactContainer(
                      // title: "${settingController.settingData['data']['general_settings']['phone'].toString()}",
                      title: "Whatsapp us",
                      iconName: 'whatsapp',
                      onTap: () {
                        var phoneNumber =settingController.settingData['data']['general_settings']['phone'].toString();
                        openWhatsApp(phoneNumber);
                      },
                    ),
                  ],
                ),
              );
            }
          }
        ),
      ),
    );
  }
}

class ContactContainer extends StatelessWidget {
  final String title;
  final String iconName; // Icon name instead of IconData
  final Function onTap;

  const ContactContainer({
    Key key,
    this.title,
    this.iconName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (iconName != null && IconsData.iconsMap.containsKey(iconName)) {
      icon = Icon(
        IconsData.iconsMap[iconName],
        color: Theme.of(context).primaryColor,
        size: 30, // Set the icon color
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.black38,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context)
                        .primaryColor, // Set your desired border color here
                    width: 1.0, // Set the width of the border
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  child: icon,
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black38,
                    fontFamily: 'PublicSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
