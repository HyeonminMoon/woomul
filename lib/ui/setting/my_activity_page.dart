import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class MyActivityScreen extends StatefulWidget {
  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {

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

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 230,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                '내 활동',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Placeholder(fallbackHeight: 120), //프로필 사진 가져오기
              Text(
                '닉네임',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                'MBTI | 엠비티아이닉',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                    '내 게시글',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                //icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                child: Text(
                  '내 댓글',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '저장 게시물',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '좋아요',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
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
        key: _scaffoldKey,
        body:
          TabBarView(
            children: <Widget>[
              Center(
                child: _buildForm(context),
              ),
              Center(
                child: _buildForm(context),
              ),
              Center(
                child: _buildForm(context),
              ),
              Center(
                child: _buildForm(context),
              ),
            ],
          ),/*Align(
          alignment: Alignment.center,
          child: _buildForm(context),
        ),*/
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  //해당 게시글로 이동될려나?
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
        ));
  }


}