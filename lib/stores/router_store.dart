import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:truyen_full_audio/models/index.dart';
import 'package:truyen_full_audio/stores/index.dart';
import '../pages/category/index.dart';
import '../pages/story/index.dart';
import '../pages/dashboard/index.dart';
import '../pages/category/list.dart';
import '../pages/history/main.dart';
import 'package:provider/provider.dart';

class RouterStore with ChangeNotifier, DiagnosticableTreeMixin {
  String router = "/";

  navigateTo(BuildContext context, String router) {
    List<String> menuBase = ['/', '/categories'];
    this.router = router;
    if (menuBase.contains(this.router) && menuBase.contains(router)) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => targetWidgetRouter(router)
      ),);
      // Navigator.pushNamed(context, router);
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => targetWidgetRouter(router)
      ),);
      // Navigator.pushNamed(context, router);
    }
  }

  Widget targetWidgetRouter(String router) {
    switch (router) {
      case '/':
        {
          return DashboardPage();
        }
      case '/category':
        {
          return CategoryShowPage();
        }
      case '/categories':
        {
          return CategoryListPage();
        }
      case '/story':
        {
          return StoryPage();
        }
      case '/history':
        {
          return HistoryPage();
        }
    }
    return DashboardPage();
  }

  get isStoryPage {
    return this.router.indexOf('/story') != -1;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
