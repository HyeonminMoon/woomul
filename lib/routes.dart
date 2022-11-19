import 'package:flutter/cupertino.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/auth/sign_in_page.dart';
import 'package:woomul/ui/auth/sign_up_page.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String loginHome = '/loginHome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    //splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    loginHome: (BuildContext context) => LoginScreen(),
    register: (BuildContext context) => SignUpScreen(),
    //register: (BuildContext context) => RegisterScreen(),
    //home: (BuildContext context) => HomeScreen(),
    //setting: (BuildContext context) => SettingScreen(),
  };
}
