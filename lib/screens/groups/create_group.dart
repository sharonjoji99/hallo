import 'package:flutter/material.dart';
import 'package:hallo/models/uid.dart';
import 'package:hallo/screens/add_friend/show_friends.dart';
import 'package:hallo/screens/groups/group_page.dart';
import 'package:hallo/services/database.dart';
import 'package:hallo/services/group_info.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String groupName = 'groupName';
  String guid;

  void _showDialog(BuildContext context, List list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Set group name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  groupName = value;
                  print('list in func is $list');
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  print('list sending to db is $list');
                  DatabaseService(uid: current_user_uid).createGroup(
                      list, groupName);
                  //FIX THIS CODE GUID IS NULL AS OF NOW
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      GroupPage(
                        groupUID: guid,
                        fname: groupName,
                      )));
                },
                child: Text('create'),
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GroupInfo.selectedFriends.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<String> groupMembers = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Group",
        ),
        centerTitle: true,
        backgroundColor: Theme
            .of(context)
            .accentColor,
        elevation: 4,
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .backgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 15,
                child: ListStream(check: true)),
            Expanded(
              flex: 1,
              child: RaisedButton(
                onPressed: () {
                  groupMembers = GroupInfo.selectedFriends;
                  print('group member in screen is $groupMembers');
                  _showDialog(context, groupMembers);
                },
                child: Text('Create'),
              ),
            )
          ],
        ),
        //Text('New message to: '),
      ),
    );
  }
}

