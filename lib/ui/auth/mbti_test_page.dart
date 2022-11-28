import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../../routes.dart';

class MBTITestScreen extends StatefulWidget {
  @override
  _MBTITestScreenState createState() => _MBTITestScreenState();
}

class _MBTITestScreenState extends State<MBTITestScreen> {

  bool first = false;
  bool second = false;
  bool next = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    second = false;
    first = false;
    next = false;

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
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

          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearPercentIndicator(
                width: phoneSize.width*0.8,
                lineHeight: 14.0,
                percent: 0.5,//firebase 에서 문제 번호 받아와서 바뀌게 해야함
                center: Text(
                  "50.0%",
                  style: TextStyle(
                      fontSize: 12.0
                  ),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Colors.white,
                progressColor: Colors.blue,
              ),
              _buildForm1(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: next== false ? Colors.white : Colors.blueAccent,
        child: InkWell(
          onTap: () {
            setState(() {
              //선택지를 선택하면 색이 바뀌도록 하는 기능
              //firebase 랑 연동해서 다음 페이지 값 가져오(질문, 선택지)
            });
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                '다음',
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

  }

  Widget _buildForm1(BuildContext context) {
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
                      onTap: (){
                        //선택 되면 색 바뀌고
                        //선택 값 전달 되도록
                        setState(() {
                          second == false ? (first == false ? first = true : first = false) : first == false;
                          (first == true || second == true) ? next = true : next = false;
                        });
                      },
                      child: Container(
                        width: phoneSize.width * 0.8,
                        height: phoneSize.height*0.15,
                        decoration: BoxDecoration(
                          color: second == false ? (first==false?Colors.white :first == true? Colors.blueAccent : Colors.white)
                            : Colors.white, //여기 색 바꾸면 됨
                            borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]
                        ),
                        child: Text(
                          '첫번째 질문',
                          textAlign: TextAlign.center,
                        )
                      ),
                    ),

                    SizedBox(height: phoneSize.height*0.05),

                    InkWell(
                      onTap: (){
                        //선택 되면 색 바뀌고
                        //선택 값 전달 되도록
                        setState(() {
                          first == false ? (second == false ? second = true : second = false) : second == false;
                          (first == true || second == true) ? next = true : next = false;
                        });
                        print('isClick?');
                        print(second);
                      },
                      child: Container(
                          width: phoneSize.width * 0.8,
                          height: phoneSize.height*0.15,
                          decoration: BoxDecoration(
                              color: first == false ? (second==false?Colors.white :second == true? Colors.blueAccent : Colors.white)
                              : Colors.white,//여기 색 바꾸면 됨
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                )
                              ]
                          ),
                          child: Text(
                            '두번째 질문',
                            textAlign: TextAlign.center,
                          )
                      ),
                    ),

                  ],
                )



              ],
            ),
          ),
        ));
  }





}


