import 'package:flutter_application_1/main.dart';
import 'home.dart';
import 'package:flutter/material.dart';

//アカウント新規登録画面
class CreateAcount extends StatefulWidget {
  @override
   _CreateAcountState createState() => _CreateAcountState();
}
class _CreateAcountState extends State<CreateAcount> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                // 遷移先の画面としてホーム画面を指定
                                return TitlePage();}),
                              );
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
        ),
        title: Text('新規登録',style: TextStyle(color:Colors.white)),
      ),
      body: Center(   
        child:Container( 
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            //タイトル
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 60.0,),
                child:Text('アカウントを作ろう！',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26)),),

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
                        decoration: InputDecoration(labelText: 'ユーザー名',icon: Icon(Icons.perm_identity)),
                        onChanged: (String value) {}  
                      ), 
                      //メールアドレス入力
                      TextFormField(
                        decoration: InputDecoration(labelText: 'メールアドレス',icon: Icon(Icons.email)),
                        onChanged: (String value) {
                        }  
                        ),
                      // パスワード入力
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'パスワード',
                          icon: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                              
                        onChanged: (String value) {
                        },
                      ),  
          
                      //登録ボタン
                      Container(
                        margin: EdgeInsets.all(30),
                        child:SizedBox(
                          width: 200, 
                          height: 50, 
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue,),
                            onPressed: () { 
                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                // 遷移先の画面としてホーム画面を指定
                                return HomePage();}),
                              );
                            },
                            child: Text('アカウント登録', style: TextStyle(color: Colors.white)),
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
