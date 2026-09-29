import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: SQLiteUpdate()));

class SQLiteUpdate extends StatefulWidget {
  const SQLiteUpdate({super.key});
  @override
  State<SQLiteUpdate> createState() => _SQLiteUpdateState();
}

class _SQLiteUpdateState extends State<SQLiteUpdate> {
  final TextEditingController _idController = TextEditingController();
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

  _updateStudent() async {
    if (_db != null && _idController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      await _db!.update(
        'students',
        {'name': _nameController.text},
        where: 'id = ?',
        whereArgs: [int.parse(_idController.text)],
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Update Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Student ID")),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "New Name")),
            ElevatedButton(onPressed: _updateStudent, child: const Text("Update")),
          ],
        ),
      ),
    );
  }
}
