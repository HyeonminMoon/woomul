import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:woomul/main.dart';
import 'package:woomul/ui/board/board_search_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/free_board_page.dart';

import '../../provider/auth_service.dart';
import '../../provider/board_service.dart';
import '../../routes.dart';

class HomeBoardScreen extends StatefulWidget {
  @override
  _HomeBoardScreenState createState() => _HomeBoardScreenState();
}


class _HomeBoardScreenState extends State<HomeBoardScreen> {

  int _selectedIndex = 0;

  var errorCheck;

  late TextEditingController _keywordController;


  @override
  void initState() {
    // TODO: implement initState
    initFirebaseMessage();
    super.initState();
    _keywordController = TextEditingController(text: "");

    errorCheck = false;

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
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();
    final boardService = context.read<BoardService>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: phoneSize.height*0.08,),

              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'WOOMUL',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24
                  ),
                ),
              ),

              SizedBox(height: phoneSize.height * 0.05,),

              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(left : 20, right : 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: textFieldForm(_keywordController, "찾고싶은 키워드를 검색하세요", "아이디를 확인해주세요", false),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 3.0),
                      child: IconButton(
                        icon: Icon(
                            Icons.search,
                          color: Color(0xff828796),
                        ),
                        onPressed: () {
                          //검색 결과 페이지로 이동
                          //검색어가 입력 됐을 경우(비어 있으면 검색 안 눌리게 하나욤? 일단 대애충 해놨슴미다)
                          if (_keywordController.toString() != '') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(_keywordController.text)));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                child: Text(
                  '월간 HOT 게시물',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),
                ),
              ),

              FutureBuilder<List<QuerySnapshot>>(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBoardScreen(
                                        'HOT 게시판', docs[0].get('key'), docs[0].id, docs[0].get('userUid'))));
                          },
                          child: Container(
                            height: phoneSize.height*0.25,
                            //margin: EdgeInsets.only(top: 10, bottom: 12),
                            padding: EdgeInsets.only(left: 15,top:10,right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          children: [
                                            /*
                                      Text(
                                          docs[0].get('name'),
                                      ),*/
                                            if (docs[0].get('title').length > 40)
                                              Text(
                                                docs[0].get('title').substring(0, 40) + '...',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14
                                                ),
                                              ),
                                            if (docs[0].get('title').length <= 40)
                                              Text(
                                                docs[0].get('title'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              docs[0].get('name'),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '.',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              docs[0].get('userMbti'),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            //Text(docs[0].get('userMbtiMean'))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),


                                if (docs[0].get('content').length > 50)
                                  Text(
                                      docs[0].get('content').substring(0, 40) + '...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                    ),
                                  ),
                                if (docs[0].get('content').length <= 50)
                                  Text(
                                      docs[0].get('content'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              //클릭 되면, 색 채워지고(user 데이터 불러와야 할듯)
                                              //횟수 증가 되도록
                                            },
                                            icon: Icon(
                                              Icons.favorite_border,
                                              color: Color(0xffA0A3BD),
                                              size: 15,
                                            )
                                        ),
                                        Text(
                                          docs[0].get('likeNum').toString(),
                                          //likeNum.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xffA0A3BD),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.forum_outlined,
                                              color: Color(0xffA0A3BD),
                                              size: 15,
                                            )
                                        ),
                                        Text(
                                          //commentNum.toString(),
                                          docs[0].get('commentNum').toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xffA0A3BD),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: phoneSize.height * 0.03,),

                      Container(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                        child: Text(
                          '월간 BEST 게시물',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBoardScreen(
                                        'BEST 게시판', docs2[0].get('key'), docs2[0].id, docs2[0].get('userUid'))));
                          },
                          child: Container(
                            height: phoneSize.height*0.25,
                            //margin: EdgeInsets.only(top: 10, bottom: 12),
                            padding: EdgeInsets.only(left: 15,top:10,right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          children: [
                                            if (docs[0].get('title').length > 40)
                                              Text(
                                                docs[0].get('title').substring(0, 40) + '...',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14
                                                ),
                                              ),
                                            if (docs[0].get('title').length <= 40)
                                              Text(
                                                docs[0].get('title'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              docs[0].get('name'),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '.',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              docs[0].get('userMbti'),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),

                                if (docs[0].get('content').length > 50)
                                  Text(
                                    docs[0].get('content').substring(0, 40) + '...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14
                                    ),
                                  ),
                                if (docs[0].get('content').length <= 50)
                                  Text(
                                    docs[0].get('content'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              //클릭 되면, 색 채워지고(user 데이터 불러와야 할듯)
                                              //횟수 증가 되도록
                                            },
                                            icon: Icon(
                                              Icons.favorite_border,
                                              color: Color(0xffA0A3BD),
                                              size: 15,
                                            )
                                        ),
                                        Text(
                                            docs[0].get('likeNum').toString(),
                                          //likeNum.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xffA0A3BD),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.forum_outlined,
                                              color: Color(0xffA0A3BD),
                                              size: 15,
                                            )
                                        ),
                                        Text(
                                          //commentNum.toString(),
                                          docs[0].get('commentNum').toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Color(0xffA0A3BD),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),

              //_board1(context),
            ],
          ),
        ),
      ),

    );
  }


  Widget _board1(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();
    final boardService = context.read<BoardService>();

    return Column(
      children: [
        FutureBuilder<List<QuerySnapshot>>(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(left : 20, right : 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: textFieldForm(_keywordController, "찾고싶은 키워드를 검색하세요", "아이디를 확인해주세요", false),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.search,
                          color: Color(0xffA0A3BD),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                  child: Text(
                    '월간 HOT 게시물',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailBoardScreen(
                                  'HOT 게시판', docs[0].get('key'), docs[0].id, docs[0].get('userUid'))));
                    },
                    child: Container(
                      height: phoneSize.height*0.25,
                      //margin: EdgeInsets.only(top: 10, bottom: 12),
                      padding: EdgeInsets.only(left: 15,top:10,right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    children: [
                                      /*
                                      Text(
                                          docs[0].get('name'),
                                      ),*/
                                      if (docs[0].get('title').length > 50)
                                        Text(
                                          docs[0].get('title').substring(0, 40) + '...',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14
                                          ),
                                        ),
                                      if (docs[0].get('title').length <= 50)
                                        Text(
                                          docs[0].get('title'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        docs[0].get('name'),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffA0A3BD)
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffA0A3BD)
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        docs[0].get('userMbti'),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffA0A3BD)
                                        ),
                                      ),
                                      //Text(docs[0].get('userMbtiMean'))
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),


                          if (docs[0].get('content').length > 50)
                            Text(docs[0].get('content').substring(0, 40) + '...'),
                          if (docs[0].get('content').length <= 50)
                            Text(docs[0].get('content')),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        //클릭 되면, 색 채워지고(user 데이터 불러와야 할듯)
                                        //횟수 증가 되도록
                                      },
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Color(0xffA0A3BD),
                                        size: 15,
                                      )
                                  ),
                                  Text(
                                    '좋아요 수',
                                    //likeNum.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xffA0A3BD),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.forum_outlined,
                                        color: Color(0xffA0A3BD),
                                        size: 15,
                                      )
                                  ),
                                  Text(
                                    //commentNum.toString(),
                                    '댓글 수',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xffA0A3BD),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: phoneSize.height * 0.06,),

                Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                  child: Text(
                    '월간 HOT 게시물',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailBoardScreen(
                                'BEST 게시판', docs2[0].get('key'), docs2[0].id, docs2[0].get('userUid'))));
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



      ],
    );
  }


  Widget _board2(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Container(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }

  Widget _board3(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Container(),
          Container(),
          Container(),
          Container(),
        ],
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
