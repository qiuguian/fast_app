///
/// fast_root_tabbar.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

part of fast_app_ui;

typedef CheckLogin(index);

class FastRootTabBar extends StatefulWidget {

  FastRootTabBar({
    required this.pages,
    this.checkLogin,
    this.currentIndex = 0,
    this.color,
    this.needLogins = const [],
    this.isFirtBlackColor = false,
  });

  final List pages;
  final CheckLogin? checkLogin;
  final int currentIndex;
  final Color? color;
  final List needLogins;
  final bool isFirtBlackColor;

  @override
  _FastRootTabBarState createState() => _FastRootTabBarState();
}

class _FastRootTabBarState extends State<FastRootTabBar> {
  var pages = <BottomNavigationBarItem>[];
  int currentIndex = 0;
  List<Widget> contents = [];

  @override
  void initState() {
    super.initState();

    currentIndex = widget.currentIndex;

    FastNotification.addListener(FastActions.toTabBar(), (index) {
      if (mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });

    currentIndex = widget.currentIndex;

    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      pages.add(BottomNavigationBarItem(
        icon: model.icon,
        activeIcon: model.selectIcon,
        label: model.title,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
//      fixedColor: Color.fromRGBO(45, 45, 45, 1.0),
      selectedItemColor: widget.color ?? Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        if (widget.checkLogin != null && widget.needLogins.contains(index) &&
            !(AppCache.get(FastActions.isLogin())??false)) {
          widget.checkLogin?.call(index);
        } else {
          FastNotification.push(FastActions.toTab(index));
          setState(() => currentIndex = index);
        }
      },
      iconSize: 18.0,
    );

    contents.clear();
    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      contents
          .add(Offstage(child: model.page, offstage: currentIndex != i));
    }

    return Scaffold(
      bottomNavigationBar: Theme(
          data: ThemeData(
              canvasColor: currentIndex == 0 && widget.isFirtBlackColor ? Colors.black : Colors.white),
          child: bottomNavigationBar),
      body: Stack(
        children: contents.toList(growable: false),
      ),
    );
  }
}

class FastTabBarModel {
  const FastTabBarModel({this.title = '', required this.page, required this.icon, required this.selectIcon});

  final String title;
  final Widget icon;
  final Widget selectIcon;
  final Widget page;
}

class RootTabBar extends StatefulWidget {
  RootTabBar({
    required this.pages,
    this.checkLogin,
    this.currentIndex = 0,
  });

  final List pages;
  final CheckLogin? checkLogin;
  final int currentIndex;

  @override
  State<StatefulWidget> createState() => RootTabBarState();
}

class RootTabBarState extends State<RootTabBar> {
  int currentIndex = 0;
  List<Widget> contents = [];

  @override
  void initState() {
    super.initState();

    FastNotification.addListener('1', (index) {
      if (mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });

    currentIndex = widget.currentIndex;
  }

  List<BottomNavigationBarItem> pages() {
    List<BottomNavigationBarItem> barItems =
    [];
    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      barItems.add(
        BottomNavigationBarItem(
          icon: Container(),
          activeIcon: Container(),
          title: Wrap(
            spacing: 3,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(model.title, style: TextStyle(fontSize: 12.0)),
              Visibility(
                visible: currentIndex == i,
                child: Container(
                  height: 2,
                  width: 25,
                  decoration: BoxDecoration(
                    gradient:
                    LinearGradient(colors: [Colors.amber[500]!, Colors.red]),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              Visibility(
                visible: currentIndex == i,
                child: model.icon,
              ),
            ],
          ),
        ),
      );
    }
    return barItems;
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar bottomNavigationBar() {
      return BottomNavigationBar(
        items: pages(),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        fixedColor: Colors.black,
        unselectedItemColor: Color(0xff808086),
        selectedFontSize: 16,
        unselectedFontSize: 15,
        onTap: (int index) {
          FastNotification.push("111");
          setState(() => currentIndex = index);
        },
        iconSize: 18.0,
      );
    }

    contents.clear();
    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      contents
          .add(Offstage(child: model.page, offstage: currentIndex != i));
    }

    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: Colors.white),
        child: bottomNavigationBar(),
      ),
      body: Stack(
        children: contents.toList(growable: false),
      ),
    );
  }
}
