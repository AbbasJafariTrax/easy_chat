
import 'package:easy_chat/Const/Size.dart';
import 'package:flutter/material.dart';

class MyTextFieldAuth extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final bool obscureTextField;

  final TextEditingController txtController;

  const MyTextFieldAuth({
    this.label,
    this.textInputType,
    this.txtController,
    this.obscureTextField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: TextFormField(
        controller: txtController,
        keyboardType: textInputType,
        obscureText: obscureTextField,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required!";
          } else if (value.length < 3) {
            return "This field must bigger than three!";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: mediaQuery(context).width * 0.03,
            vertical: mediaQuery(context).height * 0.01,
          ),
        ),
      ),
    );
  }
}
