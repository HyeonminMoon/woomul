import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import '../../provider/auth_service.dart';
import 'mbti_test_page.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import '../../routes.dart';

List<String> listSex = <String>['여', '남'];

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var index;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCheckController;

  DateTime? selectedDate;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate.toString());
      });
    }
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
                index != 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: index == 0
                                      ? Color.fromRGBO(77, 100, 243, 0.1)
                                      : Color(0xffEDEFEF),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: index == 0 ? Color(0xff4D64F3) : Color(0xffEDEFEF),
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: index == 0 ? Color(0xff4D64F3) : Color(0xff8E9191),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(width: 7),
                          Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: index == 1
                                      ? Color.fromRGBO(77, 100, 243, 0.1)
                                      : Color(0xffEDEFEF),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: index == 1 ? Color(0xff4D64F3) : Color(0xffEDEFEF),
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '2',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff8E9191),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                          SizedBox(width: 7),
                          Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: index == 2
                                      ? Color.fromRGBO(77, 100, 243, 0.1)
                                      : Color(0xffEDEFEF),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: index == 2 ? Color(0xff4D64F3) : Color(0xffEDEFEF),
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff8E9191),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ],
                      )
                    : Container(),
                index == 0
                    ? _buildForm1(context, authService)
                    : index == 1
                        ? _buildForm2(context, authService)
                        : index == 2
                            ? _buildForm3(context)
                            : _buildForm4(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
            color: (index == 0 && _emailController.text != '' && emailDoubleChecked == true
                && _passwordController.text != '' && _passwordCheckController.text != '') ||
                    (index == 1 && _nameController.text != '' && selectedDate != null) ||
                    (index == 2 && term1 == true && term2 == true && term3 == true && term4 == true)
                ? Color(0xff4D64F3)
                : Color(0xffD0D3E5), //1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
            child: (index == 0 && _emailController.text != '') ||
                    (index == 1 && _nameController.text != '' && selectedDate != null) ||
                    (index == 2 && term1 == true && term2 == true && term3 == true && term4 == true)
                ? InkWell(
                    onTap: () {
                      setState(() {
                        //index 가 2보다 작을 동안만 되도록 바꾸기
                        //3이 되면 회원 가입 완료 페이지로 넘어가도록
                        //인증 완료 및 입력값이 다 들어갔을 경우에 색이 바뀌고, 페이지 바뀌도록 하는 기능
                        if (index == 0) {
                          if (_passwordController.text != _passwordCheckController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("비밀번호가 일치하지 않습니다."),
                            ));
                          } else {
                            if (_passwordController.text.length < 8 ||
                                _passwordController.text.length > 20) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("비밀번호 길이는 8자 이상, 20자 이하로 설정해주세요"),
                              ));
                            } else {
                              index++;
                            }
                          }
                        } else if (index == 1) {
                          index++;
                        } else if (index == 2) {
                          //mbti 계산 로직직

                          String mbti = '';
                          String mbtiWord1 = 'E';
                          String mbtiWord2 = 'S';
                          String mbtiWord3 = 'T';
                          String mbtiWord4 = 'J';

                          mbti1 == false ? mbtiWord1 = 'E' : mbtiWord1 = 'I';
                          mbti2 == false ? mbtiWord2 = 'S' : mbtiWord2 = 'N';
                          mbti3 == false ? mbtiWord3 = 'T' : mbtiWord3 = 'F';
                          mbti4 == false ? mbtiWord4 = 'J' : mbtiWord4 = 'P';

                          mbti = mbtiWord1 + mbtiWord2 + mbtiWord3 + mbtiWord4;

                          authService.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              onSuccess: () {

                                authService.signIn(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    onSuccess: () {
                                      // 로그인 성공

                                      final user = authService.currentUser();

                                      if (user != null) {
                                        authService.createUserData(
                                            uid: user.uid,
                                            email: _emailController.text,
                                            name: _nameController.text,
                                            sex: dropdownValue,
                                            birth: int.parse(DateFormat("yyyyMMdd").format(selectedDate!)),
                                            mbti: mbti,
                                            mbtiMean: meanMBTI(mbti)!,
                                            marketingPush: term5,
                                            signupDate: DateTime.now(),
                                            deleteDate: null);
                                      }

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => BoardScreen()));
                                    },
                                    onError: (err) {
                                      // 에러 발생
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(err),
                                      ));
                                    });
                              },
                              onError: (err) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(err),
                                ));
                              });
                        }
                      });
                    },
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          index != 3 ? '다음' : 'WOOMUL 시작하기',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
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

            //textFieldForm(_emailController, "가입하실 이메일을 입력해주세요.", "이메일을 확인해주세요", false, false, 1),

            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: phoneSize.width * 0.6,
                    child: textFieldForm(_emailController, "가입하실 이메일을 입력해주세요.", "이메일을 확인해주세요", false, false, 1)),
                SizedBox(width: phoneSize.width * 0.03,),
                Container(
                  height: phoneSize.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () async {
                      // 여기 체크해봐야함! [ERROR]
                      if (await authService.doubleCheck(_emailController.text) == true) {
                        emailDoubleChecked = false;
                      } else {
                        emailDoubleChecked = true;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffECF1FF),
                      side: BorderSide(
                        color: Color(0xffB1C7FF)
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      '중복 확인',
                      style: TextStyle(
                          color: Color(0xff466FFF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),

            _emailController.text != '' && emailDoubleChecked == false ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '이미 가입된 이메일입니다.',
                  style: TextStyle(
                    color: Color(0xffFF6868)
                  ),
                )
              ],
            ) : _emailController.text != '' && emailDoubleChecked == true ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '가입이 가능한 이메일입니다.',
                  style: TextStyle(
                      color: Color(0xff3462FF)
                  ),
                )
              ],
            ):Container(),

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

  Widget _buildForm2(BuildContext context, AuthService authService) {
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
            Row(
              children: [
                Container(
                  width: phoneSize.width * 0.6,
                    child: textFieldForm(_nameController, "닉네임을 입력해주세요.", "닉네임을 확인해주세요", false, false, 2)),

                SizedBox(width: phoneSize.width * 0.03,),

                ElevatedButton(
                  onPressed: () async {
                    // 닉네임 중복 기능 추가
                    if (await authService.doubleCheck2(_nameController.text) == true) {
                      nameChecked = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("이미 있는 닉네임입니다"),
                      ));
                    } else {
                      nameChecked = true;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffECF1FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(
                      color: Color(0xffB1C7FF),
                    )
                  ),
                  child: Text(
                    '중복 확인',
                    style: TextStyle(
                        color: Color(0xff466FFF), fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
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

                    SizedBox(height: phoneSize.height * 0.01),

                    GestureDetector(
                      onTap: () {
                        //달력 picker 켜지기

                        _selectDate(context);
                      },
                      child: Container(
                        width: phoneSize.width * 0.56,
                        height: phoneSize.height* 0.062,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (selectedDate == null)
                                Text(
                                '생년월일 (YYYYMMDD)',//나중에 picker 로 값 가져오면 텍스트 바뀌도록 해야함
                                  style: TextStyle(
                                    color: Color(0xffA0A3BD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              if (selectedDate != null)
                                Text(
                                  DateFormat("yyyyMMdd").format(selectedDate!),//나중에 picker 로 값 가져오면 텍스트 바뀌도록 해야함
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),

                              Icon(
                                Icons.calendar_month,
                                color: Color(0xffA0A3BD),
                              )
                            ],
                          )

                        //textFieldForm(_birthController, "생년월일 (YYYYMMDD)", "생년월일을 확인해주세요", false, true, 3),
                      ),
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
            //textFieldForm(_birthController, "생년월일 (YYYYMMDD)", "생년월일을 확인해주세요", false, true, 3),
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
