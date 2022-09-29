import 'dart:html';
import 'main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'member_register.dart';
import 'random_string.dart';

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
class EditMemberPage extends StatefulWidget {
  // 画面遷移元からのデータを受け取る変数
  final eventid;
  final memberid;
  final name;
  final payment;
  final deadline;

  // コンストラクタ
  const EditMemberPage(
      {Key? key,
      required this.eventid,
      required this.memberid,
      required this.name,
      required this.payment,
      required this.deadline})
      : super(key: key);
  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  // State
  // イベントのID
  String eventid = "";
  // メンバーのID
  String memberid = "";
  // 新しい名前
  String newname = "";
  // 新しい金額
  String newpayment = "";
  // 新しい締め切り
  var newdeadline;
  // エラー文
  String FormExceptionText = "";

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    eventid = widget.eventid;
    memberid = widget.memberid;
    newname = widget.name;
    newpayment = widget.payment.toString();
    newdeadline = widget.deadline;
  }

  // 日付を入力するフォーム
  _DeadlinePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: newdeadline,
        firstDate: DateTime(2003),
        lastDate: DateTime(2023));
    if (datePicked != null && datePicked != newdeadline) {
      setState(() {
        newdeadline = datePicked;
      });
    }
  }

  // 日付のフォーマッター
  DateFormat outputFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('メンバー編集'),
      ),
      // ListViewを使いリスト一覧を表示
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'メンバーの情報を更新しよう',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
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
                          // 名前の入力フィールド
                          TextFormField(
                            // 自動フォーカス
                            autofocus: true,
                            // テキスト入力のラベルを設定
                            decoration: InputDecoration(
                              labelText: '名前',
                              icon: Icon(
                                Icons.badge,
                              ),
                              hintText: 'メンバーの名前を入力してください',
                              hintStyle: TextStyle(
                                  color: kTextColorSecondary, fontSize: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kAccentColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kTextColorSecondary,
                                ),
                              ),
                            ),
                            initialValue: newname,
                            onChanged: (String value) {
                              setState(() {
                                newname = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          // 金額の入力フィールド
                          TextFormField(
                            // 自動フォーカス
                            autofocus: true,
                            // テキスト入力のラベルを設定
                            decoration: InputDecoration(
                              labelText: '金額',
                              icon: Icon(
                                Icons.money,
                              ),
                              hintText: '金額を数字で入力してください',
                              hintStyle: TextStyle(
                                  color: kTextColorSecondary, fontSize: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kAccentColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kTextColorSecondary,
                                ),
                              ),
                            ),
                            initialValue: newpayment,
                            onChanged: (String value) {
                              setState(() {
                                newpayment = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),

                          // 日付の入力ボックス
                          Container(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                icon: Icon(Icons.edit_calendar),
                                border: InputBorder.none,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: '支払期限',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: kTextColorSecondary,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                        outputFormat.format(newdeadline),
                                        textAlign: TextAlign.left),
                                  ),
                                ),
                                onTap: () {
                                  _DeadlinePicker(context);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 更新ボタン
                          ElevatedButton.icon(
                              icon: const Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                              label: const Text('更新'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                fixedSize: Size.fromHeight(30),
                              ),
                              onPressed: () async {
                                if (newname != "" && newpayment != "") {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(eventid)
                                        .collection('participants')
                                        .doc(memberid)
                                        .update({
                                      'name': newname,
                                      'money': int.parse(newpayment),
                                      'deadline': newdeadline,
                                    });
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    setState(() {
                                      //例外が発生したら実行する処理
                                      FormExceptionText = "金額は数字で入力してください";
                                    });
                                  }
                                } else if (newname != "") {
                                  setState(() {
                                    //例外が発生したら実行する処理
                                    FormExceptionText = "金額が未入力です";
                                  });
                                } else if (newpayment != "") {
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
                              }),

                          // 注意書きのテキスト
                          Text(
                            FormExceptionText,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ))),
              const SizedBox(height: 15),
            ]))
      ]),
    );
  }
}
