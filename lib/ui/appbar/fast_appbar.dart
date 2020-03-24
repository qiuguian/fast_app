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
    this.backgroundColor = Colors.white,
    this.mainColor = const Color(0xFF212121),
    this.titleW,
    this.bottom,
    this.leading,
    this.isCenterTitle = true,
    this.brightness = Brightness.light,
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
                      style: new TextStyle(color: mainColor),
                    )
                  : titleW,
              backgroundColor: backgroundColor,
              elevation: 0.0,
              brightness: brightness,
              leading: leading == null
                  ? showBackIcon
                      ? new InkWell(
                          child: new Container(
                            width: 15,
                            height: 28,
                            child: new Icon(
                              CupertinoIcons.left_chevron,
                              color: mainColor,
                            ),
                          ),
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.pop(context);
                            }
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
                    style: new TextStyle(color: mainColor),
                  )
                : titleW,
            backgroundColor: backgroundColor,
            elevation: 0.0,
            brightness: brightness,
            leading: leading == null
                ? showBackIcon
                    ? new InkWell(
                        child: new Container(
                          width: 15,
                          height: 28,
                          child: new Icon(
                            CupertinoIcons.left_chevron,
                            color: mainColor,
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
