import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageList extends StatelessWidget {
  final object = FirebaseFirestore.instance
      .collection('chat')
      .orderBy('createdAt', descending: true);
  @override
  Widget build(BuildContext context) {
    final userIDSelf = FirebaseAuth.instance.currentUser.uid;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        builder: (cntx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.data.docs.isEmpty
                  ? Center(
                      child: Text('Start chat...'),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemBuilder: (cnts, index) {
                        final text =
                            snapshot.data.docs[index].data()['message'];
                        final userID =
                            snapshot.data.docs[index].data()['userID'];
                        final userName =
                            snapshot.data.docs[index].data()['user_name'] ??
                                'dummy';
                        final imageUrl =
                            snapshot.data.docs[index].data()['image_url'];
                        return MessageBubble(
                          text,
                          userIDSelf == userID,
                          userName,
                          imageUrl,
                          key: ValueKey(snapshot.data.docs[index].id),
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                    );
        },
        stream: object.snapshots(),
      ),
    );
  }
}
