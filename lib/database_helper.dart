import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'item_model.dart';

class DatabaseHelper {
  static const int _version = 2;
  static const String _name = "Inventory.db";
  static const migrations = [
    {
      "name": "1",
      "quantity": 10,
      "amount": 1,
    },
    {
      "name": "2",
      "quantity": 2,
      "amount": 2,
    },
    {
      "name": "5",
      "quantity": 5,
      "amount": 5,
    },
    {
      "name": "10",
      "quantity": 10,
      "amount": 10,
    },
    {
      "name": "20",
      "quantity": 0,
      "amount": 20,
    },
    {
      "name": "50",
      "quantity": 0,
      "amount": 50,
    },
    {
      "name": "100",
      "quantity": 0,
      "amount": 100,
    },
    {
      "name": "200",
      "quantity": 0,
      "amount": 200,
    },
    {
      "name": "500",
      "quantity": 0,
      "amount": 500,
    },
    {
      "name": "2000",
      "quantity": 0,
      "amount": 2000,
    },
    {
      "name": "paytm",
      "quantity": 0,
      "amount": 0,
    },
    {
      "name": "uco",
      "quantity": 0,
      "amount": 0,
    },
    {
      "name": "sbi",
      "quantity": 0,
      "amount": 0,
    },
  ];
  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _name),
        onCreate: (db, version) async {
      db.execute(
          "CREATE TABLE Inventory(id INTEGER PRIMARY KEY, name TEXT, category TEXT, image TEXT, givenAway INTEGER)");
      db.execute(
          "CREATE TABLE Money(id INTEGER PRIMARY KEY, name TEXT, quantity INT, amount REAL)");
      for (var i = 0; i < migrations.length; i++) {
        await db.insert("Money", migrations[i]);
      }
    }, onUpgrade: (db, oldVersion, newVersion) async {
      db.execute(
          "CREATE TABLE Money(id INTEGER PRIMARY KEY, name TEXT, quantity INT, amount REAL)");
      for (var i = 0; i < migrations.length; i++) {
        await db.insert("Money", migrations[i]);
      }
    }, version: _version);
  }

  static Future<int> insert(InventoryItem item) async {
    Database db = await _getDB();

    return db.insert("Inventory", item.toJson());
  }

  static Future<List<InventoryItem>> retrieveItems() async {
    Database db = await _getDB();
    List<Map<String, dynamic>> json = await db.query("Inventory");
    List<InventoryItem> x = List.generate(json.length, (index) {
      return InventoryItem.fromJson(json[index]);
    });

    return x;
  }

  static Future<int> delete(InventoryItem item) async {
    Database db = await _getDB();
    return db.delete("Inventory", where: "id = ?", whereArgs: [item.id]);
  }

  static Future<int> update(InventoryItem item) async {
    Database db = await _getDB();
    return db.update("Inventory", item.toJson(),
        where: "id = ?", whereArgs: [item.id]);
  }

  static Future<MoneyItem> retrieveMoney(String item) async {
    Database db = await _getDB();
    List<Map<String, dynamic>> json = await db.query("Money",
        columns: ["id", "name", "quantity", "amount"],
        where: "name = ?",
        whereArgs: [item]);
    List<MoneyItem> x = List.generate(json.length, (index) {
      return MoneyItem.fromJson(json[index]);
    });

    return x[0];
  }

  static Future<int> updateMoney(MoneyItem item) async {
    Database db = await _getDB();
    return db.update("Money", item.toJson(),
        where: "name = ?", whereArgs: [item.name]);
  }
}
