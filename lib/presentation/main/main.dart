import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/presentation/my/my_page.dart';
import 'package:whiskit_app/presentation/setting/setting_page.dart';
import 'package:whiskit_app/presentation/start/start_page.dart';
import 'package:whiskit_app/presentation/whisky_list/whisky_list_page.dart';
import '../home/home_page.dart';
import 'bottom_navigation_bar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // uid の存在を確認
  SharedPreferences prefsRead = await SharedPreferences.getInstance();
  String _uid = prefsRead.getString('uid');
  print(_uid);
  // uidが空ならログインページに飛ばす。
  if (_uid == '') {
    runApp(StartPage());
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
        textTheme: TextTheme(),
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
    HomePage(),
    WhiskyListPage(),
    MyPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 8,
        unselectedFontSize: 8,
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
            label: 'さがす',
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
