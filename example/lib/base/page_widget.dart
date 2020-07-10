import 'package:flutter/material.dart';

abstract class BasePageWidget extends StatefulWidget {
  const BasePageWidget({Key key}) : super(key: key);
}

class BasePageState<T extends BasePageWidget> extends State<T>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  static const int singleView = 1;

  var _appInForeground;

  var _scaffold = new GlobalKey<ScaffoldState>();

  bool inForeground() => _appInForeground;

  /// Init the Params
  @protected
  void initParams() {}

  /// Call When BackPressed Event
  @protected
  Future<bool> onBack() => Future.value(true);

  /// Content Click Event
  @protected
  void onContentClick() {
    if (autoCloseKeyboard()) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @protected
  String getTitle() => "";

  @protected
  Color getBackgroundColor() => Theme.of(context).scaffoldBackgroundColor;

  @protected
  int getTabViewCount() => singleView;

  @protected
  bool hasTopBar() => true;

  @protected
  bool autoCloseKeyboard() => true;

  @protected
  bool centerTitle() => true;

  @protected
  buildBody() => Container();

  @protected
  AppBar buildTopBar() {
    return hasTopBar()
        ? AppBar(
            title: Text(
              getTitle(),
              style: TextStyle(color: Colors.white),
            ),
            elevation: 10,
            centerTitle: centerTitle(),
          )
        : null;
  }

  @protected
  BottomNavigationBar buildBottomBar() => null;

  @protected
  FloatingActionButton buildFloatingBtn() => null;

  @protected
  Widget buildLayout() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onContentClick();
        },
        child: Scaffold(
          key: _scaffold,
          backgroundColor: getBackgroundColor(),
          appBar: buildTopBar(),
          body: buildBody(),
          bottomNavigationBar: buildBottomBar(),
          floatingActionButton: buildFloatingBtn(),
        ),
      );

  @protected
  toast(String msg, [SnackBar snackBar]) {
    snackBar ??= SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 200),
    );
    _scaffold.currentState.showSnackBar(snackBar);
  }

  /// Finish the Page
  /// @param result Valued True Mean to Pass onWillPop() Method Call.
  finish([result = true]) {
    Navigator.pop(context, result);
  }

  //=================== 页面跳转 Start ========================//

  @protected
  changePage(MaterialPageRoute route) {
    Navigator.pushReplacement(context, route);
  }

  @protected
  changePageRoute(Route route) {
    Navigator.pushReplacement(context, route);
  }

  @protected
  changePageName(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @protected
  goPage(MaterialPageRoute route) {
    Navigator.push(context, route);
  }

  @protected
  goPageRoute(Route route) {
    Navigator.push(context, route);
  }

  @protected
  goPageName(String routeName, [Object arguments]) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  //=================== 页面跳转 End ========================//

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Init Data
    initParams();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///  resumed: Visible And Activate
  ///  inactive:Visible And Inactive
  ///  paused: Invisible And Inactive
  ///  suspending：iOS State: Suspending
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _appInForeground = true;
    } else if (state == AppLifecycleState.inactive) {
      _appInForeground = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Build Layout
    int tabViewCount = getTabViewCount();
    Widget content = tabViewCount > singleView
        ? DefaultTabController(length: tabViewCount, child: buildLayout())
        : buildLayout();
    return WillPopScope(
      onWillPop: onBack,
      child: content,
    );
  }

  @override
  bool get wantKeepAlive => false;
}
