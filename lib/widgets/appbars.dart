import 'package:flutter/material.dart';

PreferredSizeWidget appBar(
    BuildContext context, String title, TextStyle textStyle) {
  return AppBar(
    elevation: 0,
    title: Text(title),
    //backgroundColor: Colors.black54,
  );
}
