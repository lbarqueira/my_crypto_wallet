import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/ui/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
