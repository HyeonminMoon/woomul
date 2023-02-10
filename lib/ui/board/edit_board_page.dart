import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/auth_service.dart';
import 'package:woomul/ui/board/bottombar_page.dart';

import '../../provider/board_service.dart';
import '../../routes.dart';

List<String> board = <String>['자유게시판', '연애게시판', '고민게시판', '비밀게시판'];

class EditBoardScreen extends StatefulWidget {
  @override
  _EditBoardScreenState createState() => _EditBoardScreenState();
}

class _EditBoardScreenState extends State<EditBoardScreen> {
  bool _customTileExpanded = false;
  double _currentSliderValue = 25;
  List<String> age = ['10대 중반', '10대 후반', '20대', '30대', '전연령'];

  var errorCheck;
  late TextEditingController _ContentController =
      TextEditingController(text: "");
  late TextEditingController _TitleController = TextEditingController(text: "");

  //List<String> board = <String>['자유게시판', '연애게시판', '고민게시판', '비밀게시판'];

  String dropdownValue = board.first;

  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  List<String> mbtiList = [
    'ISTJ',
    'ISFJ',
    'INFJ',
    'INTJ',
    'ISTP',
    'ISFP',
    'INFP',
    'INTP',
    'ESTJ',
    'ESFJ',
    'ENFJ',
    'ENTJ',
    'ESTP',
    'ESFP',
    'ENFP',
    'ENTP'
  ];

