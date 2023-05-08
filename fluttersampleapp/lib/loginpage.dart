import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:refluttersdk/refluttersdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

final _refluttersdkPlugin = Refluttersdk();

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var fcmToken = null;
  late var navigationParameter;
  late String userId;
  late String userPassword;
  late SharedPreferences shared;
  late bool isLogin;

  bool userIDfieldSufixAlert = false;
  bool userpassfieldSufixAert = false;
  bool uIdfildAlertText = false;
  bool userpasswordfieldAlertText = false;

  final userId_controller = TextEditingController();

  final userPassword_contoller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // FCM
    Firebase.initializeApp();

    initializeSharedPreference();
    // Screen Tracking
    _refluttersdkPlugin.screentracking("LoginPage");
  }

  initializeSharedPreference() async {
    shared = await SharedPreferences.getInstance();
    setState(() {
      userId = shared.getString("userId").toString();
    });

    // Getting FCM Token
    FirebaseMessaging.instance.getToken().then((newToken) {
      print("FCM token: $newToken ");
      shared.setString("fcmToken", newToken!);
      setState(() {
        fcmToken = newToken;
      });

    });

    // User Login validations
    isLoggedIn();

  }

// Login Validations
  void isLoggedIn() async {
    isLogin = (shared.getBool('login') ?? false);

    if (isLogin) {
      /*
        * Post Login => User Register
        */
      setState(() {
        userId = shared.getString("userId").toString();
        fcmToken = shared.getString("fcmToken").toString();
      });

      onResulticksUserRegister();

      // Navigate to Dashboard
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyAppp()));
    } else {
      /*
       * Pre Login => Update FCM token
       */
      updatePushToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      //Navigator.of(context).pop;
      return true;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: (Column(
                        children: <Widget>[
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                    child: Text(
                                      "VISION EDUCATION",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 225, 10, 100),
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                                  color: Colors.deepPurple,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: TextField(
                                          onTap: () {
                                            setState(() {
                                              userIDfieldSufixAlert = false;
                                              userIDfieldSufixAlert = false;
                                            });
                                          },
                                          controller: userId_controller,
                                          style: TextStyle(color: Colors.white),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(),
                                              errorText: userIDfieldSufixAlert
                                                  ? "Enter valid input"
                                                  : null,
                                              hintText: 'Email',
                                              prefixIcon: Icon(
                                                  Icons.mail_outline_sharp,
                                                  color: Colors.white),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              suffixIcon: userIDfieldSufixAlert
                                                  ? Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    )
                                                  : null,
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: TextField(
                                          onTap: () {
                                            setState(() {
                                              userpassfieldSufixAert = false;
                                              userpasswordfieldAlertText =
                                                  false;
                                            });
                                          },
                                          controller: userPassword_contoller,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(),
                                            errorText: userpassfieldSufixAert
                                                ? "Enter valid password"
                                                : null,
                                            hintText: 'Password',
                                            prefixIcon: Icon(Icons.lock_outline,
                                                color: Colors.white),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.white,
                                            )),
                                            suffixIcon: userpassfieldSufixAert
                                                ? Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  )
                                                : null,
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 7, 220, 15),
                                        child: Text("Forget password?",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 7, 10, 0),
                                        child: SizedBox(
                                          height: 50,
                                          //height of button
                                          width: double.infinity,
                                          //width of button equal to parent widget
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(
                                                      10) //content padding inside button
                                                  ),
                                              onPressed: () {
                                               loginValidation();
                                              },
                                              child: Text("LOG IN",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0))),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(90, 720, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Don`t have an account? ",
                                              style: TextStyle(
                                                color: Colors.indigo,
                                              )),
                                          GestureDetector(
                                            child: Text("Create one",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      )),
                    )
                  ],
                )),
          ),
        ));
  }


  loginValidation()
  {
     // Reading the values from the UI
     setState(() {
      userId =
          userId_controller.text;
      userPassword =
          userPassword_contoller
              .text;
    });

     // User Id Validation
     if (userId.length == 0) {
       setState(() {
         userIDfieldSufixAlert =  true;
       });
       return;
     }
     // Password Validation
     if (userPassword.length == 0) {
        setState(() {
         userpassfieldSufixAert = true;
        });
        return ;
     }

     // Data stored
     shared.setString("userId", userId);
     shared.setBool("login", true);

     // Resulticks User register
     onResulticksUserRegister();

     // Navigate to Dashboard
     Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => const MyAppp()));
    }


  updatePushToken() {

    if(fcmToken != null)
      {
        _refluttersdkPlugin.updatePushToken(fcmToken);
       } else {
      // Getting FCM Token
      FirebaseMessaging.instance.getToken().then((newToken) {
        print("FCM token: $newToken ");
        shared.setString("fcmToken", newToken!);
        setState(() {
          fcmToken = newToken;
        });
        _refluttersdkPlugin.updatePushToken(fcmToken);
      });

     }

  }

  onResulticksUserRegister() {
    Map userData = {
      "userUniqueId": userId,
      // * unique id could be email id, mobile no, or BrandID defined id like Customer hash, PAN number
      "name": "",
      "age": "",
      "email": "",
      "phone": "",
      "gender": "",
      "profileUrl": "",
      "dob": "",
      "education": "",
      "employed": true,
      "married": false,
      "deviceToken": fcmToken,
      // * FCM Token
    };
    _refluttersdkPlugin.sdkRegisteration(userData);
  }
}
