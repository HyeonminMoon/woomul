import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/setting/password_check_page.dart';
import 'package:woomul/ui/setting/password_rewrite_page.dart';
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
          title: Text(
            '탈퇴하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff484848)
            ),
          ),
          centerTitle: true,
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
                index == 0 ? _buildForm1(context)
                    : index == 1 ? _buildForm3(context)
                    : _buildForm4(context)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
            color: (index == 0 || (_passwordController.text != ''))
                ? Color(0xff4D64F3)
                : Color(0xffD0D3E5), //1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
            child: InkWell(
              onTap: (){
                setState(() {
                  if(index == 0) {
                    index ++;
                  } else if(_passwordController.text != '') {
                    index ++;
                  } else {
                    authService.deleteUser();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                });

              },
              child: SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: Center(

                  child: Text(
                    index != 2 ? '다음' : 'WOOMUL로 돌아가기',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )),
      );
    });
  }

  Widget _buildForm1(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: phoneSize.height * 0.04,),
              Text(
                'WOOMUL 을 탈퇴하시면,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(height: phoneSize.height * 0.03,),
              Text(
                '다양한 WOOMUL 서비스에 액세스 할 수 있는 계정이 삭제되어 더 이상 WOOMUL 서비스를 이용할 수 없으며 계정과 데이터는 일정 기간 이후 파기됩니다.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14
                ),
              ),

              SizedBox(height: phoneSize.height * 0.04,),

              Text(
                '* 법령에 의해 개인정보를 보존해야 하는 경우, 해당 개인정보는 물리적, 논리적으로 분리하여 해당 법령에서 정한 기간에 따라 저장합니다.\n\n'
                    '* 회원 탈퇴, 보관 기한 만료 등 파기 사유가 발생한 개인정보는 재생이 불가능한 방법으로 파기됩니다. 전자적 파일 형태로 기록, 저장된 개인정보는 기록을 재생할 수 없도록 파기하며, 종이 문서에 기록, 저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6E7191)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm3(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: phoneSize.height * 0.04,),
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
                          _passwordController, "비밀번호를 입력해주세요.", "비밀번호가 일치하지 않습니다.", false),
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
                  '탈퇴 처리가 완료되었습니다.\n다시 만나요',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),

                SizedBox(
                  height: phoneSize.height * 0.01,
                ),

                //가입축하 이미지 넣기
                SizedBox(
                  width: phoneSize.width * 1,
                  height: phoneSize.height * 0.5,
                  child: Image.asset("assets/images/loginImage.png"),
                ),
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
