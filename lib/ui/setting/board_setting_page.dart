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

  double _currentSliderValue = 20;
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
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '게시판 연령대 필터',
                          ),
                          Text(
                            '필터를 적용하면 원하는 연령대의 게시물만 볼 수 있어요!'
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
                              Text(
                                  '10대 중반'
                              ),
                              SizedBox(width: phoneSize.width*0.03,),
                              Text(
                                  '10대 후반'
                              ),
                              SizedBox(width: phoneSize.width*0.09,),
                              Text(
                                  '20대'
                              ),
                              SizedBox(width: phoneSize.width*0.13,),
                              Text(
                                  '30대'
                              ),
                              SizedBox(width: phoneSize.width*0.08,),
                              Text(
                                  '전연령'
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '게시판 MBTI 필터'
                        ),
                        Text(
                          '선택한 MBTI 유형의 게시물만 볼 수 있어요!'
                        ),
                        SizedBox(height: phoneSize.height*0.02,),
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
                        //여기선 그냥 터치 안 되도록
                      },
                      child: Container(
                        height: phoneSize.height * 0.08,
                        padding: EdgeInsets.only(left:10.0, right:10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
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
    return SizedBox(
      height: phoneSize.height*0.3,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 1,
        ),
        shrinkWrap: true,
        itemCount: mbti.length,
        itemBuilder: (context, index) => Container(
          width: 71,
          height: 48,
          child: ElevatedButton(
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
                  color: Colors.blue
              ),
            ),
          ),
        ),
      ),
    );
  }

}