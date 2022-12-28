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
                    ),
                  ),
                  Placeholder(fallbackHeight: 120), //프로필 사진 가져오기
                  Text(
                    userData.name,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    userData.mbti + ' | ' + 'mbti닉',
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
                ],
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
                                  DetailBoardScreen(boardType, doc.get("key"))));
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
                                      boardType
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          name
                                      ),
                                      SizedBox(width:10),
                                      Text(
                                          createDate.toString()
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
                              content
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
        String data = '없다';

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
                                    DetailBoardScreen(value, doc.get("contentKey"))));
                      });

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
                                      '댓글'
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          name
                                      ),
                                      SizedBox(width:10),
                                      Text(
                                          createDate.toString()
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
    );
  }


}