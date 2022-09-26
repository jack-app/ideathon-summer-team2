import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class EventDetail extends StatelessWidget {
  final String eventid;
  const EventDetail({
    Key? key,
    required this.eventid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
        body: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .doc(eventid)
                .snapshots(),
            builder: (context, snapshot) {
              // データが取得できた場合
              if (snapshot.hasData) {
                final DocumentSnapshot documents = snapshot.data!;
                // 取得した投稿メッセージ一覧を元にリスト表示
                return Expanded(
                    child: Column(children: [
                  Text(documents.get('name')),
                  Text((DateFormat.yMMMd('ja'))
                      .format(documents.get('date').toDate())),
                  Text(
                    '参加者一覧',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(child: Participants(eventid: eventid))
                ]));
              }
              return Center(
                child: Text('読み込み中...'),
              );
            }),
        Container(
          child: ElevatedButton(
            child: Text('へんしゅー'),
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }),
              );
            },
          ),
        ),
        SizedBox(height: 20)
      ],
    ));
  }
}

class Participants extends StatelessWidget {
  final String eventid;
  const Participants({
    Key? key,
    required this.eventid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventid)
            .collection('participants')
            .snapshots(),
        builder: (context, snapshot) {
          // データが取得できた場合
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            // 取得した投稿メッセージ一覧を元にリスト表示
            return ListView(
              children: documents.map((document) {
                return _Participants(
                    name: document['name'],
                    money: document['money'],
                    deadline: document['deadline']);
              }).toList(),
            );
          }
          return Center(
            child: Text('読み込み中...'),
          );
        });
  }
}

class _Participants extends StatelessWidget {
  final String name;
  final int money;
  final Timestamp deadline;

  const _Participants({
    Key? key,
    required this.name,
    required this.money,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(name)),
          SizedBox(width: 8),
          SizedBox(
              width: 50,
              child: Text(
                '${money.toString()}円',
                textAlign: TextAlign.end,
              )),
          SizedBox(width: 30),
          SizedBox(
              width: 100,
              child: Text(DateFormat.yMMMd('ja').format(deadline.toDate()))),
        ],
      ),
    );
  }
}
