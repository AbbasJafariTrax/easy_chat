import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery(context).width * 0.035,
          vertical: mediaQuery(context).height * 0.2,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Log in",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.03,
              ),
              Row(
                children: [
                  Text(
                    "Hi, ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Good Day!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.005,
              ),
              Text(
                "Please sign in to to continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.08,
              ),
              MyTextField(
                txtController: _emailController,
                label: "EMAIL",
                textInputType: TextInputType.emailAddress,
              ),
              MyTextField(
                txtController: _passwordController,
                label: "PASSWORD",
                textInputType: TextInputType.visiblePassword,
                obscureTextField: true,
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.05,
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.05,
                width: mediaQuery(context).width * 0.28,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: btnColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final bool obscureTextField;

  final TextEditingController txtController;

  const MyTextField({
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
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.symmetric(
            horizontal: mediaQuery(context).width * 0.03,
            vertical: mediaQuery(context).height * 0.01,
          ),
        ),
      ),
    );
  }
}
