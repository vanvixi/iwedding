import 'package:jaspr/browser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding/app.dart';
import 'package:wedding/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App());
}
