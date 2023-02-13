import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woomul/ui/auth/sign_in_page.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: _buildForm(context),
        ),
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
                Image(
                  image: AssetImage('assets/images/loginImage.png')
                ),
                Text(
                  'WOOMUL',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '우리들의 MBTI 로 소통하는 공간',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff6E7191)
                  ),
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
                        color: Color(0xff466fff),
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),

                SizedBox(height: phoneSize.height * 0.02),

                Container(
                  width: phoneSize.width *0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color.fromRGBO(74, 84, 255, 0.9), Color.fromRGBO(0, 102, 255, 0.6)]),
                    borderRadius: BorderRadius.circular(54),
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
                        '회원가입',
                      style: TextStyle(
                        color: Color(0xffFCFCFC),
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}