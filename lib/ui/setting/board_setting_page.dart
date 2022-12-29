import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class BoardSettingScreen extends StatefulWidget {
  @override
  _BoardSettingScreenState createState() => _BoardSettingScreenState();
}

class _BoardSettingScreenState extends State<BoardSettingScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var errorCheck;
  late bool _showAppleSignIn;

  RangeValues _currentSliderValue = RangeValues(20,50);
  List<String> age = ['10대 중반', '10대 후반', '20대', '30대', '전연령'];

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      setState(() {
        _showAppleSignIn = true;
      });
    } else {
      _showAppleSignIn = false;
    }

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '게시판 설정',
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
      key: _scaffoldKey,
      body: Align(
        alignment: Alignment.center,
        child: _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    List<String> mbtiList = ['ISTJ', 'ISFJ', 'INFJ', 'INTJ',
      'ISTP', 'ISFP', 'INFP', 'INTP',
      'ESTJ', 'ESFJ', 'ENFJ', 'ENTJ',
      'ESTP', 'ESFP', 'ENFP', 'ENTP'];
    var phoneSize = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: phoneSize.height*0.04,),

                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 25),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '게시판 연령대 필터',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                          SizedBox(height: phoneSize.height * 0.01,),
                          Text(
                            '필터를 적용하면 원하는 연령대의 게시물만 볼 수 있어요!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xff5F8BFF),
                              inactiveTrackColor: Color(0xffB1C7FF),
                              thumbColor: Colors.white,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0,
                              ),
                            ),
                            child: RangeSlider(
                              values: _currentSliderValue,
                              max: 100,
                              divisions: 4,
                              //activeColor: Color(0xff5F8BFF),
                              //inactiveColor: Color(0xffB1C7FF),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentSliderValue = values;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                  '10대 중반',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10
                                ),
                              ),
                              SizedBox(width: phoneSize.width*0.08,),
                              Text(
                                  '10대 후반',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                ),
                              ),
                              SizedBox(width: phoneSize.width*0.09,),
                              Text(
                                  '20대',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                ),
                              ),
                              SizedBox(width: phoneSize.width*0.13,),
                              Text(
                                  '30대',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                ),
                              ),
                              SizedBox(width: phoneSize.width*0.08,),
                              Text(
                                  '전연령',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: phoneSize.height*0.06,),



                  ],
                ),

                Container(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 25),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '게시판 MBTI 필터',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: phoneSize.height*0.01,),
                        Text(
                          '선택한 MBTI 유형의 게시물만 볼 수 있어요!',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13
                          ),
                        ),
                        SizedBox(height: phoneSize.height*0.03,),
                        _MBTI2(context, mbtiList),
                      ],
                    )
                ),

                SizedBox(height: phoneSize.height*0.04,),
                

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        //커뮤니티 이용규칙 페이지? 여기 어떻게 할려나?
                      },
                      child: Container(
                        height: phoneSize.height * 0.08,
                        padding: EdgeInsets.only(left:12.0, right:10.0),
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
                            Container(
                              padding: EdgeInsets.only(right : 16.0),
                              child: Icon(
                                Icons.help_outline_outlined,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '커뮤니티 이용규칙',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: phoneSize.height * 0.04),



              ],
            ),
          ),
        ));
  }

  Widget _MBTI2(BuildContext context, List mbti){
    var phoneSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      //height: phoneSize.height*0.3,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 1.4,
        ),
        shrinkWrap: true,
        itemCount: mbti.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            //색 바뀌게 하고, 해당 정보 값 저장하기
          },
          child: Container(
            width: 71,
            height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white, //선택되면 색 바뀌어야함!
                border: Border.all(
                  width: 1,
                  color: Color(0xffB1C7FF),
                ),
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${mbti[index]}',
                  style: TextStyle(
                      color: Color(0xff4E4B66), //선택되면 색 바껴야 함!
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
            /*ElevatedButton(
              onPressed: () {
                //색 바뀌게 하고, 해당 정보 값 저장하기
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Color(0xffB1C7FF))
              ),
              child: Text(
                '${mbti[index]}',
                style: TextStyle(
                    color: Color(0xff4E4B66),
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),*/
          ),
        ),
      ),
    );
  }

}