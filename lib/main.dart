import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/login_page.dart';
import 'package:whiskit_app/twitter_login_page.dart';
import 'package:whiskit_app/whisky_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // uid の存在を確認
  SharedPreferences prefsRead = await SharedPreferences.getInstance();
  String _uid = prefsRead.getString('uid');
  print(_uid);
  // uidが空ならログインページに飛ばす。
  if (_uid == '') {
    runApp(TwitterLoginPage());
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: ChangeNotifierProvider<BottomNavigationBarProvider>(
        child: BottomNavigationBarExample(),
        create: (_) => BottomNavigationBarProvider(),
      ),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  var currentTab = [
    Home(),
    WhiskyListPage(),
    Profile(),
    TwitterLoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        selectedItemColor: Colors.cyan[600],
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '探す',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          )
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        height: 300,
        width: 300,
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        color: Colors.amber,
      )),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 300,
          width: 300,
          child: Text(
            "マイページ",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          color: Colors.blue,
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        height: 300,
        width: 300,
        child: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        color: Colors.cyan,
      )),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
