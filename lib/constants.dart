import 'package:flutter/material.dart';

const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: "Type your message here...",
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(
          color: Color(0xFF850D27),
        )),
    border: InputBorder.none,
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Color(0xFF850D27))));

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color(0xFF850D27), width: 1.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
