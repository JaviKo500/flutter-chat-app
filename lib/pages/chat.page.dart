import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';

import 'package:flutter_chat_app/models/messages_response.dart';

import 'package:flutter_chat_app/widgets/chat_message.dart';



class ChatPage extends StatefulWidget {
  static const routeName = 'chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;
  final List<ChatMessage> _messages = [
  ];
  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('personal-message', _listenMessage);
    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory( String userId ) async{
    List<Message> chat = await chatService.getChat(userId);
    final history = chat.map((m) => ChatMessage(
      uid: m.from, 
      text: m.message, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
    ));
    setState(() {
      _messages.insertAll(0, history);
    });
    print(chat.length);
  }
  void _listenMessage( dynamic payload ){
    ChatMessage message = ChatMessage(
      uid: payload['from'], 
      text: payload['message'], 
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 300))
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(
                userTo.name.substring(0,2),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            const SizedBox(height: 3),
            Text(
              userTo.name,
              style: const TextStyle(color:  Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: ( _, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1,),
            // TODO: input text
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
   );
  }

  Widget _inputChat() => SafeArea(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (text) {
                setState(() {
                  if( text.trim().length > 0){
                    _isWriting = true;
                  } else {
                    _isWriting = false;
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Send message'
              ),
              focusNode: _focusNode,
            ),
          ),
          // send button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS ? 
              CupertinoButton(
                child: Text('Send'), 
                onPressed: _isWriting ?
                () => _handleSubmit(_textController.text.trim())
                :
                null
              )
              :
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _isWriting ?
                      () => _handleSubmit(_textController.text.trim())
                      :
                      null
                  ),
                ),
              )
              
          )
        ],
      ),
    )
  );

  _handleSubmit(String text){
    if (text.trim().isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      uid: authService.userLoggedIn.uid, 
      text: text, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
    socketService.emit('personal-message', {
      'from': authService.userLoggedIn.uid,
      'to': chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
      for( ChatMessage message in _messages){
        message.animationController.dispose();
      }
      socketService.socket.off('personal-message');
      super.dispose();
  }
}