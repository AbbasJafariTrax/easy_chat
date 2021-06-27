import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

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
  StreamSubscription<Event> addListenerVar;
  StreamSubscription<Event> editListenerVar;
  StreamSubscription<Event> deleteListenerVar;

  Map<String, dynamic> _userList = {};

  Map<String, dynamic> get userList {
    return _userList;
  }

  final DBRef = FirebaseDatabase.instance.reference().child('Users');

  Future<void> addContact({
    String userName,
    String email,
    String userId,
    bool isOnline,
  }) async {
    try {
      await DBRef.child(userId).set(
        {
          "userName": userName,
          "email": email,
          "isOnline": isOnline,
        },
      );
    } catch (e) {
      print("Mahdi: addContact: error: $e");
    }
  }

  // _tempUserList.putIfAbsent(
  //   UserModel(
  //     email: value["email"],
  //     userName: value["userName"],
  //     userId: key,
  //     isOnline: value["isOnline"],
  //   ),

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
