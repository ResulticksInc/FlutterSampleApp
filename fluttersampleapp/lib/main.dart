import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:visioneducation/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refluttersdk/refluttersdk.dart';
import 'notification.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(title: 'Vision Education',));
}

final _refluttersdkPlugin = Refluttersdk();
class MyApp extends StatefulWidget {
  const MyApp({Key? key, required String title}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  late SharedPreferences shared;
  late var fcmToken;

  @override
  void initState(){
    super.initState();
    _refluttersdkPlugin.initWebSDK("./firebase-messaging-sw.js");

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        resizeToAvoidBottomInset: false,
        body: MyLoginPage(),
      ),
    );
  }

}

