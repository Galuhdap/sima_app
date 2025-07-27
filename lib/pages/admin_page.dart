import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  void _addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: items[index]);
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  items[index] = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder:
            (context, index) => ListTile(
              title: Text(items[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editItem(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(index),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
