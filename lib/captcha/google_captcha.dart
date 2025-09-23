import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/recaptcha_v2.dart';

class GoogleCaptcha extends StatelessWidget {
  final void Function(bool isVerified) onVerified;

  const GoogleCaptcha({Key? key, required this.onVerified}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecaptchaV2(
      apiKey: 'YOUR_SITE_KEY',
      apiSecret: 'YOUR_SECRET_KEY',
      onVerifiedSuccessfully: (success) {
        onVerified(success);
      },
      onVerifiedError: (err) {
        onVerified(false);
      },
    );
  }
}
