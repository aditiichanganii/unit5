import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: SQLiteDisplay()));

class SQLiteDisplay extends StatefulWidget {
  const SQLiteDisplay({super.key});
  @override
  State<SQLiteDisplay> createState() => _SQLiteDisplayState();
}

class _SQLiteDisplayState extends State<SQLiteDisplay> {
  Database? _db;
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  _initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'students_db.db'),
      onCreate: (db, version) => db.execute("CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"),
      version: 1,
    );
    _refreshStudents();
  }

  _refreshStudents() async {
    if (_db != null) {
      final data = await _db!.query('students');
      setState(() => _students = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Display Students")),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(_students[i]['name']),
          subtitle: Text("ID: ${_students[i]['id']}"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshStudents,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
