import 'package:flutter/material.dart';

import 'package:refluttersdk/refluttersdk.dart';
import 'dashboard.dart';
import 'mynavigator.dart';
import 'notification.dart';


class Certification extends StatefulWidget {

const Certification({Key? key}) : super(key: key);
 @override
  State<Certification> createState() => _CertificationState();
}

final _refluttersdkPlugin=Refluttersdk();

class _CertificationState extends State<Certification> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Call the system service here
    //   _refluttersdkPlugin.screentracking("CertificationPage");
    // });
    _refluttersdkPlugin.screentracking("CertificationPage");
    _locationUpdate();
 }

  _locationUpdate() async {
   _refluttersdkPlugin.locationUpdate(13.0827,80.2707);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyAppp()));
      return false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child:Scaffold(
        appBar: AppBar(

          title: Row(children: [
            Text("Page 1"),
            Container(
              color: Colors.transparent,
              child:  SizedBox(
                height: 20,
                width: 224,
              ),
            ),
            Stack(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => NotificationPage()));
                    },
                    child:Icon(Icons.notifications)
                ),
               
              ],
            )
          ],),
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,

        ),
        body: Stack(
          children: [
            Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Page1")

                ],
              )
            )
          ],
        ),
        endDrawer: MyNavigator(),
      ),

    );
  }
}
