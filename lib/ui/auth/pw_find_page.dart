import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/login_home_page.dart';

import '../../provider/auth_service.dart';

class pwFindScreen extends StatefulWidget {
  const pwFindScreen({Key? key}) : super(key: key);

  @override
  _pwFindScreenState createState() => _pwFindScreenState();
}

class _pwFindScreenState extends State<pwFindScreen> {
  var index;
  var errorCheck;

  late TextEditingController _emailController;

  bool emailChecked = false;
  bool emailDoubleChecked = false;
  bool isChecked = false;
  bool emptyEmail = true;
  bool wrongEmail = true;
  bool checker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = 0;

    checker == false;

    _emailController = TextEditingController(text: "");

    errorCheck = false;
    isChecked = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForm(context, authService)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
            color: (emptyEmail == false && wrongEmail == false && emailDoubleChecked == true)
                ? Color(0xff4D64F3)
                : Color(0xffD0D3E5), //1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
            child:  (emptyEmail == false && wrongEmail == false && emailDoubleChecked == true)
                ? InkWell(
              onTap: () {
                //print('안녕');
                authService.resetPW(_emailController.text);
                setState(() {

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => emailSendScreen()));
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
                : InkWell(
              onTap: (){

                /*
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BoardScreen()));
                 */
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


  Widget _buildForm(BuildContext context, AuthService authService) {
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
                  '가입시 등록한',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),
                Text(
                  '이메일(아이디) 주소를 입력해주세요.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff4E4B66)),
                ),

                SizedBox(height: phoneSize.height * 0.07),

                Text(
                  '이메일',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4E4B66)),
                ),

                Row(
                  children: [

                    Container(
                      width: phoneSize.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textFieldForm(_emailController, "새로운 비밀번호를 입력해주세요.", "", false, false, 1),
                        ],
                      ),
                    ),

                    SizedBox(width: phoneSize.width * 0.03,),
                    Container(
                      height: phoneSize.height * 0.06,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          checker = true;

                          if (_emailController.text == ''){
                            emptyEmail = true;
                          } else {
                            emptyEmail = false;

                            if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(_emailController.text)){
                              wrongEmail = true;
                            } else {
                              wrongEmail = false;

                              if (await authService.doubleCheck(_emailController.text) == true) {
                                emailDoubleChecked = true;
                              } else {
                                print('이메일 없는데?');
                              }
                            }
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
                if (checker != false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        emptyEmail == true ?
                        '이메일을 입력해주세요.' :
                        wrongEmail == true ?
                        '이메일 형식을 확인해주세요' :
                        emailDoubleChecked == false ?
                        '가입되지 않은 이메일 입니다' : ' '
                        ,
                        style: TextStyle(
                            color: Color(0xffFF6868)
                        ),
                      )
                    ],
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


class emailSendScreen extends StatefulWidget {
  const emailSendScreen({Key? key}) : super(key: key);

  @override
  _emailSendScreenState createState() => _emailSendScreenState();
}

class _emailSendScreenState extends State<emailSendScreen> {
  @override
  Widget build(BuildContext context) {

    var phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
          child: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '인증 메일 발송 완료',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xff14142B)),
                  ),

                  SizedBox(
                    height: phoneSize.height * 0.07,
                  ),

                  Image(
                      image: AssetImage('assets/images/Mailbox.gif')
                  ),
                  Row(
                    children: [
                      Text('woomul_dev@gmail.com', style: TextStyle(color: Colors.blueAccent),),
                      Text(' 로 전송한')
                    ],
                  ),
                  Text('이메일을 확인하여 가입 절차를 완료해주세요')
                ],
              ),
            ),
          )),
    );
  }
}

