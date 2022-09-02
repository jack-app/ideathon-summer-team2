import 'dart:html';

import 'package:flutter/material.dart';

class EventRegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'イベント登録',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: EventRegisterPage(),
    );
  }
}

// リスト一覧画面用Widget
class EventRegisterPage extends StatefulWidget {
  @override
  _EventRegisterPageState createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {
  // State
  // イベントの名前
  String EventName = '';
  // 参加メンバーのリスト
  List<Map> memberList = [];
  // メンバー情報の初期値
  var member = {
    'name': 'test', // 名前
    'payment': 0, // 支払金額
  };

  // 新規メンバーの値
  var newMemberName = "";
  var newMemberPayment = 0;

  // テキストフィールドの制御
  var _memberNameController = TextEditingController();
  var _memberPaymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('イベント登録'),
      ),
      // ListViewを使いリスト一覧を表示
      body: Column(children: [
        // イベント名の入力フィールド
        TextField(
          // 自動フォーカス
          autofocus: true,
          // テキスト入力のラベルを設定
          decoration: InputDecoration(labelText: "イベント名"),
          onChanged: (String value) {
            setState(() {
              EventName = value;
            });
          },
        ),
        // 確定したメンバーのリスト表示
        ListView.builder(
          // ListViewをColumn内で使うときはこれを書かないとダメらしい
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: memberList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(memberList[index]['name']),
                subtitle: Text(memberList[index]['payment'].toString()),

                //右側にボタンを配置
                trailing: Row(
                  // これを書かないとレイアウトが崩れる
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    // メンバー削除ボタン
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // リスト削除
                          memberList.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        Column(children: <Widget>[
          // テキスト入力
          TextField(
            // コントローラー
            controller: _memberNameController,
            // 自動フォーカス
            autofocus: true,
            // テキスト入力のラベルを設定
            decoration: InputDecoration(labelText: "名前"),
            onChanged: (String value) {
              setState(() {
                newMemberName = value;
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            // コントローラー
            controller: _memberPaymentController,
            // 数字入力指定
            keyboardType: TextInputType.number,
            // 自動フォーカス
            autofocus: true,
            // テキスト入力のラベルを設定
            decoration: InputDecoration(labelText: "金額"),
            onChanged: (String value) {
              setState(() {
                newMemberPayment = int.parse(value);
              });
            },
          ),
        ])
      ]),

      // メンバーを追加するボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // メンバーの追加
            memberList.add({
              'name': newMemberName, // 名前
              'payment': newMemberPayment, // 支払金額
            });

            // 新しいメンバーの値を初期化
            newMemberName = "";
            newMemberPayment = 0;
          });

          // テキストフィールドの入力を削除
          _memberNameController.clear();
          _memberPaymentController.clear();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
