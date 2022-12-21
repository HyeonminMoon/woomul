import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woomul/ui/board/free_board_page.dart';

import '../../routes.dart';

class MainBoardScreen extends StatefulWidget {
  @override
  _MainBoardScreenState createState() => _MainBoardScreenState();
}


class _MainBoardScreenState extends State<MainBoardScreen> {

  var errorCheck;
  int _selectedIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    errorCheck = false;

  }

  @override
  void dispose() {
    super.dispose();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          '게시판',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _board1(context),
                  ],
                ),
              ]
          ),
        ),
      ),

    );
  }


  Widget _board1(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //HOT 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('HOT 게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      'HOT 게시판'
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //BEST 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('BEST 게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('BEST 게시판'),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: phoneSize.height * 0.04),
          GestureDetector(
            onTap: () {
              //자유 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('자유게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('자유 게시판'),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //연애 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('연애게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('연애 게시판'),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //고민 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('고민게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('고민 게시판'),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //비밀 게시판 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreeBoardScreen('비밀게시판')));
            },
            child: Container(
              width: phoneSize.width * 0.8,
              height: phoneSize.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('비밀 게시판'),
                  Container(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _board2(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Container(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }

  Widget _board3(BuildContext context) {
    var phoneSize = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Container(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
