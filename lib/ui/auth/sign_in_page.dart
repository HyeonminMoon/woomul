import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

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
    return Scaffold(
      key: _scaffoldKey,
      body: Align(
        alignment: Alignment.center,
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                // Padding(
                //     padding: const EdgeInsets.all(32.0),
                //     child:
                SizedBox(
                  width: phoneSize.width*1,
                  height: phoneSize.width*0.5,
                  child: Image.asset("assets/images/login.png"),
                ),
                Text(
                  '코드한입에 어서오세요!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: phoneSize.height * 0.03),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right : 16.0),
                      child: Icon(
                        Icons.mail_outline,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: textFieldForm(
                          _emailController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                    ),
                  ],
                ),
                SizedBox(height: phoneSize.height * 0.008),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right : 16.0),
                      child: Icon(
                        Icons.lock_open,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: textFieldForm(
                          _passwordController, "비밀번호를 입력해주세요.", "비밀번호를 확인해주세요", true),
                    ),
                  ],
                ),
                SizedBox(height: 2.0),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 40),
                        InkWell(
                          onTap: () {
                            //print("비번 이메일 보내기");
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('비밀번호 재설정 이메일'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('비밀번호를 다시 재설정하고 싶으시다면, 계정 메일을 입력한 후 확인을 눌러주세요 :)'),
                                    SizedBox(height: 8.0),
                                    textFieldForm(
                                        _resetEmailController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            "비밀번호를 잊어버리셨나요?",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.02),

                      ],
                    )),
                SizedBox(height: phoneSize.height * 0.05),

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
          ),
        ));
  }

  Widget circularButton(String image, Future<void> Function() function) {
    var size = MediaQuery.of(context).size.width * 0.12;
    return InkWell(
        child: Container(
          width: size,
          height: size,
          child: Center(
              child: Image.asset(image, width: size * 0.7, height: size * 0.7)),
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
        ),
        onTap: function);
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
            .titleLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
              color: Theme.of(context).colorScheme.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
            ),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}
