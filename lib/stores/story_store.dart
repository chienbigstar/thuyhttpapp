import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:truyen_full_audio/setting/index.dart';
import '../models/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoryStore with ChangeNotifier, DiagnosticableTreeMixin {
  String link;
  String titlePage = "";
  List<StoryModel> stories = [];
  StoryModel story;
  List<ChapterModel> chapters = [];
  ChapterModel chapter;
  int pageNumber = 1;
  String html = '';
  List<StoryModel> listStoryDashboard = [];
  bool isExpandPlayer = false;
  Map<String, dynamic> dataAds = {"lastTime": null, 'countInc': 0};
  double speed = 1.0;
  List<SCategory> listCategories = [];
  SCategory category;

  notify() {
    notifyListeners();
  }

  setChapter(chapter) {
    this.chapter = chapter;
    this.notify();
  }

  nextChapter() async {
    var index =
        this.chapters.indexWhere((element) => element.id == this.chapter.id);
    if (index < this.chapters.length - 1) {
      print('*** do next chap');
      this.chapter = this.chapters[index + 1];
      if (this.chapter.content == null) {
        var res =
            await http.get(pathHost + '/chapter/' + chapter.id.toString());
        Map<String, dynamic> chap = jsonDecode(res.body);
        this.chapter.content = chap['content'];
      }
      this.notify();
    } else if (this.chapter.chapterNumber < this.story.chaptersCount) {
      try {
        var res = await http.get(pathHost +
            '/chapter-by-bookId/' +
            this.story.id.toString() +
            '?offset=' +
            this.chapters.last.chapterNumber.toString());
        Map<String, dynamic> chapters = jsonDecode(res.body);
        chapters['results'].forEach((element) {
          this.chapters.add(new ChapterModel(element));
        });
        this.notify();
      } catch (err) {}
    }
  }

  prevChapter() async {
    var index =
        this.chapters.indexWhere((element) => element.id == this.chapter.id);
    if (index > 0) {
      print('*** do next chap');
      this.chapter = this.chapters[index - 1];
      if (this.chapter.content == null) {
        var res =
            await http.get(pathHost + '/chapter/' + chapter.id.toString());
        Map<String, dynamic> chap = jsonDecode(res.body);
        this.chapter.content = chap['content'];
      }
      this.notify();
    }
  }

  bool shouldShowAdsFull() {
    if (this.dataAds['lastTime'] == null) {
      return this.dataAds['countInc'] > 3;
    } else if (this.dataAds['countInc'] > 5) {
      return DateTime.now().millisecondsSinceEpoch >
          (this.dataAds['lastTime'] + 1800000);
    } else {
      return false;
    }
  }

  void toggleExpand() {
    this.isExpandPlayer = !this.isExpandPlayer;
    this.notifyListeners();
  }

  void setLink(String link) {
    this.link = link;
    this.notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
