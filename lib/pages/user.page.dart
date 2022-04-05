import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/users_services.dart';
import 'package:flutter_chat_app/services/socket_service.dart';

import 'package:flutter_chat_app/models/user.dart';


class UserPage extends StatefulWidget {
  static const routeName = 'user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final userService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<User> users = [];
  // final users = [
    // User(uid: '1', name: 'javier', email: 'ja@gmail.com', online: true),
    // User(uid: '2', name: 'isabela', email: 'isa@gmail.com', online: false),
    // User(uid: '3', name: 'melisa', email: 'meli@gmail.com', online: true),
  // ];
  @override
  void initState() {
    _loadUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar( 
        title: Text(
          authService.userLoggedIn.name,
          style: const TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          color: Colors.black87,
          onPressed: () {
            socketService.disconnect();  
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online ?
                Icon(Icons.check_circle, color: Colors.blue[400],)
              :
                const Icon(Icons.offline_bolt, color: Colors.red,)
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
        onTap: (){
          final chatService = Provider.of<ChatService>( context, listen: false );
          chatService.userTo = user;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _loadUsers() async {
    
    users = await userService.getUsers();
    setState(() {});
    // await Future.delayed(
    //   const Duration(milliseconds: 1000)
    // );
    _refreshController.refreshCompleted();
  }
}