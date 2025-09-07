import 'package:flutter/material.dart';

class StudentFormPage extends StatelessWidget {
  const StudentFormPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Student ID')),
            TextField(decoration: const InputDecoration(labelText: 'Name')),
            TextField(decoration: const InputDecoration(labelText: 'Faculty')),
            TextField(decoration: const InputDecoration(labelText: 'Department')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}