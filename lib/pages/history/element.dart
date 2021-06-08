import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truyen_full_audio/models/index.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';

Widget categoryItem(BuildContext context, String name, int id) {
  return FlatButton(
    color: Colors.transparent,
    padding: EdgeInsets.all(0),
    onPressed: () {
      context.read<StoryStore>().story = new StoryModel({"name": name, "id": id});
      Provider.of<RouterStore>(context, listen: false).navigateTo(context, '/category');
    },
    child: Container(
      margin: EdgeInsets.all(10),
      decoration: decoMenuDashboardPage(),
      child: Center(
        child: Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,),
      ),
    ),
  );
}