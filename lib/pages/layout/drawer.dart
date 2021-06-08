import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/index.dart';
import '../../stores/router_store.dart';

// ignore: non_constant_identifier_names
Drawer DrawerLayout(context) {
  RouterStore router = Provider.of<RouterStore>(context, listen: false);
  return Drawer(
    child: Container(
      decoration: gradient1(),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/images/icon.png',
              width: 10,
              height: 10,
            ),
            padding: EdgeInsets.all(30),
          ),
          ListTile(
            title: Container(child: Text('Home')),
            leading: Icon(Icons.home),
            onTap: () => {router.navigateTo(context, '/')},
          ),
          ListTile(
            title: Container(child: Text('Thể loại')),
            leading: Icon(Icons.category),
            onTap: () => {router.navigateTo(context, '/categories')},
          ),
          ListTile(
            title: Container(child: Text('Lịch sử')),
            leading: Icon(Icons.history),
            onTap: () => {router.navigateTo(context, '/history')},
          ),
        ],
      ),
    ),
  );
}
