import 'package:covoice/database/covoice_database.dart';
import 'package:covoice/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'views/app_widget.dart';

//TODO: Remove from production
Future testCode() async {
  //Map<String, List<Exercise>> list = await Exercise.findAllGroupByModule();
  print('executed test code');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //databaseFactory.deleteDatabase('${await getDatabasesPath()}/covoice_database.db');
  CovoiceDatabase.initDatabase();
  await testCode();
  runApp(const AppWidget());
}
