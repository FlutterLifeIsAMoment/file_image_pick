// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:file_image_pick/file_image_pick.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getFile() async {
    try {
      FileImageModel fileModel = await FileChooseManager.instance.openChooseFile();
      print(fileModel);
    } on PlatformException {
      throw ('Failed to get file');
    }
  }

  Future<void> getImage() async {
    try {
      FileImageModel fileModel = await FileChooseManager.instance.getImage();
      print(fileModel);
    } on PlatformException {
      throw ('Failed to get image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('点击获取文件'),
                ),
                onTap: () {
                  getFile();
                },
              ),
            ),
            Center(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('点击获取图片'),
                ),
                onTap: () {
                  getImage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
