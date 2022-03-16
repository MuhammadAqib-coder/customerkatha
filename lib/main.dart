import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/variable_value_hive.dart';
import 'package:flutter_doc_sqflite/util/price_provider.dart';
import 'package:flutter_doc_sqflite/widgets/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Hive.initFlutter();
  //Hive.registerAdapter(TransactionAdapter());
  //await Hive.openBox<Transaction>("transaction");

  //Hive.registerAdapter(CustomerHisabAdapter());
  //Hive.registerAdapter(CustomerDetailListHiveAdapter());
  //Hive.registerAdapter(VariableValueAdapter());
  //await Hive.openBox<CustomerHisab>("hisab");
  //await Hive.openBox<CustomerDetailListHive>("hisabList");
  //await Hive.openBox<VariableValue>("varaibles");

  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue
    ),
    debugShowCheckedModeBanner: false,
    title: "Remainder App",
    home: Home(),
  ));
}
