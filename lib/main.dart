import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lawyermobile/service/notifications.dart';
import 'package:lawyermobile/service/overrides.dart';
import 'package:lawyermobile/src/app_root.dart';
import 'package:lawyermobile/src/app_shared.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppShared.init();
  await NotificationService().initFCM();
  runApp(const AppRoot());
}
