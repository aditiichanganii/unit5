import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: SPUsername()));

class SPUsername extends StatefulWidget {
  const SPUsername({super.key});
  @override
  State<SPUsername> createState() => _SPUsernameState();
}

class _SPUsernameState extends State<SPUsername> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = "";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _savedName = prefs.getString('username') ?? "No name saved");
  }

  _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    _loadName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SP Username")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter Username")),
            ElevatedButton(onPressed: _saveName, child: const Text("Save")),
            Text("Saved Name: $_savedName"),
          ],
        ),
      ),
    );
  }
}
