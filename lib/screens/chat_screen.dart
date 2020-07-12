import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/extensions/string_extenstion.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('xNo Chat'),
        backgroundColor: Color(0xFF850D27),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              // decoration: kMessageContainerDecoration,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 18,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          messageTextController.clear();
                          var now = DateTime.now();
                          String date =
                              '${now.day.toString()}/${now.month.toString()}';
                          String time =
                              '${DateFormat.jm().format(now).toString()}';
                          _firestore.collection('messages').add(
                            {
                              'text': messageText,
                              'sender': loggedInUser.email,
                              'date': date,
                              'time': time,
                              'Timestamp': FieldValue.serverTimestamp()
                            },
                          );
                        },
                        child: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('Timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        //data - Flutter Async method..
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          //data - Firebase data method...
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final username = messageSender.split("@")[0];
          final date = message.data['date'];
          final time = message.data['time'];
          final currentUser = loggedInUser.email;
          //TODO: Add the Date feature when user clicked the messagebubble...
          // final embededDate = '${messageSender} ${date}';

          final messageBubble = MessageBubble(
            sender: username,
            text: messageText,
            isMe: currentUser == messageSender,
            date: date,
            time: time,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.sender,
    this.text,
    this.isMe,
    this.date,
    this.time,
  });
  final String sender;
  final String text;
  final bool isMe;
  final String date;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe ? "You ${time}" : '${sender.captialFirstLetter()} ${time}',
            style: TextStyle(fontSize: 12.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            color: isMe ? Color(0xFF850D27) : Colors.lightBlue[800],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16.0, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
