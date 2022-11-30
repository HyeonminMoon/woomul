import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../routes.dart';

class DetailBoardScreen extends StatefulWidget {
  @override
  _DetailBoardScreenState createState() => _DetailBoardScreenState();
}

class _DetailBoardScreenState extends State<DetailBoardScreen> {

  late TextEditingController _commentController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var errorCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentController = TextEditingController(text: "");
    errorCheck = false;

  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '자유게시판',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {

          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _board1(context),
                  _commentPart(context),
                ],
              ),

              Positioned(
                  bottom: 0,
                  child: Container(
                    width: phoneSize.width,
                    color: Colors.white,
                    child: Row(
                      children: [
                        /*Expanded(
                          child: textFieldForm(
                              _commentController, "아이디를 입력해주세요.", "아이디를 확인해주세요", false),
                        ),*/
                        Container(
                          width:phoneSize.width*0.5,
                          child: textFieldForm(
                              _commentController, "", "", false),
                        ),
                        SizedBox(width: phoneSize.width*0.2,),
                        TextButton(
                          onPressed: () {
                            //댓글 내용 fb 에 전송해서 저장
                          },
                          child: Text(
                            '저장'
                          )

                        )
                      ],
                    )
                  )
              ),
            ]
          ),
        ),
      ),


    );

  }

  //게시글 detail UI
  Widget _board1(BuildContext context){
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //height: phoneSize.height*0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Placeholder(fallbackHeight: 15,fallbackWidth: 15),//프로필 사진
                    SizedBox(width: phoneSize.width *0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '닉네임'
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                'mbti'
                            ),
                            SizedBox(width:10),
                            Text(
                                'mbti 뜻'
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.48),
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                        Icon(Icons.bookmark_border_outlined)
                      ],
                    )
                  ],
                ),

                Text(
                  '제목',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),

                SizedBox(height: phoneSize.height*0.02),

                Text(
                    '게시글 내용 살짝 보이게 어쩌고저쩌고\n'
                        'mbti 가 어쩌고 저쩌고 해서 했는데\n'
                        '사실 내 mbti 는 이건데 걔는 이거고'
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                'image + 좋아요 숫자'
                            )
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                                '대표 닉네임 님 외 n인이 좋아합니다.'
                            )
                          ],
                        )
                      ],
                    ),

                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _commentPart(BuildContext context){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '댓글 전체보기 '//댓글 수 받아오기
              ),
              Text(
                  '(댓글수)',
                style: TextStyle(
                  color: Colors.blue
                ),
              )
            ],
          ),

          SizedBox(height: 10),

          //댓글 불러오기
          _comment(),
        ],
      )
    );
  }

  //댓글 하나하나
  Widget _comment(){
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: phoneSize.width,
            height: phoneSize.height*0.19,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Placeholder(fallbackHeight: 15,fallbackWidth: 15),//프로필 사진
                    SizedBox(width: phoneSize.width *0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                '닉네임'
                            ),
                            Text(
                              ' . '
                            ),
                            Text(
                              'mbti'
                            )
                          ],
                        ),
                        SizedBox(height: phoneSize.height*0.02),
                      ],
                    ),
                    SizedBox(width: phoneSize.width * 0.45),
                    Text(
                      '작성시간'
                    )
                  ],
                ),
                Text(
                  '난 내가 enfp 아닌거 같은데 주변에선 맞다고 그러거든 근데 어쩌고저쩌고'
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              //클릭 되면, 색 채워지고(user 데이터 불러와야 할듯)
                              //횟수 증가 되도록
                            },
                            icon: Icon(Icons.favorite_border)
                        ),
                        Text(
                            '좋아요 수'
                        )
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                            onPressed: (){

                            },
                            icon: Icon(Icons.forum_outlined)
                        ),
                        Text(
                            '댓글 수'
                        )
                      ],
                    )
                  ],
                )

              ],
            ),
          ),
        ],
      )
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
                color: Color(0xFF0000)//Theme.of(context).colorScheme.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            filled: true,
            fillColor: Color(0xffFCFCFC),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEFF0F7))),
            errorBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }






}


