import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/setting/my_information_edit_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
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
            fontWeight: FontWeight.w700,
            fontSize: 16
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              //수정하기 page 로 이동
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageEditScreen()));
            },
            child: Text(
                '수정하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff4975FF)
              ),
            ),

          )
        ],
      ),
      key: _scaffoldKey,
      body: Align(
        alignment: Alignment.center,
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    final authService = context.read<AuthService>();
    final userData = context.read<UserData>();
    final user = authService.currentUser();

    return FutureBuilder<void>(
      future: userData.getUserData(user!.uid),
      builder: (context, snapshot) {
        return Form(
            key: _formKey,
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: <Widget>[
                    Placeholder(fallbackHeight: 120,fallbackWidth: 120), // 프로필 불러오기 해야함!!
                    //Image(image: AssetImage('assets/images/chara/ENFJ_M.png')),
                    SizedBox(height: phoneSize.height * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '닉네임',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.01),
                        Container(
                          height: phoneSize.height * 0.08,
                          padding: EdgeInsets.only(left:18.0, right:10.0),
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
                              Text(
                                userData.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffA0A3BD)
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
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.01),
                        Container(
                          height: phoneSize.height * 0.08,
                          padding: EdgeInsets.only(left:18.0, right:10.0),
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
                              Text(
                                userData.mbti,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xffA0A3BD)
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
                              fontWeight: FontWeight.w400,
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
                              Text(
                                userData.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xffA0A3BD)
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
                              fontWeight: FontWeight.w400,
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
                              Text(
                                '⚫⚫⚫⚫⚫⚫⚫',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 7,
                                    color: Color(0xffA0A3BD) //얘는 색깔이 안 바뀜 ㅋㅋㅋㅋㅋㅋㅋㅋ
                                ),
                              )
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right : 16.0),
                                    child: Icon(
                                      Icons.shield,
                                      color: Color(0xffA0A3BD),
                                    ),
                                  ),
                                  Text(
                                    '마켓팅 수신 동의 설정',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffA0A3BD)
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = false; //firebase 에서 동의 했는지 값 가져와서 고정하기! 지금은 임의로 무조건 false 로 해놨음
                                  });
                                },
                                activeTrackColor: Colors.blue,
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: phoneSize.height * 0.02),

                    /*
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            //여기선 그냥 터치 안 되도록
                            authService.deleteUser(uid: user!.uid);
                          },
                          child: Container(
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
                                Container(
                                  padding: EdgeInsets.only(right : 16.0),
                                  child: Icon(
                                    Icons.mood_bad,
                                    color: Color(0xffA0A3BD),
                                  ),
                                ),
                                Text(
                                  '탈퇴하기',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xffA0A3BD)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),*/

                    SizedBox(height: phoneSize.height * 0.04),



                  ],
                ),
              ),
            ));
      }
    );
  }


  Widget textFieldForm(TextEditingController controller, String labelText,
      String errorText, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        obscureText: obscure,
        controller: controller,
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
            fillColor: Color(0xffFCFCFC),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEFF0F7))),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}