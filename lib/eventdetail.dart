import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'eventlist.dart';
import 'edit_member.dart';
import 'add_member.dart';

class EventDetail extends StatelessWidget {
  final String event_id;
  final DateTime event_date;
  const EventDetail({
    Key? key,
    required this.event_id,
    required this.event_date,
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
                    .doc(event_id)
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
                      Expanded(
                          child: Participants(
                              event_id: event_id, event_date: event_date))
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
  final String event_id;
  final DateTime event_date;

  const Participants(
      {Key? key, required this.event_id, required this.event_date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    // 日付のフォーマッター
    DateFormat outputFormat = DateFormat.yMMMd('ja');
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(event_id)
            .collection('participants')
            .snapshots(),
        builder: (context, snapshot) {
          // データが取得できた場合
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            // 取得した投稿メッセージ一覧を元にリスト表示
            return Column(children: [
              Expanded(
                  child: ListView.builder(
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
                                        eventid: event_id,
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
                                //右側にボタンを配置
                                trailing: Row(
                                  // これを書かないとレイアウトが崩れる
                                  mainAxisSize: MainAxisSize.min,

                                  children: <Widget>[
                                    // メンバー削除ボタン
                                    IconButton(
                                      tooltip: '削除',
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(event_id)
                                            .collection('participants')
                                            .doc(documents[index].id)
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(event_id)
                                            .get()
                                            .then((DocumentSnapshot snapshot) {
                                          int participants_num =
                                              snapshot.get('participants_num');
                                          FirebaseFirestore.instance
                                              .collection('events')
                                              .doc(event_id)
                                              .update({
                                            'participants_num':
                                                participants_num - 1
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ]);
                },
              )),
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
                      return AddMemberPage(
                          event_id: event_id, deadline: event_date);
                    }),
                  );
                },
              ),
            ]);
          }
          return Center(
            child: Text('読み込み中...'),
          );
        });
  }
}
