import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/setting/password_rewrite_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _resetEmailController;

  late ScrollController _scrollController;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var errorCheck;
  late bool _showAppleSignIn;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      setState(() {
        _showAppleSignIn = true;
      });
    } else {
      _showAppleSignIn = false;
    }

    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _resetEmailController = TextEditingController(text: "");
    _scrollController = ScrollController();
    errorCheck = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, UserData>(builder: (context, authService, userData, child) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          body: Align(
            alignment: Alignment.center,
            child: _buildForm(context, authService, userData),
          ),
        ),
      );
    });
  }

  Widget _buildForm(BuildContext context, AuthService authService, UserData userData) {
    var phoneSize = MediaQuery.of(context).size;
    final user = authService.currentUser();
    final userData2 = context.read<UserData>();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: phoneSize.width * 0.2,
                ),
                SizedBox(
                  width: phoneSize.width * 1,
                  height: phoneSize.width * 0.5,
                  child: Image.asset("assets/images/loginImage.png"),
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
                      fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff6E7191)),
                ),
                SizedBox(height: phoneSize.height * 0.12),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.account_circle,
                          color: Color(0xffA0A3BD),
                        ),
                      ),
                      Expanded(
                        child: textFieldForm(_emailController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false,
                            _scrollController),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: phoneSize.height * 0.02),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.lock,
                          color: Color(0xffA0A3BD),
                        ),
                      ),
                      Expanded(
                        child: textFieldForm(_passwordController, "비밀번호를 입력해주세요.", "비밀번호를 확인해주세요",
                            true, _scrollController),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        child: TextButton(
                      onPressed: () {
                        //비밀번호 찾기 기능 추가
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PassWordEditScreen()));
                      },
                      style: TextButton.styleFrom(
                          //foregroundColor: Colors.black,
                          ),
                      child: Text(
                        '비밀번호를 잊으셨나요?',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff466FFF)),
                      ),
                    )),
                  ],
                ),
                SizedBox(height: phoneSize.height * 0.05),
                Container(
                  width: phoneSize.width * 0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(74, 84, 255, 0.9),
                      Color.fromRGBO(0, 102, 255, 0.6)
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      //해당 계정이 있는지 확인하기 기능
                      //계정 및 비밀번호가 제대로 입력되었는지 확인하기 기능
                      //로그인 되도록 코드 추가하시면 됩니다!

                      // 로그인
                      authService.signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                        onSuccess: () async {
                          // 로그인 성공

                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => BoardScreen()));
                        },
                        onError: (err) {
                          // 에러 발생
                        },
                      );

                      if (user == null) {
                        print("유저 정보가 없습니다");
                      } else {
                        print("안녕하세요. ${user.email}님");
                        print(userData.getUserData(user.uid));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      '시 작 하 기',
                      style: TextStyle(
                          color: Color(0xffFCFCFC), fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: phoneSize.height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 아이디가 없으신가요?  ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        "회원 가입하러 가기",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xff466FFF)),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: phoneSize.height * 0.02,
                ),

              ],
            ),
          ),
        ));
  }

  Widget circularButton(String image, Future<void> Function() function) {
    var size = MediaQuery.of(context).size.width * 0.12;
    return InkWell(
        onTap: function,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Center(child: Image.asset(image, width: size * 0.7, height: size * 0.7)),
        ));
  }

  Widget textFieldForm(TextEditingController controller, String labelText, String errorText,
      bool obscure, ScrollController scontroller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        onTap: () {
          scontroller.animateTo(120.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
