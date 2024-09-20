import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/constants/images.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/helper_widget/appbar_helper.dart';
import 'package:n_prep/helper_widget/custom_textfomfield.dart';
import 'package:n_prep/helper_widget/toast_msg.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();

  //api calling
  AuthController authController =Get.put(AuthController());

  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  changeButton(){
    if(_formKey.currentState.validate()){
      print('Change Button Pressed............');


      var cpass_url = apiUrls().changepassword_api;
      var cpass_body ={
        'old_password': oldPassController.text,
        'password': newPassController.text,
        'password_confirmation': conPassController.text,
      };
      Logger().d("chnage passsword url......${cpass_url}");
      Logger().d("chnage passsword body......${cpass_body}");
      authController.ChangePass(cpass_url, cpass_body);


    }
  }

  cancelButton(){
    print('Cancel Button Pressed............');
    ToastHelper.showMessage('Cancel Button Pressed............');
  }

  bool obscureText = true;
  bool confirmobscureText = true;

  void toggle() {
    setState((){
      obscureText = !obscureText;
    });
  }

  void confirmtoggle() {
    setState((){
      confirmobscureText = !confirmobscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHelper(
        title: 'Change Password',
        context: context,
        showBackIcon: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .05,),
                CustomTextFormField(
                  validator: Validations.validatePassword,
                  hintText: 'Old Password',
                  controller: oldPassController,
                  textInputAction: TextInputAction.next,
                  l_icon: Image.asset(password_icon,scale: 2.8,),
                  keyType: TextInputType.visiblePassword,
                  obscure: true,
                  // obscure: true,
                ),
                sizebox_height_15,
                CustomTextFormField(
                  validator: Validations.validatePassword,
                  hintText: 'New Password',
                  controller: newPassController,
                  l_icon: Image.asset(password_icon,scale: 2.8,),
                  textInputAction: TextInputAction.next,
                  keyType: TextInputType.visiblePassword,
                  obscure: obscureText,
                  suffix: IconButton(
                    icon: obscureText==true?Icon(Icons.visibility_off,size: 16,):Icon(Icons.visibility,size: 16),
                    onPressed: (){
                      toggle();
                    },
                  ),
                ),
                sizebox_height_15,
                CustomTextFormField(
                  validator: (value) => Validations.validateConfirmPassword(newPassController.text, value,),
                  hintText: 'Confirm Password',
                  controller: conPassController,
                  l_icon: Image.asset(password_icon,scale: 2.8,),
                  textInputAction: TextInputAction.done,
                  keyType: TextInputType.visiblePassword,
                  obscure: confirmobscureText,
                  suffix: IconButton(
                    icon: confirmobscureText==true?Icon(Icons.visibility_off,size: 16,):Icon(Icons.visibility,size: 16),
                    onPressed: (){
                      confirmtoggle();
                    },
                  ),
                ),
                sizebox_height_30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          changeButton();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                        ),
                        child: Text(
                          'Change'.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // cancelButton();
                        },
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                          elevation: 0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
