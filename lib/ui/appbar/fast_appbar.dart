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
    this.rightDMActions = const [],
    this.backgroundColor,
    this.mainColor,
    this.titleW,
    this.bottom,
    this.leading,
    this.isCenterTitle = true,
    this.brightness,
    this.onBack,
  });

  final String title;
  final bool showBackIcon;
  final bool showShadow;
  final List<Widget>? rightDMActions;
  final Color? backgroundColor;
  final Color? mainColor;
  final Widget? titleW;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool isCenterTitle;
  final Brightness? brightness;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size(100, bottom != null ? 100 : 50);

  onBackAction(BuildContext context) async {
    FocusScope.of(context)
        .requestFocus(FocusNode());
    if (onBack != null) {
      onBack?.call();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle _brightness = brightness == Brightness.light
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    Color _backgroundColor = backgroundColor ?? fastTheme.appBarColor;
    Color _mainColor = mainColor ?? fastTheme.appBarTextColor;

    return showShadow
        ? Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: fastTheme.lineColor,
                  width: showShadow ? 0.5 : 0.0))),
      child: AppBar(
        title: titleW == null
            ? Text(
          title,
          style: TextStyle(color: _mainColor, fontSize: 16),
        )
            : titleW,
        backgroundColor: _backgroundColor,
        elevation: 0.0,
        systemOverlayStyle: _brightness,
        leading: leading == null
            ? showBackIcon
            ? InkWell(
          child: Padding(
            padding:
            EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: Container(
              width: 15,
              height: 28,
              child: Icon(
                CupertinoIcons.left_chevron,
                color: _mainColor,
              ),
            ),
          ),
          onTap: () => onBackAction(context),
        )
            : null
            : leading,
        centerTitle: isCenterTitle,
        actions: rightDMActions ?? [Center()],
        bottom: bottom != null ? bottom : null,
      ),
    )
        : AppBar(
      title: titleW == null
          ? Text(
        title,
        style: TextStyle(color: _mainColor, fontSize: 16),
      )
          : titleW,
      backgroundColor: _backgroundColor,
      elevation: 0.0,
      systemOverlayStyle: _brightness,
      leading: leading == null
          ? showBackIcon
          ? InkWell(
          child: Padding(
            padding:
            EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: Container(
              width: 15,
              height: 28,
              child: Icon(
                CupertinoIcons.left_chevron,
                color: _mainColor,
              ),
            ),
          ),
          onTap: () => onBackAction(context)
      )
          : null
          : leading,
      centerTitle: isCenterTitle,
      bottom: bottom != null ? bottom : null,
      actions: rightDMActions ?? [Center()],
    );
  }
}
