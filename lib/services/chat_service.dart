import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_chat_app/global/environments.dart';

import 'package:flutter_chat_app/services/auth_service.dart';

import 'package:flutter_chat_app/models/user.dart';

class ChatService with ChangeNotifier{
  late User userTo;
  
  Future<List <Message>> getChat( String userId) async {
    final uri = Uri.parse('${Environment.apiUrl}/messages/$userId');
    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final messagesResponse = messagesResponseFromJson(resp.body);

    return messagesResponse.messages;
  }
}