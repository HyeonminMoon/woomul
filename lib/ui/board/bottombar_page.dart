import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/board_service.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';
import 'package:woomul/ui/setting/main_setting_page.dart';


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
    // TODO: implement initState
    super.initState();

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

  Widget _board2(BuildContext context){
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
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }
          final docs = snapshot.data![0].docs ?? [];
          final docs2 = snapshot.data![1].docs ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailBoardScreen('HOT 게시판', docs[0].get('key'))));
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
                              fallbackHeight: 15, fallbackWidth: 15), //프로필 사진
                          SizedBox(width: phoneSize.width * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [Text('mbti')],
                              ),
                              Row(
                                children: [
                                  Text('개인 mbti'),
                                  SizedBox(width: 10),
                                  Text('뜻')
                                ],
                              )
                            ],
                          ),
                          SizedBox(width: phoneSize.width * 0.48),
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                  },
                                  icon: Icon(docs2.isEmpty == true
                                      ? Icons.favorite_border
                                      : Icons.favorite)),
                              Icon(Icons.bookmark_border_outlined)
                            ],
                          )
                        ],
                      ),
                      if (docs[0].get('title').length > 50)
                        Text(
                          docs[0].get('title').substring(0,40) + '...',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      if (docs[0].get('title').length <= 50)
                        Text(
                          docs[0].get('title'),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      SizedBox(height: phoneSize.height * 0.02),
                      if (docs[0].get('content').length > 50)
                        Text(docs[0].get('content').substring(0,40) + '...'),
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
                                children: [Text('대표 닉네임 님 외 n인이 좋아합니다.')],
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
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailBoardScreen('BEST 게시판', docs2[0].get('key'))));
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
                              fallbackHeight: 15, fallbackWidth: 15), //프로필 사진
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
                                  Text('개인MBTI'),
                                  SizedBox(width: 10),
                                  Text('뜻')
                                ],
                              )
                            ],
                          ),
                          SizedBox(width: phoneSize.width * 0.48),
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                  },
                                  icon: Icon(docs2.isEmpty == true
                                      ? Icons.favorite_border
                                      : Icons.favorite)),
                              Icon(Icons.bookmark_border_outlined)
                            ],
                          )
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
                                children: [Text('대표 닉네임 님 외 n인이 좋아합니다.')],
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


