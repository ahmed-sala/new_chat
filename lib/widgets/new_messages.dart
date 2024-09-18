import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firebaseFirestore = FirebaseFirestore.instance;
final firebase = FirebaseAuth.instance;

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  void _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    final user = firebase.currentUser!;
    _messageController.clear();
    final userCredential =
        await firebaseFirestore.collection('users').doc(user.uid).get();
    final username = userCredential.data()!['username'];
    final userImage = userCredential.data()!['image_url'];
    firebaseFirestore.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': username,
      'userImage': userImage,
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 1,
          bottom: 14,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(labelText: 'Send a message...'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendMessage,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
  }
}
