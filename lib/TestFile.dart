import 'package:flutter/material.dart';

class TestFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        color: Colors.black,
        child: TextField(),
      ),
      body: Container(
        child: TextField(),
      ),
    );
  }
}
