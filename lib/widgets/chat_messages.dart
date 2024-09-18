import 'package:chat_app_v2/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authinticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('An error occurred!'),
            );
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data found!'),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
              padding: EdgeInsets.only(
                bottom: 40,
                left: 14,
                right: 14,
              ),
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                final chatDoc = chatDocs[index];
                final nextChatDoc =
                    index + 1 < chatDocs.length ? chatDocs[index + 1] : null;
                final currentMessageUserID = chatDoc['userId'];
                final nextMessageUserId =
                    nextChatDoc != null ? nextChatDoc['userId'] : null;
                final nextUserIsMe = currentMessageUserID == nextMessageUserId;
                if (nextUserIsMe) {
                  return MessageBubble.next(
                    message: chatDoc['text'],
                    isMe: authinticatedUser.uid == currentMessageUserID,
                  );
                } else {
                  return MessageBubble.first(
                      userImage: chatDoc['userImage'],
                      username: chatDoc['username'],
                      message: chatDoc['text'],
                      isMe: authinticatedUser.uid == currentMessageUserID);
                }
              });
        });
  }
}
