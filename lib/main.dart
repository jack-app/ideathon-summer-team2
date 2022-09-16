import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '集金アプリ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(),//配置調整のため
              Container(//タイトル
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8),
                child: Text('集金アプリ'),
              ),
              Container(),//配置調整のため
              Container(),//配置調整のため
              Container(//イベント一覧へ
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('イベント一覧'),
                    )
                  ],
                  )
              ),
              Container(//イベント登録へ
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('イベント登録'),
                    )
                  ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
