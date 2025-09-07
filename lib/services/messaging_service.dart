import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final _fcm = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Request permissions (iOS)
    await _fcm.requestPermission();
    await _fcm.getToken(); // No unused variable warning
  }

  // Listen for foreground messages
  void listenToMessages(Function(RemoteMessage) onMessage) {
    FirebaseMessaging.onMessage.listen(onMessage);
  }
}