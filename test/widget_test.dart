// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codenection_2025/screens/gate_ocr_page.dart';
import 'package:camera/camera.dart';

void main() {
  testWidgets('GateOCRPage shows AppBar title', (WidgetTester tester) async {
    // Create a fake CameraDescription for testing
    final camera = CameraDescription(
      name: 'TestCam',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0,
    );

    await tester.pumpWidget(MaterialApp(
      home: GateOCRPage(camera: camera),
    ));

    // Check for AppBar title
    expect(find.text('Gate OCR (PoC)'), findsOneWidget);
  });
}
