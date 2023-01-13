import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/board_service.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/ui/board/edit_board_page.dart';

import '../../provider/auth_service.dart';
import '../../routes.dart';
import '../board/detail_board_page.dart';

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

    final authService = context.read<AuthService>();
    final userData = context.read<UserData>();
    final user = authService.currentUser();
    final boardService = context.read<BoardService>();
    final commentService = context.read<CommentService>();

    var phoneSize = MediaQuery.of(context).size;

    return FutureBuilder<dynamic>(
      future: Future.wait([
        boardService.readAll(user!.uid),
        commentService.readAll(user!.uid),
        userData.getUserData(user!.uid),
      ]),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }

        final docsBoard = snapshot.data[0]?.docs ?? [];
        final docsComment = snapshot.data[1]?.docs ?? [];
        final docsUser = snapshot.data[2]?.docs ?? [];

        return DefaultTabController(
          initialIndex: 0,
          length: 2,
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
                      fontWeight: FontWeight.w700,
                      fontSize: 16
                    ),
                  ),

                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(phoneSize.height * 0.12),
                child: Column(
                  children: [
                    Placeholder(fallbackHeight: 120),
                    SizedBox(height: phoneSize.height*0.03,),
                    Text(
                      userData.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: phoneSize.height*0.01,),
                    Text(
                      userData.mbti + ' | ' + userData.mbtiMean, //mbti 뜻 fb 에서 가져와야함~
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                      ),
                    ),
                    TabBar(
                      indicatorColor: Color(0xff466FFF),
                      labelColor: Color(0xff466FFF),
                      unselectedLabelColor: Color(0xffA0A3BD),
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                              '내 게시글',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          //icon: Icon(Icons.cloud_outlined),
                        ),
                        Tab(
                          child: Text(
                            '내 댓글',
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
            key: _scaffoldKey,
            body:
              TabBarView(
                children: <Widget>[
                  Center(
                    child: _buildBoardForm(context, docsBoard),
                  ),
                  Center(
                    child: _buildCommentForm(context, docsComment, boardService),
                  ),
                ],
              ),/*Align(
              alignment: Alignment.center,
              child: _buildForm(context),
            ),*/
          ),
        );
      }
    );
  }

  Widget _buildBoardForm(BuildContext context, docs) {
    var phoneSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {

        final doc = docs[index];
        String boardType = doc.get("boardType");
        String name = doc.get("name");
        DateTime createDate = doc.get("createDate").toDate();
        String content = doc.get("content");
        String title = doc.get("title");
        String likeNum = doc.get("likeNum").toString();
        String commentNum = doc.get("commentNum").toString();

        return Form(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      //해당 게시글로 이동될려나?
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailBoardScreen(boardType, doc.get("key"), doc.id, doc.get('userUid'))));
                    },
                    child: Container(
                      height: phoneSize.height*0.3,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(left: 15,top:20,right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Placeholder(fallbackHeight: 15,fallbackWidth: 15),
                                  SizedBox(width: phoneSize.width *0.03),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              boardType,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffA0A3BD)
                                            ),
                                          ),
                                          Text(
                                            '  .  ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffA0A3BD)
                                            ),
                                          ),
                                          Text(
                                              createDate.toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffA0A3BD)
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),//프로필 사진

                              IconButton(
                                icon: Icon(
                                    Icons.more_horiz,
                                  color: Color(0xff6E7191)
                                ),
                                onPressed: () {
                                  setState(() {
                                    //이거 무슨 기능 넣을건지 모름..
                                  });
                                },
                              )
                            ],
                          ),

                          Text(
                              content
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        print('기능');
                                      },
                                      icon: Icon(
                                          Icons.favorite_border,
                                        color: Color(0xffA0A3BD),
                                      )
                                  ),
                                  Text(
                                      likeNum,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                        color: Color(0xffA0A3BD)
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        //댓글로 바로 가지나여?
                                      },
                                      icon: Icon(
                                          Icons.forum_outlined,
                                          color: Color(0xffA0A3BD)
                                      )
                                  ),
                                  Text(
                                      commentNum,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffA0A3BD)
                                    ),
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
    );
  }

  Widget _buildCommentForm(BuildContext context, docs, BoardService boardService) {
    var phoneSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {

        final doc = docs[index];
        String comment = doc.get("comment");
        String name = doc.get("name");
        DateTime createDate = doc.get("createDate").toDate();

        return Form(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      boardService.readBoardType(doc.get('contentKey')).then((value){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailBoardScreen(value, doc.get("contentKey"), doc.id, doc.get('userUid'))));
                      });

                      //해당 게시글로 이동될려나?

                    },
                    child: Container(
                      height: phoneSize.height*0.26,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(left: 15,top:20,right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Placeholder(fallbackHeight: 15,fallbackWidth: 15),
                                  SizedBox(width: phoneSize.width *0.03),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '여기에 게시글 제목 들어가는게 맞지 않나?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              name,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffA0A3BD)
                                            ),
                                          ),
                                          Text(
                                            '  .  ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffA0A3BD)
                                            ),
                                          ),
                                          Text(
                                              createDate.toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffA0A3BD)
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),//프로필 사진
                              IconButton(
                                icon: Icon(
                                    Icons.more_horiz,
                                    color: Color(0xff6E7191)
                                ),
                                onPressed: () {
                                  setState(() {
                                    //이거 무슨 기능 넣을건지 모름..
                                  });
                                },
                              )
                            ],
                          ),

                          Text(
                              comment
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
                                      icon: Icon(
                                          Icons.favorite_border,
                                          color: Color(0xffA0A3BD)
                                      )
                                  ),
                                  Text(
                                      '좋아요 수',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffA0A3BD)
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  IconButton(
                                      onPressed: (){

                                      },
                                      icon: Icon(
                                          Icons.forum_outlined,
                                          color: Color(0xffA0A3BD)
                                      )
                                  ),
                                  Text(
                                      '댓글 수',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffA0A3BD)
                                    ),
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
    );
  }


}