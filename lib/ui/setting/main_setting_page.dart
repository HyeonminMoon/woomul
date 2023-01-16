import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:woomul/main.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/setting/board_setting_page.dart';
import 'package:woomul/ui/setting/my_activity_page.dart';
import 'package:woomul/ui/setting/my_information_page.dart';
import 'package:woomul/ui/setting/service_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var errorCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    errorCheck = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    final authService = context.read<AuthService>();
    final userData = context.read<UserData>();

    final mbti = userData.mbti;
    final ss = userData.sex == 'man' ? 'M' : 'F';

    final user = authService.currentUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            //뒤로가기
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Stack(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_profile(context, userData, authService),
                //_board1(context),
                FutureBuilder<void>(
                    future: userData.getUserData(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              //Placeholder(fallbackHeight: 15, fallbackWidth: 15), //프로필 사진 불러오기
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/chara/$mbti$ss.png'),
                              ),
                              SizedBox(width: phoneSize.width * 0.03),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        userData.name,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        userData.mbti,
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                      ),
                                      SizedBox(width: 10),
                                      Text('|'),
                                      SizedBox(width: 10),
                                      Text(
                                        'mbti 뜻', //이것도 값 가져와야 함!
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    SizedBox(height: phoneSize.height * 0.04),
                    GestureDetector(
                      onTap: () {
                        //내 정보 이동
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPageScreen()));
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12.0),
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Color(0xff466FFF),
                                  ),
                                ),
                                Text(
                                  '내 정보',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffD0D3E5),
                                size: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //내 활동 이동
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyActivityScreen()));
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12.0),
                                  child: Icon(
                                    Icons.public,
                                    color: Color(0xff466FFF),
                                  ),
                                ),
                                Text(
                                  '내 활동',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffD0D3E5),
                                size: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*
          GestureDetector(
            onTap: () {
              //게시판 설정 이동
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BoardSettingScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.article_outlined,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '게시판 설정',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffD0D3E5),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),*/

                    GestureDetector(
                      onTap: () {
                        //이용안내 이동
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Color(0xff466FFF),
                                  ),
                                ),
                                Text(
                                  '이용안내',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffD0D3E5),
                                size: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //이용안내 이동
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12.0),
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: Color(0xff466FFF),
                                  ),
                                ),
                                Text(
                                  '알람설정',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                              ],
                            ),
                            Spacer(),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox();
                                  }
                                  final myDocId = snapshot.data!.docs[0].id;

                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(myDocId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox();
                                        }
                                        final bool isPushAlarmTurnOn =
                                        snapshot.data!.get('isPushAlarmTurnOn');
                                        return SizedBox(
                                          width: 48,
                                          height: 40,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Switch(
                                              activeColor: Color(0xff466FFF),
                                              activeTrackColor: Colors.black45,
                                              value: isPushAlarmTurnOn,
                                              onChanged: (_) async {
                                                FirebaseFirestore.instance
                                                    .collection('user')
                                                    .doc(myDocId)
                                                    .update({
                                                  'isPushAlarmTurnOn': isPushAlarmTurnOn ? false : true
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                }),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //로그아웃 이동
                        context.read<AuthService>().signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12.0),
                                  child: Icon(
                                    Icons.logout,
                                    color: Color(0xff466FFF),
                                  ),
                                ),
                                Text(
                                  '로그아웃',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.05,),

                Container(
                  height: phoneSize.height * 0.2,
                  color: Colors.grey,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  //user 기본 프로필
  Widget _profile(BuildContext context, UserData userData, AuthService authService) {
    var phoneSize = MediaQuery.of(context).size;
    final user = authService.currentUser();
    return FutureBuilder<void>(
        future: userData.getUserData(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Column(
            children: [
              Row(
                children: [
                  Placeholder(fallbackHeight: 15, fallbackWidth: 15), //프로필 사진 불러오기
                  SizedBox(width: phoneSize.width * 0.03),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userData.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            userData.mbti,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          SizedBox(width: 10),
                          Text('|'),
                          SizedBox(width: 10),
                          Text(
                            'mbti 뜻', //이것도 값 가져와야 함!
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _board1(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          SizedBox(height: phoneSize.height * 0.04),
          GestureDetector(
            onTap: () {
              //내 정보 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPageScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '내 정보',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffD0D3E5),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //내 활동 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyActivityScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.public,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '내 활동',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffD0D3E5),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*
          GestureDetector(
            onTap: () {
              //게시판 설정 이동
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BoardSettingScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.article_outlined,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '게시판 설정',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffD0D3E5),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),*/

          GestureDetector(
            onTap: () {
              //이용안내 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.info_outline,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '이용안내',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffD0D3E5),
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //이용안내 이동
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '알람설정',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                  Spacer(),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }
                        final myDocId = snapshot.data!.docs[0].id;

                        return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(myDocId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              }
                              final bool isPushAlarmTurnOn =
                                  snapshot.data!.get('isPushAlarmTurnOn');
                              return SizedBox(
                                width: 48,
                                height: 40,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    activeColor: Color(0xff466FFF),
                                    activeTrackColor: Colors.black45,
                                    value: isPushAlarmTurnOn,
                                    onChanged: (_) async {
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(myDocId)
                                          .update({
                                        'isPushAlarmTurnOn': isPushAlarmTurnOn ? false : true
                                      });
                                    },
                                  ),
                                ),
                              );
                            });
                      }),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //로그아웃 이동
              context.read<AuthService>().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12.0),
                        child: Icon(
                          Icons.logout,
                          color: Color(0xff466FFF),
                        ),
                      ),
                      Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
