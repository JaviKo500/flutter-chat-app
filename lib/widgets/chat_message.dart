import 'package:flutter/material.dart';
class ChatMessage extends StatelessWidget {
  final String uid;
  final String text;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,  
    required this.uid, 
    required this.text,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == '123'
            ? _myMessage()
            : _notMyMessage()  ,
        ),
      ),
    );
  }

  Widget _myMessage() => Align(
    alignment: Alignment.centerRight,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
      child: Text(text, style: const TextStyle(color: Colors.white),),
      decoration:  BoxDecoration(
        color: Color(0xff4D9EF6),
        borderRadius: BorderRadius.circular(20)
      ),
    ),
  );
  Widget _notMyMessage() => Container(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
      child: Text(text, style: const TextStyle(color: Colors.black87),),
      decoration:  BoxDecoration(
        color: Color(0xffE4E5E8),
        borderRadius: BorderRadius.circular(20)
      ),
    ),
  );
}