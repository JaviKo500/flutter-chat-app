
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_chat_app/global/environments.dart';
import 'package:flutter_chat_app/models/login_response.dart';
import 'package:flutter_chat_app/models/user.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late User _user; 

  User get userLoggedIn => _user;
  
  set userLoggedIn (User user){
    _user = user;
  }
  bool _authenticated = false;

  final _storage = FlutterSecureStorage();

  bool get authenticated => _authenticated;
  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }

  // static getter of token

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }
  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }



  Future<bool> logIn( String email, String password) async {
    authenticated = true;
    final data = {
      'email': email,
      'password': password
    };
    final uri = Uri.parse('${ Evironment.apiUrl }/login');
    final resp = await http.post( uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    authenticated = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginMessageFromJson( resp.body );
      userLoggedIn = loginResponse.user;
      _saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    authenticated = true;
    final data = {
      'name': name,
      'email': email,
      'password': password
    };
    final uri = Uri.parse('${ Evironment.apiUrl }/login/new');
    final resp = await http.post( uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    authenticated = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginMessageFromJson( resp.body );
      userLoggedIn = loginResponse.user;
      _saveToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${ Evironment.apiUrl }/login/renew');
    final resp = await http.get( uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );
    authenticated = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginMessageFromJson( resp.body );
      userLoggedIn = loginResponse.user;
      _saveToken(loginResponse.token);
      return true;
    } else {
      logOut();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}