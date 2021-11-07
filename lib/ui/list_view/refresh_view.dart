import 'package:fast_app/fast_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshView extends StatefulWidget {
  RefreshView({required this.child, this.onRefresh, this.onLoading,this.hasNextPage});

  final Widget child;
  final Function()? onRefresh;
  final Function()? onLoading;
  final bool Function()? hasNextPage;

  @override
  _RefreshViewState createState() => _RefreshViewState();
}

class _RefreshViewState extends State<RefreshView> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    FastNotification.addListener("RefreshViewFinish", (data) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  @override
  void dispose() {
    FastNotification.removeListenerByEvent('RefreshViewFinish');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.noMore) {
            body = Text("无更多数据");
          } else if (mode == LoadStatus.idle) {
            body = Text("向上拉加载更多");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("放开加载更多");
          } else {
            body = Text("无更多数据");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: () async {
        _refreshController.resetNoData();
        await widget.onRefresh?.call();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        if (widget.hasNextPage?.call() ?? true) {
          List data = await widget.onLoading?.call() ?? [];
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      },
      child: widget.child,
    );
  }
}
