import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woomul/ui/auth/sign_in_page.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';

import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: phoneSize.width*1,
                  height: phoneSize.height*0.3,
                  //child: Image.asset("assets/images/login.png"), -> 이미지 값 넣기
                ),
                Text(
                  'WOOMUL',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '우리들의 MBTI 로 소통하는 공간',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(height: phoneSize.height * 0.08),

                Container(
                  width: phoneSize.width *0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(54),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      //로그인 페이지로 이동
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                          SignInScreen())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                        '로그인',
                      style: TextStyle(
                        color: Colors.blueAccent
                      ),
                    ),
                  ),
                ),

                SizedBox(height: phoneSize.height * 0.02),

                Container(
                  width: phoneSize.width *0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      //회원가입 페이지로 이동
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              SignUpScreen())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                        '회원가입'
                    ),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}