// Dart imports:
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:stacked/stacked.dart';
import 'package:grab_it/screens/utils/globals.dart' as globals;

import '../home/home_view.dart';
import '../utils/firebase_auth_service.dart';

class LoginViewModel extends BaseViewModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  String? phoneNumber;
  String? countryCode = "+91";
  String busyObject = "login";

  String smsCode = '';
  bool showOtp = false;

  final _firebaseAuth = FirebaseAuthService();


  /// validate Phone number
  Future<void> validate() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      if (phoneNumber != null) {
        //showOtp = true;
        //notifyListeners();
        loginApi();
      }
    } else {
      setAutoValidateMode(AutovalidateMode.always);
    }

    notifyListeners();
  }

  /// verify otp
  void verifyOTPApi(BuildContext context) async {
    if (smsCode.isNotEmpty) {
      setBusyForObject(busyObject, true);
      final uid = await _firebaseAuth.verifyCode(smsCode);
      if (uid != null) {
        globals.userMobile = phoneNumber ?? '';
        globals.uid = uid;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeView()));
      }
      setBusyForObject(busyObject, false);
    }
  }

  /// call api login
  Future<void> loginApi() async {
    setBusyForObject(busyObject, true);

    /// call function to verify phoneNumber
    _verifyPhoneNumber(
      number: phoneNumber!,
      countryCode: countryCode!,
    );
  }

  /// verify phone number function
  void _verifyPhoneNumber({
    required String number,
    required String countryCode,
  }) async {


    /// call function to verify phoneNumber from firebase auth service class
    await _firebaseAuth.verifyPhoneNumber(
      route: true,
      phoneNumber: "$countryCode$number",
    );

    /// code send callback
    _firebaseAuth.codeSent = () async {
      showOtp = true;
      setBusyForObject(busyObject, false);
      notifyListeners();
    };

    _firebaseAuth.verificationFailed = (v) {
      //SmartDialog.showToast(v);
      setBusyForObject(busyObject, false);
      notifyListeners();
    };
  }

  void setAutoValidateMode(AutovalidateMode mode) {
    autoValidateMode = mode;
    notifyListeners();
  }
}
