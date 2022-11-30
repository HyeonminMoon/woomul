import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../routes.dart';

class FreeBoardScreen extends StatefulWidget {
  @override
  _FreeBoardScreenState createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends State<FreeBoardScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
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
        actions: [
          IconButton(
              onPressed: (){
                //글쓰기 페이지로 이동
              },
              icon: Icon(Icons.edit, color: Colors.black,))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //얘를 여러 개 불러오도록 하면 됨
              _board1(context),
            ],
          ),
        ),
      ),


    );

  }

  //게시글 UI
  //firebase 랑 model 이용해서 여러 개 불러오도록 하면 됩니다~
  Widget _board1(BuildContext context){
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //자세히 보기로 이동
            },
            child: Container(
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
                          Text(
                            '제목'
                          ),
                          Row(
                            children: [
                              Text(
                                '닉네임'
                              ),
                              SizedBox(width:10),
                              Text(
                                '올린 시간'
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(width: phoneSize.width * 0.48),
                      Icon(Icons.more_horiz)
                    ],
                  ),

                  Text(
                    '게시글 내용 살짝 보이게 어쩌고저쩌고\n'
                        'mbti 가 어쩌고 저쩌고 해서 했는데\n'
                        '사실 내 mbti 는 이건데 걔는 이거고'
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
          )
        ],
      ),
    );
  }






}


