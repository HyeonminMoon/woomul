import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/provider/fcm_service.dart';
import 'package:woomul/provider/like_service.dart';
import '../../provider/auth_service.dart';
import '../../provider/board_service.dart';
import '../../routes.dart';
import 'package:intl/intl.dart';

class DetailBoardScreen extends StatefulWidget {
  final String name;
  final String contentKey;

  const DetailBoardScreen(this.name, this.contentKey, {super.key});

  @override
  _DetailBoardScreenState createState() => _DetailBoardScreenState();
}

class _DetailBoardScreenState extends State<DetailBoardScreen> {
  late TextEditingController _commentController =
      TextEditingController(text: "");

  var errorCheck;

  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentController = TextEditingController();
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

    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();
    final boardService = context.read<BoardService>();
    final fcmService = context.read<FcmService>();

    return Consumer2<CommentService, LikeService>(
        builder: (context, commentService, likeService, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            widget.name,
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
        ),
        body: SafeArea(
          child: FutureBuilder<dynamic>(
              future: Future.wait([
                boardService.readOne(widget.contentKey), //게시글 한개 불러오기
                likeService.readOne(user!.uid, widget.contentKey), // 해당 유저가 좋아요 눌렀나 안눌렀나 체크
                likeService.read(widget.contentKey), // 이 게시글에 달린 좋아요 수
                userData.getUserData(user!.uid), // 유저 데이터 불러오기
                commentService.read(widget.contentKey) //댓글 읽기
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                final docs = snapshot.data![0].docs ?? [];
                final docs2 = snapshot.data![1].docs ?? [];
                final docs3 = snapshot.data![2].docs ?? [];
                final docs5 = snapshot.data![4].docs ?? [];

                // 스몰아이즈 : 게시글 작성자 uid
                final String boardWriteUid = docs[0].get('userUid');

                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _board1(context, boardService, likeService, userData,
                                  user!.uid, docs, docs2, docs3),
                              _commentPart(
                                  context, commentService, boardService, docs5),
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 5, top: 5, bottom: 5),
                                  margin: EdgeInsets.zero,
                                  width: phoneSize.width,
                                  height: phoneSize.height*0.09,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //댓글칸 조정하기
                                      Container(
                                        width: phoneSize.width * 0.75,
                                        child: textFieldForm(
                                            _commentController, "댓글을 작성해주세요.", "", false),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            String key = getRandomString(16);

                                      //댓글 내용 fb 에 전송해서 저장
                                      if (_commentController.text.isNotEmpty) {
                                        commentService.create(
                                            uid: user.uid,
                                            name: userData.name,
                                            mbti: userData.mbti,
                                            comment: _commentController.text,
                                            contentKey: widget.contentKey,
                                            commentKey: key,
                                            createDate: DateTime.now(),
                                            likeNum: 0);

                                        _commentController.clear();
                                      }

                                      print(docs5[0].id);
                                      print(docs5.length);

                                      boardService.update(docs[0].id, 'commentNum', docs5.length);
                                      await fcmService.sendMessageNotification(
                                        name: userData.name,
                                        message: _commentController.text,
                                        boardWriterUid: boardWriteUid,
                                      );
                                      _commentController.clear();
                                    },
                                    child: Text('저장'))
                              ],
                            ))),
                  ]),
                );
              }),
        ),
      );
    });
  }

  //게시글 detail UI
  Widget _board1(BuildContext context, BoardService boardService, LikeService likeService,
      UserData userData, String uid, docs, docs2, docs3) {
    var phoneSize = MediaQuery.of(context).size;
    final fcmService = context.read<FcmService>();

    bool likeBool = false;
    final String boardWriteUid = docs[0].get('userUid');

    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //height: phoneSize.height*0.25,
          margin: EdgeInsets.only(top: 25, bottom: 12, right: 15, left: 15),
          padding: EdgeInsets.only(left: 20,top:20,right: 20, bottom: 25),
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
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Placeholder(fallbackHeight: 20, fallbackWidth: 20),
                      SizedBox(width: phoneSize.width * 0.03),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.name != '비밀게시판')
                            Row(
                              children: [
                                Text(
                                    docs[0].get('name'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                  ),
                                )],
                            ),
                          if (widget.name == '비밀게시판')
                            Row(
                              children: [
                                Text(
                                    "익명",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  ),
                                )],
                            ),
                          Row(
                            children: [
                              Text(
                                  docs[0].get('userMbti'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(0xffA0A3BD)
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '|',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffA0A3BD)
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                  docs[0].get('userMbtiMean'),
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
                  Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () async {

                            if (docs2.isEmpty == true) {
                              likeService.create(
                                  name: userData.name,
                                  userUid: userData.userUid,
                                  contentKey: widget.contentKey,
                                  createDate: DateTime.now());
                              print(docs3.length);
                            } else {
                              likeService.delete(docs2[0].id);
                            }

                            print(docs3.length);

                            boardService.update(docs[0].id, 'likeNum', docs3.length);
                            if (docs2.isEmpty == true) {
                              await fcmService.sendMessageNotification(
                                name: userData.name,
                                message: '좋아요를 눌렀습니다',
                                boardWriterUid: boardWriteUid,
                              );
                            }
                          },
                          icon:
                              Icon(docs2.isEmpty == true ? Icons.favorite_border : Icons.favorite)),
                      //Icon(Icons.bookmark_border_outlined)
                    ],
                  )
                ],
              ),
              Text(
                docs[0].get('title'),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                  fontSize: 15
                ),
              ),
              SizedBox(height: phoneSize.height * 0.02),
              Text(
                  docs[0].get('content'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text(docs3.length.toString())], //이 부분 어떻게 하려는지 잘 모르겠음!
                      ),
                      Row(
                        children: [Text('대표 닉네임 님 외 n인이 좋아합니다.')],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ));
  }

  Widget _commentPart(
      BuildContext context, CommentService commentService, BoardService boardService, docs5) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Row(
            children: [
              Text('댓글 전체보기 ', //댓글 수 받아오기
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff444A5E)
                ),
                  ),
              Text(
                '(댓글수)',
                style: TextStyle(
                    color: Color(0xff466FFF),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),

        //댓글 불러오기
        _comment(commentService, boardService, docs5),
      ],
    ));
  }

  //댓글 하나하나
  Widget _comment(CommentService commentService, BoardService boardService, docs) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
        child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              String name = doc.get('name');
              String mbti = doc.get('mbti');
              DateTime createDate = doc.get('createDate').toDate();
              String formattedDate = DateFormat('yyyy-MM-dd').format(createDate);
              String comment = doc.get('comment');
              int likeNum = doc.get('likeNum');

              return Column(
                children: [
                  Container(
                    width: phoneSize.width,
                    height: phoneSize.height * 0.2,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, top: 15, right: 15, bottom: 10),
                    margin: EdgeInsets.only(bottom: 7),
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
                                    fallbackHeight: 20, fallbackWidth: 20),
                                SizedBox(width: phoneSize.width * 0.03),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                            ' . ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                            mbti,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: phoneSize.height * 0.02),
                                  ],
                                ),
                              ],
                            ), //프로필 사진
                            //SizedBox(width: phoneSize.width * 0.2),
                            Text(
                                formattedDate,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffA0A3BD)
                              ),
                            )
                          ],
                        ),
                        Text(
                            comment,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff14142B)
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
                                      size: 20,
                                    )),
                                Text(
                                    likeNum.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xffA0A3BD)
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  Widget textFieldForm(
      TextEditingController controller, String labelText, String errorText, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        maxLength: 100,
        obscureText: obscure,
        controller: controller,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
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
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            hintText: labelText,
            hintStyle: TextStyle(
                color: Color(0xffA0A3BD)
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Color(0xFF0000) //Theme.of(context).colorScheme.primary,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Color(0xffEFF0F7),
              ),
            ),
            filled: true,
            fillColor: Color(0xffFCFCFC),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEFF0F7))),
            errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.red))),
      ),
    );
  }
}
