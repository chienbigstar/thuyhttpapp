import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truyen_full_audio/models/category.dart';
import '../layout/bottom_app_bar.dart';
import '../layout/index.dart';
import '../../stores/index.dart';
import '../../helper/index.dart';
import 'element.dart';
import 'package:http/http.dart' as http;
import '../../setting/index.dart';
import 'dart:convert';

// ignore: must_be_immutable
class CategoryListPage extends StatelessWidget {
  String textSearch = '';
  StoryStore store;
  RouterStore routerStore;
  bool isFirstFetch = true;

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

  Widget gridViewBox(context) {
    return Expanded(
      child: GridView.count(children: [
        ...this.store.listCategories.map((item) {
          return categoryItem(context, item.name, item.id);
        })
      ], crossAxisCount: 4),
    );
  }

  Widget listMenuWidget() {
    return Consumer<StoryStore>(
      builder: (context, store, child) {
        if (this.isFirstFetch) {
          return Center(
            child: Icon(Icons.timer),
          );
        }

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

  fetchCategories() async {
    try {
      var res = await http.get(pathHost + '/categories');
      Map<String, dynamic> stories = jsonDecode(res.body);
      if (isFirstFetch) this.store.listCategories.clear();
      stories['results'].forEach((element) {
        this.store.listCategories.add(new SCategory(element));
      });
      this.isFirstFetch = false;
      this.store.notify();
    } catch (err) {
      print('*** err loadmorestory ' + err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoryStore>(context, listen: false);
    this.routerStore = Provider.of<RouterStore>(context, listen: false);
    this.fetchCategories();
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
