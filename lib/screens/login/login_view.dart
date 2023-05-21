// Flutter imports:
// Project imports:

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// Package imports:
import 'package:stacked/stacked.dart';

import '../home/home_view.dart';
import '../utils/shared.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (
        BuildContext context,
        LoginViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.showOtp ? 'OTP' : 'Login',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  model.showOtp
                      ? PinCodeTextField(
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
                        )
                      : Form(
                          key: model.formKey,
                          autovalidateMode: model.autoValidateMode,
                          child: CustomFormField(
                            hintText: "Enter your mobile number",
                            onChanged: (value) {},
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return "Phone number required";
                              } else if (value?.length != 10) {
                                return "Not a valid phone number (required 10 digits)";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              model.phoneNumber = value;
                            },
                          ),
                        ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    label: "Continue",
                    width: double.infinity,
                    onPressed: () => model.showOtp ? model.verifyOTPApi(context) : model.validate(),
                    isBusy: model.busy(model.busyObject),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeView()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
