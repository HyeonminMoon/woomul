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

class PassWordEditScreen extends StatefulWidget {
  @override
  _PassWordEditScreenState createState() => _PassWordEditScreenState();
}

class _PassWordEditScreenState extends State<PassWordEditScreen> {
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
                /*
                index == 0
                    ? _buildForm1(context, authService)
                    : index == 1
                    ?_buildForm3(context, authService)
                    :_buildForm4(context),*/
                index == 0
                  ? _buildForm3(context, authService)
                    : _buildForm4(context)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
            color: (index == 0 && _passwordController.text != '' && _passwordCheckController.text != '') || index == 2
                ? Color(0xff4D64F3)
                : Color(0xffD0D3E5), //1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
            child: (index == 0 && _passwordController.text != '' && _passwordCheckController.text != '')
                ? InkWell(
              onTap: () {
                setState(() {
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
                  }
                });
              },
              child: SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: Center(
                  child: Text(
                    index != 0 ? '확인' : '댜음',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )
                : InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BoardScreen()));
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
                  '비밀번호 재설정',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '가입하신 이메일(아이디)를 입력해주세요.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),

                SizedBox(height: phoneSize.height * 0.07),

                Text(
                  '이메일',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                ),

                textFieldForm(_emailController, "가입하신 이메일을 입력해주세요.", "가입하지 않은 이메일입니다.", false, false, 1),

              ],
            ),
          ),
        ));
  }



  Widget _buildForm3(BuildContext context, AuthService authService) {
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
                  '비밀번호 재설정',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '새로운 비밀번호를 입력해주세요.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),

                SizedBox(height: phoneSize.height * 0.07),


                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '새로운 비밀번호',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                    ),

                    textFieldForm(_passwordController, "새로운 비밀번호를 입력해주세요.", "", true, false, 1),

                    SizedBox(height: phoneSize.height * 0.02,),

                    Text(
                      '새로운 비밀번호 확인',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                    ),

                    //비번 일치 하지 않으면 일치 하지 않다고 알려주는 기능 추가 해야함
                    textFieldForm(_passwordCheckController, "새로운 비밀번호를 입력해주세요", "비밀번호가 일치하지 않습니다.",
                        true, false, 1),
                  ],
                )
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
                  '비밀번호가\n재설정되었어요!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                ),

                SizedBox(
                  height: phoneSize.height * 0.07,
                ),

                Image(
                  image: AssetImage('assets/images/Lockanimation.gif')
                )
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
