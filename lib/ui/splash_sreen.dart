import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/ui/auth/login_home_page.dart';

import '../provider/auth_service.dart';
import 'board/bottombar_page.dart';

class splashScreen extends StatefulWidget {

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  void initState() {

    final user = context.read<AuthService>().currentUser();

    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => user == null
              ? LoginScreen()
              : BoardScreen()
      )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  height: height,
                  width: width,
                  child: Image.asset("assets/images/splash_image.png", fit: BoxFit.fitWidth,)
              ),
              Column(
                children: [
                  Text(""),
                  Text(""),
                  Text(""),
                  Text("WOOMUL", style: TextStyle(fontFamily: "Poppins", fontSize: 24, fontWeight: FontWeight.bold),),
                  Text("우리들이 MBTI로 소통하는 공간", style: TextStyle(fontFamily: "Poppins"),)
                ],
              )
            ],
          ),
        ],
      )
    );
  }
}
