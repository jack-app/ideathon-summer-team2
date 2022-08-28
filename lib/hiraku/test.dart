import 'package:flutter/material.dart';

class EventRegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'イベント登録',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: EventRegisterPage(),
    );
  }
}

// リスト一覧画面用Widget
class EventRegisterPage extends StatefulWidget {
  @override
  _EventRegisterPageState createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {
  // State
  // イベントの名前
  String EventName = '';
  // 参加メンバーのリスト
  List<Map> memberList = [];
  // メンバー情報の初期値
  var member = {
    'name': 'test', // 名前
    'payment': 0, // 支払金額
  };
  // 選ばれているフォームのインデックス
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('イベント登録'),
      ),
      // ListViewを使いリスト一覧を表示
      body: ListView.builder(
        itemCount: memberList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(memberList[index]['name'] + index.toString()),
              subtitle: Text(memberList[index]['payment'].toString()),
              selected: selectedIndex == index ? true : false,
              selectedTileColor: Colors.pink.withOpacity(0.2),
              // (memberList[index]['open']) ? Text("open") : Text("close"),

              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },

              //右側にボタンを配置
              trailing: Row(
                // これを書かないとレイアウトが崩れる
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  // タスク更新ボタン
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    icon: Icon(Icons.mode_edit),
                  ),

                  // タスク削除ボタン
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // リスト削除
                        memberList.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // メンバーを追加するボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            memberList.add(member);
            selectedIndex = memberList.length - 1;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  // 画面遷移元からのデータを受け取る変数
  final String value;

  // コンストラクタ
  const TodoAddPage({Key? key, required this.value}) : super(key: key);

  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ
  late String _text;

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    _text = widget.value;
  }

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    // TextEditingControllerのtextで初期値を設定することが出来る
    final controller = TextEditingController(text: _text);

    // TextEditingControllerに設定したテキストのlengthをカーソルの位置に設定する
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Container(
        // 余白を付ける
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // テキスト入力
            TextField(
              controller: controller,
              // 自動フォーカス
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'タスクを入力してね',
              ),
              // 入力されたテキストの値を受け取る(valueが入力されたテキスト)
              onChanged: (String value) {
                // データが変更したことを知らせる(画面を更新する)
                setState(() {
                  // データを変更
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    // "pop"の引数から前の画面にデータを渡す
                    Navigator.of(context).pop(_text);
                  },
                  child: Text('リスト追加', style: TextStyle(color: Colors.white))),
            ),
            const SizedBox(height: 8),
            Container(
                // 横幅いっぱいに広げる
                width: double.infinity,
                // キャンセルボタン
                child: TextButton(
                  // ボタンをクリックしたときの処理
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text('キャンセル'),
                )),
          ],
        ),
      ),
    );
  }
}
