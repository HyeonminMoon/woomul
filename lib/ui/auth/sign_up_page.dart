import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var index;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  var errorCheck;

  bool mbti1 = false;
  bool mbti2 = false;
  bool mbti3 = false;
  bool mbti4 = false;

  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = 0;
    _emailController = TextEditingController(text: "");
    _nameController = TextEditingController(text: "");
    _birthController = TextEditingController(text: "");
    errorCheck = false;
    mbti1 = false;
    mbti2 = false;
    mbti3 = false;
    mbti4 = false;
    isChecked = false;
    print(index);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _birthController.dispose();
    index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              index--;
            });
            print(index);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xffEDEFEF),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color(0xffEDEFEF),
                      )
                    ),
                    child: Text(
                      '1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff8E9191),
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ),
                  Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Color(0xffEDEFEF),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xffEDEFEF),
                          )
                      ),
                      child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff8E9191),
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                  Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Color(0xffEDEFEF),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xffEDEFEF),
                          )
                      ),
                      child: Text(
                        '3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff8E9191),
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                ],
              ),

              index == 0 ? _buildForm1(context)
              : index == 1 ? _buildForm2(context)
              : _buildForm3(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: const Color(0xffD0D3E5),//1번 페이지의 경우, 이메일 인증 후에 색 바뀔 수 있도록
        child: InkWell(
          onTap: () {
            setState(() {
              //index 가 2보다 작을 동안만 되도록 바꾸기
              //3이 되면 회원 가입 완료 페이지로 넘어가도록
              //인증 완료 및 입력값이 다 들어갔을 경우에 색이 바뀌고, 페이지 바뀌도록 하는 기능
              index ++;
            });
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                '다음',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),

    );

  }

  Widget _buildForm1(BuildContext context) {
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
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  '안녕하세요!\n'
                      '이메일(아이디) 인증 후 회원가입을 진행해주세요.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(height: phoneSize.height * 0.08),
                
                Text(
                  '이메일'
                ),

                textFieldForm(
                    _emailController, "이메일을 입력해주세요.", "이메일을 확인해주세요", false),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //이메일 인증 요청 팝업
                        //인증 메일 전송 기능
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffECF1FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                          '인증요청',
                        style: TextStyle(
                          color: Colors.blue
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
                Text(
                  '회원정보 입력',
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  'WOOMUL에서 사용할 정보들을 입력해주세요.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(height: phoneSize.height * 0.08),

                Text(
                    '닉네임'
                ),

                textFieldForm(
                    _nameController, "이메일을 입력해주세요.", "이메일을 확인해주세요", false),

                SizedBox(height: phoneSize.height * 0.03),

                Text(
                    '생년월일'
                ),

                textFieldForm(
                    _birthController, "생년월일을 입력해주세요.", "생년월일을 확인해주세요", false),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'E',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: phoneSize.height * 0.01),

                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'I',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: phoneSize.width * 0.02),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'S',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: phoneSize.height * 0.01),

                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'N',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: phoneSize.width * 0.02),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'T',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: phoneSize.height * 0.01),

                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'F',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: phoneSize.width * 0.02),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'J',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: phoneSize.height * 0.01),

                        Container(
                          width: 75,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              //색 바뀌게 하고, 해당 정보 값 저장하기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'P',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
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
                ),
                SizedBox(height: phoneSize.height * 0.01),
                Text(
                  'WOOMUL 서비스를 이용하시려면\n'
                      '필수 약관에 동의가 필요합니다.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(height: phoneSize.height * 0.08),

                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;

                          // 전체 동의 되는 기능 추가
                          // 선택 됐음을 알려주는 기능 추가
                        });
                      },
                    ),

                    SizedBox(height: phoneSize.width * 0.01),

                    Text(
                        'WOOMUL 이용약관 전체동의'
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 6, 0, 6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, size: 20,),
                            onPressed: () {
                              setState(() {
                                //색 바뀌기
                                //선택 됐음 알려주는 기능 추가
                              });
                            },
                          ),
                          Text(
                            '[필수] 어쩌고저쩌고'
                          )
                        ],
                      ),
                    ],
                  ),
                )




              ],
            ),
          ),
        ));
  }

  Widget textFieldForm(TextEditingController controller, String labelText,
      String errorText, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4)
            )
          ]
        ),
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
              filled: true,
              fillColor: Colors.white,
              labelText: labelText,
              labelStyle: TextStyle(
                  color: Colors.white//Theme.of(context).colorScheme.primary,
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
      ),
    );
  }


}