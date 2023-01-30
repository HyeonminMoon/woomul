import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchResultScreen extends StatefulWidget {

  final String searchWord;

  const SearchResultScreen(this.searchWord, {super.key});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
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
              Text(widget.searchWord),

              //_board1(context,) //이거 리스트 불러오는 코드! 작업 할 때 주석 처리 해제 하시면 됨!
            ],
          ),
        ),
      ),
    );
  }

  //이거 리스트 불러오는 코드! 작업하실 때 주석 처리 해제 하시고 하시면 됩니당
  /*
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
  } */

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
            Text(
              '검색 결과',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Color(0xff14142B)),
            ),

            SizedBox(height: phoneSize.height * 0.03),

            //_board1(context)
          ],
        ),
      ),
    ));
  }
}
