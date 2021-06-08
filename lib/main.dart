import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/history/main.dart';
import 'stores/index.dart';
import 'pages/dashboard/index.dart';
import 'pages/category/index.dart';
import 'pages/story/index.dart';
import 'setting/index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouterStore()),
        ChangeNotifierProvider(create: (_) => StoryStore())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'AndikaNewBasic-Regular',
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        scaffoldBackgroundColor: themeColor,
        primaryColor: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardPage(),
      routes: {
        '/categories': (context) => CategoryListPage(),
        '/history': (context) => HistoryPage(),
        '/category': (context) => CategoryShowPage(),
        '/story': (context) => StoryPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
