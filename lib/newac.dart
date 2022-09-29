import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'eventlist.dart';

//アカウント新規登録画面
class CreateAcount extends StatefulWidget {
  @override
  _CreateAcountState createState() => _CreateAcountState();
}

class _CreateAcountState extends State<CreateAcount> {
  bool _isObscure = true;
  // メッセージ表示用
  String infoText = '';
  // 入力した名前・メールアドレス・パスワード
  String name = '';
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 遷移先の画面としてホーム画面を指定
                return TitlePage();
              }),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text('新規登録', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //タイトル
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 60.0,
                ),
                child: Text('アカウントを作ろう！',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
              ),

              //登録フォーム
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
                      //ユーザー入力
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'ユーザー名',
                            icon: Icon(Icons.perm_identity)),
                        onChanged: (String value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      //メールアドレス入力
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'メールアドレス', icon: Icon(Icons.email)),
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      // パスワード入力
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'パスワード',
                          icon: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text(infoText),
                      ),
                      //登録ボタン
                      Container(
                        margin: EdgeInsets.all(30),
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                            ),
                            onPressed: () async {
                              if (name == "") {
                                setState(() {
                                  infoText = "名前を入力してください";
                                });
                              } else {
                                try {
                                  // メール/パスワードでユーザー登録
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  // ユーザー情報を更新
                                  userState.setUser(result.user!);
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  Map<String, dynamic> insertObj = {
                                    'id': user!.uid,
                                    'name': name,
                                  };
                                  var doc = await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid);
                                  await doc.set(insertObj);
                                  // ユーザー登録に成功した場合
                                  // チャット画面に遷移＋ログイン画面を破棄
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return EventListPage();
                                    }),
                                  );
                                } catch (e) {
                                  // ユーザー登録に失敗した場合
                                  setState(() {
                                    infoText = "登録に失敗しました：${e.toString()}";
                                  });
                                }
                              }
                            },
                            child: Text('アカウント登録',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//ログイン画面(いとぅくん)
