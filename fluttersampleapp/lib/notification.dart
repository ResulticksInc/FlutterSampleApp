import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:refluttersdk/refluttersdk.dart';
import 'dashboard.dart';
import 'mynavigator.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}
final _refluttersdkPlugin=Refluttersdk();
class _NotificationPageState extends State<NotificationPage> {
  

  List notifyList=[];
  int selectedIndex = -1;
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
    _refluttersdkPlugin.screentracking("Notification Page");
    NotificationDataClass.nCount=0;

    getNotificationList();
    setUnreadNotificationCount();
  }
  getNotificationList()  async {
    var nList=await _refluttersdkPlugin.getNotificationList();
    List<dynamic> jsonArray = json.decode(nList);
    notifyList = jsonArray;
  
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
            Text("Notification"),
            Container(
              color: Colors.transparent,
              child:  SizedBox(
                height: 20,
                width: 170,
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
      body: Scaffold(
        body: ListView.builder(
          itemCount: notifyList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index)=>Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            child:GestureDetector(
              onTap: (){
                setState(() {
                  selectedIndex=index;

                });
                _refluttersdkPlugin.readNotification(notifyList[index]["nameValuePairs"]["campaignId"]);
                
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  //color: selectedIndex==index ? Colors.white70:Colors.white,
                  color:Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.0,0.0), // shadow direction: bottom right
                    ),
                  ],
                ),
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 55.0,
                            height:40.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              // foregroundColor: Colors.green,
                              child: Image.asset("assets/notification-bell.png",color:Colors.blue,height: 25,width: 25,),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notifyList[index]['nameValuePairs']['title'],style:TextStyle(color: Colors.black,fontSize:18.0,fontWeight: FontWeight.bold)),
                              Expanded(


                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(notifyList[index]['nameValuePairs']['body'],style:TextStyle(color: Colors.grey,fontSize:18.0,),maxLines: 10,softWrap: true,),
                                ),

                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        _refluttersdkPlugin.readNotification(notifyList[index]["nameValuePairs"]["campaignId"]);
                                        setUnreadNotificationCount();
                                  }, child:Row(
                                    children: [
                                      Text("Read")
                                    ],
                                  )
                                  ),
                                  SizedBox(
                                      width: 10,
                                  ),
                                  ElevatedButton(onPressed: (){
                                    _refluttersdkPlugin.readNotification(notifyList[index]["nameValuePairs"]["campaignId"]);
                                    setUnreadNotificationCount();
                                  }, child:Row(
                                    children: [
                                      Text("Un read")
                                    ],
                                  )
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(onPressed: (){
                                    notifyList.removeAt(index);
                                    _refluttersdkPlugin.deleteNotificationByCampaignId(notifyList[index]["nameValuePairs"]["campaignId"]);
                                   getNotificationList();
                                  }, child:Row(
                                    children: [
                                      Text("Delete")
                                    ],
                                  )
                                  ),
                                ],
                              ) ,
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            ),
         ),
        ),
          endDrawer: MyNavigator()
      )
    );
  }
}


class NotificationDataClass {

  static List<NotificationDataClass> noficationData=[];
  static List campaignId=[],campaignTitle=[],campaignBody=[],customActionUrl=[],customActionPhone=[];
  static var nCount=0;
  late String notificationTitle;
  late String notificationBody;
  late String url;
  late String phone;
  NotificationDataClass({required this.notificationTitle,required this.notificationBody,required this.phone,required this.url});

  static Future<int> getNotificationCount() async {
    nCount=(await _refluttersdkPlugin.getUnReadNotificationCount())!;
    print("unReadNotificationCount :: $nCount");
    return nCount;
  }
  static setNotificationList()  async {
    var nList=await _refluttersdkPlugin.getNotificationList();

    List<dynamic> jsonArray = json.decode(nList);
    
    for (var jsonMap in jsonArray) {
      String campaignId = jsonMap['nameValuePairs']['campaignId'];
      if(NotificationDataClass.campaignId.length==0){
        NotificationDataClass.campaignId.add(campaignId);
      }
      else
      {

        if(!NotificationDataClass.campaignId.contains(campaignId)){
          NotificationDataClass.campaignId.add(campaignId);
        }
      }

      String title= jsonMap['nameValuePairs']['title'];
      if(NotificationDataClass.campaignTitle.length!=0){
        for (int i = 0; i <  NotificationDataClass.campaignTitle.length; i++) {
          if(NotificationDataClass.campaignId[i]!=campaignId){
            NotificationDataClass.campaignTitle.add(title);
          }
        }
      }
      else
        NotificationDataClass.campaignTitle.add(title);

      String body= jsonMap['nameValuePairs']['body'];
      if(NotificationDataClass.campaignBody.length!=0){
        for (int i = 0; i <   NotificationDataClass.campaignBody.length; i++) {
          if(NotificationDataClass.campaignBody[i]!=campaignId){
            NotificationDataClass.campaignBody.add(body);
          }
        }

      }
      else
        NotificationDataClass.campaignBody.add(body);

      String customActions = jsonArray[0]['nameValuePairs']['customActions'];
      List<dynamic> customActionsList = jsonDecode(customActions);
      for (var i = 0; i < customActionsList.length; i++) {
        if(i==0){
          String url = customActionsList[i]['url'];
          NotificationDataClass.customActionUrl.add(url);
        }
        else if(i==1){
          String phone = customActionsList[i]['url'];
          NotificationDataClass.customActionPhone.add(phone);
        }
        else
          break;
      }
    }
  }
}
