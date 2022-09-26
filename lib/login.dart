import 'home.dart';
import 'package:flutter/material.dart';
//アカウント作成画面
class CreateAcount extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(   
        child:Container( 
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            //タイトル
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 100.0,),
              child:Text('アカウント作成',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26)),),
            
            //ユーザー入力
            TextFormField(
              decoration: InputDecoration(labelText: 'ユーザー名'),
              onChanged: (String value) {
              }  
            ),
            //メールアドレス入力
            TextFormField(
              decoration: InputDecoration(labelText: 'メールアドレス'),
              onChanged: (String value) {
              }  
            ),
          
            // パスワード入力
            TextFormField(
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
              onChanged: (String value) {
              },
            ),  
  
            //登録ボタン
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
                    // 遷移先の画面としてホーム画面を指定
                    return HomePage();}),
                    );},
                    child: Text('登録', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }        
}


//ログイン画面(いとぅくん)
