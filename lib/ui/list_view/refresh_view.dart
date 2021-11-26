import 'package:fast_app/fast_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshView extends StatefulWidget {
  RefreshView({
    required this.child,
    this.onRefresh,
    this.onLoading,
    this.hasNextPage,
    this.dataController,
    this.emptyMsg = '暂无数据',
  });

  final Widget child;
  final Function()? onRefresh;
  final Function()? onLoading;
  final bool Function()? hasNextPage;
  final BaseController? dataController;
  final String emptyMsg;

  @override
  _RefreshViewState createState() => _RefreshViewState();
}

class _RefreshViewState extends State<RefreshView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<void> _future;

  @override
  void initState() {
    super.initState();

    if (widget.dataController != null) {
      _future = widget.dataController!.onLoadData();
    } else {
      _future = withoutApi();
    }

    FastNotification.addListener("RefreshViewFinish", (data) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  Future<void> withoutApi() async {}

  @override
  void dispose() {
    FastNotification.removeListenerByEvent('RefreshViewFinish');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              // child: CircularProgressIndicator(),
              child: CupertinoActivityIndicator(),
            );
          case ConnectionState.done:
            // if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return $SmartRefresher();
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget $SmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.noMore) {
            body = Text(
              "无更多数据",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            );
          } else if (mode == LoadStatus.idle) {
            body = Text(
              "向上拉加载更多",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            );
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(
              "加载失败!",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            );
          } else if (mode == LoadStatus.canLoading) {
            body = Text(
              "放开加载更多",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            );
          } else {
            body = Text(
              "无更多数据",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            );
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
        if (widget.dataController != null) {
          await widget.dataController!.reloadData();
        } else {
          await widget.onRefresh?.call();
        }
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        if ((widget.dataController?.hasNextPage ??
            (widget.hasNextPage?.call() ?? true))) {
          if (widget.dataController != null) {
            await widget.dataController!.loadMoreData();
          } else {
            await widget.onLoading?.call();
          }
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      },
      child: widget.dataController != null
          ? widget.dataController!.dataList.isNotEmpty
              ? widget.child
              : emptyView()
          : widget.child,
    );
  }

  Widget emptyView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.0),
      child: Center(
        child: InkWell(
          onTap: () => widget.dataController?.reloadData(),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/ic_common_empty.png',
                package: "fast_app",
              ),
              Text('${widget.emptyMsg}',
                  style: TextStyle(color: Color(0xffCCCCCC), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
