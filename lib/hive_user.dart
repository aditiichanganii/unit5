import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MaterialApp(home: HiveUser()));
}

class HiveUser extends StatefulWidget {
  const HiveUser({super.key});
  @override
  State<HiveUser> createState() => _HiveUserState();
}

class _HiveUserState extends State<HiveUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  late Box _userBox;
  String _displayText = "";

  @override
  void initState() {
    super.initState();
    _userBox = Hive.box('userBox');
    _loadUser();
  }

  _loadUser() {
    setState(() {
      String name = _userBox.get('name', defaultValue: 'N/A');
      int age = _userBox.get('age', defaultValue: 0);
      _displayText = "Name: $name, Age: $age";
    });
  }

  _saveUser() {
    _userBox.put('name', _nameController.text);
    _userBox.put('age', int.tryParse(_ageController.text) ?? 0);
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            ElevatedButton(onPressed: _saveUser, child: const Text("Save User")),
            const SizedBox(height: 20),
            Text(_displayText, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
