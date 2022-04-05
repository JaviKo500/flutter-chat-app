// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat_app/models/user.dart';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    UserResponse({
        required this.ok,
        required this.msg,
        required this.users,
        required this.page,
    });

    bool ok;
    String msg;
    List<User> users;
    int page;

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        ok: json['ok'],
        msg: json['msg'],
        users: List<User>.from(json['users'].map((x) => User.fromJson(x))),
        page: json['page'],
    );

    Map<String, dynamic> toJson() => {
        'ok': ok,
        'msg': msg,
        'users': List<dynamic>.from(users.map((x) => x.toJson())),
        'page': page,
    };
}

