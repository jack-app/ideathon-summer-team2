import 'dart:html';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'RandomString.dart';

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
class MemberRegisterPage extends StatefulWidget {
  // 画面遷移元からのデータを受け取る変数
  final String UserID;
  final String EventName;
  final DateTime EventDate;

  // コンストラクタ
  const MemberRegisterPage(
      {Key? key,
      required this.UserID,
      required this.EventName,
      required this.EventDate})
      : super(key: key);

  @override
  _MemberRegisterPageState createState() => _MemberRegisterPageState();
}

class _MemberRegisterPageState extends State<MemberRegisterPage> {
  // 入力されたテキストをデータとして持つ
  late String _UserID;
  late String _EventName;
  late DateTime _EventDate;

  // State
  // 参加メンバーのリスト
  List<Map> MemberList = [];

  // 新規メンバーの値
  var NewMemberName;
  var NewMemberPaymentStr;
  var NewMemberDeadline;

  // エラー文
  var FormExceptionText = "";

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    _UserID = widget.UserID;
    _EventName = widget.EventName;
    _EventDate = widget.EventDate;

    // 新規メンバーの初期値を指定
    NewMemberName = "";
    NewMemberPaymentStr = "";
    NewMemberDeadline = _EventDate;
  }

  // テキストフィールドの制御
  var _memberNameController = TextEditingController();
  var _memberPaymentController = TextEditingController();

  // メンバーの期限入力フォーム
  _DeadlinePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: NewMemberDeadline,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != NewMemberDeadline) {
      setState(() {
        NewMemberDeadline = datePicked;
      });
    }
  }

  // 日付のフォーマッター
  DateFormat outputFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
        // AppBarを表示し、タイトルも設定
        appBar: AppBar(
          title: Text('メンバー登録'),
        ),
        // ListViewを使いリスト一覧を表示
        body: SingleChildScrollView(
          child: Column(children: [
            Text(_EventName + '   ' + outputFormat.format(_EventDate)),
            const SizedBox(height: 15),

            // メンバーのフォーム
            Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 10.0,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
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
                              NewMemberName = value;
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
                              NewMemberPaymentStr = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),

                        // 支払期限のフォーム
                        FormLabelText('支払期限'),
                        Row(
                          children: <Widget>[
                            Text(outputFormat.format(NewMemberDeadline)),
                            IconButton(
                                onPressed: () {
                                  _DeadlinePicker(context);
                                },
                                icon: Icon(
                                  Icons.edit_calendar,
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
                      ],
                    ))),
            Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // メンバーを追加するボタン
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'メンバー追加',
                      onPressed: () {
                        if (NewMemberName != "" && NewMemberPaymentStr != "") {
                          try {
                            setState(() {
                              // メンバーの追加
                              MemberList.add({
                                'name': NewMemberName, // 名前
                                'payment':
                                    int.parse(NewMemberPaymentStr), // 支払金額
                                'deadline': NewMemberDeadline,
                              });
                              // 新しいメンバーの値を初期化
                              NewMemberName = "";
                              NewMemberPaymentStr = "";
                              NewMemberDeadline = _EventDate;
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
                        } else if (NewMemberName != "") {
                          setState(() {
                            //例外が発生したら実行する処理
                            FormExceptionText = "金額が未入力です";
                          });
                        } else if (NewMemberPaymentStr != "") {
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

                    const SizedBox(width: 30),

                    // イベント登録ボタン
                    IconButton(
                      icon: const Icon(Icons.send),
                      tooltip: 'イベント登録',
                      onPressed: () async {
                        String EventDocID = generateNonce(20);
                        // ドキュメント作成
                        await FirebaseFirestore.instance
                            .collection('events') // コレクションID
                            .doc(EventDocID) // ドキュメントID
                            .set({
                          'author': _UserID,
                          'name': _EventName,
                          'date': _EventDate,
                        }); // データ

                        for (var index = 0;
                            index < MemberList.length;
                            index++) {
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(EventDocID)
                              .collection('participants')
                              .doc()
                              .set({
                            'deadline': MemberList[index]['deadline'],
                            'money': MemberList[index]['payment'],
                            'name': MemberList[index]['name'],
                          });
                        }
                        // 1つ前の画面に戻る
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
            ]),

            // メンバーのカードとフォームのスタート
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

              itemCount: MemberList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(MemberList[index]['name']),
                    subtitle: Text('金額' +
                        MemberList[index]['payment'].toString() +
                        '円   期限:' +
                        outputFormat.format(MemberList[index]['deadline'])),

                    //右側にボタンを配置
                    trailing: Row(
                      // これを書かないとレイアウトが崩れる
                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                        // メンバー削除ボタン
                        IconButton(
                          tooltip: '削除',
                          onPressed: () {
                            setState(() {
                              // リスト削除
                              MemberList.removeAt(index);
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
          ]),
        ));
  }
}
