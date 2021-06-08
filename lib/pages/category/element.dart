import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truyen_full_audio/models/category.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';

Widget categoryItem(BuildContext context, String name, int id) {
  return FlatButton(
    color: Colors.transparent,
    padding: EdgeInsets.all(0),
    onPressed: () {
      Provider.of<StoryStore>(context, listen: false).category =
          new SCategory({"name": name, "id": id});
      Provider.of<StoryStore>(context, listen: false).titlePage = name;
      Provider.of<RouterStore>(context, listen: false)
          .navigateTo(context, '/category');
    },
    child: Container(
      margin: EdgeInsets.all(10),
      decoration: decoMenuDashboardPage(),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
