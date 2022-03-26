import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_app/helpers/show_alert.dart';

import 'package:flutter_chat_app/services/auth_service.dart';

import 'package:flutter_chat_app/widgets/blue_button.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';
import 'package:flutter_chat_app/widgets/logo.dart';


class RegisterPage extends StatelessWidget {
  static const routeName = 'register';
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
                Logo(title: 'Register',),
                _Form(),
                Labels(
                  route: 'login',
                  title: 'You have account?',
                  subTitle: 'Sing in',
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
  final nameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Name',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
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
            placeholder: 'Sing up', 
            onPressed: authService.authenticated ? null : () async {
              final loginOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
              FocusScope.of(context).unfocus();
              if ( loginOk == true ) {
                // TODO: connect socket server
                Navigator.pushReplacementNamed(context, 'user');
              } else {
                showAlert(context, 'Invalid credentials', loginOk);
              }
            }
          )
        ],
      ),
    );
  }
}

