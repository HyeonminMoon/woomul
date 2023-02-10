import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/board/board_search_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/edit_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';

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

  var errorCheck;

  late TextEditingController _keywordController;

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

    _keywordController = TextEditingController(text: "");

    errorCheck = false;
  }

  @override
  void dispose() {
    super.dispose();

    _keywordController.dispose();
  }

  void paginatedData(String boardType) async {
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

    final authService = context.read<AuthService>();
    final user = authService.currentUser();

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
              fontSize: 16,
              fontWeight: FontWeight.w700
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
                    Icons.edit_outlined,
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
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: textFieldForm(_keywordController, "찾고싶은 키워드를 검색하세요", "아이디를 확인해주세요", false),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 3.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Color(0xff828796),
                          ),
                          onPressed: () {
                            //검색 결과 페이지로 이동
                            //검색어가 입력 됐을 경우(비어 있으면 검색 안 눌리게 하나욤? 일단 대애충 해놨슴미다)
                            if (_keywordController.toString() != '') {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(_keywordController.text)));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //얘를 여러 개 불러오도록 하면 됨
                if (widget.name != 'HOT 게시판' && widget.name != 'BEST 게시판')
                  _board1(context, boardService, user!.uid),
                if (widget.name == 'HOT 게시판')
                  _board2(context, boardService, 'commentNum', user!.uid),
                if (widget.name == 'BEST 게시판')
                  _board2(context, boardService, 'likeNum', user!.uid)
              ],
            ),
          ),
        ),
      );
    });
  }

  //게시글 UI
  //firebase 랑 model 이용해서 여러 개 불러오도록 하면 됩니다~
  Widget _board1(BuildContext context, BoardService boardService, String uid) {

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
                  String userUid = doc.get('userUid');
                  String mbti = doc.get('userMbti');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //자세히 보기로 이동
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailBoardScreen(
                                      widget.name, contentKey, docs[0].id, userUid)));
                        },
                        child: Container(
                          //height: phoneSize.height*0.25,
                          height: phoneSize.height*0.25,
                          margin: EdgeInsets.only(top: 10, bottom: 12),
                          padding: EdgeInsets.only(left: 15,top:20,right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
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
                                      Placeholder(
                                          fallbackHeight: 20,
                                          fallbackWidth: 20),//프로필 사진 들어가야 함~
                                      SizedBox(width: phoneSize.width * 0.03),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (title.length > 40)
                                            Text(
                                                "${title.substring(0, 40)}...",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: Color(0xff14142B)
                                              ),
                                            ),
                                          if (title.length <= 40)
                                            Text(
                                                title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: Color(0xff14142B)
                                              ),
                                            ),
                                          Row(
                                            children: [
                                              if (widget.name != '비밀게시판')
                                                Text(
                                                    userName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: Color(0xffA0A3BD)
                                                  ),
                                                ),
                                              if (widget.name == '비밀게시판')
                                                Text(
                                                    "익명",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13,
                                                      color: Color(0xffA0A3BD)
                                                  ),
                                                ),
                                              SizedBox(width: 5),
                                              Text(
                                                '.',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: Color(0xffA0A3BD)
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                  formattedDate,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: Color(0xffA0A3BD)
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (userUid == uid)//프로필 사진
                                  Icon(
                                      Icons.more_horiz,
                                    color: Color(0xff6E7191),
                                  )
                                ],
                              ),
                              if (content.length > 50)
                                Text(
                                    '${content.substring(0,40)}...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                              if (content.length <= 50)
                                Text(
                                  content,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400
                                  ),),
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
                                          icon: Icon(
                                              Icons.favorite_border,
                                            color: Color(0xffA0A3BD),
                                            size: 15,
                                          )
                                      ),
                                      Text(
                                          likeNum.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xffA0A3BD),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.forum_outlined,
                                            color: Color(0xffA0A3BD),
                                            size: 15,
                                          )
                                      ),
                                      Text(
                                          commentNum.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xffA0A3BD),
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
                  );
                });
          }),
    );
  }

  Widget _board2(
      BuildContext context, BoardService boardService, String boardType, String uid) {
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
              String userUid = doc['userUid'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //자세히 보기로 이동
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailBoardScreen(widget.name, contentKey, doc['id'], userUid)));
                    },
                    child: Container(
                      //height: phoneSize.height*0.25,
                      height: phoneSize.height*0.25,
                      margin: EdgeInsets.only(top: 10, bottom: 12),
                      padding: EdgeInsets.only(left: 15,top:20,right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                                    Placeholder(
                                        fallbackHeight: 20,
                                        fallbackWidth: 20),
                                    SizedBox(width: phoneSize.width * 0.03),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (title.length > 40)
                                          Text(
                                            '${title.substring(0, 40)}...',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                                color: Color(0xff14142B)
                                            ),
                                          ),
                                        if (title.length <= 50)
                                          Text(
                                            title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                                color: Color(0xff14142B)
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            Text(
                                              userName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              date.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: Color(0xffA0A3BD)
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ), //프로필 사진
                                if (userUid == uid)
                                Icon(
                                  Icons.more_horiz,
                                  color: Color(0xff6E7191),
                                )
                              ],
                            ),
                            if (content.length > 50)
                              Text(
                                '${content.substring(0,50)}...',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            if (content.length <= 50)
                              Text(
                                content,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                ),
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
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: Color(0xffA0A3BD),
                                          size: 15,
                                        )),
                                    Text(
                                      likeNum.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffA0A3BD),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.forum_outlined,
                                          color: Color(0xffA0A3BD),
                                          size: 15,
                                        )),
                                    Text(
                                      commentNum.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffA0A3BD),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                    ),
                  )
                ],
              );
            }));
  }

  Widget textFieldForm(TextEditingController controller, String labelText, String errorText,
      bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        onTap: () {
          //scontroller.animateTo(120.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        obscureText: obscure,
        controller: controller,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Color(0xffA0A3BD)),
        cursorColor: Color(0xffA0A3BD),
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
            labelStyle: TextStyle(color: Color(0xFF0000) //Theme.of(context).colorScheme.primary,
            ),
            hintStyle: TextStyle(
                color: Color(0xff828796),
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),
            hintText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Color(0xFF0000) /*Theme.of(context).colorScheme.surface*/),
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF0000))),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffFF6868)))),
      ),
    );
  }

}
