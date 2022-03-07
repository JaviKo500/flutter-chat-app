import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:flutter_chat_app/models/user.dart';


class UserPage extends StatefulWidget {
  static const routeName = 'user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1', name: 'javier', email: 'ja@gmail.com', online: true),
    User(uid: '2', name: 'isabela', email: 'isa@gmail.com', online: false),
    User(uid: '3', name: 'melisa', email: 'meli@gmail.com', online: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(
          'My name',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          color: Colors.black87,
          onPressed: () {
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400],),
            //  Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete:  Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _loadUsers,
        child: _listViewUsers(),
      )
   );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _, i ) => _userListTile(users[i]), 
      separatorBuilder: ( _, i ) => const Divider() , 
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  _loadUsers() async {
    await Future.delayed(
      const Duration(milliseconds: 1000)
    );
    _refreshController.refreshCompleted();
  }
}