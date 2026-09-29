import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: DBProducts()));

class DBProducts extends StatefulWidget {
  const DBProducts({super.key});
  @override
  State<DBProducts> createState() => _DBProductsState();
}

class _DBProductsState extends State<DBProducts> {
  Database? _db;

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  _initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'products_db.db'),
      onCreate: (db, version) => db.execute("CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL)"),
      version: 1,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Products Table")),
      body: Center(child: Text(_db == null ? "Initializing DB..." : "Products Table Created")),
    );
  }
}
