import 'package:flutter_chat_app/global/environments.dart';
import 'package:flutter_chat_app/models/user_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_chat_app/models/user.dart';


class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get( uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      final usersResponse = userResponseFromJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}