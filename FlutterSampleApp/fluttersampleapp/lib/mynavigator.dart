import 'package:flutter/material.dart';
import 'package:refluttersdk/refluttersdk.dart';
import 'package:visioneducation/carrier.dart';
import 'package:visioneducation/dashboard.dart';
import 'package:visioneducation/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'certification.dart';



class MyNavigator extends StatefulWidget {
  const MyNavigator({Key? key}) : super(key: key);

  @override
  State<MyNavigator> createState() => _MyNavigatorState();
}

final _refluttersdkPlugin=Refluttersdk();
class _MyNavigatorState extends State<MyNavigator> {

  late SharedPreferences logindata;
  late String username;


  var logButtonStatus=false;
  var unreadNotificationcount=0;

  setUnreadNotificationCount() async {
    var count= await _refluttersdkPlugin.getUnReadNotificationCount();
    setState(() {
      unreadNotificationcount=count!;
    });
  }

@override
void initState() {
    // TODO: implement initState
    super.initState();
    initializeSharedPreference();
    setUnreadNotificationCount();
  }
  initializeSharedPreference()async{
  logindata=await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {

    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
             UserAccountsDrawerHeader(accountName: Text("VisionUser"), accountEmail: Text(""),
             currentAccountPicture: CircleAvatar(
               radius:2.5,
                 backgroundColor: Colors.white,
                 child:Icon(Icons.account_circle_outlined,size: 60,)
             ),

              ),

          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardPage(title: 'VisionEducation',)));
            },
          ),

          
          ListTile(
            title: const Text('Page 1'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Certification()));
            },
          ),
          ListTile(
            
            title: const Text('Page 2'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Carrier()));
            },
          ),
          ListTile(
           
            title: Text("Logout"),
            onTap: () {
              setLogOUt();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MyLoginPage()));

            },
          ),
        ],
      ),
    );
  }
  setLogOUt(){
    logindata.setBool('login',false);
  }
}