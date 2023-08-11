import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelForm extends StatelessWidget {
  const LabelForm(
      {Key? key,
      required this.text,
      required this.textColor,
      this.isBold = false})
      : super(key: key);

  final String text;
  final Color textColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          )),
    );
  }
}

class LoginFormInput extends StatelessWidget {
  const LoginFormInput(
      {super.key,
      required this.controller,
      required this.validate,
      required this.keyBoardType,
      required this.textColor,
      required this.borderColor,
      this.isPassword = false,
      this.hintText = "",
      this.formater = const [],
      this.focusColor = Colors.white,
      this.focusedColor = Colors.white});

  void onchange(String value) {}

  final TextEditingController controller;
  final validate;
  final TextInputType keyBoardType;
  final Color textColor;
  final Color borderColor;
  final Color focusColor;
  final Color focusedColor;
  final String hintText;
  final bool isPassword;
  final List<TextInputFormatter> formater;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.next,
        validator: validate,
        controller: controller,
        style: TextStyle(color: textColor),
        keyboardType: keyBoardType,
        inputFormatters: formater,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: focusColor)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ));
  }
}
