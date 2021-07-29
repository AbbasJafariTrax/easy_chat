import 'dart:async';

import 'package:flutter/foundation.dart';

class PhoneCodeManagement extends ChangeNotifier {
  bool _isSendingClicked = false;
  bool _timerFlagVar = false;
  Timer _timer = Timer(Duration.zero, () {});

  bool get isSendingClicked {
    return _isSendingClicked;
  }

  bool get timerFlagVar {
    return _timerFlagVar;
  }

  void setIsSendingClicked(bool status) {
    _isSendingClicked = status;
    notifyListeners();
  }

  // bool _timerFlag = false;
  //
  // bool get timerFlag {
  //   return _timerFlag;
  // }
  //
  // void setTimerFlag(bool status) {
  //   _timerFlag = status;
  //   notifyListeners();
  // }

  int _countDown = 60;

  int get countDown {
    return _countDown;
  }

  void startTimer() {
    _timerFlagVar = true;
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_countDown == 0) {
          timer.cancel();
          _timerFlagVar = false;
          _countDown = 60;
          setIsSendingClicked(false);
          notifyListeners();
        } else {
          _countDown--;
          notifyListeners();
        }
      },
    );
  }

  void stopTimer() {
    _timerFlagVar = false;
    _timer.cancel();
  }

  void setCountDown(int mCountDown) {
    _countDown = mCountDown;
    notifyListeners();
  }
}
