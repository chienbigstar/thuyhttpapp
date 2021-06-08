import 'dart:ffi';

import 'package:flutter/material.dart';
import '../layout/index.dart';
import '../../helper/index.dart';
import 'package:provider/provider.dart';
import '../../stores/index.dart';
import '../../models/index.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_gifs/loading_gifs.dart';
import '../../setting/index.dart';
import 'dart:convert';

// ignore: must_be_immutable
class StoryPage extends StatelessWidget {
  StoryStore storyStore;

  String textSearch = '';
  int page = 0;
  bool isLoading = false;
  bool isFirstFetch = true;
  bool isNoLoadmore = false;

  fetchChapters() async {
    if (this.isLoading) return;
    try {
      this.isLoading = true;
      var res = await http.get(pathHost + '/chapter-by-bookId/' + this.storyStore.story.id.toString());
      Map<String, dynamic> chapters = jsonDecode(res.body);
      if (this.page == 0) this.storyStore.chapters.clear();
      chapters['results'].forEach((element) {
        this.storyStore.chapters.add(new ChapterModel(element));
      });
      this.storyStore.story.chaptersCount = chapters["totalCount"];
      this.page = this.page + 1;
      this.isLoading = false;
      this.isFirstFetch = false;
      if (chapters['results'].length < 10) this.isNoLoadmore = true;
      this.storyStore.notify();
    } catch (err) {
      this.isLoading = false;
      this.storyStore.notify();
      print('*** error fetch chapters ' + err.toString());
    }
  }

  playChapter(ChapterModel chapter, BuildContext context) async {
    try {
      var res = await http.get(pathHost + '/chapter/' + chapter.id.toString());
      Map<String, dynamic> chapterJ = jsonDecode(res.body);

      this.storyStore.chapter = new ChapterModel(chapterJ);
      this.storyStore.isExpandPlayer = true;
      this.storyStore.notify();
    } catch (err) {
      print('*** ${err.toString()}');
    }
  }

  Widget listViewChapters(BuildContext context) {
    Widget itemLoading() {
      return Image.asset(
        cupertinoActivityIndicator,
        scale: 1,
        height: 50,
      );
    }

    bool shouldShowLoading(index) {
      return this.isLoading && index == this.storyStore.chapters.length - 1;
    }

    Widget itemListView(index) {
      return FlatButton(
        onPressed: () {
          this.playChapter(this.storyStore.chapters[index], context);
        },
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          this.storyStore.chapters[index].title,
                          style: TextStyle(
                          color: this.storyStore.chapters[index].id ==
                                  this.storyStore.chapter?.id
                              ? Color(0xFF0C9869)
                              : Colors.black),
                    ))
                  ],
                ),
              ],
            ),
            shouldShowLoading(index) ? itemLoading() : Container(),
          ],
        ),
      );
    }

    return NotificationListener(
        child: ListView.builder(
          itemCount: this.storyStore.chapters.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                decoration: decorationCategoryPage(),
                child: itemListView(index),
              ),
            );
          },
        ),
        onNotification: (t) {
          if (t is ScrollEndNotification) {
            if (this.isNoLoadmore) return false;
            fetchChapters();
            this.storyStore.notify();
          }
          return false;
        });
  }

  eventClickSearch(BuildContext context) {}

  Widget searchBox(BuildContext context) {
    return Expanded(
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
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Tìm kiếm chương")),
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

  Widget boxContent(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(children: [
        Text(this.storyStore.story.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: listViewChapters(context)),
      ]);
    });
  }

  Widget htmlViewer() {
    if (this.storyStore.chapter == null) return Container();
    return Column(
      children: [
        Text(
          this.storyStore.story.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
        ),
        Text(
          this.storyStore.chapter.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
        ),
        Expanded(
          flex: 10,
            child: ListView(
            children: [
              HtmlWidget(this.storyStore.chapter?.content ?? '',
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        boxControl()
      ],
    );
  }

  Widget boxControl() {
    if (this.storyStore.story == null || this.storyStore.chapter == null || this.storyStore.chapters.length == 0) return Container();

    var funcPrev = this.storyStore.chapter.chapterNumber == 1 ? null : () {
      this.storyStore.prevChapter();
    };
    var funcNext = this.storyStore.chapter.chapterNumber == this.storyStore.story.chaptersCount ? null : () {
      this.storyStore.nextChapter();
    };
    return Expanded(
        flex: 1,
        child: Container(
         child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                FlatButton(
                  child: Text("Chương trước", style: TextStyle(decoration: TextDecoration.underline),),
                  onPressed: funcPrev,),
                FlatButton(child: Text("Chương tiếp",  style: TextStyle(decoration: TextDecoration.underline)),
                onPressed: funcNext,),
              ],),
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                this.storyStore.isExpandPlayer = false;
                this.storyStore.notify();
              },)
      ],),),
    );
  }

  Widget detailContextWidget() {
    return Consumer<StoryStore>(
      builder: (context, store, child) {
        if (this.isFirstFetch) {
          return Center(
            child: Icon(Icons.timer),
          );
        }

        return Expanded(
          child: Container(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double maxHeight = constraints.maxHeight - 0;
                return Column(
                  children: [
                    Container(
                        height: this.storyStore.isExpandPlayer ? 0 : maxHeight,
                        child: boxContent(context)),
                    Container(
                      height: this.storyStore.isExpandPlayer ? maxHeight : 0,
                      child: htmlViewer(),
                      padding: EdgeInsets.only(left: 10, right: 10),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.storyStore = Provider.of<StoryStore>(context, listen: false);
    this.storyStore.chapters = [];
    this.fetchChapters();
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
              Expanded(child: detailContextWidget())
            ],
          ),
        ));
  }
}
