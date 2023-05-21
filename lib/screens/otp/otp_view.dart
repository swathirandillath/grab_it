// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// Package imports:
import 'package:stacked/stacked.dart';

import '../utils/shared.dart';
import 'otp_viewmodel.dart';

// Project imports:

class OtpView extends StatelessWidget {
  const OtpView({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
  }) : super(key: key);

  final String phoneNumber;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
      viewModelBuilder: () => OtpViewModel(phoneNumber, countryCode),
      builder: (
        BuildContext context,
        OtpViewModel model,
        Widget? child,
      ) {
        var screenSize = MediaQuery.of(context).size;
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Enter OTP send to $countryCode $phoneNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.scale,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinTheme: PinTheme(
                    fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    activeFillColor: Colors.white,
                    activeColor: Colors.black,
                    inactiveColor: Colors.black,
                    disabledColor: Colors.black,
                    selectedColor: Colors.black,
                    fieldHeight: 45,
                    fieldWidth: 45,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    print('onCompleted $value');
                    model.smsCode = value;
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return true;
                  },
                ),
                SizedBox(height: 30),
                PrimaryButton(
                  width: double.infinity,
                  label: "Continue",
                  onPressed: () => model.validate(),
                  isBusy: model.busy(model.busyObject),
                ),
                SizedBox(height: 30),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: "Resend code in ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: "10 Seconds",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
