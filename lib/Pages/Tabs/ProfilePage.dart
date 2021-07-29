import 'package:easy_chat/Const/SharedPrefsKeys.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/ContactsListAPI.dart';
import 'package:easy_chat/Pages/Auth/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_chat/Const/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  bool isVisible = false;

  Future<void> userProfile;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _phoneNumController.dispose();
  }

  void getUserInfo() async {
    final SharedPreferences prefs = await _prefs;

    userProfile = Provider.of<ContactsList>(context, listen: false)
        .getUserProfile(phoneNum: prefs.getString(PHONE_NUMBER_KEY))
        .then((value) {
      _nameController.text = value.value["userName"];
      isVisible = value.value["isInVisible"] == "true" ? true : false;
      _phoneNumController.text = value.key;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Column(
              children: <Widget>[
                SizedBox(
                  height: mediaQuery(context).height * 0.2,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : SingleChildScrollView(
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
                              image:
                                  AssetImage("assets/images/empty_profile.jpg"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isVisible ? "Display" : "Hide",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: isVisible,
                        activeColor: btnColor,
                        activeTrackColor: txtColor,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.4),
                        onChanged: (val) {
                          setState(() {
                            isVisible = val;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: mediaQuery(context).height * 0.06),
                  ProfileTextField(
                    nameController: _nameController,
                    mLabel: "Your Name",
                    mTextInputType: TextInputType.name,
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
                      onPressed: () {
                        Provider.of<ContactsList>(
                          context,
                          listen: false,
                        ).saveProfile(
                          phoneNum: _phoneNumController.text,
                          uId: FirebaseAuth.instance.currentUser.uid,
                          userName: _nameController.text,
                          isOnline: true,
                          isInVisible: !isVisible,
                        );
                      },
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

// class VisibleRow extends StatefulWidget {
//   bool isActive;
//
//   VisibleRow({
//     Key key,
//     this.isActive,
//   }) : super(key: key);
//
//   @override
//   _VisibleRowState createState() => _VisibleRowState();
// }
//
// class _VisibleRowState extends State<VisibleRow> {
//   // bool isActive = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           widget.isActive ? "Display" : "Hide",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Switch(
//           value: widget.isActive,
//           activeColor: btnColor,
//           activeTrackColor: txtColor,
//           inactiveThumbColor: Colors.grey,
//           inactiveTrackColor: Colors.grey.withOpacity(0.4),
//           onChanged: (val) {
//             setState(() {
//               widget.isActive = val;
//             });
//           },
//         )
//       ],
//     );
//   }
// }

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
