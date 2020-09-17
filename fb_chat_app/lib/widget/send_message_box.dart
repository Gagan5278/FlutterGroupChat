import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendMessageBox extends StatefulWidget {
  @override
  _SendMessageBoxState createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  String _addedMessage = '';
  final object = FirebaseFirestore.instance.collection('chat');
  final _messageController = TextEditingController();

  void _sendMessage() async {
    final userID = FirebaseAuth.instance.currentUser.uid;
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(userID).get();
    final username = userData.data()['user_name'];
    final imageURL = userData.data()['image_url'];
    _messageController.text = "";
    object.add({
      'message': _addedMessage,
      'createdAt': Timestamp.now(),
      'userID': userID,
      'user_name': username,
      'image_url': imageURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      margin: EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Your message..'),
              onChanged: (val) {
                setState(() {
                  _addedMessage = val;
                });
              },
            ),
          ),
          RaisedButton.icon(
              onPressed: _addedMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: Text('Send')),
        ],
      ),
    );
  }
}
