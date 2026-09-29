import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: SQLiteInsert()));

class SQLiteInsert extends StatefulWidget {
  const SQLiteInsert({super.key});
  @override
  State<SQLiteInsert> createState() => _SQLiteInsertState();
}

class _SQLiteInsertState extends State<SQLiteInsert> {
  final TextEditingController _nameController = TextEditingController();
  Database? _db;

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
  }

  _insertStudent() async {
    if (_db != null && _nameController.text.isNotEmpty) {
      await _db!.insert('students', {'name': _nameController.text});
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Inserted!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Insert Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Student Name")),
            ElevatedButton(onPressed: _insertStudent, child: const Text("Insert")),
          ],
        ),
      ),
    );
  }
}
