library sticky_scroll_view;

import 'package:flutter/material.dart';

class StickyScrollView extends StatefulWidget {
  final Widget header;
  final double headerHeight;

  final Widget sticker;
  final double stickerHeight;

  /// Main View
  final Widget body;

  /// Use in Customize Appbar Height
  final double appbarHeight;

  const StickyScrollView({
    Key key,
    this.header,
    this.headerHeight,
    this.appbarHeight = kToolbarHeight,
    @required this.stickerHeight,
    @required this.sticker,
    @required this.body,
  })  : assert(sticker != null,
            '>_ Hei Guys, Why Use this if u have no Sticker……'),
        assert(stickerHeight != null && stickerHeight > 0),
        assert(header == null || (headerHeight != null && headerHeight > 0)),
        super(key: key);

  @override
  _StickyScrollViewState createState() => _StickyScrollViewState();
}

class _StickyScrollViewState extends State<StickyScrollView> {
  List<Widget> _buildContent(BuildContext context, bool innerBoxIsScrolled) {
    var children = <Widget>[];
    if (widget.header != null) {
      children.add(_buildHeader(context));
    }
    children.add(
      SliverPersistentHeader(
        delegate: _HeaderDelegate(widget.sticker, widget.stickerHeight),
        pinned: true,
      ),
    );
    return children;
  }

  _buildHeader(BuildContext context) => SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          leading: SizedBox.shrink(),
          flexibleSpace: Column(
            children: [widget.header],
          ),
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(widget.headerHeight - widget.appbarHeight),
            child: SizedBox.shrink(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          _buildContent(context, innerBoxIsScrolled),
      body: widget.body,
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget view;
  final double height;

  _HeaderDelegate(this.view, this.height);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.view;
  }

  @override
  double get maxExtent => this.height;

  @override
  double get minExtent => this.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
