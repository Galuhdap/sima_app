import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Page')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(title: Text(items[index])),
      ),
    );
  }
}
