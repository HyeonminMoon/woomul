import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:woomul/main.dart';
import 'package:woomul/provider/board_service.dart';
import 'package:woomul/ui/board/board_home_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';
import 'package:woomul/ui/setting/main_setting_page.dart';
import 'package:http/http.dart' as http;

import '../../provider/auth_service.dart';
import '../../routes.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  int _selectedIndex = 0;

  var errorCheck;

  late TextEditingController _keywordController;


  @override
  void initState() {
    initFirebaseMessage();
    super.initState();
    _keywordController = TextEditingController(text: "");

    errorCheck = false;
  }

  void initFirebaseMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                priority: Priority.max,
                icon: android.smallIcon,
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _keywordController.dispose();

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    final List<Widget> _widgetOptions = <Widget>[
      Expanded(child: HomeBoardScreen()),
      //_board1(context),
      //_board3(context),
      Expanded(child: MainBoardScreen()),
      Expanded(child: SettingScreen()),
    ];
    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '게시판',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {

          },
        ),
      ),*/
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            //_board1(context),
            //_board2(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff466FFF),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }


  Widget textFieldForm(TextEditingController controller, String labelText, String errorText,
      bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        onTap: () {
          //scontroller.animateTo(120.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        obscureText: obscure,
        controller: controller,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Color(0xffA0A3BD)),
        cursorColor: Color(0xffA0A3BD),
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              errorCheck = true;
            });
            return errorText;
          } else {
            setState(() {
              errorCheck = false;
            });
            return null;
          }
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            labelText: labelText,
            labelStyle: TextStyle(color: Color(0xFF0000) //Theme.of(context).colorScheme.primary,
            ),
            hintStyle: TextStyle(
              color: Color(0xff828796),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
            hintText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Color(0xFF0000) /*Theme.of(context).colorScheme.surface*/),
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF0000))),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffFF6868)))),
      ),
    );
  }
}
