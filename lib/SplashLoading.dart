import 'package:easy_chat/Const/Size.dart';
import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: mediaQuery(context).height,
        width: mediaQuery(context).width,
        child: Center(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
