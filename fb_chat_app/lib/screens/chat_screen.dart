import 'package:fb_chat_app/widget/message_list.dart';
import 'package:fb_chat_app/widget/send_message_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat app'),
          actions: [
            DropdownButton(
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                    child: Container(
                  child: Row(
                    children: [Text('Logout'), Icon(Icons.exit_to_app)],
                  ),
                )),
              ],
              onChanged: (identifier) {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [Expanded(child: MessageList()), SendMessageBox()],
          ),
        ));
  }
}
