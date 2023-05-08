import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:refluttersdk/refluttersdk.dart';
import 'dashboard.dart';
import 'mynavigator.dart';
import 'notification.dart';


class PostGraduation extends StatefulWidget {
  const PostGraduation({Key? key}) : super(key: key);

  @override
  State<PostGraduation> createState() => _PostGraduationState();
}

final _refluttersdkPlugin=Refluttersdk();
class _PostGraduationState extends State<PostGraduation> {
  var unreadNotificationcount=0;
  setUnreadNotificationCount() async{
    var count= await _refluttersdkPlugin.getUnReadNotificationCount();
    setState(() {
      unreadNotificationcount=count!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refluttersdkPlugin.screentracking("PostGraduationPage");
    appconversionTracking();
    setUnreadNotificationCount();
    getReadNotificationCount();

  }

  appconversionTracking() {
    _refluttersdkPlugin.appConversion();
  }

  getReadNotificationCount() async {
    var rnCount=await _refluttersdkPlugin.getReadNotificationCount();
    print("ReadNotificationCount :: $rnCount");
  }

  getunReadNotificationCount() async {
    var urnCount=await _refluttersdkPlugin.getUnReadNotificationCount();
    print("unReadNotificationCount :: $urnCount");
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
          automaticallyImplyLeading: false,
          title:Row(children: [
            Text("Post Graduation"),
            Container(
              color: Colors.transparent,
              child:  SizedBox(
                height: 20,
                width: 140,
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
                unreadNotificationcount>0? Positioned(
                  top: 1,
                  right: 2,
                  left: 9,
                  child: Container(
                    height: 13,
                    width: 20,
                    decoration: BoxDecoration(color: unreadNotificationcount>0 ? Colors.redAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget>[
                        Text("${unreadNotificationcount}",style: TextStyle(fontSize: 10.0),),
                      ],
                    ),
                  ),
                ):Container(),
              ],
            )
          ],),
          backgroundColor: Colors.indigo,
        ),
        body: Stack(
          children: [
            Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset(
                'assets/postGraduate.png',
                height:70,
                width: 70,
              ),

                ],
              ),
            )
          ],
        ),
        endDrawer: MyNavigator(),
      ),

    );
  }
}
