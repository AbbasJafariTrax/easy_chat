import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MyToast.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/Pages/Auth/SignupPage.dart';
import 'package:easy_chat/Pages/Tabs/ChatTabs/ChatList.dart';
import 'package:easy_chat/Pages/Tabs/TabPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const routeName = "Sign in page";
  FirebaseAuth auth = FirebaseAuth.instance;
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
                "Please sign in to continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.08,
              ),
              MyTextFieldAuth(
                txtController: _emailController,
                label: "EMAIL",
                textInputType: TextInputType.emailAddress,
              ),
              MyTextFieldAuth(
                txtController: _passwordController,
                label: "PASSWORD",
                textInputType: TextInputType.visiblePassword,
                obscureTextField: true,
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.05,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: mediaQuery(context).height * 0.05,
                  width: mediaQuery(context).width * 0.28,
                  child: ElevatedButton(
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
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TabPages()),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          showToast(message: "No user found for that email.");
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          showToast(
                            message: "Wrong password provided for that user.",
                          );
                        } else if (e.code == 'invalid-email') {
                          print('Invalid email.');
                          showToast(message: "Invalid email.");
                        } else if (e.code == "user-disabled") {
                          print("User disabled");
                          showToast(message: "User disabled.");
                        }
                      }
                    },
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
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, SignUpPage.routeName);
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: txtColor,
                        fontSize: 15,
                      ),
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
