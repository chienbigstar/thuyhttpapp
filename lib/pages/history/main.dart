import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truyen_full_audio/models/category.dart';
import 'package:truyen_full_audio/models/index.dart';
import 'package:truyen_full_audio/setting/index.dart';
import '../layout/bottom_app_bar.dart';
import '../layout/index.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';
import 'element.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HistoryPage extends StatelessWidget {
  String textSearch = '';
  StoryStore store;
  RouterStore routerStore;
  bool isFirstFetch = true;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  eventClickSearch(BuildContext context) {
    if (this.textSearch.trim() == '') return;
    this.store.category = new SCategory({"id": -1, "name": this.textSearch});
    this.store.titlePage = "Tìm kiếm: ${this.textSearch}";
    this.routerStore.navigateTo(context, '/category');
  }

  Widget searchBox(BuildContext context) {
    return Container(
        height: 50,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        maxLines: 1,
                        onChanged: (text) {
                          this.textSearch = text;
                        },
                        onEditingComplete: () {
                          this.eventClickSearch(context);
                        },
                        controller: TextEditingController(),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Tìm kiếm truyện")),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      this.eventClickSearch(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget listHistoryBox(context) {
    return Expanded(
      flex: 5,
      child: ListView.builder(
        itemCount: this.store.stories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              decoration: decorationCategoryPage(),
              child: FlatButton(
                onPressed: () async {
                  this.store.story = this.store.stories[index];
                  this.store.isExpandPlayer = false;
                  this.store.titlePage = this.store.stories[index].name;

                  Provider.of<RouterStore>(context, listen: false)
                      .navigateTo(context, '/story');
                },
                padding: EdgeInsets.all(0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                          flex: 1,
                          child: Image.network(this.store.stories[index].image)),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(
                              this.store.stories[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(this.store.stories[index].authorName),
                            Text(this.store.stories[index].createdAt),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ]),
                  ],
                ),
              )
            )
          );
        }
      )
    );
  }

  Widget listMenuWidget() {
    return Consumer<StoryStore>(
      builder: (context, store, child) {
        if (this.isFirstFetch) {
          return Expanded(
              child: Center(
            child: Icon(Icons.timer),
          ));
        }

        return Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              searchBox(context),
              SizedBox(
                height: 10,
              ),
              listHistoryBox(context),
            ],
          ),
        );
      },
    );
  }
  
  fetchStories() async {
    try {
      final SharedPreferences prefs = await _prefs;
      var stories = prefs.get('history');
      stories = jsonDecode(stories);
      List<StoryModel> listStory = [];
      stories['stories'].forEach((s) => listStory.add(new StoryModel(jsonDecode(s))));
      this.store.stories = listStory;
      this.isFirstFetch = false;
      this.store.notify();
    } catch (err) {
      print(err.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoryStore>(context, listen: false);
    this.routerStore = Provider.of<RouterStore>(context, listen: false);
    this.fetchStories();
    return Scaffold(
        appBar: AppBarLayout(context),
        drawer: DrawerLayout(context),
        bottomNavigationBar: BottomAppBarLayout(context),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: gradient1(),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                listMenuWidget(),
              ],
            ),
          ),
        ));
  }
}
