import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:woomul/provider/auth_service.dart';
import 'package:woomul/main.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/setting/main_setting_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';

class MyPageEditScreen extends StatefulWidget {
  @override
  _MyPageEditScreenState createState() => _MyPageEditScreenState();
}

class _MyPageEditScreenState extends State<MyPageEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mbtiController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _resetEmailController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var errorCheck;
  late bool _showAppleSignIn;

  bool isSwitched = false;


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

    _nameController = TextEditingController(text: "");
    _mbtiController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _resetEmailController = TextEditingController(text: "");
    errorCheck = false;

  }

  @override
  void dispose() {
    _nameController.dispose();
    _mbtiController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final authService = context.read<AuthService>();
    final user = authService.currentUser();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            '내 정보',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardScreen()));
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                //내용 fb 에 저장 및 업로드
              },
              child: Text(
                  '저장하기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xff4975FF)
                ),
              ),
  
            )
          ],
      ),
      key: _scaffoldKey,
      body: Align(
        alignment: Alignment.center,
        child: _buildForm(context, authService),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AuthService authService) {
    var phoneSize = MediaQuery.of(context).size;
    final userData = context.read<UserData>();
    final mbti = userData.mbti;
    final ss = userData.sex == 'man' ? 'M' : 'F';

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(height: phoneSize.height * 0.02,),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/chara/$mbti$ss.png'),
                  radius: 60,
                ),
                SizedBox(height: phoneSize.height * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    SizedBox(height: phoneSize.height * 0.01),
                    Container(
                      padding: EdgeInsets.only(left:10.0, right:10.0),
                      height: phoneSize.height * 0.08,
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
                            child: textFieldForm(
                                _nameController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                          ),

                          //솔직히 이거 편집 아이콘 없어도 될 거 같긴한데...
                          Container(
                            padding: EdgeInsets.only(right : 16.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Color(0xff466FFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MBTI',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    SizedBox(height: phoneSize.height * 0.01),
                    Container(
                      height: phoneSize.height * 0.08,
                      padding: EdgeInsets.only(left:10.0, right:10.0),
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
                            child: textFieldForm(
                                _mbtiController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                          ),
                          Container(
                            padding: EdgeInsets.only(right : 16.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Color(0xff466FFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이메일',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    SizedBox(height: phoneSize.height * 0.01),
                    Container(
                      height: phoneSize.height * 0.08,
                      padding: EdgeInsets.only(left:10.0, right:10.0),
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
                            child: textFieldForm(
                                _emailController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                          ),
                          Container(
                            padding: EdgeInsets.only(right : 16.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Color(0xff466FFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '비밀번호',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    SizedBox(height: phoneSize.height * 0.01),
                    Container(
                      height: phoneSize.height * 0.08,
                      padding: EdgeInsets.only(left:10.0, right:10.0),
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
                            child: textFieldForm(
                                _passwordController, "비밀번호를 입력해주세요.", "비밀번호를 확인해주세요", false),
                          ),
                          Container(
                            padding: EdgeInsets.only(right : 16.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Color(0xff466FFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left:10.0, right:10.0),
                      height: phoneSize.height * 0.08,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right : 16.0),
                                child: Icon(
                                  Icons.shield,
                                  color: Color(0xff466FFF),
                                ),
                              ),
                              Text(
                                '마켓팅 수신 동의 설정',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value; //firebase 에서 값 가져오면 될듯
                              });
                            },
                            activeTrackColor: Color(0xff466FFF),
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.02),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        //회원 정보 삭제
                        authService.deleteUser();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));

                      },
                      child: Container(
                        padding: EdgeInsets.only(left:10.0, right:10.0),
                        height: phoneSize.height * 0.08,
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
                            Container(
                              padding: EdgeInsets.only(right : 16.0),
                              child: Icon(
                                Icons.mood_bad,
                                color: Color(0xff466FFF),
                              ),
                            ),
                            Text(
                              '탈퇴하기',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),


              ],
            ),
          ),
        ));
  }


  Widget textFieldForm(TextEditingController controller, String labelText,
      String errorText, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        obscureText: obscure,
        controller: controller,
        cursorColor: Color(0xffA0A3BD),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.black),
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
            labelStyle: TextStyle(
                color: Color(0xFF0000)//Theme.of(context).colorScheme.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            filled: true,
            fillColor: Color(0xffFFFFFF),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xffFF6868)))),
      ),
    );
  }
}