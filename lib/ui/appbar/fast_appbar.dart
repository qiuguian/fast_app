///
/// fast_appbar.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

part of fast_app_ui;

class FastAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FastAppBar({
    this.title = '',
    this.showBackIcon = true,
    this.showShadow = false,
    this.rightDMActions,
    this.backgroundColor,
    this.mainColor,
    this.titleW,
    this.bottom,
    this.leading,
    this.isCenterTitle = true,
    this.brightness,
  });

  final String title;
  final bool showBackIcon;
  final bool showShadow;
  final List<Widget> rightDMActions;
  final Color backgroundColor;
  final Color mainColor;
  final Widget titleW;
  final PreferredSizeWidget bottom;
  final Widget leading;
  final bool isCenterTitle;
  final Brightness brightness;

  @override
  Size get preferredSize => new Size(100, bottom != null ? 100 : 50);

  @override
  Widget build(BuildContext context) {
    Brightness _brightness = brightness ?? fastTheme.brightness;
    Color _backgroundColor = backgroundColor ?? fastTheme.appBarColor;
    Color _mainColor = mainColor ?? fastTheme.appBarTextColor;

    return showShadow
        ? new Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: new BorderSide(
                        color: fastTheme.lineColor,
                        width: showShadow ? 0.5 : 0.0))),
            child: new AppBar(
              title: titleW == null
                  ? new Text(
                      title,
                      style: new TextStyle(color: _mainColor,fontSize: 16),
                    )
                  : titleW,
              backgroundColor: _backgroundColor,
              elevation: 0.0,
              brightness: _brightness,
              leading: leading == null
                  ? showBackIcon
                      ? new InkWell(
                          child: new Padding(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, right: 10),
                            child: new Container(
                              width: 15,
                              height: 28,
                              child: new Icon(
                                CupertinoIcons.left_chevron,
                                color: _mainColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            Navigator.pop(context);
                          },
                        )
                      : null
                  : leading,
              centerTitle: isCenterTitle,
              actions: rightDMActions ?? [new Center()],
              bottom: bottom != null ? bottom : null,
            ),
          )
        : new AppBar(
            title: titleW == null
                ? new Text(
                    title,
                    style: new TextStyle(color: _mainColor,fontSize: 16),
                  )
                : titleW,
            backgroundColor: _backgroundColor,
            elevation: 0.0,
            brightness: _brightness,
            leading: leading == null
                ? showBackIcon
                    ? new InkWell(
                        child: new Padding(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          child: new Container(
                            width: 15,
                            height: 28,
                            child: new Icon(
                              CupertinoIcons.left_chevron,
                              color: _mainColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                        },
                      )
                    : null
                : leading,
            centerTitle: isCenterTitle,
            bottom: bottom != null ? bottom : null,
            actions: rightDMActions ?? [new Center()],
          );
  }
}
