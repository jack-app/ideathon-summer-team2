import 'package:flutter/material.dart';

//ホーム画面
class HomePage extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              child:Text('イベント一覧',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36)),
              
            ),
            //イベントリスト
            Container(
              height: 400,
              margin: EdgeInsets.all(40),
              color: Colors.blue,
              child:ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('1/3:ほげほげ'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('1/3:ほげほげ'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('1/3:ほげほげ'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('1/3:ほげほげ'),
                    ),
                  ),
                ],
              ),
            ),

            //イベント新規登録ボタン
            Container(
              margin: EdgeInsets.all(40),
              child:SizedBox(
                width: 200, //横幅
                height: 50, //高さ
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue,),
                  onPressed: () { // ここで遷移先の画面を指定　
                  },
                  child: Text('イベント新規登録', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
