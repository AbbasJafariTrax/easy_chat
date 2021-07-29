import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MyToast.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/Const/mCheckConnection.dart';
import 'package:easy_chat/MyAPI/ContactsListAPI.dart';
import 'package:easy_chat/MyAPI/PhoneCodeManagement.dart';
import 'package:easy_chat/Pages/Auth/SignupPage.dart';
import 'package:easy_chat/Pages/Tabs/ChatTabs/ChatList.dart';
import 'package:easy_chat/Pages/Tabs/TabPages.dart';
import 'package:easy_chat/Widgets/MAuthWidget/MyTextFieldAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static const routeName = "Sign in page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneNumController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _phoneNumController.dispose();
  }

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
                label: "FULL NAME",
                textInputType: TextInputType.name,
              ),
              MyTextFieldAuth(
                txtController: _phoneNumController,
                label: "PHONE NUMBER",
                textInputType: TextInputType.phone,
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
                      showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue =
                              Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(
                              0.0,
                              curvedValue * 200,
                              0.0,
                            ),
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                content: MAlertContent(
                                  phoneNum: _phoneNumController.text,
                                  type: "SignIn",
                                  fullName: _emailController.text,
                                ),
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: false,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {},
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery(context).height * 0.25,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Don't have an account? ",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black.withOpacity(0.5),
              //         fontSize: 15,
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Navigator.pushReplacement(
              //           context,
              //           MaterialPageRoute(builder: (context) => SignUpPage()),
              //         );
              //       },
              //       child: Text(
              //         "Sign up",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: txtColor,
              //           fontSize: 15,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration mInputBorder({TextEditingController ctrl, bool isCodeVerify}) {
  return InputDecoration(
    hintText: "*",
    contentPadding: EdgeInsets.only(bottom: 0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 2,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: ctrl.text.isEmpty ? Colors.transparent : btnColor,
        width: 2,
      ),
    ),
    fillColor: inputBackgroundColor,
    filled: true,
    hintStyle: TextStyle(
      color: isCodeVerify ? btnColor : Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    counterText: "",
  );
}

class MAlertContent extends StatefulWidget {
  final String phoneNum;
  final String fullName;
  final String type;

  MAlertContent({this.phoneNum, this.fullName, this.type});

  @override
  _MAlertContentState createState() => _MAlertContentState();
}

class _MAlertContentState extends State<MAlertContent> {
  FocusNode _focusDigit1 = FocusNode();
  FocusNode _focusDigit2 = FocusNode();
  FocusNode _focusDigit3 = FocusNode();
  FocusNode _focusDigit4 = FocusNode();
  FocusNode _focusDigit5 = FocusNode();
  FocusNode _focusDigit6 = FocusNode();

  TextEditingController ctrlDigit1 = TextEditingController();
  TextEditingController ctrlDigit2 = TextEditingController();
  TextEditingController ctrlDigit3 = TextEditingController();
  TextEditingController ctrlDigit4 = TextEditingController();
  TextEditingController ctrlDigit5 = TextEditingController();
  TextEditingController ctrlDigit6 = TextEditingController();

  bool isCodeVerify = true;
  bool isLoading = true;
  FocusNode _keyboardFocus = FocusNode();

  //Firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  String mVerificationId;
  PhoneAuthCredential credential;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      _focusDigit1.requestFocus();
      Provider.of<PhoneCodeManagement>(context, listen: false).startTimer();
      sendingPhoneNum(args: widget.phoneNum);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ctrlDigit1.dispose();
    ctrlDigit2.dispose();
    ctrlDigit3.dispose();
    ctrlDigit4.dispose();
    ctrlDigit5.dispose();
    ctrlDigit6.dispose();

    _focusDigit1.dispose();
    _focusDigit2.dispose();
    _focusDigit3.dispose();
    _focusDigit4.dispose();
    _focusDigit5.dispose();
    _focusDigit6.dispose();

    Provider.of<PhoneCodeManagement>(context, listen: false).stopTimer();
  }

  void sendingPhoneNum({String args}) async {
    bool isConnected = await mCheckConnection();

    if (!isConnected) {
      showToast(message: "انترنت قطع است!");
      return null;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: args,
      verificationCompleted: (
        PhoneAuthCredential credential,
      ) async {
        try {
          await auth.signInWithCredential(credential).then(
            (value) async {
              User userCredential = await FirebaseAuth.instance.currentUser;

              Provider.of<ContactsList>(context, listen: false).addContact(
                userName: widget.fullName,
                isOnline: true,
                phoneNum: widget.phoneNum,
                uId: userCredential.uid,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => TabPages()),
                (route) => false,
              );
            },
          );
        } catch (e) {
          print("Mahdi: verificationCompleted: error: $e");
        }
      },
      codeSent: (
        String verificationId,
        int resendToken,
      ) async {
        mVerificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        mVerificationId = verificationId;
      },
      verificationFailed: (FirebaseAuthException e) {
        Provider.of<PhoneCodeManagement>(context, listen: false).stopTimer();
        if (e.code == 'invalid-phone-number') {
          showToast(
            message: "شماره شما نامعتبر است!",
            backgroundColor: Colors.red,
            msgColor: Colors.white,
          );
        }
        showToast(
          message: e.message,
          msgColor: Colors.black,
          backgroundColor: Colors.white,
        );
        print("Mahdi: verificationFailed: $e");
      },
      timeout: Duration(seconds: 65),
    );
  }

  void sendCodeToServer({String phoneNum}) async {
    bool textFieldStatus = (ctrlDigit1.text.isNotEmpty &&
        ctrlDigit2.text.isNotEmpty &&
        ctrlDigit3.text.isNotEmpty &&
        ctrlDigit4.text.isNotEmpty &&
        ctrlDigit5.text.isNotEmpty &&
        ctrlDigit6.text.isNotEmpty);

    print("Mahdi: PhoneCodeN 1 $textFieldStatus");

    if (!textFieldStatus) {
      return;
    }

    String mySmsCode = ctrlDigit1.text +
        ctrlDigit2.text +
        ctrlDigit3.text +
        ctrlDigit4.text +
        ctrlDigit5.text +
        ctrlDigit6.text;

    print("Mahdi: PhoneCodeN 1 $mySmsCode");

    //TODO get phone code
    credential = PhoneAuthProvider.credential(
      verificationId: mVerificationId,
      smsCode: mySmsCode,
    );

    print("Mahdi: PhoneCodeN 1 $widget.credential");

    if (mySmsCode.isEmpty || mySmsCode == null) {
      showToast(
        message: "لطفا کد خود را وارد کنید!",
        backgroundColor: Colors.red,
        msgColor: Colors.white,
      );
      return;
    } else if (credential.smsCode.toString() != mySmsCode) {
      isCodeVerify = false;
      showToast(
        message: "کد اشتباه است!",
        backgroundColor: Colors.red,
        msgColor: Colors.white,
      );
      return;
    }

    bool isConnected = await mCheckConnection();

    if (!isConnected) {
      showToast(message: "انترنت قطع است!");
      return null;
    }

    await auth.signInWithCredential(credential).then(
      (value) async {
        print("Mahdi: val 20 ${auth.currentUser.uid} ::");
        if (credential != null) {
          User userCredential = FirebaseAuth.instance.currentUser;

          Provider.of<ContactsList>(context, listen: false).addContact(
            userName: widget.fullName,
            isOnline: true,
            phoneNum: widget.phoneNum,
            uId: userCredential.uid,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabPages()),
            (route) => false,
          );
        } else {
          showToast(message: "لطفا منتظر ارسال کد بمانید!");
        }
      },
    ).catchError((e) {
      print("Mahdi: err 2 $e : ${credential}");
      setState(() {
        isCodeVerify = false;
      });
    });
  }

  void checkInput(TextEditingController ctrl, FocusNode fcsNode) {
    if (ctrlDigit1.text.isEmpty) {
      _focusDigit1.requestFocus();
    } else if (ctrlDigit2.text.isEmpty) {
      _focusDigit2.requestFocus();
    } else if (ctrlDigit3.text.isEmpty) {
      _focusDigit3.requestFocus();
    } else if (ctrlDigit4.text.isEmpty) {
      _focusDigit4.requestFocus();
    } else if (ctrlDigit5.text.isEmpty) {
      _focusDigit5.requestFocus();
    } else if (ctrlDigit6.text.isEmpty) {
      _focusDigit6.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: (RawKeyEvent val) {
        if (val.runtimeType.toString() == 'RawKeyDownEvent' &&
            val.data.keyLabel.isNotEmpty) {
          if (_focusDigit1.hasFocus && ctrlDigit1.text.length > 0) {
            FocusScope.of(context).requestFocus(_focusDigit2);
            ctrlDigit2.text = val.data.keyLabel;
          } else if (_focusDigit2.hasFocus && ctrlDigit2.text.length > 0) {
            FocusScope.of(context).requestFocus(_focusDigit3);
            ctrlDigit3.text += val.data.keyLabel;
          } else if (_focusDigit3.hasFocus && ctrlDigit3.text.length > 0) {
            FocusScope.of(context).requestFocus(_focusDigit4);
            ctrlDigit4.text += val.data.keyLabel;
          } else if (_focusDigit4.hasFocus && ctrlDigit4.text.length > 0) {
            FocusScope.of(context).requestFocus(_focusDigit5);
            ctrlDigit5.text += val.data.keyLabel;
          } else if (_focusDigit5.hasFocus && ctrlDigit5.text.length > 0) {
            FocusScope.of(context).requestFocus(_focusDigit6);
            ctrlDigit6.text += val.data.keyLabel;

            ctrlDigit6.selection = TextSelection.fromPosition(
              TextPosition(offset: ctrlDigit6.text.length),
            );
          }

          sendCodeToServer(phoneNum: widget.phoneNum);
        } else if (val.runtimeType.toString() == 'RawKeyDownEvent' &&
            val.data.logicalKey.keyId == 4295426090) {
          if (_focusDigit2.hasFocus && ctrlDigit2.text.length == 0) {
            FocusScope.of(context).requestFocus(_focusDigit1);

            if (ctrlDigit1.text.length > 0) {
              ctrlDigit1.text = ctrlDigit1.text.substring(
                0,
                ctrlDigit1.text.length - 1,
              );
            }
          } else if (_focusDigit3.hasFocus && ctrlDigit3.text.length == 0) {
            FocusScope.of(context).requestFocus(_focusDigit2);

            if (ctrlDigit2.text.length > 0) {
              ctrlDigit2.text = ctrlDigit2.text.substring(
                0,
                ctrlDigit2.text.length - 1,
              );
            }
          } else if (_focusDigit4.hasFocus && ctrlDigit4.text.length == 0) {
            FocusScope.of(context).requestFocus(_focusDigit3);

            if (ctrlDigit3.text.length > 0) {
              ctrlDigit3.text = ctrlDigit3.text.substring(
                0,
                ctrlDigit3.text.length - 1,
              );
            }
          } else if (_focusDigit5.hasFocus && ctrlDigit5.text.length == 0) {
            FocusScope.of(context).requestFocus(_focusDigit4);

            if (ctrlDigit4.text.length > 0) {
              ctrlDigit4.text = ctrlDigit4.text.substring(
                0,
                ctrlDigit4.text.length - 1,
              );
            }
          } else if (_focusDigit6.hasFocus && ctrlDigit6.text.length == 0) {
            FocusScope.of(context).requestFocus(_focusDigit5);

            if (ctrlDigit5.text.length > 0) {
              ctrlDigit5.text = ctrlDigit5.text.substring(
                0,
                ctrlDigit5.text.length - 1,
              );
            }
          }
        }
      },
      focusNode: _keyboardFocus,
      child: Container(
        height: mediaQuery(context).height * 0.5,
        width: mediaQuery(context).width * 0.9,
        child: Column(
          children: [
            SizedBox(height: mediaQuery(context).height * 0.02),
            Text(
              "OTP Verification",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: mediaQuery(context).height * 0.06),
            RichText(
              text: TextSpan(
                text: "Enter OTP Code sent to:   ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: "${widget.phoneNum}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mediaQuery(context).height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit1.text.isEmpty)
                            checkInput(ctrlDigit1, _focusDigit1);
                        },
                        child: TextField(
                          controller: ctrlDigit1,
                          focusNode: _focusDigit1,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit1.text.isEmpty)
                              checkInput(ctrlDigit1, _focusDigit1);
                          },
                          onChanged: (str) {
                            if (str.length == 1) {
                              FocusScope.of(context).requestFocus(_focusDigit2);
                            }

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit1,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: mediaQuery(context).width * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit2.text.isEmpty)
                            checkInput(ctrlDigit2, _focusDigit2);
                        },
                        child: TextField(
                          controller: ctrlDigit2,
                          focusNode: _focusDigit2,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit2.text.isEmpty)
                              checkInput(ctrlDigit2, _focusDigit2);
                          },
                          onChanged: (str) {
                            if (str.length == 1) {
                              FocusScope.of(context).requestFocus(_focusDigit3);
                            } else if (str.length == 0) {
                              FocusScope.of(context).requestFocus(_focusDigit1);
                            }

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit2,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: mediaQuery(context).width * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit3.text.isEmpty)
                            checkInput(ctrlDigit3, _focusDigit3);
                        },
                        child: TextField(
                          controller: ctrlDigit3,
                          focusNode: _focusDigit3,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit3.text.isEmpty)
                              checkInput(ctrlDigit3, _focusDigit3);
                          },
                          onChanged: (str) {
                            if (str.length == 1) {
                              FocusScope.of(context).requestFocus(_focusDigit4);
                            } else if (str.length == 0) {
                              FocusScope.of(context).requestFocus(_focusDigit2);
                            }

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit3,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: mediaQuery(context).width * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit4.text.isEmpty)
                            checkInput(ctrlDigit4, _focusDigit4);
                        },
                        child: TextField(
                          controller: ctrlDigit4,
                          focusNode: _focusDigit4,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit4.text.isEmpty)
                              checkInput(ctrlDigit4, _focusDigit4);
                          },
                          onChanged: (str) {
                            if (str.length == 1) {
                              FocusScope.of(context).requestFocus(_focusDigit5);
                            } else if (str.length == 0) {
                              FocusScope.of(context).requestFocus(_focusDigit3);
                            }

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit4,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: mediaQuery(context).width * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit5.text.isEmpty)
                            checkInput(ctrlDigit5, _focusDigit5);
                        },
                        child: TextField(
                          controller: ctrlDigit5,
                          focusNode: _focusDigit5,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit5.text.isEmpty)
                              checkInput(ctrlDigit5, _focusDigit5);
                          },
                          onChanged: (str) {
                            if (str.length == 1) {
                              FocusScope.of(context).requestFocus(_focusDigit6);
                            } else if (str.length == 0) {
                              FocusScope.of(context).requestFocus(_focusDigit4);
                            }

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit5,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: mediaQuery(context).width * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mediaQuery(context).width * 0.08,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (ctrlDigit6.text.isEmpty)
                            checkInput(ctrlDigit6, _focusDigit6);
                        },
                        child: TextField(
                          controller: ctrlDigit6,
                          focusNode: _focusDigit6,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                            color: isCodeVerify ? btnColor : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            if (ctrlDigit6.text.isEmpty)
                              checkInput(ctrlDigit6, _focusDigit6);
                          },
                          onChanged: (str) {
                            if (str.length == 0) {
                              FocusScope.of(context).requestFocus(_focusDigit5);
                            }
                            ctrlDigit6.selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: ctrlDigit6.text.length,
                              ),
                            );

                            sendCodeToServer(phoneNum: widget.phoneNum);
                          },
                          decoration: mInputBorder(
                            ctrl: ctrlDigit6,
                            isCodeVerify: isCodeVerify,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: mediaQuery(context).height * 0.04),
            Consumer<PhoneCodeManagement>(
              builder: (BuildContext context, value, Widget child) {
                return Text(
                  value.timerFlagVar
                      ? "${value.countDown}"
                      : "Didn't receive OTP code?",
                  style: TextStyle(color: Colors.grey),
                );
              },
            ),
            SizedBox(height: mediaQuery(context).height * 0.01),
            Consumer<PhoneCodeManagement>(
              builder: (BuildContext context, value, Widget child) {
                return value.timerFlagVar
                    ? SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          Provider.of<PhoneCodeManagement>(context,
                                  listen: false)
                              .startTimer();

                          sendingPhoneNum(args: widget.phoneNum);
                        },
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            color: btnColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
              },
            ),
            Spacer(),
            SizedBox(
              width: mediaQuery(context).height * 0.9,
              child: ElevatedButton(
                child: Text("Sign Up"),
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}

// return Scaffold(
//   body: isLoading
//       ? Center(child: CircularProgressIndicator())
//       : Container(
//           height: mediaQuery(context).height * 0.6,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.red),
//           ),
//           margin: EdgeInsets.symmetric(
//             vertical: mediaQuery(context).height * 0.2,
//             horizontal: mediaQuery(context).width * 0.05,
//           ),
//           child: Column(
//             children: [
//               Text(
//                 "OTP Verification",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(height: mediaQuery(context).height * 0.02),
//               RichText(
//                 text: TextSpan(
//                   text: "Enter OTP Code sent to:   ",
//                   style: TextStyle(color: Colors.grey),
//                   children: [
//                     TextSpan(
//                       text: "+93 787072236",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: mediaQuery(context).height * 0.02),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit1.text.isEmpty)
//                               checkInput(ctrlDigit1, _focusDigit1);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit1,
//                             focusNode: _focusDigit1,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit1.text.isEmpty)
//                                 checkInput(ctrlDigit1, _focusDigit1);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 1) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit2);
//                               }
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit1,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: mediaQuery(context).width * 0.05,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit2.text.isEmpty)
//                               checkInput(ctrlDigit2, _focusDigit2);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit2,
//                             focusNode: _focusDigit2,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit2.text.isEmpty)
//                                 checkInput(ctrlDigit2, _focusDigit2);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 1) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit3);
//                               } else if (str.length == 0) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit1);
//                               }
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit2,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: mediaQuery(context).width * 0.05,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit3.text.isEmpty)
//                               checkInput(ctrlDigit3, _focusDigit3);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit3,
//                             focusNode: _focusDigit3,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit3.text.isEmpty)
//                                 checkInput(ctrlDigit3, _focusDigit3);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 1) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit4);
//                               } else if (str.length == 0) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit2);
//                               }
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit3,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: mediaQuery(context).width * 0.05,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit4.text.isEmpty)
//                               checkInput(ctrlDigit4, _focusDigit4);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit4,
//                             focusNode: _focusDigit4,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit4.text.isEmpty)
//                                 checkInput(ctrlDigit4, _focusDigit4);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 1) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit5);
//                               } else if (str.length == 0) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit3);
//                               }
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit4,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: mediaQuery(context).width * 0.05,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit5.text.isEmpty)
//                               checkInput(ctrlDigit5, _focusDigit5);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit5,
//                             focusNode: _focusDigit5,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit5.text.isEmpty)
//                                 checkInput(ctrlDigit5, _focusDigit5);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 1) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit6);
//                               } else if (str.length == 0) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit4);
//                               }
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit5,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: mediaQuery(context).width * 0.05,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: mediaQuery(context).width * 0.08,
//                         child: GestureDetector(
//                           onDoubleTap: () {
//                             if (ctrlDigit6.text.isEmpty)
//                               checkInput(ctrlDigit6, _focusDigit6);
//                           },
//                           child: TextField(
//                             controller: ctrlDigit6,
//                             focusNode: _focusDigit6,
//                             showCursor: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             maxLengthEnforcement:
//                                 MaxLengthEnforcement.enforced,
//                             style: TextStyle(
//                               color: isCodeVerify ? btnColor : Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             onTap: () {
//                               if (ctrlDigit6.text.isEmpty)
//                                 checkInput(ctrlDigit6, _focusDigit6);
//                             },
//                             onChanged: (str) {
//                               if (str.length == 0) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_focusDigit5);
//                               }
//                               ctrlDigit6.selection =
//                                   TextSelection.fromPosition(
//                                 TextPosition(
//                                   offset: ctrlDigit6.text.length,
//                                 ),
//                               );
//
//                               sendCodeToServer(phoneNum: args);
//                             },
//                             decoration: mInputBorder(
//                               ctrl: ctrlDigit6,
//                               isCodeVerify: isCodeVerify,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
// );
