import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/auth_service.dart';

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
                  TextButton(
                    onPressed: () {
                      //내용 fb 에 저장 및 업로드
                      if (_ContentController.text != '' &&
                          _TitleController.text != '') {
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
                    child: Text('업로드'),
                  )
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //얘를 여러 개 불러오도록 하면 됨
                        _board0(context, boardService, userData),
                        SizedBox(
                          height: phoneSize.height * 0.04,
                        ),
                        _board1(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget _board0(BuildContext context, boardService, UserData userData) {
    var phoneSize = MediaQuery.of(context).size;
    return ExpansionTile(
      title: Text('게시물 노출 필터'),
      backgroundColor: Colors.white,
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: phoneSize.width,
              color: Colors.white,
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.blueAccent),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
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

                  //title
                  Container(
                    width: phoneSize.width * 0.8,
                    child: textFieldForm(_TitleController, "", "", false),
                  ),

                  Container(
                    width: phoneSize.width * 0.8,
                    child: textFieldForm(_ContentController, "", "", false),
                  ),
                ],
              ))
        ],
      ),
    );
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
