import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/auth_service.dart';

import '../../routes.dart';

class MBTITestScreen extends StatefulWidget {
  @override
  _MBTITestScreenState createState() => _MBTITestScreenState();
}

class _MBTITestScreenState extends State<MBTITestScreen> {
  bool first = false;
  bool second = false;
  bool next = false;
  bool result = false;
  String passButton = '다음';

  int index = 0;

  String mbti = '';

  var questions = [
    'Question1',
    'Question2',
    'Question3',
    'Question4',
    'Question5',
    'Question6',
    'Question7',
    'Question8',
    'Question9',
    'Question10',
    'Question11',
    'Question12'
  ];

  var questionValue = [
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
    second = false;
    first = false;
    next = false;
    result = false;
    index = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Consumer<MbtiService>(builder: (context, mbtiService, child) {
      return FutureBuilder<QuerySnapshot>(
          future: mbtiService.read(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return SizedBox.shrink();
            }
            final docs = snapshot.data?.docs ?? [];
            var percent = docs[0].get(questions[index])[2];
            var option1 = docs[0].get(questions[index])[0];
            var option2 = docs[0].get(questions[index])[1];
            return Scaffold(
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
                    setState(() {
                      if (index == 0) {
                        Navigator.pop(context);
                      }
                      questionValue[index] = false;

                      if (result == true) {
                        result = false;
                      } else {
                        index--;
                      }
                    });
                  },
                ),
              ),
              body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result == false)
                          LinearPercentIndicator(
                            width: phoneSize.width * 0.8,
                            lineHeight: 14.0,
                            percent:
                                percent / 100, //firebase 에서 문제 번호 받아와서 바뀌게 해야함
                            center: Text(
                              percent.toString(),
                              style: TextStyle(fontSize: 12.0),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: Colors.white,
                            progressColor: Colors.blue,
                          ),
                        if (result == false)
                          _buildForm1(context, option1, option2),
                        if (result == true) _buildForm2(context)
                      ],
                    )),
              ),
              bottomNavigationBar: Material(
                color: next == false ? Colors.white : Colors.blueAccent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (second == true) {
                        questionValue[index] = true;
                      }

                      first = false;
                      second = false;
                      next = false;

                      if (index < 11) {
                        index++;
                      } else {
                        result = true;
                        mbti = MbtiResult(questionValue);
                      }
                    });
                  },
                  child: SizedBox(
                    height: kToolbarHeight,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        index == 11 ? '결과 보기' : '다음',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget _buildForm1(BuildContext context, option1, option2) {
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
              '나는',
            ),
            SizedBox(height: phoneSize.height * 0.01),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    //선택 되면 색 바뀌고
                    //선택 값 전달 되도록
                    setState(() {
                      first = true;
                      second = false;

                      if (first == true || second == true) {
                        next = true;
                      }
                    });
                  },
                  child: Container(
                      width: phoneSize.width * 0.8,
                      height: phoneSize.height * 0.15,
                      decoration: BoxDecoration(
                          color: first == true
                              ? Colors.blueAccent
                              : Colors.white, //여기 색 바꾸면 됨
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        children: [
                          Text(
                            '첫번째 질문',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            option1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
                SizedBox(height: phoneSize.height * 0.05),
                InkWell(
                  onTap: () {
                    //선택 되면 색 바뀌고
                    //선택 값 전달 되도록
                    setState(() {
                      second = true;
                      first = false;

                      if (first == true || second == true) {
                        next = true;
                      }
                    });
                  },
                  child: Container(
                      width: phoneSize.width * 0.8,
                      height: phoneSize.height * 0.15,
                      decoration: BoxDecoration(
                          color: second == true
                              ? Colors.blueAccent
                              : Colors.white, //여기 색 바꾸면 됨
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        children: [
                          Text(
                            '두번째 질문',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            option2,
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildForm2(BuildContext context) {
    return Container(
      child: Column(
        children: [Text('안녕하세요 당신의 mbti는 $mbti 입니다')],
      ),
    );
  }

  String MbtiResult(List<bool> data) {
    String mbti = '';

    int option1 =
        data.getRange(0, 3).where((element) => element == true).length;
    int option2 =
        data.getRange(3, 6).where((element) => element == true).length;
    int option3 =
        data.getRange(6, 9).where((element) => element == true).length;
    int option4 =
        data.getRange(9, 12).where((element) => element == true).length;

    String _option1 = '';
    String _option2 = '';
    String _option3 = '';
    String _option4 = '';

    if (option1 < 1) {
      _option1 = 'E';
    } else {
      _option1 = 'I';
    }

    if (option2 < 1) {
      _option2 = 'S';
    } else {
      _option2 = 'N';
    }

    if (option3 < 1) {
      _option3 = 'T';
    } else {
      _option3 = 'F';
    }

    if (option4 < 1) {
      _option4 = 'J';
    } else {
      _option4 = 'P';
    }

    mbti = _option1 + _option2 + _option3 + _option4;

    return mbti;
  }
}
