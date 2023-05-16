package com.example.visioneducation
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.resul.refluttersdk.RefluttersdkPlugin
import io.flutter.Log



class MessagingService : FirebaseMessagingService() {
    lateinit var token: String


    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
       Log.d("onMessage", "From handler!!!!")

    /*
     *   SDK Notification Listener
     */
    if( RefluttersdkPlugin().onReceivedCampaign(remoteMessage,this)){
           return;
        }
    }
}

