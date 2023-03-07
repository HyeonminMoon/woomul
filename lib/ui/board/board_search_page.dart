import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/board_service.dart';
import 'detail_board_page.dart';
import 'package:intl/intl.dart';


class SearchResultScreen extends StatefulWidget {

  final String searchWord;

  const SearchResultScreen(this.searchWord, {super.key});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  var search;

  var errorCheck;

  late TextEditingController _keywordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = false;
    _keywordController = TextEditingController(text: "");

    errorCheck = false;
  }

  @override
  void dispose() {
    super.dispose();
    _keywordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final boardService = context.read<BoardService>();

    var phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: search == false ? Text(
          '검색',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ) : Container(
          height: phoneSize.height * 0.05,
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top : 8),
          //margin: EdgeInsets.only(left : 20, right : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffEFF0F6),
          ),
          child: Row(
            children: [
              Expanded(
                child: textFieldForm(_keywordController, "찾고싶은 키워드를 검색하세요", "검색어를 확인해주세요", false),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: () => {
              setState(() {
                  if (search == false){
                    search = true;
                  }
                  else {
                    search = false;
                  }
                  //검색 버튼 한 번 더 누르면 search 되거나.. 기능 추가 하면 될듯!
                }
              )
            },
          ),
        ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm3(context),

              //검색어에 해당되는 게시물이 있는지 확인하고, _board0 or _board1 불러오도록 해야함!
              //_board0(context)
              _board1(context, boardService) //이거 리스트 불러오는 코드! 작업 할 때 주석 처리 해제 하시면 됨!
            ],
          ),
        ),
      ),
    );
  }

  Widget _board0(BuildContext context) {
    var phonSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(),
        SizedBox(height: phonSize.height * 0.2,),
        Container(
          width: phonSize.width * 0.2,
          alignment: Alignment.center,
          child: Image.asset("assets/images/noSearch.png"),
        ),
        SizedBox(height: phonSize.height * 0.03,),
        Text(
          '해당하는 검색 결과가 없습니다.',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xffA0A3BD)
          ),
        )
      ],
    );
  }


  Widget _board1(BuildContext context, BoardService boardService) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
          future: boardService.searchAll(_keywordController.text),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? [];
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  String boardType = doc.get('boardType');
                  String title = doc.get('title');
                  String userName = doc.get('name');
                  String userUid = doc.get('userUid');
                  DateTime date = doc.get('createDate').toDate();
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  String content = doc.get('content');
                  String contentKey = doc.get('key');
                  int likeNum = doc.get('likeNum');
                  int commentNum = doc.get('commentNum');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //자세히 보기로 이동
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailBoardScreen(boardType, contentKey, docs[index].id, userUid))); },
                        child: Container(
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
                                          if (title.length > 50)
                                            Text(
                                              "${title.substring(0, 40)}...",
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
                                              if (boardType != '비밀게시판')
                                                Text(
                                                  userName,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13,
                                                      color: Color(0xffA0A3BD)
                                                  ),
                                                ),
                                              if (boardType == '비밀게시판')
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
                                  ), //프로필 사진
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

  Widget _buildForm3(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        child: SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  widget.searchWord,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff466FFF)),
                ),

                Text(
                  ' 검색 결과 ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff484848)
                  ),
                ),

                Text(
                  '검색 게시글 수건',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff466FFF)
                  )
                )
              ],
            ),

            SizedBox(height: phoneSize.height * 0.03),

            //_board1(context)
          ],
        ),
      ),
    ));
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
