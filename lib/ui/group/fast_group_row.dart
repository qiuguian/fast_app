///
/// fast_root_tabbar.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

part of fast_app_ui;

typedef FastGroupRowItem(index);

class FastGroupRow extends StatelessWidget {
  final List<FastGroupModel> groups;
  final int rowNum;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final FastGroupRowItem onTap;
  final double iconSize;

  FastGroupRow({
    this.groups,
    this.rowNum = 4,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(10),
    this.onTap,
    this.iconSize = 55,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: padding,
      color: backgroundColor,
      width: double.infinity,
      child: new Wrap(
        spacing: 10,
        runSpacing: 10,
        children: groups.map((item) {
          FastGroupModel model = item;
          return new InkWell(
            onTap: () {
              if (onTap != null) {
                onTap(model.index ?? 0);
              }
            },
            child: new Container(
              width:
              (MediaQuery
                  .of(context)
                  .size
                  .width - 10 * (rowNum + 1)) /
                  rowNum,
              alignment: Alignment.center,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: iconSize + 5,
                    height: iconSize + 5,
                    margin: EdgeInsets.only(bottom: 5),
                    child:
                    model.icon.contains('http') ? new CachedNetworkImage(
                      imageUrl: model.icon,
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.fill,) : new Image.asset(
                        model.icon, width: iconSize,
                        height: iconSize,
                        fit: BoxFit.fill),
                  ),
                  new Text('${model.name}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(fontSize: 13)),
                ],
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class FastGroupModel {
  String name;
  String icon;
  String package;
  int index;

  FastGroupModel({this.name, this.icon, this.package, this.index});
}
