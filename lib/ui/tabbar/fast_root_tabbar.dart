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
    this.pages,
    this.checkLogin,
    this.currentIndex = 0,
  });

  final List pages;
  final CheckLogin checkLogin;
  final int currentIndex;

  @override
  _FastRootTabBarState createState() => _FastRootTabBarState();
}

class _FastRootTabBarState extends State<FastRootTabBar> {
  var pages = new List<BottomNavigationBarItem>();
  int currentIndex;
  var contents = new List<Offstage>();

  @override
  void initState() {
    super.initState();

    currentIndex = widget.currentIndex;

    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      pages.add(new BottomNavigationBarItem(
        icon: model.icon,
        activeIcon: model.selectIcon,
        title: new Text(model.title, style: new TextStyle(fontSize: 12.0)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      fixedColor: Color.fromRGBO(45, 45, 45, 1.0),
      onTap: (int index) {
        setState(() => currentIndex = index);
      },
      iconSize: 18.0,
    );

    contents.clear();
    for (int i = 0; i < widget.pages.length; i++) {
      FastTabBarModel model = widget.pages[i];
      contents
          .add(new Offstage(child: model.page, offstage: currentIndex != i));
    }

    return new Scaffold(
      bottomNavigationBar: new Theme(
          data: new ThemeData(canvasColor: Colors.grey[50]),
          child: bottomNavigationBar),
      body: new Stack(
        children: contents.toList(growable: false),
      ),
    );
  }
}

class FastTabBarModel {
  const FastTabBarModel({this.title, this.page, this.icon, this.selectIcon});

  final String title;
  final Widget icon;
  final Widget selectIcon;
  final Widget page;
}
