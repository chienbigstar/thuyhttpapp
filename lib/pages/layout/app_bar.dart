import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: non_constant_identifier_names
PreferredSize AppBarLayout(context){
  return PreferredSize(
    preferredSize: Size.fromHeight(50.0),
    child: AppBar(
      actions: <Widget>[
        FlatButton(child: Text("Back", style: TextStyle(color: Colors.white),), onPressed: () {
          Navigator.of(context).maybePop();
        }),
      ],
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset('assets/icons/menu.svg'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }
      ),
    ),
  );
}