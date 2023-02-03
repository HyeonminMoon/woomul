import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import '../../provider/auth_service.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import '../../routes.dart';

List<String> listSex = <String>['선택', '여', '남'];

class SecessionScreen extends StatefulWidget {
  @override
  _SecessionScreenState createState() => _SecessionScreenState();
}

class _SecessionScreenState extends State<SecessionScreen> {
  var index;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCheckController;

  var errorCheck;

  var tmpPW = 'testpassword1';
  var tmpSEX = 'man';

  String dropdownValue = listSex.first;

  bool mbti1 = false;
  bool mbti2 = false;
  bool mbti3 = false;
  bool mbti4 = false;

  bool emailChecked = false;
  bool emailDoubleChecked = false;
  bool nameChecked = false;
  bool birthChecked = false;

  bool isChecked = false;

  bool term1 = false;
  bool term2 = false;
  bool term3 = false;
  bool term4 = false;
  bool term5 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = 0;
    _emailController = TextEditingController(text: "");
    _nameController = TextEditingController(text: "");
    _birthController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordCheckController = TextEditingController(text: "");
    errorCheck = false;
    mbti1 = false;
    mbti2 = false;
    mbti3 = false;
    mbti4 = false;
    isChecked = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _birthController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    //index.dispose(); int 값을 dispose() 했을떄 오류 발생함 221228 현민
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (index == 0) {
                  Navigator.pop(context);
                }
                if (index > 0) {
                  index--;
                }
              });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForm3(context)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
            color: (term1 == true && term2 == true && term3 == true && term4 == true)
                ? Color(0xff4D64F3)
                : Color(0xffD0D3E5), //1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
            child: SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: Text(
                  '다음',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )),
      );
    });
  }

  Widget _buildForm1(BuildContext context, AuthService authService) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '이메일 입력',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '안녕하세요!\n'
                      '이메일(아이디) 인증 후 회원가입을 진행해주세요.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),

                SizedBox(height: phoneSize.height * 0.07),

                Text(
                  '이메일',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                ),

                textFieldForm(_emailController, "가입하실 이메일을 입력해주세요.", "이메일을 확인해주세요", false, false, 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // 여기 체크해봐야함! [ERROR]
                        if (await authService.doubleCheck(_emailController.text) == true) {
                          emailDoubleChecked = false;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("이미 있는 아이디입니다"),
                          ));
                        } else {
                          emailDoubleChecked = true;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffECF1FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(54)),
                      ),
                      child: Text(
                        '중복 확인',
                        style: TextStyle(
                            color: Color(0xff466FFF), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                //중복 이메일 체크 기능 추가하시면 여기 확인 해주세여!
                emailDoubleChecked == true
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '비밀번호',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                    ),

                    textFieldForm(_passwordController, "비밀번호를 입력해주세요.", "", true, false, 1),

                    Text(
                      '비밀번호 확인',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                    ),

                    //비번 일치 하지 않으면 일치 하지 않다고 알려주는 기능 추가 해야함
                    textFieldForm(_passwordCheckController, "비밀번호를 입력해주세요", "비밀번호가 일치하지 않습니다.",
                        true, false, 1),
                  ],
                )
                    : Container()
              ],
            ),
          ),
        ));
  }


  Widget _buildForm3(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '약관동의',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                SizedBox(height: phoneSize.height * 0.03),
                Text(
                  'WOOMUL 서비스를 이용하시려면\n'
                      '필수 약관에 동의가 필요합니다.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),
                SizedBox(height: phoneSize.height * 0.04),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;

                          if (isChecked == true){
                            term1 = true;
                            term2 = true;
                            term3 = true;
                            term4 = true;
                            term5 = true;
                          }else {
                            term1 = false;
                            term2 = false;
                            term3 = false;
                            term4 = false;
                            term5 = false;
                          }

                        });
                      },
                    ),
                    SizedBox(height: phoneSize.width * 0.01),
                    Text('WOOMUL 이용약관 전체동의'),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: phoneSize.width * 0.02,),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 20,
                            color: term1 == true ? Color(0xff4D64F3) : Color(0xffF8FAFE),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              if (term1 == false){
                                term1 = true;
                              }else{
                                term1 = false;
                              }
                              print(term1);
                            });
                          },
                        ),
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '(필수) 개인 정보 수집 및 이용에 동의합니다.',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '개인정보 수집 및 이용 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: phoneSize.width * 0.02,),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 20,
                            color: term2 == true ? Color(0xff4D64F3) : Color(0xffF8FAFE),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              if (term2 == false){
                                term2 = true;
                              }else{
                                term2 = false;
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '(필수) 서비스 이용약관에 동의합니다.',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '이용약관 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: phoneSize.width * 0.02,),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 20,
                            color: term3 == true ? Color(0xff4D64F3) : Color(0xffF8FAFE),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              if (term3 == false){
                                term3 = true;
                              }else{
                                term3 = false;
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '(필수) 개인정보의 제 3자 제공에 동의합니다.',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '개인정보 제 3자 제공 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: phoneSize.width * 0.02,),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 20,
                            color: term4 == true ? Color(0xff4D64F3) : Color(0xffF8FAFE),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              if (term4 == false){
                                term4 = true;
                              }else{
                                term4 = false;
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '(필수) 커뮤니티 이용규칙 확인 동의',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '커뮤니티 이용규칙 확인 동의 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: phoneSize.width * 0.02,),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 20,
                            color: term5 == true ? Color(0xff4D64F3) : Color(0xffF8FAFE),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              if (term5 == false){
                                term5 = true;
                              }else{
                                term5 = false;
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '(선택) 광고성 정보 수신 동의',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '광고성 정보 수신 동의 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildForm4(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '짝짝짝!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                Row(
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff466FFF)),
                    ),
                    SizedBox(
                      width: phoneSize.width * 0.02,
                    ),
                    Text(
                      '님',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                    )
                  ],
                ),

                Text(
                  '회원가입이 완료되었습니다.',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),

                SizedBox(
                  height: phoneSize.height * 0.07,
                ),

                //가입축하 이미지 넣기
                Placeholder(
                  fallbackHeight: phoneSize.height * 0.4,
                ),
              ],
            ),
          ),
        ));
  }

  Widget textFieldForm(TextEditingController controller, String labelText, String errorText,
      bool obscure, bool keyboardType, int textForm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 9,
            offset: Offset(0, 3),
          )
        ], borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          keyboardType: keyboardType == true ? TextInputType.number : TextInputType.text,
          obscureText: obscure,
          controller: controller,
          cursorColor: Color(0xffA0A3BD),
          onChanged: (data) {},
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Color(0xff4E4B66)),
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
              filled: true,
              fillColor: Colors.white,
              labelText: labelText,
              hintText: labelText,
              hintStyle: TextStyle(color: Color(0xffA0A3BD)),
              labelStyle: TextStyle(color: Colors.white //Theme.of(context).colorScheme.primary,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: Color(0xFF0000) /*Theme.of(context).colorScheme.surface*/),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF0000))),
              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffFF6868)))),
        ),
      ),
    );
  }
}
