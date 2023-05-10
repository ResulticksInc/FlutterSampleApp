package com.example.visioneducation
import android.app.Activity
import android.app.Application
import com.resul.refluttersdk.RefluttersdkPlugin

class VisionEducation :Application(){


    override fun onCreate() {
        super.onCreate()
        /*
         *  SDK Initialization
        */
        RefluttersdkPlugin().initReSdk(this)
    }


}