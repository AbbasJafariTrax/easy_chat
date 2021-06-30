import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MyToast.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/ContactsListAPI.dart';
import 'package:easy_chat/Pages/Auth/SignInPage.dart';
import 'package:easy_chat/Pages/Tabs/ChatTabs/ChatList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpPage extends StatelessWidget {
  static const routeName = "Sign up page";
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

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
                "Sign up",
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
                    "Welcome!",
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
                "Please sign up to continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.02,
              ),
              MyTextFieldAuth(
                txtController: _fullNameController,
                label: "FULL NAME",
                textInputType: TextInputType.name,
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
              MyTextFieldAuth(
                txtController: _confirmPassController,
                label: "CONFIRM PASSWORD",
                textInputType: TextInputType.visiblePassword,
                obscureTextField: true,
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.02,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: mediaQuery(context).height * 0.05,
                  width: mediaQuery(context).width * 0.28,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      if (_passwordController.text !=
                          _confirmPassController.text) {
                        showToast(message: "Your password does not match");
                        return;
                      }
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        Provider.of<ContactsList>(context, listen: false)
                            .addContact(
                          userName: _fullNameController.text,
                          email: userCredential.user.email,
                          userId: userCredential.user.uid,
                          isOnline: true,
                        );

                        Navigator.pushReplacementNamed(
                          context,
                          ChatList.routeName,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          print('Email already in use.');
                          showToast(message: "Email already in use.");
                        } else if (e.code == 'invalid-email') {
                          print('Invalid email');
                          showToast(message: "Invalid email.");
                        } else if (e.code == "operation-not-allowed") {
                          print('Operation not allowed');
                          showToast(message: "Operation not allowed.");
                        } else if (e.code == "weak-password") {
                          print("Weak password");
                          showToast(message: "Weak password.");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: btnColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "SIGNUP",
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
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, SignInPage.routeName);
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
    ;
  }
}
