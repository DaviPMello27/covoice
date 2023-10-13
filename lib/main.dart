import 'package:covoice/database/covoice_database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'views/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CovoiceDatabase.initDatabase();
  runApp(const AppWidget());
}
