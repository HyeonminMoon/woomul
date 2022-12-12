import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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
    errorCheck = false;

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, UserData>(builder: (context, authService, userData, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: Align(
            alignment: Alignment.center,
            child: _buildForm(context, authService, userData),
          ),
        );
      }
    );
  }

  Widget _buildForm(BuildContext context, AuthService authService, UserData userData) {
    var phoneSize = MediaQuery.of(context).size;
    final user = authService.currentUser();
    final userData2 = context.read<UserData>();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: phoneSize.width*1,
                  height: phoneSize.width*0.4,
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
                SizedBox(height: phoneSize.height * 0.2),
                Container(
                  padding: EdgeInsets.only(left:10.0, right:10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right : 16.0),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: textFieldForm(
                            _emailController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: phoneSize.height * 0.02),
                Container(
                  padding: EdgeInsets.only(left:10.0, right:10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right : 16.0),
                        child: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: textFieldForm(
                            _passwordController, "비밀번호를 입력해주세요.", "비밀번호를 확인해주세요", true),
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
                        onPressed: (){
                          //비밀번호 찾기 기능 추가
                          print(userData2.name);
                          print(userData2.mbti);
                          if (user != null) {
                            print(user.uid);
                          }
                        },
                        style: TextButton.styleFrom(
                          //foregroundColor: Colors.black,
                        ),
                        child: Text(
                          '비밀번호를 잊으셨나요?'
                        ),
                      )
                    ),
                  ],
                ),
                SizedBox(height: phoneSize.height * 0.05),

                Container(
                  width: phoneSize.width *0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
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
                        onSuccess: () {
                          // 로그인 성공
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("로그인 성공"),
                          ));
                        },
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );



                      if(user == null) {
                        print("유저 정보가 없습니다");
                      }else{
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
                      '시 작 하 기'
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.register);
                      },
                      child: Text(
                        "회원 가입하러 가기",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ),
                  ],
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
          child: Center(
              child: Image.asset(image, width: size * 0.7, height: size * 0.7)),
        ));
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
              borderSide: BorderSide(color: Color(0xFF0000)/*Theme.of(context).colorScheme.surface*/),
            ),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF0000))),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}