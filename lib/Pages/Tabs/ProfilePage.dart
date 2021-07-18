import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/Pages/Auth/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_chat/Const/Colors.dart';

class ProfilePage extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = "Abbas";
    _emailController.text = "abbas@gmail.com";
    _phoneNumController.text = "+93787072236";

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: mediaQuery(context).height * 0.1,
          left: mediaQuery(context).width * 0.08,
          right: mediaQuery(context).width * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: mediaQuery(context).height * 0.11,
                  width: mediaQuery(context).height * 0.11,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        mediaQuery(context).height * 0.055,
                      ),
                      border: Border.all(
                        color: btnColor,
                        width: 4,
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/empty_profile.jpg"),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Joined",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: mediaQuery(context).height * 0.01),
                    Text(
                      "6 month ago",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: mediaQuery(context).height * 0.06),
            VisibleRow(),
            SizedBox(height: mediaQuery(context).height * 0.06),
            ProfileTextField(
              nameController: _nameController,
              mLabel: "Your Name",
              mTextInputType: TextInputType.name,
            ),
            SizedBox(height: mediaQuery(context).height * 0.04),
            ProfileTextField(
              nameController: _emailController,
              mLabel: "Your Email",
              mTextInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: mediaQuery(context).height * 0.04),
            ProfileTextField(
              nameController: _phoneNumController,
              mLabel: "Your Phone Number",
              mTextInputType: TextInputType.phone,
            ),
            SizedBox(height: mediaQuery(context).height * 0.08),
            SizedBox(
              width: mediaQuery(context).width * 0.3,
              child: ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save"),
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: mediaQuery(context).width * 0.3,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser.uid != null)
                    FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.exit_to_app),
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                  alignment: Alignment.centerLeft,
                ),
                label: Text("Sign Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VisibleRow extends StatefulWidget {
  VisibleRow({
    Key key,
  }) : super(key: key);

  @override
  _VisibleRowState createState() => _VisibleRowState();
}

class _VisibleRowState extends State<VisibleRow> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isActive ? "Display" : "Hide",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: isActive,
          activeColor: btnColor,
          activeTrackColor: txtColor,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.4),
          onChanged: (val) {
            setState(() {
              isActive = val;
            });
          },
        )
      ],
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController nameController;
  final TextInputType mTextInputType;
  final String mLabel;

  const ProfileTextField({
    this.mLabel,
    this.mTextInputType,
    this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // focusNode: _phoneFocusNode,
      showCursor: true,
      controller: nameController,
      keyboardType: mTextInputType,
      validator: (val) {
        if (val.isEmpty || val == null) {
          return "لطفا شماره تماس خود را وارد کنید!";
        }
        return null;
      },
      // onFieldSubmitted: (_) {
      //   _focusDigit6.requestFocus();
      // },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 13,
          right: 13,
        ),
        labelText: mLabel,
        labelStyle: TextStyle(
          fontSize: 13,
          color: Colors.grey.withOpacity(0.9),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: btnColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: btnColor),
        ),
      ),
    );
  }
}
