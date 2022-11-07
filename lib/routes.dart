import 'package:flutter/cupertino.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    //splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    //register: (BuildContext context) => RegisterScreen(),
    //home: (BuildContext context) => HomeScreen(),
    //setting: (BuildContext context) => SettingScreen(),
  };
}
