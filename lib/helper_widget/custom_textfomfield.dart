import 'package:flutter/material.dart';
import 'package:n_prep/constants/custom_text_style.dart';
import 'package:n_prep/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool status_cursor;
  final TextEditingController controller;
  final String Function(String) validator;
  final String Function(String) onChanged;
  final String Function(String) onSave;
  final String Function(String) onButtonSave;
  final OutlinedBorder borders;
  final UnderlineInputBorder bordersinput;
  final  TextStyle styles;
  final  TextStyle hinttextstyle;
  final Image l_icon;
  final Icon p_icon;
  final TextInputType keyType;
  final TextInputAction textInputAction;
  final int maxLength;
  final bool obscure;
  final formatter;
  final IconButton suffix;
  final  bool readonly;

  VoidCallback onTap;

   CustomTextFormField({
    Key key,
    this.hintText,
    this.status_cursor,
    this.controller,
    this.l_icon,
    this.borders,
    this.styles,
    this.hinttextstyle,
    this.onChanged,
    this.onSave,
    this.onButtonSave,
    this.p_icon,
    this.obscure,
    this.keyType,
    this.maxLength,
    this.validator,
    this.textInputAction,
    this.formatter,
    this.suffix,
    this.onTap,
    this.readonly,this.bordersinput
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readonly??false,
      onChanged: onChanged,
      onSaved:  onSave,
      onFieldSubmitted: onButtonSave,
      autofocus: status_cursor==null?false:status_cursor,
      cursorColor: status_cursor==true?Colors.white38:primary,
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 10,top: 15),
       hintText: hintText,

          hintStyle: hinttextstyle==null?TextStyles.HintStyle:hinttextstyle,
          counterText: '',
          icon: l_icon ?? p_icon,
        // contentPadding: EdgeInsets.only(top: 2),
        isCollapsed: false,
          alignLabelWithHint: false,
        isDense: true,
        suffixIcon:suffix,
        // border: borders,
        enabledBorder: bordersinput,
          disabledBorder: bordersinput,
        border: bordersinput,
          focusedBorder: bordersinput

         ),
      obscureText: obscure ?? false,
      style: styles,

      controller: controller,
      validator: validator,
      maxLength: maxLength,
      keyboardType: keyType,
      autovalidateMode: AutovalidateMode.disabled,
      textInputAction:textInputAction,
      inputFormatters: formatter,

    );
  }
}
