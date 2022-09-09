import 'package:flutter/material.dart';
void main() => runApp(MyApp()); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'お金集めるんです',
      theme: ThemeData(
        primarySwatch: Colors.blue,),
      home: TitlePage(),
    );
  }
}

//タイトル画面      
class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //タイトル
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 200.0,
              horizontal: 20.0,),
            child:Text('集金アプリ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36)),),
          //イベント一覧ボタン
          Container(
            margin: EdgeInsets.all(40),
            child:SizedBox(
              width: 200, //横幅
              height: 50, //高さ
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue,),
                onPressed: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                // 遷移先の画面としてリスト追加画面を指定
                  return HomePage();}),
                );},
                child: Text('イベント一覧', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          //イベント登録画面
          Container(
            margin: EdgeInsets.all(40),
            child:SizedBox(
              width: 200, //横幅
              height: 50, //高さ
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue,),
                onPressed: () {},
                child: Text('イベント登録', style: TextStyle(color: Colors.white)),
            ),
              ),
            ),
            ]
        ),
      ),
    ); 
  }
}

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

            //新規登録画面
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