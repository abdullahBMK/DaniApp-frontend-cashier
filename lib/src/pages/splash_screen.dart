import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/controller.dart';
import '../repository/user_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  Controller _con;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SplashScreenState() : super(Controller()) {
    _con = controller;
  }

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // showDialog(
        //   context: scaffoldKey.currentContext,
        //   builder: (context) => AlertDialog(
        //     content: ListTile(
        //       title: Text(message['notification']['title']),
        //       subtitle: Text(message['notification']['body']),
        //     ),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Ok'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (currentUser.apiToken == null) {
        Navigator.of(context).pushReplacementNamed('/Login');
      } else {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                image: AssetImage("assets/img/backimg.png"),
                fit: BoxFit.cover,
              ),
        ),
        child: Center(
          child: //Column(
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: <Widget>[
              // Image.asset(
              //   'assets/img/logo.png',
              //   width: 150,
              //   fit: BoxFit.cover,
              // ),
              // SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
