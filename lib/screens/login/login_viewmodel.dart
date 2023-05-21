// Dart imports:
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:stacked/stacked.dart';

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

  /// validate Phone number
  Future<void> validate() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      if (phoneNumber != null) {
        showOtp = true;
        notifyListeners();
        //loginApi();
      }
    } else {
      setAutoValidateMode(AutovalidateMode.always);
    }

    notifyListeners();
  }

  /// verify otp
  void verifyOTPApi(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeView()));

    /*final _firebaseAuth = locator<FirebaseAuthService>();
    if (smsCode.isNotNullNorBlank) {
      setBusyForObject(busyObject, true);
      final uid = await _firebaseAuth.verifyCode(smsCode);
      if (uid != null) {
        var param = {
          "code": countryCode,
          "mobile": phoneNumber,
          "otp": smsCode,
          "device_token": await NotificationService().getDeviceToken(),
          "device_type": getDeviceType()
        };
        appUser = await runBusyFuture(_apiService.verifyOtp(param: param),
            busyObject: busyObject);
        if (appUser.isNotNull) {
          appUser?.code = countryCode;
          await saveUserInPref();
          if (appUser?.isExists == false) {
            navigationService.clearStackAndShow(Routes.registrationFormView);
          } else {
            /// userType 0 --> student view
            /// others --> teacher view
            appUser?.getUserType == 0
                ? navigationService.clearStackAndShow(Routes.homeView)
                : navigationService.clearStackAndShow(Routes.homeView);
          }
        }
      }
      setBusyForObject(busyObject, false);
    }*/
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
    final _firebaseAuth = FirebaseAuthService();

    /// call function to verify phoneNumber from firebase auth service class
    await _firebaseAuth.verifyPhoneNumber(
      route: true,
      phoneNumber: "$countryCode$number",
    );

    /// code send callback
    _firebaseAuth.codeSent = () async {
      showOtp = true;
      notifyListeners();
      /*await navigationService.navigateTo(
        Routes.otpView,
        arguments: OtpViewArguments(
          phoneNumber: number,
          countryCode: countryCode,
        ),
      );
      setBusyForObject(busyObject, false);*/
    };

    _firebaseAuth.verificationFailed = (v) {
      //SmartDialog.showToast(v);
      setBusyForObject(busyObject, false);
    };
  }

  void setAutoValidateMode(AutovalidateMode mode) {
    autoValidateMode = mode;
    notifyListeners();
  }
}
