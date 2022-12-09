
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/auth_service.dart';
import 'package:woomul/provider/board_service.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/auth/mbti_test_page.dart';
import 'package:woomul/ui/auth/sign_in_page.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/edit_board_page.dart';
import 'package:woomul/ui/board/free_board_page.dart';
import 'package:woomul/ui/board/main_board_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BoardService()),
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => MbtiService()),
        ChangeNotifierProvider(create: (context) => CommentService())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

      home: BoardScreen(),//const MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}


