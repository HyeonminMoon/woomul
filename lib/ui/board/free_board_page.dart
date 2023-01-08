import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/edit_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';
import 'package:intl/intl.dart';

import '../../provider/auth_service.dart';
import '../../provider/board_service.dart';
import '../../routes.dart';
import 'package:intl/intl.dart';

class FreeBoardScreen extends StatefulWidget {
  final String name;

  const FreeBoardScreen(this.name, {super.key});

  @override
  _FreeBoardScreenState createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends State<FreeBoardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? lastDocument;
  List<Map<String, dynamic>> list = [];
  final ScrollController _pageController = ScrollController();
  bool isMoreData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paginatedData(widget.name);

    _pageController.addListener(() {
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        paginatedData(widget.name);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void paginatedData(String boardType) async {
    print(boardType);
    if (isMoreData) {
      final collectionReference = _firestore.collection('board');

      late QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (lastDocument == null) {
        if (boardType != 'HOT 게시판' && boardType != 'BEST 게시판') {
          querySnapshot = await collectionReference
              .where('boardType', isEqualTo: boardType)
              .orderBy('createDate', descending: true)
              .limit(6)
              .get();
        } else {
          String data = '';
          String date = DateFormat('yyyyMM').format(DateTime.now());

          if (boardType == 'HOT 게시판') {
            data = 'commentNum';
          } else {
            data = 'likeNum';
          }

          querySnapshot = await collectionReference
              .where("createDateMonth", isEqualTo: date)
              .orderBy(data, descending: true)
              .limit(6)
              .get();
        }
      } else {
        if (boardType != 'HOT 게시판' && boardType != 'BEST 게시판') {
          querySnapshot = await collectionReference
              .where('boardType', isEqualTo: boardType)
              .orderBy('createDate', descending: true)
              .limit(6)
              .startAfterDocument(lastDocument!)
              .get();
        } else {
          String data = '';
          String date = DateFormat('yyyyMM').format(DateTime.now());

          if (boardType == 'HOT 게시판') {
            data = 'commentNum';
          } else {
            data = 'likeNum';
          }

          querySnapshot = await collectionReference
              .where("createDateMonth", isEqualTo: date)
              .orderBy(data, descending: true)
              .limit(6)
              .startAfterDocument(lastDocument!)
              .get();
        }
      }

      lastDocument = querySnapshot.docs.last;
      print('lastDocument입니다');
      print(lastDocument);

      list.addAll(querySnapshot.docs.map((e) => e.data()));
      setState(() {});

      if (querySnapshot.docs.length < 6) {
        isMoreData = false;
      }
    } else {
      print("No More Data");
    }
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
              Navigator.pop(context);
            },
          ),
          actions: [
            if (widget.name != 'HOT 게시판' && widget.name != 'BEST 게시판')
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
                if (widget.name != 'HOT 게시판' && widget.name != 'BEST 게시판')
                  _board1(context, boardService),
                if (widget.name == 'HOT 게시판')
                  _board2(context, boardService, 'commentNum'),
                if (widget.name == 'BEST 게시판')
                  _board2(context, boardService, 'likeNum')
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
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
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
                                  builder: (context) => DetailBoardScreen(
                                      widget.name, contentKey)));
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
                                      if (title.length > 50)
                                        Text("${title.substring(0, 40)}..."),
                                      if (title.length <= 50) Text(title),
                                      Row(
                                        children: [
                                          if (widget.name != '비밀게시판')
                                            Text(userName),
                                          if (widget.name == '비밀게시판')
                                            Text("익명"),
                                          SizedBox(width: 10),
                                          Text(formattedDate)
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(width: phoneSize.width * 0.2),
                                  Icon(Icons.more_horiz)
                                ],
                              ),
                              if (content.length > 50)
                                Text('${content.substring(0, 40)}...'),
                              if (content.length <= 50)
                                Text(
                                  content,
                                  overflow: TextOverflow.ellipsis,
                                ),
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

  Widget _board2(
      BuildContext context, BoardService boardService, String boardType) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
        child: ListView.builder(
            controller: _pageController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final doc = list[index];
              String title = doc['title'];
              String userName = doc['name'];
              DateTime date = doc['createDate'].toDate();
              String content = doc['content'];
              String contentKey = doc['key'];
              int likeNum = doc['likeNum'];
              int commentNum = doc['commentNum'];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title.length > 50)
                                    Text('${title.substring(0, 50)}...'),
                                  if (title.length <= 50) Text(title),
                                  Row(
                                    children: [
                                      Text(userName),
                                      SizedBox(width: 10),
                                      Text(date.toString())
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(width: phoneSize.width * 0.2),
                              Icon(Icons.more_horiz)
                            ],
                          ),
                          if (content.length > 50)
                            Text('${content.substring(0, 50)}...'),
                          if (content.length <= 50) Text(content),
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
            }));
  }
}
