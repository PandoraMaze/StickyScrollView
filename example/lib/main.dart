import 'package:flutter/material.dart';
import 'package:sticky_scroll_view/sticky_scroll_view.dart';

import 'base/page_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pandora Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'StickyScrollView Demo'),
    );
  }
}

class MyHomePage extends BasePageWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends BasePageState<MyHomePage> {
  @override
  bool centerTitle() => false;

  @override
  String getTitle() {
    return widget.title;
  }

  @override
  buildBody() => Container(
        child: StickyScrollView(
          header: _buildHeader(100),
          headerHeight: 100,
          stickerHeight: 56,
          sticker: _buildSticker(56),
          body: _buildList(),
        ),
      );

  _buildHeader(double height) => Container(
        height: height,
        color: Colors.teal,
        alignment: Alignment.center,
        child: Text(
          'I am the Header, Will be Hide !',
          style: TextStyle(color: Colors.white),
        ),
      );

  _buildSticker(double height) => Container(
        height: height,
        color: Colors.redAccent,
        alignment: Alignment.center,
        child: Text(
          'I Will be Stick on the Top !',
          style: TextStyle(color: Colors.white),
        ),
      );

  _buildList() => ListView.separated(
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text('The Item index $index'),
        ),
        separatorBuilder: (BuildContext context, int index) => index.isEven
            ? Divider(
                color: Colors.orange,
                indent: 8.0,
                endIndent: 8.0,
              )
            : Divider(
                color: Colors.green,
                indent: 16.0,
                endIndent: 16.0,
              ),
        itemCount: 30,
      );
}
