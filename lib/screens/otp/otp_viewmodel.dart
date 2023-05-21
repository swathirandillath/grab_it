// Flutter imports:

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:

class OtpViewModel extends BaseViewModel {
  OtpViewModel(this.phoneNumber, this.countryCode);

  final String phoneNumber;
  final String countryCode;
  String smsCode = '';
  String busyObject = "otp";

  /// validate otp
  Future<void> validate() async {
    if (smsCode.isNotEmpty && smsCode.length == 6) {
      verifyOTPApi();
    } else {
      // SmartDialog.showToast('Enter a valid OTP');
    }
  }

  /// verify otp
  void verifyOTPApi() async {
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
}
