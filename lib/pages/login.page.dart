import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_chat_app/helpers/show_alert.dart';

import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';

import 'package:flutter_chat_app/widgets/blue_button.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';
import 'package:flutter_chat_app/widgets/logo.dart';


class LoginPage extends StatelessWidget {
  static const routeName = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Logo(title: 'Messenger',),
                _Form(),
                Labels(
                  route: 'register',
                  title: 'Dont have account?',
                  subTitle:'create accout now!'
                ),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
   );
  }
}


class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          // TextField(),
          BlueButton(
            placeholder: 'Log in', 
            onPressed: authService.authenticated ? null : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authService.logIn(emailCtrl.text.trim(), passCtrl.text.trim());
              if ( loginOk ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'user');
              } else {
                showAlert(context, 'Invalid credentials', 'Email or password invalid');
              }
            }
          )
        ],
      ),
    );
  }
}

