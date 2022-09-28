import 'package:flutter/material.dart';

const kButtonColorPrimary = Color(0xFFECEFF1);
const kButtonTextColorPrimary = Color(0xFF455A64);
const Color kAccentColor = Color(0xFFFE7C64);
const Color kBackgroundColor = Color(0xFF19283D);
const Color kTextColorPrimary = Color(0xFFECEFF1);
const Color kTextColorSecondary = Color(0xFFB0BEC5);
const Color kIconColor = Color(0xFF455A64);

void main() => runApp(MyApp());

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
      onTap: () {},
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マネコレ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
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
                child: _CustomTextField(
                  labelText: 'mail',
                  hintText: 'メールアドレスを入力してください',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                //パスワード入力
                width: 500,
                child: _CustomTextField(
                  labelText: 'password',
                  hintText: 'パスワードを入力してください',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 24),
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
                  onPressed: () {},
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
      ),
    );
  }
}
