import 'package:flutter/material.dart';
import 'package:n_prep/utils/colors.dart';

class Decorations {
  static InputDecoration nameInputDecoration = InputDecoration(
    hintText: 'Name.',
    icon: Icon(Icons.person_outline,color: primary,),
    counterText: ''
  );

  static InputDecoration mobileInputDecoration = InputDecoration(
    hintText: 'Mobile No.',
    icon: Icon(Icons.phone,color: primary),
    counterText: ''
  );

  static InputDecoration emailInputDecoration = InputDecoration(
    hintText: 'Email',
    icon: Icon(Icons.email_outlined,color: primary),
    counterText: ''
  );

  static InputDecoration passwordInputDecoration = InputDecoration(
    hintText: 'Password',
      icon: Icon(Icons.password,color: primary),
    counterText: ''
  );
  static InputDecoration cPasswordInputDecoration = InputDecoration(
      hintText: 'Confirm Password',
      icon: Icon(Icons.password,color: primary),
      counterText: ''

  );

}
