import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truyen_full_audio/models/index.dart';
import '../layout/bottom_app_bar.dart';
import '../layout/index.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';
import 'element.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../setting/index.dart';
import 'dart:convert';

// ignore: must_be_immutable
class DashboardPage extends StatelessWidget {
  String textSearch = '';
  StoryStore store;
  RouterStore routerStore;
  bool isLoading = false;
  int page = 0;
  bool isNoLoadmore = false;

  loadMoreStory() async {
    if (this.isLoading) return;
    try {
      this.isLoading = true;
      EasyLoading.show(status: 'Loading...');
      var offset = (this.page) * 10;
      var res =
          await http.get(pathHost + '/newest-book?offset=' + offset.toString());
      Map<String, dynamic> stories = jsonDecode(res.body);
      if (this.page == 0) this.store.listStoryDashboard.clear();
      stories['results'].forEach((element) {
        this.store.listStoryDashboard.add(new StoryModel(element));
      });
      if (stories['results'].length < 10) this.isNoLoadmore = true;
      this.store.notify();
      this.page = this.page + 1;
      EasyLoading.dismiss();
      this.isLoading = false;
    } catch (err) {
      EasyLoading.dismiss();
      this.isLoading = false;
      print('*** err loadmorestory ' + err.toString());
    }
  }

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

  List<Widget> listItemWidget(BuildContext context) {
    return [
      ...this.store.listStoryDashboard.map(
          (story) => storyItem(context, story))
    ];
  }

  Widget gridViewBox(context) {
    return Expanded(
      flex: 5,
      child: NotificationListener(
        child: GridView.count(
            children: listItemWidget(context), crossAxisCount: 3),
        onNotification: (t) {
          if (this.isNoLoadmore) return false;
          if (t is ScrollEndNotification) {
            loadMoreStory();
          }
          return false;
        },
      ),
    );
  }

  Widget listMenuWidget() {
    return Consumer<StoryStore>(
      builder: (context, store, child) {
        return Expanded(
          flex: 10,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              searchBox(context),
              SizedBox(
                height: 10,
              ),
              gridViewBox(context),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoryStore>(context, listen: false);
    this.routerStore = Provider.of<RouterStore>(context, listen: false);
    this.loadMoreStory();
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
