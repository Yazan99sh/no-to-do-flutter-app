import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:notodo_app/model/Item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _dp;

  Future<Database> get dp async {
    if (_dp != null) {
      return _dp;
    } else {
      _dp = await initDp();
      return _dp;
    }
  }

  final String itemInfo = "itemInfo";
  final String itemName = "itemName";
  final String id = "id";
  final String itemDate = "itemDate";

  DatabaseHelper.internal();

  initDp() async {
    Directory dDirectory = await getApplicationDocumentsDirectory();
    String path = join(dDirectory.path, "NoToDo.dp");
    var ourDp = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDp;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $itemInfo ($id INTEGER PRIMARY KEY,$itemName TEXT,$itemDate TEXT)");
  }

  Future<int> saveItem(Item item) async {
    var dpClient = await dp;
    int res = await dpClient.insert("$itemInfo", item.toMap());
    return res;
  }

  Future<List> getItems() async {
    var dpClient = await dp;
    var result = await dpClient
        .rawQuery("SELECT * FROM $itemInfo ORDER BY $itemName ASC");
    return result.toList();
  }

  Future<int> getCount() async {
    var dpClient = await dp;
    var result = await dpClient.rawQuery("SELECT COUNT(*) FROM $itemInfo ");
    return Sqflite.firstIntValue(result);
  }

  Future<Item> getItem(int ids) async {
    var dpClient = await dp;
    var result = await dpClient.rawQuery(
      "SELECT * FROM $itemInfo WHERE id=$ids",
    );

    if (result.length == 0) {
      return null;
    }

      return new Item.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dpClient = await dp;
    var result =
        await dpClient.delete("$itemInfo", where: "$id=?", whereArgs: [id]);
    return result;
  }

  Future<int> updateItem(Item item) async {
    var dpClient = await dp;
    var result = await dpClient.update("$itemInfo", item.toMap(),
        where: "$id=?", whereArgs: [item.id]);
    return result;
  }

  Future close() async {
    var dpClient = await dp;
    var result = await dpClient.close();
    return result;
  }
}
