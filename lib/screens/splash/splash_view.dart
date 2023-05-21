import 'package:flutter/material.dart';
import 'package:grab_it/screens/splash/splash_view_model.dart';
import 'package:stacked/stacked.dart';

import '../login/login_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Image.network(
                    'https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png')),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.cabin,
                  color: Colors.white,
                ),
                title: const Text(
                  'Google',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const LoginView()));
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                title: const Text(
                  'Phone',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const LoginView()));
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
