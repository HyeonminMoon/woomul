import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/provider/like_service.dart';
import '../../provider/auth_service.dart';
import '../../provider/board_service.dart';
import '../../routes.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var errorCheck;

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();
    final boardService = context.read<BoardService>();

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
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _board1(
                      context, boardService, likeService, userData, user!.uid),
                  _commentPart(context, commentService),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                      width: phoneSize.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: phoneSize.width * 0.5,
                            child: textFieldForm(
                                _commentController, "", "", false),
                          ),
                          SizedBox(
                            width: phoneSize.width * 0.2,
                          ),
                          TextButton(
                              onPressed: () {
                                String key = getRandomString(16);

                                userData.getUserData(user.uid);

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
                                      likeNum: 2);
                                }
                              },
                              child: Text('저장'))
                        ],
                      ))),
            ]),
          ),
        ),
      );
    });
  }

  //게시글 detail UI
  Widget _board1(BuildContext context, BoardService boardService,
      LikeService likeService, UserData userData, String uid) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: FutureBuilder<List<QuerySnapshot>>(
          future: Future.wait([
            boardService.readOne(widget.contentKey),
            likeService.readOne(uid, widget.contentKey),
            likeService.read(widget.contentKey)
          ]),
          builder: (context, snapshot) {
            final docs = snapshot.data![0].docs ?? [];
            final docs2 = snapshot.data![1].docs ?? [];
            final docs3 = snapshot.data![2].docs ?? [];
            bool likeBool = false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                              fallbackHeight: 15, fallbackWidth: 15), //프로필 사진
                          SizedBox(width: phoneSize.width * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [Text(docs[0].get('name'))],
                              ),
                              Row(
                                children: [
                                  Text('개인MBTI'),
                                  SizedBox(width: 10),
                                  Text('뜻')
                                ],
                              )
                            ],
                          ),
                          SizedBox(width: phoneSize.width * 0.48),
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    userData.getUserData(uid);

                                    if (docs2.isEmpty == true) {
                                      likeService.create(
                                          name: userData.name,
                                          userUid: userData.userUid,
                                          contentKey: widget.contentKey,
                                          createDate: DateTime.now());
                                    } else {
                                      print('여기는 들어옵니다');
                                      likeService.delete(docs2[0].id);
                                    }
                                  },
                                  icon: Icon(docs2.isEmpty == true
                                      ? Icons.favorite_border
                                      : Icons.favorite)),
                              Icon(Icons.bookmark_border_outlined)
                            ],
                          )
                        ],
                      ),
                      Text(
                        docs[0].get('title'),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: phoneSize.height * 0.02),
                      Text(docs[0].get('content')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text(docs3.length.toString())],
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
            );
          }),
    );
  }

  Widget _commentPart(BuildContext context, CommentService commentService) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('댓글 전체보기 ' //댓글 수 받아오기
                ),
            Text(
              '(댓글수)',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),

        SizedBox(height: 10),

        //댓글 불러오기
        _comment(commentService),
      ],
    ));
  }

  //댓글 하나하나
  Widget _comment(CommentService commentService) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
        child: FutureBuilder<QuerySnapshot>(
            future: commentService.read(widget.contentKey),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    String name = doc.get('name');
                    String mbti = doc.get('mbti');
                    DateTime createDate = doc.get('createDate').toDate();
                    String comment = doc.get('comment');
                    int likeNum = doc.get('likeNum');
                    return Column(
                      children: [
                        Container(
                          width: phoneSize.width,
                          height: phoneSize.height * 0.19,
                          color: Colors.white,
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
                                      Row(
                                        children: [
                                          Text(name),
                                          Text(' . '),
                                          Text(mbti)
                                        ],
                                      ),
                                      SizedBox(height: phoneSize.height * 0.02),
                                    ],
                                  ),
                                  SizedBox(width: phoneSize.width * 0.45),
                                  Text(createDate.toString())
                                ],
                              ),
                              Text(comment),
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
                                      Text('댓글 수')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            }));
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
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            labelText: labelText,
            labelStyle: TextStyle(
                color: Color(0xFF0000) //Theme.of(context).colorScheme.primary,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            filled: true,
            fillColor: Color(0xffFCFCFC),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEFF0F7))),
            errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}
