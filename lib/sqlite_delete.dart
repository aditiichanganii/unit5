import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(const MaterialApp(home: SQLiteDelete()));

class SQLiteDelete extends StatefulWidget {
  const SQLiteDelete({super.key});
  @override
  State<SQLiteDelete> createState() => _SQLiteDeleteState();
}

class _SQLiteDeleteState extends State<SQLiteDelete> {
  final TextEditingController _idController = TextEditingController();
  Database? _db;

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  _initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'students_db.db'),
      version: 1,
    );
  }

  _deleteStudent() async {
    if (_db != null && _idController.text.isNotEmpty) {
      await _db!.delete(
        'students',
        where: 'id = ?',
        whereArgs: [int.parse(_idController.text)],
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Delete Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Student ID to Delete")),
            ElevatedButton(onPressed: _deleteStudent, child: const Text("Delete")),
          ],
        ),
      ),
    );
  }
}
