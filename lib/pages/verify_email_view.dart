import 'package:flutter/material.dart';
import 'package:remind_me/routes.dart';
import 'package:remind_me/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                  "We've sent you an email verification. Please open it to verify your account"),
              const Text(
                  "If you haven't received email yet, press the button below"),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text('Send email verification'),
              ),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Restart'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
