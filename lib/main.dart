import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'config/config.dart';
import 'eventlist.dart';
import 'eventdetail.dart';
import 'newac.dart';

// 作成したウィジェットのインポート
import 'event_register.dart';
import 'start.dart';

const kButtonColorPrimary = Color(0xFFECEFF1);
const kButtonTextColorPrimary = Color(0xFF455A64);
const Color kAccentColor = Color(0xFFFE7C64);
const Color kBackgroundColor = Color(0xFF19283D);
const Color kTextColorPrimary = Color(0xFFECEFF1);
const Color kTextColorSecondary = Color(0xFFB0BEC5);
const Color kIconColor = Color(0xFF455A64);

final configurations = Configurations();

// void main() {
//   runApp(EventRegisterWidget());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: configurations.apiKey,
    appId: configurations.appId,
    messagingSenderId: configurations.messagingSenderId,
    projectId: configurations.projectId,
    //authDomain: configurations.authDomain,
    //storageBucket: configurations.storageBucket,
  ));
  final firebaseUser = await FirebaseAuth.instance.userChanges().first;
  runApp(MyApp());
}

class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
        create: (context) => UserState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'マネコレ',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginCheck(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ));
  }
}
