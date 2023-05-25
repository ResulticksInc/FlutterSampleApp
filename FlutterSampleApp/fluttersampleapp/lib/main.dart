import 'package:firebase_core/firebase_core.dart' if (dart.library.io) 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visioneducation/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refluttersdk/refluttersdk.dart';


void main() async{
  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
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
    _refluttersdkPlugin.initWebSDK("./sw.js");
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

