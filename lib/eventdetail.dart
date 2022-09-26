import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'eventlist.dart';
import 'edit_member.dart';

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
        // AppBarを表示し、タイトルも設定
        appBar: AppBar(
          title: Text('イベント詳細'),
        ),
        body: Column(
          children: [
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
                      Text(
                        documents.get('name'),
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        (DateFormat.yMMMd('ja'))
                            .format(documents.get('date').toDate()),
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
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
    // 日付のフォーマッター
    DateFormat outputFormat = DateFormat.yMMMd('ja');
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
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                      child: Card(
                          elevation: 5.0,
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  // 遷移先の画面としてリスト追加画面を指定
                                  return EditMemberPage(
                                      eventid: eventid,
                                      memberid: documents[index].id,
                                      name: documents[index]['name'],
                                      payment: documents[index]['money'],
                                      deadline: documents[index]['deadline']
                                          .toDate());
                                }),
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text(documents[index]['name']),
                              subtitle: Text(
                                  '金額：${documents[index]['money'].toString()}円   期限：${outputFormat.format(documents[index]['deadline'].toDate())}'),
                            ),
                          ))),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text('メンバー追加'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      fixedSize: Size.fromHeight(30),
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // 遷移先の画面としてリスト追加画面を指定
                          return EditMemberPage(
                              eventid: eventid,
                              memberid: documents[index].id,
                              name: "",
                              payment: "",
                              deadline: documents[index]['deadline'].toDate());
                        }),
                      );
                    },
                  )
                ]);
              },
            );
          }
          return Center(
            child: Text('読み込み中...'),
          );
        });
  }
}
