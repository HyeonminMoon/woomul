import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/edit_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';

import '../../provider/board_service.dart';
import '../../routes.dart';

class FreeBoardScreen extends StatefulWidget {
  final String name;

  const FreeBoardScreen(this.name, {super.key});

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

    return Consumer<BoardService>(builder: (context, boardService, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            '${widget.name}',
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardScreen()));
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditBoardScreen()));
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //얘를 여러 개 불러오도록 하면 됨
                _board1(context, boardService),
              ],
            ),
          ),
        ),
      );
    });
  }

  //게시글 UI
  //firebase 랑 model 이용해서 여러 개 불러오도록 하면 됩니다~
  Widget _board1(BuildContext context, BoardService boardService) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
          future: boardService.read(widget.name),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? [];
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  String title = doc.get('title');
                  String userName = doc.get('name');
                  DateTime date = doc.get('createDate').toDate();
                  String content = doc.get('content');
                  String contentKey = doc.get('key');
                  int likeNum = doc.get('likeNum');
                  int commentNum = doc.get('commentNum');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //자세히 보기로 이동
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailBoardScreen(widget.name, contentKey)));
                        },
                        child: Container(
                          //height: phoneSize.height*0.25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Placeholder(
                                      fallbackHeight: 15,
                                      fallbackWidth: 15), //프로필 사진
                                  SizedBox(width: phoneSize.width * 0.03),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(title),
                                      Row(
                                        children: [
                                          Text(userName),
                                          SizedBox(width: 10),
                                          Text(date.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(width: phoneSize.width * 0.48),
                                  Icon(Icons.more_horiz)
                                ],
                              ),
                              Text(content),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            //클릭 되면, 색 채워지고(user 데이터 불러와야 할듯)
                                            //횟수 증가 되도록
                                          },
                                          icon: Icon(Icons.favorite_border)),
                                      Text(likeNum.toString())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.forum_outlined)),
                                      Text(commentNum.toString())
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
    );
  }
}
