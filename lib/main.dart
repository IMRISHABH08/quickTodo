import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicktodo/screens/home/home.dart';

import 'db/db.dart';

final db = DB();
void main() async {
  await db.initDatabase();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[850],
    ));
    return GetMaterialApp(
      title: "Quick ToDo ",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          //primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: Home(),
    );
  }
}
