import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/pages/chat.page.dart';
import 'package:flutter_chat_app/pages/loading.page.dart';
import 'package:flutter_chat_app/pages/login.page.dart';
import 'package:flutter_chat_app/pages/register.page.dart';
import 'package:flutter_chat_app/pages/user.page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  UserPage.routeName: ( _ ) => UserPage(),
  ChatPage.routeName: ( _ ) => ChatPage(),
  LoginPage.routeName: ( _ ) => LoginPage(),
  RegisterPage.routeName: ( _ ) => RegisterPage(),
  LoadingPage.routeName: ( _ ) => LoadingPage(),
};