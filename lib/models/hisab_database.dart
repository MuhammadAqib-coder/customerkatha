import 'package:flutter_doc_sqflite/util/user_detail.dart';
import 'package:flutter_doc_sqflite/util/user_profile.dart';
import 'package:flutter_doc_sqflite/util/varaible_state.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HisabDatabase {
  Database? _database;
  final String userProfile = "userprofile";
  final String userDetail = "userdetail";
  final String variableState = "variablestate";

  HisabDatabase._instance();
  static final HisabDatabase hisabDatabase = HisabDatabase._instance();

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDB();
      return _database!;
    }
    return _database!;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, "easyloadhisab.db"),
      version: 1,
      onCreate: createDB,
      //onUpgrade: upgradeDB
    );
    return _database!;
  }

  upgradeDB(Database db, int oldVersion, int newVersion) {}

  createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $userProfile(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
    await db.execute(
        "CREATE TABLE $userDetail(id INTEGER PRIMARY KEY, price TEXT NOT NULL, date TEXT NOT NULL, user_id INTEGER)");
    await db.execute(
        "CREATE TABLE $variableState(id INTEGER PRIMARY KEY, user_id INTEGER, total INTEGER, advance INTEGER )");
  }

  insertData(String tableName, dynamic data) async {
    Database db = await database;
    await db.insert(tableName, data.toMap());
  }

  deleteData(String tableName, int id) async {
    Database db = await database;
    await db.delete(tableName, where: "id=?", whereArgs: [id]);
  }

  updateData(String tableName, dynamic data) async {
    Database db = await database;
    await db
        .update(tableName, data.toMap(), where: "id=?", whereArgs: [data.id]);
  }

  Future<List<UserProfile>> fetchUserProfile() async {
    Database db = await database;
    final List<Map<String, dynamic>> maplist = await db.query(userProfile,
        columns: ['id', 'name', 'description'], orderBy: "name ASC");

    var list = List.generate(
        maplist.length,
        (index) => UserProfile(
            id: maplist[index]['id'],
            name: maplist[index]["name"],
            description: maplist[index]['description']));
    return list;
  }

  Future<List<UserDetail>> fetchUserDetail(int userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> mapList = await db.query(userDetail,
        columns: ['id', 'price', 'date', 'user_id'],
        where: "user_id=?",
        whereArgs: [userId],
        orderBy: "date DESC");
    var list = List.generate(
        mapList.length,
        (index) => UserDetail(
            id: mapList[index]['id'],
            userId: mapList[index]['user_id'],
            price: mapList[index]['price'],
            date: mapList[index]['date']));

    return list;
  }

  Future<VaraibleState> fetchVaraibleState(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> mapList =
        await db.query(variableState, where: "user_id=?", whereArgs: [userId]);
    // var list = List.generate(
    //     mapList.length,
    //     (index) => VaraibleState(
    //         name: name,
    //         total: mapList[index]['total'],
    //         advance: mapList[index]['advance']));

    if (mapList.isEmpty) {
      return VaraibleState(userId: userId, total: 0, advance: 0);
    } else {
      return VaraibleState(
          id: mapList[0]['id'],
          userId: mapList[0]['user_id'],
          total: mapList[0]['total'],
          advance: mapList[0]['advance']);
    }
  }

  Future<bool> userVerification(String name) async {
    Database db = await database;
    var data = await db.query(userProfile, where: "name=?", whereArgs: [name]);
    if (data.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  deleteUserDetail(int userId) async {
    Database db = await database;
    //await db.rawDelete("UPDATE $userDetail SET name=$news WHERE name LIKE $old");
    await db.delete(userDetail, where: "user_id=?", whereArgs: [userId]);
  }
}
