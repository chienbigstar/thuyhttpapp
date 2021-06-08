import 'package:flutter/material.dart';
import 'package:truyen_full_audio/setting/index.dart';
import '../layout/index.dart';
import '../../helper/index.dart';
import 'package:provider/provider.dart';
import '../../stores/index.dart';
import 'package:http/http.dart' as http;
import '../../models/index.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CategoryShowPage extends StatelessWidget {
  bool isFetchStories = false;
  StoryStore store;
  bool isNoStory = false;
  List<StoryModel> stories = [];
  var _controller = ScrollController();
  bool isLoading = false;
  bool isFirstFetch = true;
  int page = 0;
  bool isNoLoadmore = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  fetchCategory() async {
    if (this.isLoading) return;
    try {
      this.isLoading = true;

      var link;
      if (this.store.category.id == -1) {
        link = pathHost +
            '/book-search-by-name?search=' +
            this.store.category.name;
      } else {
        link = pathHost + '/book-by-catId/' + this.store.category.id.toString();
      }

      var res = await http.get(link);
      Map<String, dynamic> stories = jsonDecode(res.body);
      if (this.page == 0) this.store.stories.clear();
      stories['results'].forEach((element) {
        this.store.stories.add(new StoryModel(element));
      });
      if (stories['results'].length < 10) this.isNoLoadmore = true;
      this.page = this.page + 1;
      this.isFirstFetch = false;
      EasyLoading.dismiss();
      this.store.notify();
      this.isLoading = false;
    } catch (err) {
      this.isLoading = false;
      print(err.toString());
    }
  }

  Widget listViewStory(BuildContext context) {
    Widget itemLoading() {
      return Image.asset(
        cupertinoActivityIndicator,
        scale: 1,
        height: 50,
      );
    }

    bool shouldShowLoading(index) {
      return this.isLoading && index == this.store.chapters.length;
    }

    return NotificationListener(
      child: ListView.builder(
        itemCount: this.stories.length,
        controller: this._controller,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              decoration: decorationCategoryPage(),
              child: FlatButton(
                onPressed: () async {
                  this.store.story = this.stories[index];
                  this.store.isExpandPlayer = false;
                  this.store.titlePage = this.stories[index].name;

                  final SharedPreferences prefs = await _prefs;
                  var odlsData = prefs.get('history');
                  odlsData = odlsData == null || odlsData == ''
                      ? "{\"stories\":[]}"
                      : odlsData;
                  var data = jsonDecode(odlsData);
                  List<dynamic> stories = data['stories'];
                  var indexStory = stories
                      .indexWhere((i) => jsonDecode(i)["id"] == store.story.id);
                  if (indexStory != -1) {
                    stories.removeAt(indexStory);
                  }
                  stories.insert(0, jsonEncode(store.story.asMap()));
                  List<String> newStories = [];
                  stories.asMap().forEach((key, value) {
                    if (key <= 20) {
                      newStories.add(value);
                    }
                  });
                  prefs.setString(
                      'history', jsonEncode({"stories": newStories}));

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
                          child: Image.network(this.stories[index].image)),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(
                              this.stories[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(this.stories[index].authorName),
                            Text(this.stories[index].createdAt),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ]),
                    shouldShowLoading(index) ? itemLoading() : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      onNotification: (t) {
        if (t is ScrollEndNotification &&
            this._controller.position.pixels > 5) {
          handleScrollEnd(context);
        }
        return false;
      },
    );
  }

  handleScrollEnd(context) async {
    if (this.isNoLoadmore) return;
    await this.fetchCategory();
  }

  Widget listStoryWidget() {
    return Consumer<StoryStore>(
      builder: (context, store, child) {
        this.stories = store.stories;
        this.isNoStory = this.stories.length == 0;
        if (this.isFirstFetch) {
          return Expanded(
              child: Center(
            child: Icon(Icons.timer),
          ));
        }

        return Expanded(
          flex: 10,
          child: Column(
            children: [
              this.isNoStory ? Text("no story") : Container(),
              Expanded(child: listViewStory(context)),
            ],
          ),
        );
      },
    );
  }

  fetchFirstPage() async {
    await this.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoryStore>(context, listen: false);
    this.fetchFirstPage();
    return Scaffold(
        appBar: AppBarLayout(context),
        drawer: DrawerLayout(context),
        bottomNavigationBar: BottomAppBarLayout(context),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: gradient1(),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                this.store.titlePage,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              listStoryWidget(),
            ],
          ),
        ));
  }
}
