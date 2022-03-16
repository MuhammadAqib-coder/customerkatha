import 'package:flutter_doc_sqflite/models/hisab_database.dart';

class UserProfile {
  int? id;
  String name;
  String description;

  UserProfile({this.id, required this.name, required this.description});

  String get getName {
    return name;
  }

  String get getDesc {
    return description;
  }

  void set setName(String name) {
    this.name = name;
  }

  void set setDesc(String description) {
    this.description = description;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"name": name, "description": description};
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
