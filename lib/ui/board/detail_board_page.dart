import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/provider/fcm_service.dart';
import 'package:woomul/provider/like_service.dart';
import '../../provider/auth_service.dart';
import '../../provider/board_service.dart';
import 'package:intl/intl.dart';

class DetailBoardScreen extends StatefulWidget {
  final String name;
  final String contentKey;
  final String id;
  final String boardWriteUid;

  const DetailBoardScreen(this.name, this.contentKey, this.id, this.boardWriteUid, {super.key});

  @override
  _DetailBoardScreenState createState() => _DetailBoardScreenState();
}

class _DetailBoardScreenState extends State<DetailBoardScreen> {
  late TextEditingController _commentController =
      TextEditingController(text: "");

  late AuthService authService;
  late User? user;
  late UserData userData;
  late BoardService boardService;
  late CommentService commentService;
  late LikeService likeService;



  var errorCheck;

  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {

    authService = context.read<AuthService>();
    userData = context.read<UserData>();
    boardService = context.read<BoardService>();

    commentService = context.read<CommentService>();
    likeService = context.read<LikeService>();

    user = authService.currentUser();
    userData.getUserData(user!.uid);

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

  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    final fcmService = context.read<FcmService>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Stack(children: <Widget>[
                  FutureBuilder<dynamic>(
                      future: Future.wait([
                        boardService.readOne(widget.contentKey),
                        likeService.readOne(user!.uid, widget.contentKey),
                        likeService.read(widget.contentKey),
                        commentService.read(widget.contentKey)
                      ]),
                      builder: (context, snapshot) {

                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Container();
                        }

                        final docs = snapshot.data![0].docs ?? [];
                        final docs2 = snapshot.data![1].docs ?? [];
                        final docs3 = snapshot.data![2].docs ?? [];
                        final docs5 = snapshot.data![3].docs ?? [];

                        // 스몰아이즈 : 게시글 작성자 uid
                        final String boardWriteUid = docs[0].get('userUid');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _board1(context, boardService, likeService, userData,
                                user!.uid, docs, docs2, docs3),
                            _commentPart(
                                context, commentService, boardService, docs5, user!.uid),
                          ],
                        );
                      }
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
                                  onPressed: () async {
                                    String key = getRandomString(16);

                                    //댓글 내용 fb 에 전송해서 저장
                                    if (_commentController.text.isNotEmpty) {
                                      commentService.create(
                                          uid: user!.uid,
                                          name: userData.name,
                                          mbti: userData.mbti,
                                          comment: _commentController.text,
                                          contentKey: widget.contentKey,
                                          commentKey: key,
                                          createDate: DateTime.now(),
                                          likeNum: 0);
                                    }
                                    int comNum = await commentService.readNum(widget.contentKey);
                                    setState(() {
                                      boardService.update(widget.id, 'commentNum', comNum);
                                    });


                                    await fcmService.sendMessageNotification(
                                      name: userData.name,
                                      message: _commentController.text,
                                      boardWriterUid: widget.boardWriteUid,
                                    );

                                    _commentController.clear();

                                  },
                                  child: Text(
                                    '저장',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: _commentController.text == "" ? Color(0xffD0D3E5) : Color(0xff466FFF)
                                    ),
                                  ))
                            ],
                          ))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //게시글 detail UI
  Widget _board1(BuildContext context, BoardService boardService, LikeService likeService,
      UserData userData, String uid, docs, docs2, docs3) {
    var phoneSize = MediaQuery.of(context).size;
    final fcmService = context.read<FcmService>();

    bool likeBool = false;
    final String boardWriteUid = docs[0].get('userUid');

    final mbti = userData.mbti;
    final ss = userData.sex == 'man' ? 'M' : 'F';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/chara/$mbti$ss.png'),
                        radius: 20,
                      ),
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
                  ),

                  if (uid == boardWriteUid)
                    IconButton(
                      icon: Icon(
                          Icons.delete_outline,
                        color: Color(0xffA0A3BD),
                        size: 28,
                      ),
                      onPressed: () {
                        //게시판 삭제 기능 추가
                      },
                    ),

                ],
              ),
              SizedBox(height: phoneSize.height * 0.01,),

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

              SizedBox(height: phoneSize.height * 0.02,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        } else {
                          likeService.delete(docs2[0].id);
                        }

                        int likeNum = await likeService.readNum(widget.contentKey);

                        setState(() {
                          boardService.update(docs[0].id, 'likeNum', likeNum);
                        });


                        if (docs2.isEmpty == true) {
                          await fcmService.sendMessageNotification(
                            name: userData.name,
                            message: '좋아요를 눌렀습니다',
                            boardWriterUid: boardWriteUid,
                          );
                        }
                      },
                      icon: Icon(docs2.isEmpty == true ? Icons.favorite_border : Icons.favorite)
                  ),

                  SizedBox(width: phoneSize.width * 0.01,),

                  Text(
                    docs3.length.toString(),
                    style: TextStyle(
                        color: Color(0xffA0A3BD),
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),
                  ),
                ],
              ),

            ],
          ),
        )
      ],
    ));
  }

  Widget _commentPart(
      BuildContext context, CommentService commentService, BoardService boardService, docs5, String uid) {
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
        _comment(commentService, boardService, docs5, uid),
      ],
    ));
  }

  //댓글 하나하나
  Widget _comment(CommentService commentService, BoardService boardService, docs, String uid) {
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
              String userUid = doc.get('uid');

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
                                            widget.name == '비밀게시판' ? '익명' : name,
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
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if(uid == userUid)
                            Icon(
                              Icons.more_horiz,
                              color: Color(0xff6E7191),
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
            counterText: '',
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