  List<bool> mbtiValue = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ContentController = TextEditingController(text: "");
    _TitleController = TextEditingController(text: "");
    errorCheck = false;
  }

  @override
  void dispose() {
    super.dispose();
    _ContentController.dispose();
  }

  void DeleteDialog() {
    var phoneSize = MediaQuery.of(context).size;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            //Dialog Main Title
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Text(
                  "게시글 작성 종료",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
            content: Container(
                width: phoneSize.width,
                height: phoneSize.height * 0.07,
                child: Text(
                  '게시글 작성을 취소할까요?\n'
                      '작성 중인 내용은 저장되지 않습니다.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.all(0),
            actions: <Widget>[
              Column(
                children: [
                  Container(
                    width: phoneSize.width * 0.43,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(74, 84, 255, 0.9),
                        Color.fromRGBO(0, 102, 255, 0.6)
                      ]),
                      borderRadius: BorderRadius.circular(54),
                    ),
                    child: TextButton(
                      child: Text(
                        "확인",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xffFCFCFC)
                        ),
                      ),
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BoardScreen()));
                      },
                    ),
                  ),
                  SizedBox(height: phoneSize.height * 0.04,)
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final userData = context.read<UserData>();

    return Consumer<BoardService>(builder: (context, boardService, child) {
      return FutureBuilder<void>(
          future: userData.getUserData(user!.uid),
          builder: (context, snapshot) {
            int position = mbtiList.indexOf(userData.mbti);
            mbtiValue[position] = true;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                '게시물 작성',
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
                  print(userData.name);
                  //Navigator.pop(context);
                  DeleteDialog();
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    //내용 fb 에 저장 및 업로드
                    if (_ContentController.text != '' && _TitleController.text != ''){
                      String key = getRandomString(16);

                        List<String> selectedList =
                            selectedMbti(mbtiList, mbtiValue);

                        boardService.create(
                            key: key,
                            userUid: user!.uid,
                            name: userData.name,
                            firstPicUrl: null,
                            ageNum: _currentSliderValue,
                            ageRange: [
                              age[(_currentSliderValue / 25).round()]
                            ], // 임의로 리스트로 넣어놓음!
                            mbti: selectedList,
                            userMbti: userData.mbti,
                            userMbtiMean: userData.mbtiMean,
                            boardType: dropdownValue,
                            createDateMonth:
                                DateFormat('yyyyMM').format(DateTime.now()),
                            createDate: DateTime.now(),
                            title: _TitleController.text,
                            content: _ContentController.text,
                            commentNum: 0,
                            likeNum: 0);

                      Navigator.pop(context);
                    }

                  },
                  child: Text(
                      '업로드',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xff4975FF) //이거 text 가 차 있으면 색깔 바뀌게 해야함!
                    ),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //얘를 여러 개 불러오도록 하면 됨
                    //_board0(context, boardService, userData), //나중에 조검 적용된 담에 활성화 하기
                    SizedBox(
                      height: phoneSize.height * 0.04,
                    ),
                    Expanded(child: _board1(context)),
                  ],
                ),
              ),
            ),
          );
        }
      );
    });
  }

  Widget _board0(BuildContext context, boardService, UserData userData) {
    var phoneSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(110, 113, 145, 0.12).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ExpansionTile(
              title: Text(
                  '게시물 노출 필터',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              children: <Widget>[
                //ListTile(title: Text('This is tile number 1')),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '연령대',
                    ),
                    Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 4,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Text('10대 중반'),
                        SizedBox(
                          width: phoneSize.width * 0.03,
                        ),
                        Text('10대 후반'),
                        SizedBox(
                          width: phoneSize.width * 0.09,
                        ),
                        Text('20대'),
                        SizedBox(
                          width: phoneSize.width * 0.13,
                        ),
                        Text('30대'),
                        SizedBox(
                          width: phoneSize.width * 0.08,
                        ),
                        Text('전연령')
                      ],
                    ),
                    SizedBox(
                      height: phoneSize.height * 0.06,
                    ),
                    Text('MBTI'),
                    _MBTI2(context, userData),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _MBTI(BuildContext context, List mbti) {
    return Container(
      width: 71,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          //색 바뀌게 하고, 해당 정보 값 저장하기
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Color(0xffB1C7FF))),
        child: Text(
          'MBTI',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _MBTI2(BuildContext context, UserData userData) {
    var phoneSize = MediaQuery.of(context).size;
    return SizedBox(
      height: phoneSize.height * 0.3,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 1,
        ),
        shrinkWrap: true,
        itemCount: mbtiList.length,
        itemBuilder: (context, index) => Container(
          width: 71,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              //색 바뀌게 하고, 해당 정보 값 저장하기
              setState(() {
                if (mbtiList[index] != userData.mbti) {
                  if (mbtiValue[index] == false) {
                    mbtiValue[index] = true;
                  } else {
                    mbtiValue[index] = false;
                  }
                } else {
                  print(userData.mbti);
                }
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    mbtiValue[index] == false ? Colors.white : Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Color(0xffB1C7FF))),
            child: Text(
              '${mbtiList[index]}',
              style: TextStyle(
                  color:
                      mbtiValue[index] == false ? Colors.blue : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //글쓰는 위치
  //값 저장해서 fb 로 보내기~
  Widget _board1(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
          width: phoneSize.width,
          padding: EdgeInsets.only(left: 12.0, right: 10, top: 10, bottom : 10),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //width: phoneSize.width*0.2,
                    padding: EdgeInsets.only(left: 15.0, right: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffECF1FF),
                        borderRadius: BorderRadius.circular(54)
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(
                          Icons.keyboard_arrow_down,
                        color: Color(0xff3462FF),
                      ),
                      elevation: 16,
                      style: TextStyle(
                          color: Color(0xff466FFF),
                        fontWeight: FontWeight.w600
                      ),
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      onChanged: (String? value) {
                        //게시판 data 불러오고 저장하기
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: board.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              //title
              Container(
                width: phoneSize.width * 0.8,
                child: textFieldForm(_TitleController, "제목을 입력해주세요.", "", false),
              ),

              Container(
                width: phoneSize.width * 0.8,
                child: textFieldForm2(_ContentController, "내용을 입력해주세요.", "", false),
              ),
            ],
          )),
    );
  }

  //title Form
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
            hintText: labelText,
            hintStyle: TextStyle(
              color: Color(0xffA0A3BD)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Color(0xFFEFF0F7),
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

  //text titleForm
  Widget textFieldForm2(TextEditingController controller, String labelText,
      String errorText, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        obscureText: obscure,
        controller: controller,
        minLines: 100, // any number you need (It works as the rows for the textarea)
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
            hintText: labelText,
            hintStyle: TextStyle(
                color: Color(0xffA0A3BD)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Color(0xFFEFF0F7),
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

  List<String> selectedMbti(List<String> data, List<bool> value) {
    List<String> result = [];

    for (int i = 0; i < 16; i++) {
      if (value[i] == true) {
        result.add(data[i]);
      }
    }
    return result;
  }
}
