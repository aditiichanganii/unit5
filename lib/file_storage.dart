import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MaterialApp(home: FileStorage()));

class FileStorage extends StatefulWidget {
  const FileStorage({super.key});
  @override
  State<FileStorage> createState() => _FileStorageState();
}

class _FileStorageState extends State<FileStorage> {
  final TextEditingController _controller = TextEditingController();
  String _fileContent = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  _writeToFile() async {
    final file = await _localFile;
    await file.writeAsString(_controller.text);
    _readFromFile();
  }

  _readFromFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      setState(() => _fileContent = contents);
    } catch (e) {
      setState(() => _fileContent = "Error reading file");
    }
  }

  @override
  void initState() {
    super.initState();
    _readFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Storage")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter text")),
            ElevatedButton(onPressed: _writeToFile, child: const Text("Write to File")),
            const SizedBox(height: 20),
            Text("File Content: $_fileContent"),
          ],
        ),
      ),
    );
  }
}
