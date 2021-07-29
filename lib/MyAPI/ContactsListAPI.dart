import 'dart:async';

import 'package:easy_chat/Const/SharedPrefsKeys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String userId;
  String userName;
  String email;
  bool isOnline;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.isOnline,
  });
}

class ContactsList extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  StreamSubscription<Event> addListenerVar;
  StreamSubscription<Event> editListenerVar;
  StreamSubscription<Event> deleteListenerVar;

  Map<String, dynamic> _userList = {};

  Map<String, dynamic> get userList {
    return _userList;
  }

  final DBRef = FirebaseDatabase.instance.reference().child('Users');

  Future<DataSnapshot> getUserProfile({String phoneNum}) async {
    try {
      print("Mahdi: getUserProfile $phoneNum");
      print("Mahdi: getUserProfile ${DBRef.child(phoneNum).get()}");
      return DBRef.child(phoneNum).get();
    } catch (e) {
      print("Mahdi: getUserProfile: error $e");
      return null;
    }
  }

  Future<void> addContact({
    String userName,
    bool isOnline,
    String phoneNum,
    String uId,
  }) async {
    try {
      final SharedPreferences prefs = await _prefs;

      await DBRef.child(phoneNum).get().then((value) async {
        print("Mahdi: addContact: get: ${value.value}");
        if (value.value == null) {
          await DBRef.child(phoneNum).set(
            {
              "userName": userName,
              "isOnline": isOnline,
              "isInVisible": "true",
              "Phone Number": phoneNum,
              "uId": uId,
            },
          );
          prefs.setString(PHONE_NUMBER_KEY, phoneNum);
        } else {
          await DBRef.child(phoneNum).set(
            {
              "userName": value.value["userName"],
              "isOnline": isOnline,
              "isInVisible": value.value["isInVisible"],
              "Phone Number": value.value["Phone Number"],
              "uId": uId,
            },
          );
          prefs.setString(PHONE_NUMBER_KEY, phoneNum);
        }
      });
    } catch (e) {
      print("Mahdi: addContact: error: $e");
    }
  }

  Future<void> saveProfile({
    String userName,
    bool isOnline,
    bool isInVisible,
    String phoneNum,
    String uId,
  }) async {
    try {
      final SharedPreferences prefs = await _prefs;

      print("Mahdi: saveProfile: ");

      await DBRef.child(phoneNum).set(
        {
          "userName": userName,
          "isOnline": isOnline,
          "isInVisible": isInVisible,
          "Phone Number": phoneNum,
          "uId": uId,
        },
      );
      prefs.setString(PHONE_NUMBER_KEY, phoneNum);
    } catch (e) {
      print("Mahdi: saveProfile: error: $e");
    }
  }

  Future<void> getAllContacts() async {
    try {
      Map<String, dynamic> _tempUserList = {};

      await DBRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          _tempUserList.putIfAbsent(
              key,
              () => {
                    "email": value["email"],
                    "userName": value["userName"],
                    "isOnline": value["isOnline"],
                    "uId": value["uId"],
                  });
        });
      });
      _userList = _tempUserList;
      print("Mahdi: getAllContacts: $_tempUserList");
      notifyListeners();
    } catch (e) {
      print("Mahdi: getAllContacts: error: $e");
    }
  }

  void contactAddListener() {
    try {
      addListenerVar = DBRef.limitToFirst(1).onChildAdded.listen((event) {
        print(
            "Mahdi: contactAddListener ${event.snapshot.key} : ${event.snapshot.value}");
        _userList.putIfAbsent(
            event.snapshot.key,
            () => {
                  "email": event.snapshot.value["email"],
                  "userName": event.snapshot.value["userName"],
                  "isOnline": event.snapshot.value["isOnline"],
                  "uId": event.snapshot.value["uId"],
                });
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: contactAddListener: error: $e");
    }
  }

  void contactEditListener() {
    try {
      editListenerVar = DBRef.limitToFirst(1).onChildChanged.listen((event) {
        print(
            "Mahdi: contactEditListener ${event.snapshot.key} : ${event.snapshot.value}");
        _userList[event.snapshot.key] = {
          "email": event.snapshot.value["email"],
          "userName": event.snapshot.value["userName"],
          "isOnline": event.snapshot.value["isOnline"],
          "uId": event.snapshot.value["uId"],
        };
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: contactEditListener: error: $e");
    }
  }

  // void contactDeleteListener() {
  //   try {
  //     deleteListenerVar = DBRef.limitToFirst(1).onChildRemoved.listen((event) {
  //       print(
  //           "Mahdi: contactDeleteListener ${event.snapshot.key} : ${event.snapshot.value}");
  //       _userList.remove(event.snapshot.key);
  //       // _userList.removeWhere((element) {
  //       //   return element.userId == event.snapshot.key;
  //       // });
  //       notifyListeners();
  //     });
  //   } catch (e) {
  //     print("Mahdi: contactDeleteListener: error: $e");
  //   }
  // }

  void disposeAllListener() {
    addListenerVar.cancel();
    editListenerVar.cancel();
    deleteListenerVar.cancel();
    notifyListeners();
  }
}
