import 'package:flutter/material.dart';
import 'app.dart';
import 'config/injector/service_locator.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupServiceLocator();
  
  runApp(const EchoApp());
}
