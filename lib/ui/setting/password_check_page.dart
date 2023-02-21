import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/setting/my_information_edit_page.dart';
import 'package:woomul/ui/setting/password_rewrite_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';

class PasswordCheckScreen extends StatefulWidget {
  @override
  _PasswordCheckScreenState createState() => _PasswordCheckScreenState();
}

class _PasswordCheckScreenState extends State<PasswordCheckScreen> {

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
    final userData = context.read<UserData>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
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

        ],
      ),
      key: _scaffoldKey,
      body: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context),
      ),
        bottomNavigationBar: Material(
            color: _passwordController.text == '' ? Color(0xffD0D3E5) : Color(0xff4D64F3),
            child: InkWell(
              onTap: () {
                setState(() {
                  //비밀번호가 일치하는지 확인 후, 수정하기 page 로 이동되도록!
                  authService.signIn(email: userData.email,
                      password: _passwordController.text,
                      onSuccess: (){
                        if(_passwordController.text != ''){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyPageEditScreen()));
                        }
                      },
                      onError: (err){
                    print("비밀번호가 틀렸습니다");
                      });
                });
              },
              child: SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )
        ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    final authService = context.read<AuthService>();
    final userData = context.read<UserData>();
    final user = authService.currentUser();

    final mbti = userData.mbti;
    final ss = userData.sex == 'man' ? 'M' : 'F';

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: phoneSize.height * 0.07,),
                      Text(
                        '개인 정보 보호를 위해\n비밀번호를 입력해주세요',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),

                      //SizedBox(height: phoneSize.height * 0.01,),
                      TextButton(
                        onPressed: () {
                          //비밀번호 재설정 page 로 이동
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PassWordEditScreen()));
                        },
                        style: TextButton.styleFrom(
                          //foregroundColor: Colors.black,
                        ),
                        child: Text(
                          '비밀번호를 잊으셨나요?',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff6E7191),
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
                            child: textFieldForm(
                                _passwordController, "비밀번호를 입력해주세요.", "비밀번호가 일치하지 않습니다.", true),
                          ),
                        ],
                      ),

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
                color: Color(0xFFFFFFFF)//Theme.of(context).colorScheme.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            filled: true,
            fillColor: Color(0xffFFFFFF),
            //비밀번호 확인 기능 추가 후 활성화 해야함!
            /*
            errorText: errorText,
            errorStyle: TextStyle(
              color: Color(0xffFF6868)
            ),*/
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFFFFF))),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}