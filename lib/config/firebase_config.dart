import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.i('Handling background message: ${message.messageId}');
}

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    try {
      logger.i('Initializing Firebase...');

      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        logger.i('Firebase already initialized');
        return;
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      logger.i('Firebase initialized successfully');

      // Initialize FCM
      _initializeFCM();
    } catch (e) {
      logger.e('Error initializing Firebase: $e');
      // Don't rethrow - this allows app to continue
    }
  }

  static void _initializeFCM() {
    try {
      logger.i('Initializing FCM...');

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.i('Received foreground message: ${message.messageId}');
        if (message.notification != null) {
          logger.i('Title: ${message.notification?.title}');
          logger.i('Body: ${message.notification?.body}');
        }
      });

      // Handle terminated app messages
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          logger.i('App launched from notification: ${message.messageId}');
        }
      });

      logger.i('FCM initialized successfully');
    } catch (e) {
      logger.e('Error initializing FCM: $e');
    }
  }
}


