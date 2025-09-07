import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AftercareScreen extends StatelessWidget {
  const AftercareScreen({super.key});

  Future<void> exportEvidencePDF(BuildContext context) async {
    // Store the messenger before any async operations
    final messenger = ScaffoldMessenger.of(context);
    
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Center(child: pw.Text('Evidence Report\n\nDetails go here...')),
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/evidence_report.pdf");
    await file.writeAsBytes(await pdf.save());
    
    // Use the stored messenger instead of context
    messenger.showSnackBar(
      const SnackBar(content: Text('PDF exported to device storage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aftercare & Counseling')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Counseling Contacts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Campus Counseling Center'),
              subtitle: const Text('+60 12-345 6789'),
              onTap: () {
                // Implement call or SMS
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('National Helpline'),
              subtitle: const Text('15999'),
              onTap: () {
                // Implement call or SMS
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                exportEvidencePDF(context);
              },
              child: const Text('Export Evidence as PDF'),
            ),
          ],
        ),
      ),
    );
  }
}