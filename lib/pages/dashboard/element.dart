import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';
import '../../models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Widget storyItem(BuildContext context, StoryModel story) {
  return FlatButton(
      padding: EdgeInsets.all(10),
      onPressed: () async{
        var store = context.read<StoryStore>();
        store.isExpandPlayer = false;
        store.story = story;

        final SharedPreferences prefs = await _prefs;
        var odlsData = prefs.get('history');
        odlsData = odlsData == null || odlsData == '' ? "{\"stories\":[]}" : odlsData;
        var data = jsonDecode(odlsData);
        List<dynamic> stories = data['stories'];
        var indexStory = stories.indexWhere((i) => jsonDecode(i)["id"] == store.story.id);
        if (indexStory != -1 ) {
          stories.removeAt(indexStory);
        }
        stories.insert(0, jsonEncode(store.story.asMap()));
        List<String> newStories = [];
        stories.asMap().forEach((key, value) {
          if (key <= 20) {
            newStories.add(value);
          }
        });
        prefs.setString('history', jsonEncode({"stories": newStories}));

        Provider.of<RouterStore>(context, listen: false)
            .navigateTo(context, '/story');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            true
                ? Image.network(
                    story.image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    story.image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: sColor('#0c9869'),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                    child: Center(
                        child: Text(story.name,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ))
          ],
        ),
      ));
}
