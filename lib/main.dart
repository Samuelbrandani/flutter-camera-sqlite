import 'package:flutter/material.dart';
import 'DAO/Sqlite/DBCreator.dart';
import 'SaveImageDemoSQLite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: SaveImageDemoSQLite(),
    debugShowCheckedModeBanner: false,
  ));
}