import 'package:flutter/material.dart';
import '../../helper/index.dart';
import 'package:provider/provider.dart';
import '../../stores/index.dart';

// ignore: non_constant_identifier_names
BottomAppBar BottomAppBarLayout(context) {
  RouterStore routerStore = Provider.of<RouterStore>(context, listen: false);
  return BottomAppBar(
    child: Container(
      decoration: decoAppbar(),
      child: Row(
        children: <Widget>[
          FlatButton(
              child: Text(
                'Home',
                style: TextStyle(color: routerStore.router == '/' ? Colors.black : Colors.white),
              ),
              onPressed: () {
                Provider.of<RouterStore>(context, listen: false)
                    .navigateTo(context, '/');
              }),
          FlatButton(
              child: Text(
                'Thể loại',
                style: TextStyle(color: routerStore.router == '/categories' ? Colors.black : Colors.white),
              ),
              onPressed: () {
                Provider.of<RouterStore>(context, listen: false)
                    .navigateTo(context, '/categories');
              }),
          FlatButton(
              child: Text(
                'Lịch sử',
                style: TextStyle(color: routerStore.router == '/history' ? Colors.black : Colors.white),
              ),
              onPressed: () {
                Provider.of<RouterStore>(context, listen: false)
                    .navigateTo(context, '/history');
              }),
        ],
      ),
    ),
  );
}
