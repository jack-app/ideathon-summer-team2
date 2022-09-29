import 'newac.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'login.dart';

//スタート画面
class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //タイトル
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 100.0,
                  horizontal: 20.0,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text('マネコレへようこそ！',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                      Text('マネコレで集金管理を簡単に', style: TextStyle(fontSize: 20)),
                    ]),
              ),

              //新規登録ボタン
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // 遷移先の画面として新規登録画面を指定
                          return CreateAcount();
                        }),
                      );
                    },
                    child: Text('新規登録', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),

              //ログイン画面ボタン
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // 遷移先の画面として新規登録画面を指定
                          return LoginPage();
                        }),
                      );
                    },
                    child: Text('ログイン', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
