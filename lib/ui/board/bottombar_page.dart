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

  @override
  void initState() {
    initFirebaseMessage();
    super.initState();
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
      _board2(context),
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
          '?????????',
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
            label: '???',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '?????????',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '??????',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _board2(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();
    final boardService = context.read<BoardService>();

    return Expanded(
      child: FutureBuilder<List<QuerySnapshot>>(
        future: Future.wait([
          boardService.readLimit('commentNum', 1),
          boardService.readLimit('likeNum', 1)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final docs = snapshot.data![0].docs ?? [];
          final docs2 = snapshot.data![1].docs ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailBoardScreen(
                              'HOT ?????????', docs[0].get('key'))));
                },
                child: Container(
                  //height: phoneSize.height*0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Placeholder(
                              fallbackHeight: 15, fallbackWidth: 15), //????????? ??????
                          SizedBox(width: phoneSize.width * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [Text(docs[0].get('name'))],
                              ),
                              Row(
                                children: [
                                  Text(docs[0].get('userMbti')),
                                  SizedBox(width: 10),
                                  Text(docs[0].get('userMbtiMean'))
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      if (docs[0].get('title').length > 50)
                        Text(
                          docs[0].get('title').substring(0, 40) + '...',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      if (docs[0].get('title').length <= 50)
                        Text(
                          docs[0].get('title'),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      SizedBox(height: phoneSize.height * 0.02),
                      if (docs[0].get('content').length > 50)
                        Text(docs[0].get('content').substring(0, 40) + '...'),
                      if (docs[0].get('content').length <= 50)
                        Text(docs[0].get('content')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text('2')],
                              ),
                              Row(
                                children: [Text('?????? ????????? ??? ??? n?????? ???????????????.')],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailBoardScreen(
                              'BEST ?????????', docs2[0].get('key'))));
                },
                child: Container(
                  //height: phoneSize.height*0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Placeholder(
                              fallbackHeight: 15, fallbackWidth: 15), //????????? ??????
                          SizedBox(width: phoneSize.width * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [Text(docs2[0].get('name'))],
                              ),
                              Row(
                                children: [
                                  Text(docs2[0].get('userMbti')),
                                  SizedBox(width: 10),
                                  Text(docs2[0].get('userMbtiMean'))
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        docs2[0].get('title'),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: phoneSize.height * 0.02),
                      Text(docs2[0].get('content')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text('2')],
                              ),
                              Row(
                                children: [Text('?????? ????????? ??? ??? n?????? ???????????????.')],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
