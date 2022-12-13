import 'package:flutter/material.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/auth/mbti_test_page.dart';
import 'package:woomul/ui/auth/sign_in_page.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';
import 'package:woomul/ui/board/detail_board_page.dart';
import 'package:woomul/ui/board/edit_board_page.dart';
import 'package:woomul/ui/board/free_board_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:woomul/ui/setting/board_setting_page.dart';
import 'package:woomul/ui/setting/main_setting_page.dart';
import 'package:woomul/ui/setting/my_activity_page.dart';
import 'package:woomul/ui/setting/my_information_edit_page.dart';
import 'package:woomul/ui/setting/my_information_page.dart';

void main() {
  runApp(const MyApp());
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
      home: MyActivityScreen(),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
