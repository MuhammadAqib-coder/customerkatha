import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';

class CustomerList {
  final int key;
  final CustomerDetailListHive value;

  CustomerList({required this.key, required this.value});

  int get getKey {
    return key;
  }

  CustomerDetailListHive get getValue {
    return value;
  }
}
