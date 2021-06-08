import 'package:flutter/material.dart';
import 'color.dart';

showloader(BuildContext context) {
  showDialog(context: context, barrierDismissible: false, barrierColor: sColor('#1907071a'),
    builder: (BuildContext context) {
    return WillPopScope(
      child: Dialog(backgroundColor: Colors.transparent, child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.green),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.timeline, color: Colors.white,),
              SizedBox(width: 5,),
              Text('Loading...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),),
    );
  });
}

dismissLoader(BuildContext context) {
  Navigator.of(context).pop();
}