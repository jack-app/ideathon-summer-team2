import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'eventlist.dart';
import 'start.dart';

const kButtonColorPrimary = Color(0xFFECEFF1);
const kButtonTextColorPrimary = Color(0xFF455A64);
const Color kAccentColor = Color(0xFFFE7C64);
const Color kBackgroundColor = Color(0xFF19283D);
const Color kTextColorPrimary = Color(0xFFECEFF1);
const Color kTextColorSecondary = Color(0xFFB0BEC5);
const Color kIconColor = Color(0xFF455A64);

class _CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;

  const _CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: kTextColorSecondary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
      obscureText: obscureText,
    );
  }
}

class LoginCheck extends StatefulWidget {
  LoginCheck({Key? key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態のチェック(非同期で行う)
  void checkUser() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    final userState = Provider.of<UserState>(context, listen: false);
    if (currentUser == null) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return TitlePage();
        }),
      );
    } else {
      userState.setUser(currentUser);
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return EventListPage();
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  //ログイン状態のチェック時はこの画面が表示される
  //チェック終了後にホーム or ログインページに遷移する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("読み込み中..."),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力した名前・メールアドレス・パスワード
  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 16),
            Container(
              //タイトル
              child: Text('ログイン'),
            ),
            const SizedBox(height: 8),
            Container(
                //メールアドレス入力
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'mail',
                    hintText: 'メールアドレスを入力してください',
                    hintStyle: TextStyle(color: kTextColorSecondary),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  obscureText: false,
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                )),
            const SizedBox(height: 16),
            Container(
                //メールアドレス入力
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'password',
                    hintText: 'パスワードを入力してください',
                    hintStyle: TextStyle(color: kTextColorSecondary),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  obscureText: false,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                )),
            const SizedBox(height: 12),
            Text(infoText),
            const SizedBox(height: 12),
            Container(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: kButtonTextColorPrimary,
                  backgroundColor: kButtonColorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final result = await auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    // ユーザー情報を更新
                    userState.setUser(result.user!);
                    // ログインに成功した場合
                    // チャット画面に遷移＋ログイン画面を破棄
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return EventListPage();
                      }),
                    );
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインに失敗しました：${e.toString()}";
                    });
                  }
                },
                child: Text(
                  'ログイン',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: kButtonTextColorPrimary, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
