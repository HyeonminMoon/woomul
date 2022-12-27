import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/setting/board_setting_page.dart';
import 'package:woomul/ui/setting/my_activity_page.dart';
import 'package:woomul/ui/setting/my_information_page.dart';


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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '설정',
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _profile(context, userData, authService),
                    _board1(context),
                  ],
                ),
              ]
          ),
        ),
      ),


    );

  }

  //user 기본 프로필
  Widget _profile(BuildContext context, UserData userData, AuthService authService){
    var phoneSize = MediaQuery.of(context).size;
    final user = authService.currentUser();
    return FutureBuilder<void>(
      future: userData.getUserData(user!.uid),
      builder: (context, snapshot) {
        return Column(
          children: [
            Row(
              children: [
                Placeholder(fallbackHeight: 15,fallbackWidth: 15),//프로필 사진
                SizedBox(width: phoneSize.width *0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            userData.name
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            userData.mbti
                        ),
                        SizedBox(width:10),
                        Text(
                            'mbti 뜻'
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _board1(BuildContext context){
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          

          SizedBox(height: phoneSize.height*0.04),

          GestureDetector(
            onTap: () {
              //내 정보 이동
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
            },
            child: Container(
              width: phoneSize.width*0.8,
              height: phoneSize.height*0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '내 정보'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyActivityScreen()));
            },
            child: Container(
              width: phoneSize.width*0.8,
              height: phoneSize.height*0.1,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '내 활동'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),

                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              //게시판 설정 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BoardSettingScreen()));
            },
            child: Container(
              width: phoneSize.width*0.8,
              height: phoneSize.height*0.1,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '게시판 설정'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
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
              width: phoneSize.width*0.8,
              height: phoneSize.height*0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '이용안내'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),

                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              //로그아웃 이동
              context.read<AuthService>().signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()));

            },
            child: Container(
              width: phoneSize.width*0.8,
              height: phoneSize.height*0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '로그아웃'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
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


