import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/widgets/customer_detail_list.dart';
import 'package:flutter_doc_sqflite/widgets/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  //Hive.registerAdapter(TransactionAdapter());
  //await Hive.openBox<Transaction>("transaction");

  Hive.registerAdapter(CustomerHisabAdapter());
  Hive.registerAdapter(CustomerDetailListHiveAdapter());
  await Hive.openBox<CustomerHisab>("hisab");
  await Hive.openBox<CustomerDetailListHive>("hisabList");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Remainder App",
    home: Home(),
  ));
}
