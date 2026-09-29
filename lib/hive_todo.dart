import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  runApp(const MaterialApp(home: HiveTodo()));
}

class HiveTodo extends StatefulWidget {
  const HiveTodo({super.key});
  @override
  State<HiveTodo> createState() => _HiveTodoState();
}

class _HiveTodoState extends State<HiveTodo> {
  final TextEditingController _controller = TextEditingController();
  late Box _todoBox;
  String _savedNote = "";

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box('todoBox');
    _loadNote();
  }

  _loadNote() {
    setState(() {
      _savedNote = _todoBox.get('note', defaultValue: 'No Note Saved');
    });
  }

  _saveNote() {
    _todoBox.put('note', _controller.text);
    _loadNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive To-Do Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter To-Do Note")),
            ElevatedButton(onPressed: _saveNote, child: const Text("Save Note")),
            const SizedBox(height: 20),
            Text("Saved Note: $_savedNote", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
