import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/ui/authentication.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Wallet',
      home: Authentication(),
    );
  }
}
