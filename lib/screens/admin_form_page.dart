import 'package:flutter/material.dart';

class AdminFormPage extends StatelessWidget {
  const AdminFormPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Admin ID')),
            TextField(decoration: const InputDecoration(labelText: 'Name')),
            TextField(decoration: const InputDecoration(labelText: 'Department')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}