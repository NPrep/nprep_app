


import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:n_prep/Controller/Auth/Auth_Controller.dart';
import 'package:n_prep/constants/Api_Urls.dart';
import 'package:n_prep/constants/validations.dart';
import 'package:n_prep/main.dart';
import 'package:the_apple_sign_in/scope.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../login_page/SignInWithMobile.dart';
import 'Database.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthController authController =Get.put(AuthController());

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {

    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    authController.Stopupdatelogin();
    final GoogleSignInAuthentication googleSignInAuthentication =await googleSignInAccount.authentication;
    log("UserDetail 1>> ");
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;
    var token= sprefs.getString("Fcmtoken");
    var deviceId= sprefs.getString("deviceId");

    log("UserDetail userDetails>> "+userDetails.toString());

    if (result != null) {
        var login_url = apiUrls().social_login_api;
        var login_body ={
          'name': userDetails.displayName.toString(),
          'mobile': userDetails.phoneNumber??"",
          'email': userDetails.email.toString(),
          'fcm_id': token.toString(),
          'device_id': deviceId.toString(),
          'uid': userDetails.uid.toString()

        };

        Get.find<AuthController>().Login(login_url, login_body,true);
        // var userInfoMap;
      // if(userDetails.phoneNumber==null){
      //   log('hh');
      //   Get.to(SignInWithMobile());
      // }else{
      //   log('hhww');
      //   userInfoMap = {
      //     'name': userDetails.displayName.toString(),
      //     'mobile': userDetails.phoneNumber.toString(),
      //     'email': userDetails.email.toString(),
      //     'fcm_id': token.toString(),
      //     'device_id': deviceId.toString(),
      //     'uid': userDetails.uid.toString()
      //
      //   };
      // }

      // log("UserDetail Login>> "+userInfoMap.toString());
      //
      // if(deviceId.toString()!="null"){
       // var login_url = apiUrls().social_login_api;
      //   var login_body ={
      //     'name': userDetails.displayName.toString(),
      //     'mobile': userDetails.phoneNumber??"",
      //     'email': userDetails.email.toString(),
      //     'fcm_id': token.toString(),
      //     'device_id': deviceId.toString(),
      //     'uid': userDetails.uid.toString()
      //
      //   };
      //
      //   Get.find<AuthController>().Login(login_url, login_body);
      // }else{
      //   // toastMsg("Device id not found", true);
      //   print("Device id not found");
      // }
      // DatabaseMethods().addUser(userDetails.uid, userInfoMap).then((value) {
      //   log("Login");
      //   log("UserDetail Login>> "+userDetails.phoneNumber);
      //   // Navigator.push(
      //   //     context, MaterialPageRoute(builder: (context) => Home()));
      // });
    }
    else{
        Get.find<AuthController>().Stopupdatelogin();
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken));
        final UserCredential = await auth.signInWithCredential(credential);
        final firebaseUser = UserCredential.user;
        if (scopes.contains(Scope.fullName)) {
          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

      default:
        throw UnimplementedError();
    }
  }
}
