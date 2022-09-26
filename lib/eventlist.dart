import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'eventdetail.dart';
// 作成したウィジェットのインポート
import 'hiraku/EventRegister.dart';

// リスト一覧画面用Widget
class EventListPage extends StatelessWidget {
  EventListPage();
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
        // AppBarを表示し、タイトルも設定
        appBar: AppBar(
          title: Text('リスト一覧'),
        ),
        // データを元にListViewを作成
        body: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .where('author', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                            title: Text(document['name']),
                            subtitle: Text(DateFormat.yMMMd('ja')
                                .format(document['date'].toDate())),
                            // 自分の投稿メッセージの場合は削除ボタンを表示
                            trailing: IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () async {
                                // 投稿メッセージのドキュメントを削除
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  // 遷移先の画面としてリスト追加画面を指定
                                  return EventDetail(eventid: document.id);
                                }));
                              },
                            )),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text('イベント追加'),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return EventRegisterPage(UserID: user.uid);
                }),
              );
            },
          ),
        ]));
  }
}
