import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallo/models/uid.dart';

class ChatButton extends StatefulWidget {
  final String friendName;
  final String imageURL;
  String fuid;
  bool group;
  String guid;

  // icon =0 (normal) =1(birthday) =2(selecteD)
  final int icon;
  var onPressed;

  ChatButton({this.friendName, this.onPressed, this.imageURL, this.icon, this.fuid, this.group, this.guid});

  @override
  _ChatButtonState createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.yellow.withOpacity(0.8),
    Colors.brown,
    Colors.deepPurple,
    Colors.pinkAccent,
    Colors.blue,
    Colors.orange
  ];
  Random random = new Random();
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeIndex();
  }

  void changeIndex() {
    setState(() => index = random.nextInt(3));
  }


  Color selected = Colors.lightBlue.withOpacity(.6);

  Color notSelected = Colors.white70;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;


    Widget recentText(String fuid) {
      String msgText, msgFrom;
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('messages')
              .document(current_user_uid)
              .collection(widget.fuid)
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Start Conversation');
            } else {
              final chat = snapshot.data.documents;
              print(chat);
              for (var msg in chat) {
                print(msg.data);
                msgText = msg.data['text'];
                msgFrom = msg.data['from'];
              }
              if (msgText != null) {
                return Text(msgText);
              } else {
                return Text(' ');
              }
            }
          });
    }

    Widget recentGroupText(String fuid) {
      String msgText;
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('messages')
              .document(current_user_uid)
              .collection('groups_chat')
              .document(widget.guid)
              .collection('Chats')
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Start Conversation');
            } else {
              final chat = snapshot.data.documents;
              print(chat);
              for (var msg in chat) {
                print(msg.data);
                msgText = msg.data['text'];
              }
              if (msgText != null) {
                return Text(msgText);
              } else {
                return Text(' ');
              }
            }
          });
    }


    return Material(
      elevation: 2.0,
      color: widget.icon == 2 ? selected : notSelected,
      child: MaterialButton(
        onPressed: widget.onPressed,
        height: screenHeight / 10,
        child: ListTile(
          contentPadding: EdgeInsets.all(4.0),
          leading: widget.imageURL != null
              ? CircleAvatar(
            radius: 30,
            backgroundColor: Theme
                .of(context)
                .backgroundColor,
            backgroundImage: AssetImage('images/loading.png'),
            child: ClipOval(
              child: new SizedBox(
                width: 180,
                height: 180,
                child: widget.imageURL != null
                    ? Image.network(
                  widget.imageURL,
                  fit: BoxFit.cover,
                )
                    : Container(
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/loading.png'),
                    ),
                  ),
                ),
              ),
            ),
          )
              : CircleAvatar(
            //backgroundImage: AssetImage('images/user1.png'),
            backgroundColor: colors[index].withOpacity(0.5),
            radius: 32.0,
            child: ClipOval(
              child: new SizedBox(
                width: 180,
                height: 180,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.friendName,
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              widget.group ? recentText(widget.fuid)
                  :
              recentGroupText(widget.fuid),
            ],
          ),
          trailing: widget.icon == 1
              ? Icon(
            Icons.cake,
            color: Theme
                .of(context)
                .splashColor,
          )
              : widget.icon == 2
              ? Icon(
            Icons.check,
          )
              : Icon(
            Icons.remove_circle_outline,
          ),
        ),
      ),
    );
  }
}

