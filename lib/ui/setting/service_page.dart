import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import '../../provider/auth_service.dart';
import 'package:woomul/ui/auth/mbti_test_page.dart';

import '../../routes.dart';

List<String> listSex = <String>['선택', '여', '남'];

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
              print(index);
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

  Widget _buildForm2(BuildContext context) {
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
                SizedBox(height: phoneSize.height * 0.04),
                Text(
                  '회원정보 입력',
                  style: TextStyle(color: Color(0xff14142B), fontWeight: FontWeight.w700, fontSize: 24),
                ),
                SizedBox(height: phoneSize.height * 0.015),
                Text(
                  'WOOMUL에서 사용할 정보들을 입력해주세요.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),
                SizedBox(height: phoneSize.height * 0.05),
                Text(
                  '닉네임',
                  style: TextStyle(color: Color(0xff4E4B66), fontWeight: FontWeight.w400, fontSize: 14),
                ),
                textFieldForm(_nameController, "닉네임을 입력해주세요.", "닉네임을 확인해주세요", false, false, 2),
                SizedBox(height: phoneSize.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '생년월일',
                          style: TextStyle(
                              color: Color(0xff4E4B66), fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        Container(
                          width: phoneSize.width * 0.56,
                          child: textFieldForm(
                              _birthController, "생년월일 (YYYYMMDD)", "생년월일을 확인해주세요", false, true, 3),
                        ),
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.07),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '성별',
                          style: TextStyle(
                              color: Color(0xff4E4B66), fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        SizedBox(height: phoneSize.height * 0.007),
                        Container(
                          width: phoneSize.width * 0.2,
                          padding: EdgeInsets.only(left: 12.0, right: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 9,
                                  offset: Offset(0, 3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Row(
                              children: [
                                SizedBox(
                                  width: phoneSize.width * 0.02,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xffD0D3E5),
                                ),
                              ],
                            ),
                            elevation: 16,
                            style: TextStyle(color: Color(0xffA0A3BD)),
                            underline: Container(
                              color: Colors.white,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: listSex.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: phoneSize.height * 0.05),
                Text(
                  'MBTI',
                  style: TextStyle(color: Color(0xff4E4B66), fontWeight: FontWeight.w400, fontSize: 14),
                ),
                SizedBox(
                  height: phoneSize.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti1 == false
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mbti1 = false;
                              });
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'E',
                              style: TextStyle(
                                color: mbti1 == false ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.03),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti1 == true
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mbti1 = true;
                              });
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'I',
                              style: TextStyle(
                                  color: mbti1 == true ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti2 == false
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti2 = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: mbti2 == false ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.03),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti2 == true
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti2 = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'N',
                              style: TextStyle(
                                color: mbti2 == true ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti3 == false
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti3 = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'T',
                              style: TextStyle(
                                  color: mbti3 == false ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.03),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti3 == true
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti3 = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'F',
                              style: TextStyle(
                                  color: mbti3 == true ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti4 == false
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti4 = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'J',
                              style: TextStyle(
                                  color: mbti4 == false ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(height: phoneSize.height * 0.03),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: mbti4 == true
                                ? LinearGradient(colors: [
                              Color.fromRGBO(74, 84, 255, 0.9),
                              Color.fromRGBO(0, 102, 255, 0.6)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                : LinearGradient(colors: [
                              Color.fromRGBO(255, 255, 255, 0.9),
                              Color.fromRGBO(255, 255, 255, 0.9)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                              setState(() {
                                mbti4 = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'P',
                              style: TextStyle(
                                  color: mbti4 == true ? Color(0xffFCFCFC) : Color(0xff6E7191),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => MBTITestScreen()));
                      },
                      child: Text(
                        '내 MBTI 를 모르겠어요',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline,
                          color: Color(0xffA0A3BD),
                        ),
                      ),
                    ),
                  ],
                )
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
                  '이용 안내',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                SizedBox(height: phoneSize.height * 0.03),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '개인 정보 수집 및 이용 동의',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                            textColor: Color(0xff466FFF),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '수집하는 개인정보의 항목\n'
                                        '회사는 서비스 제공을 위해, 회원가입 시점에 다음에 해당하는 개인정보를 수집합니다.\n'
                                        '1. 이메일, 닉네임, 생년월일, 성별, 연계정보(CI, DI)\n'
                                        '* 각 항목 또는 추가적으로 수집이 필요한 개인정보 및 개인정보를 포함한 자료는 이용자 응대 과정과 서비스 내부 알림 수단 등을 통해 별도의 동의 절차를 거쳐 요청, 수집될 수 있습니다.\n'
                                        '* 서비스 이용 과정에서 기기 정보(유저 에이전트), 이용 기록, 로그 기록(IP 주소, 접속 시간)이 자동으로 수집될 수 있습니다.',
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
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '서비스 이용약관',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            textColor: Color(0xff466FFF),
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
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '개인정보처리방침',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            textColor: Color(0xff466FFF),
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
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '커뮤니티 이용규칙 확인',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            textColor: Color(0xff466FFF),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '상품정보 및 혜택 수신 동의 내용 쭈르르르ㅡㄱ',
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
                        Expanded(
                          child: ExpansionTile(
                            title: Text(
                              '광고성 정보 수신 동의',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            textColor: Color(0xff466FFF),
                            children: <Widget>[
                              ListTile(
                                  title: Text(
                                    '상품정보 및 혜택 수신 동의 내용 쭈르르르ㅡㄱ',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.03,),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '에브리타임은 국내 대학생을 위한 서비스이며,\n'
                              '본인 인증을 통해 만 14세 이상만 가입할 수 있습니다.',
                          style: TextStyle(
                            fontSize: 12
                          ),
                        )
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
