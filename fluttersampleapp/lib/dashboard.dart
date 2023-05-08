import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioneducation/mynavigator.dart';
import 'carrier.dart';
import 'certification.dart';
import 'notification.dart';
import 'package:refluttersdk/refluttersdk.dart';

final _refluttersdkPlugin = Refluttersdk();

class MyAppp extends StatefulWidget {
  const MyAppp({Key? key}) : super(key: key);

  @override
  State<MyAppp> createState() => _MyApppState();
}

class _MyApppState extends State<MyAppp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Carrier': (BuildContext ctx) => const Carrier(),
        "/Certification": (BuildContext ctx) => const Certification(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Vision Education',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home:DashboardPage(title: "vision Education"),
    );
  }
}

class DashboardPage extends StatefulWidget {
   DashboardPage({Key? key, required String title}) : super(key: key);

  @override
  State<DashboardPage> createState() => DashboardPageState();
}


class DashboardPageState extends State<DashboardPage> {

  late var navigationParameter;
  late var screenName;
  late var receivedData;
  late SharedPreferences shared;

  deeplinkHandler(){

    /*
    * App screen Navigations via link and notifications
    */
    _refluttersdkPlugin.listener((data) {

      print("Deeplink Data :: $data") ;
      Map<String, dynamic> parsedData = jsonDecode(data);
      List<dynamic> customActions = jsonDecode(parsedData['customActions']);
      setState(() {
        screenName = customActions[1]['customParams']['screenName'];
        receivedData=customActions[1]['customParams']['data'];
      });
      print("ScreenName :: $screenName");
      screenNavigator(screenName,receivedData);
    });

  }


 /**
  * APP SCREEN NAVIGATER 
  */
  screenNavigator(var screenName,var data){
    switch(screenName){

      case "Carrier":{
        if(data!=null){
          Navigator.pushNamed(context, '/Carrier',arguments: data);
        }
        else
          Navigator.pushNamed(context, '/Carrier');
        break;
      }
      case "Certification":{

        if(data!=null){
          Navigator.pushNamed(context, '/Certification',arguments: data);
        }
        else
          Navigator.pushNamed(context, '/Certification');
        break;
      }

      default:{
        print("ScreenName is not defined!!!");
      }
    }


  }


initializeSharedPreference() async {
  shared = await SharedPreferences.getInstance();
  deeplinkHandler();
}


  @override
   initState(){
    super.initState();
    initializeSharedPreference();
    _refluttersdkPlugin.screentracking("DashboardPage");
  }

  

  @override
  Widget build(BuildContext context) {

    Future<bool> _onWillPop() async {
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child:Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
          Text("Vision Education"),
         Container(
           color: Colors.transparent,
           child:  SizedBox(
             height: 20,
             width: 135,
           ),
         ),
          Stack(
            children: [
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NotificationPage()));
                  },
                  child:Icon(Icons.notifications,)
              ),
            ],
          )

        ],),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,

      ),
      body:Container(
        child: (
            SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child:Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                        height: 250,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(0.0,0.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child:Column(
                          children: [
                            Padding(
                              padding:EdgeInsets.fromLTRB(0,40,0,0),
                              child: CircleAvatar(
                                radius:40.2,
                                  backgroundColor: Colors.white,
                                  child:Icon(Icons.account_circle_outlined,size: 70,)
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.fromLTRB(0,10,0,0),
                              child:Column(
                                children: [
                                  Text("Vision User",style: TextStyle(color:Colors.white,fontSize: 20.2),),
                                 // Text(shared.getString("userId").toString(),style: TextStyle(color:Colors.white,fontSize: 20.2))
                                ],
                              )
                            )

                          ],
                        ) ,
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),

                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: () async {
                              _refluttersdkPlugin.locationUpdate(13.0827, 80.2707);
                          }, child: Text("Location update"),

                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),

                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: ()
                           {
                              var eventData = {
                                "name": "payment",
                                "data": {"id": "6744", "price": "477"}
                              };
                              _refluttersdkPlugin.customEventWithData(eventData);

                          }, child: Text("Custom event"),

                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),
                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: () {
                            _refluttersdkPlugin.appConversion();
                          }, child: Text("App conversation tracking"),

                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),
                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: () async {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const Certification()));
                          }, child: Text("Page 1"),

                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),

                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: () async {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const Carrier()));
                          }, child: Text("Page 2"),

                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.fromLTRB(20,10,20,10),
                        child: Container(
                          width: double.maxFinite,
                          child: ElevatedButton(onPressed: () async {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const NotificationPage()));
                          }, child: Text("Notification list"),

                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
        ),
      ),

     endDrawer: MyNavigator()

    ),
    );
  }
}

















