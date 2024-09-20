import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Validations {
  static String validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    }
    return null; // Validation passed
  }

  static String validateOther(String value) {
    if (value.isEmpty) {
      return 'Please enter Field';
    }
    return null; // Validation passed
  }

  // Validation of Mobile Number
  static String validateMobile(String value) {
    if (value.isEmpty) {
      return 'Please enter the mobile number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null; // Validation passed
  }

  // Validation of Email
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Validation passed
  }

  // Validation of Password
  static String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter the password';
    }
    if (value.length < 8) {
      return 'Password size must be 8 characters';
    }
    return null; // Validation passed
  }

  // Validation of Confirm Password
  static String validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null; // Validation passed
  }
 /// Validation of Job qualification field...
  static String validateJobQualification(String value) {
    if (value.isEmpty) {
      return 'Please select job qualification';
    }
    return null;
  }
  /// Validation of Colleges field...
  static String validateCollege(String value) {
    if (value.isEmpty) {
      return 'Please select college';
    }
    return null;
  }


  static String validateState(String value) {
    if (value.isEmpty) {
      return 'Please enter State';
    }
    return null; // Validation passed
  }

  static String validateCity(String value) {
    if (value.isEmpty) {
      return 'Please enter City';
    }
    return null; // Validation passed
  }

  static String pinputOtp(String value) {
    if (value.isEmpty) {
      return 'Please enter OTP';
    }
    return null; // Validation passed
  }
}
Future<void> toastMsg(var msg,bool iserrorr){
  var Msg = Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: iserrorr == true?Colors.black54:Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
  return Msg;
}