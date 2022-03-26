import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login.page.dart';
import 'package:flutter_chat_app/pages/user.page.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  static const routeName = 'loading';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot){
          return Center(
            child: Text('Await .......'),
          );
        },
      ),
   );
  }

  Future checkLoginState( BuildContext context ) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticathed = await authService.isLoggedIn();
    if ( authenticathed ) {
      // TODO: connect socket server
      // Navigator.pushReplacementNamed(context, 'user');
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => UserPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }
  }
}