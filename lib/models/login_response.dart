// To parse this JSON data, do
//
//     final loginMessage = loginMessageFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat_app/models/user.dart';

LoginMessage loginMessageFromJson(String str) => LoginMessage.fromJson(json.decode(str));

String loginMessageToJson(LoginMessage data) => json.encode(data.toJson());

class LoginMessage {
    LoginMessage({
        required this.ok,
        required this.user,
        required this.token,
    });

    bool ok;
    User user;
    String token;

    factory LoginMessage.fromJson(Map<String, dynamic> json) => LoginMessage(
        ok: json["ok"],
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
    };
}


