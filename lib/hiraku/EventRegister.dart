import 'dart:html';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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

class FormLabelText extends Container {
  FormLabelText(String titleText)
      : super(
          width: double.infinity,
          child: Text(
            titleText,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        );
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
  // イベントの日程
  var EventDate = DateTime.now();
  // 参加メンバーのリスト
  List<Map> memberList = [];
  // メンバー情報の初期値
  var member = {
    'name': 'test', // 名前
    'payment': 0, // 支払金額
    'deadline': DateTime.now(), // 期限
  };

  // 新規メンバーの値
  var newMemberName = "";
  var newMemberPaymentStr = "";
  var newMemberDeadline = DateTime.now();

  // エラー文
  var FormExceptionText = "";

  // テキストフィールドの制御
  var _memberNameController = TextEditingController();
  var _memberPaymentController = TextEditingController();

  // 日付を入力するフォーム
  _EventDatePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: EventDate,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != EventDate) {
      setState(() {
        EventDate = datePicked;
      });
    }
  }

  // メンバーの
  _DeadlinePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: newMemberDeadline,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != newMemberDeadline) {
      setState(() {
        newMemberDeadline = datePicked;
      });
    }
  }

  // 日付のフォーマッター
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('イベント登録'),
      ),
      // ListViewを使いリスト一覧を表示
      body: Column(children: [
        // イベント名の入力フィールド
        TextFormField(
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
        const SizedBox(height: 10),
        FormLabelText('イベントの日程'),
        Row(
          children: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  fixedSize: Size(
                    _size.width, // 画面横いっぱい
                    10,
                  ),
                ),
                onPressed: () {
                  _EventDatePicker(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(outputFormat.format(EventDate),
                      textAlign: TextAlign.left),
                )),
          ],
        ),
        Container(
          height: 1.0,
          color: Colors.grey,
        ),

        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          child: Text(
            'メンバー',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
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
                title: Text(memberList[index]['name'] +
                    '   ' +
                    memberList[index]['payment'].toString() +
                    '円   期限:' +
                    outputFormat.format(memberList[index]['deadline'])),

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
          // 名前のフォーム
          TextFormField(
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

          // 金額のフォーム
          TextFormField(
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
                newMemberPaymentStr = value;
              });
            },
          ),
          const SizedBox(height: 8),

          // 支払期限のフォーム
          FormLabelText('支払期限'),
          Row(
            children: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    fixedSize: Size(
                      _size.width, // 画面横いっぱい
                      10,
                    ),
                  ),
                  onPressed: () {
                    _DeadlinePicker(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(outputFormat.format(newMemberDeadline),
                        textAlign: TextAlign.left),
                  )),
            ],
          ),
          Container(
            height: 1.0,
            color: Colors.grey,
          ),

          // 注意書きのテキスト
          Text(
            FormExceptionText,
            style: TextStyle(
              color: Colors.red,
            ),
          ),

          // メンバーを追加するボタン
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'メンバー追加',
            onPressed: () {
              if (newMemberName != "" && newMemberPaymentStr != "") {
                try {
                  setState(() {
                    // メンバーの追加
                    memberList.add({
                      'name': newMemberName, // 名前
                      'payment': int.parse(newMemberPaymentStr), // 支払金額
                      'deadline': newMemberDeadline,
                    });
                    // 新しいメンバーの値を初期化
                    newMemberName = "";
                    newMemberPaymentStr = "";
                    newMemberDeadline = DateTime.now();
                    FormExceptionText = "";
                  });
                  // テキストフィールドの入力を削除
                  _memberNameController.clear();
                  _memberPaymentController.clear();
                } catch (e) {
                  setState(() {
                    //例外が発生したら実行する処理
                    FormExceptionText = "金額は数字で入力してください";
                  });
                }
              } else if (newMemberName != "") {
                setState(() {
                  //例外が発生したら実行する処理
                  FormExceptionText = "金額が未入力です";
                });
              } else if (newMemberPaymentStr != "") {
                setState(() {
                  //例外が発生したら実行する処理
                  FormExceptionText = "名前が未入力です";
                });
              } else {
                setState(() {
                  //例外が発生したら実行する処理
                  FormExceptionText = "名前・金額が未入力です";
                });
              }
            },
          ),

          // イベント登録ボタン
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: 'イベント登録',
            onPressed: () async {
              // ドキュメント作成
              await FirebaseFirestore.instance
                  .collection('events') // コレクションID
                  .doc(EventName) // ドキュメントID
                  .set({'name': '鈴木', 'age': 40}); // データ
            },
          ),
        ])
      ]),
    );
  }
}
