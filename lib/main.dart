import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(MyApp()); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マネコレ',
      theme: ThemeData(
        primarySwatch: Colors.blue,),
      home: TitlePage(),
    );
  }
}

//スタート画面      
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
              child:Text('マネコレ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36)),),
            
            //アカウント作成ボタン
            Container(
              margin: EdgeInsets.all(40),
              child:SizedBox(
                width: 200, 
                height: 50, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue,),
                  onPressed: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてアカウント作成画面を指定
                    return CreateAcount();}),
                  );},
                  child: Text('アカウント作成', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          
            //ログイン画面ボタン
            Container(
              margin: EdgeInsets.all(40),
              child:SizedBox(
                width: 200, 
                height: 50, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue,),
                  onPressed: () {},
                  child: Text('ログイン', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ]
        ),
      ),
    ); 
  }
}