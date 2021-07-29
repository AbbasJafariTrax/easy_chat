import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({String message, Color backgroundColor, Color msgColor}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: msgColor,
    fontSize: 16.0,
  );
}
