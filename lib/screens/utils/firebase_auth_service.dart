// Flutter imports:
// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Project imports:

class FirebaseAuthService {
  static final FirebaseAuthService _singleton = FirebaseAuthService._internal();
  factory FirebaseAuthService() {
    return _singleton;
  }
  FirebaseAuthService._internal();

  late VoidCallback codeSent;
  Function(String)? verificationFailed;

  //late Function codeAutoRetrievalTimeout;
  String? _verificationId;
  int? currentResendToken;
  UserCredential? _userCredential;
  String? _uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // verify verify PhoneNumber and resend otp
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required bool route,
  }) async {
    await _auth.verifyPhoneNumber(
      //By default, the device waits for 30 seconds however this can be customized with the timeout argument, Max 2 min
      //Once the timeframe has passed, the device will no longer attempt to resolve any incoming messages.
      timeout: const Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        _uid = null; // to remove any value already present
        print("verificationCompleted $credential");
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        try {
          _userCredential = await _auth.signInWithCredential(credential);
          print('signInWithCredential $_userCredential');
          if (_userCredential?.user?.uid != null) {
            print("Firebase uid : ${_userCredential?.user?.uid}");
            _uid = _userCredential?.user?.uid;
          }
        } on FirebaseAuthException catch (error) {
          print('FirebaseAuthException =>  ${error.message}');
          return;
        }
      },
      verificationFailed: (FirebaseAuthException error) {
        print('verificationFailed Code: ${error.code} : $error');
        if (error.code == 'invalid-phone-number') {
          verificationFailed?.call('The provided phone number is not valid.');
        } else {
          // Handle other errors
          verificationFailed?.call(
            error.message ?? 'Something went wrong, Please try again later.',
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        /// A resendToken is only supported on Android devices, iOS devices will always return a null value
        _verificationId = verificationId;
        currentResendToken = resendToken;
        print(
          'codeSent verificationId $verificationId resendToken $resendToken',
        );
        if (route == true) {
          codeSent.call();
        }
      },
      //Android devices which support automatic SMS code resolution
      //called if the device has not automatically resolved an SMS message within a certain timeframe [timeout]
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        print('codeAutoRetrievalTimeout verificationId $verificationId');
      },
      //By default, Firebase will not re-send a new SMS message if it has been recently sent.
      // You can however override this behavior by re-calling the verifyPhoneNumber method with the
      // resend token to the forceResendingToken argument. If successful, the SMS message will be resent.
      forceResendingToken: currentResendToken,
    );
  }

  // verify otp
  Future<String?> verifyCode(String smsCode) async {
    if (_uid != null) {
      print('Firebase uid  : $_uid');
      return _uid;
    }
    if (_verificationId != null) {
      print('SmsCode : $smsCode');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      try {
        var user = await _auth.signInWithCredential(credential);
        print('signInWithCredential $user');
        if (user.user?.uid != null) {
          print("Firebase uid : ${user.user?.uid}");
          return user.user?.uid;
        }
      } on FirebaseAuthException catch (error) {
        /*
        * **account-exists-with-different-credential**:
         --- Thrown if there already exists an account with the email address asserted by the credential. Resolve this by calling fetchSignInMethodsForEmail and then asking the user to sign in using one of the returned providers. Once the user is signed in, the original credential can be linked to the user with linkWithCredential.
        **invalid-credential**:
         --- Thrown if the credential is malformed or has expired.
        **operation-not-allowed**:
         --- Thrown if the type of account corresponding to the credential is not enabled. Enable the account type in the Firebase Console, under the Auth tab.
        **user-disabled**:
         --- Thrown if the user corresponding to the given credential has been disabled.
        **user-not-found**:
         --- Thrown if signing in with a credential from EmailAuthProvider.credential and there is no user corresponding to the given email.
        **wrong-password**:
         --- Thrown if signing in with a credential from EmailAuthProvider.credential and the password is invalid for the given email, or if the account corresponding to the email does not have a password set.
        **invalid-verification-code**:
         --- Thrown if the credential is a PhoneAuthProvider.credential and the verification code of the credential is not valid.
        **invalid-verification-id**:
         --- Thrown if the credential is a PhoneAuthProvider.credential and the verification ID of the credential is not valid.id.
        * */
        if (error.code == 'invalid-verification-code') {
          //SmartDialog.showToast('Invalid OTP');
        } else {
          print('FirebaseAuthException =>  ${error.message}');
          //SmartDialog.showToast('${error.message}');
          return null;
        }
      }
      return null;
    }
    return null;
  }
}
