part of fast_app_ui;

typedef Widget ItemWidget(item);

class FastListView extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidget? builder;
  final Widget? headerView;
  final Widget? footerView;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final double? space;
  final double? runSpacing;
  final String? emptyMsg;
  final String? loadingTip;
  final ScrollController? controller;

  FastListView({
    required this.viewModel,
    this.builder,
    this.headerView,
    this.footerView,
    this.decoration = const BoxDecoration(),
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.child,
    this.space = 0,
    this.runSpacing = 0,
    this.emptyMsg = '暂无数据!点我刷新',
    this.loadingTip = '加载中',
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => FastListViewState();
}

class FastListViewState extends State<FastListView> with PageMini {
  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      pageScrollController = widget.controller!;
    }

    initPage();
    widget.viewModel.addRequestListener(start: () {
      if (mounted) {
        setState(() {
          isPageLoading = true;
        });
      }
    }, finish: () {
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
    setState(() {
      isPageLoading = widget.viewModel.isLoading;
    });
  }

  @override
  refreshData() => widget.viewModel.refreshData();

  @override
  loadMoreData() => widget.viewModel.loadMoreData();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: widget.viewModel.dataList.length > 0,
          child: Container(
            decoration: widget.decoration,
            padding: widget.padding,
            margin: widget.margin,
            child: SingleChildScrollView(
              controller: pageScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.headerView ?? Container(),
                  widget.builder != null
                      ? Wrap(
                          spacing: widget.space ?? 0,
                          runSpacing: widget.runSpacing ?? 0,
                          children: List.from(widget.viewModel.dataList
                              .map(widget.builder!)
                              .toList(growable: false)),
                        )
                      : widget.child!,
                  widget.footerView ?? Container(),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 && !isPageLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: Center(
              child: InkWell(
                onTap: () => refreshData(),
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
                        style:
                            TextStyle(color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: Center(
                  child: Text('${widget.loadingTip}',
                      style: TextStyle(fontSize: 13)))),
        ),
      ],
    );
  }
}

typedef Widget ItemWidgetBuilder(context, position);

class FastListViewBuilder extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidgetBuilder? builder;
  final Widget? headerView;
  final Widget? footerView;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget? child;
  final double space;
  final double runSpacing;
  final String emptyMsg;
  final String loadingTip;
  final ScrollController controller;

  FastListViewBuilder({
    required this.viewModel,
    this.builder,
    this.headerView,
    this.footerView,
    this.decoration = const BoxDecoration(),
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.child,
    this.space = 0,
    this.runSpacing = 0,
    this.emptyMsg = '暂无数据!点我刷新',
    this.loadingTip = '加载中',
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => FastListViewBuilderState();
}

class FastListViewBuilderState extends State<FastListViewBuilder>
    with PageMini {
  @override
  void initState() {
    super.initState();

    pageScrollController = widget.controller;

    initPage();

    widget.viewModel.addRequestListener(start: () {
      if (mounted) {
        setState(() {
          isPageLoading = true;
        });
      }
    }, finish: () {
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
  }

  @override
  refreshData() => widget.viewModel.refreshData();

  @override
  loadMoreData() => widget.viewModel.loadMoreData();

  @override
  Widget build(BuildContext context) {
    int count = widget.viewModel.dataList.length +
        (widget.headerView != null ? 1 : 0) +
        (widget.footerView != null ? 1 : 0);

    return Stack(
      children: <Widget>[
        Visibility(
          visible: widget.viewModel.dataList.length > 0 ||
              widget.headerView != null ||
              widget.footerView != null,
          child: Padding(
            padding: widget.padding,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              controller: pageScrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: count,
              itemBuilder: (context, index) {
                if (widget.headerView != null) {
                  if (index == 0) {
                    return widget.headerView!;
                  } else {
                    return widget.viewModel.dataList.length > 0
                        ? widget.builder!(context, index - 1)
                        : Center(
                            child: InkWell(
                              onTap: () => refreshData(),
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
                                      style: TextStyle(
                                          color: Color(0xffCCCCCC),
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                  }
                } else if (widget.footerView != null && index == count - 1) {
                  return widget.footerView!;
                } else {
                  return widget.builder!(context, index);
                }
              },
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 &&
              !isPageLoading &&
              widget.headerView == null &&
              widget.footerView == null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: Center(
              child: InkWell(
                onTap: () => refreshData(),
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
                        style:
                            TextStyle(color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: Center(
                  child: Text('${widget.loadingTip}',
                      style: TextStyle(fontSize: 13)))),
        ),
      ],
    );
  }
}

class FastListViewRefreshBuilder extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidgetBuilder? builder;
  final Widget? headerView;
  final Widget? footerView;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget? child;
  final double space;
  final double runSpacing;
  final String emptyMsg;
  final String loadingTip;
  final ScrollController controller;

  FastListViewRefreshBuilder({
    required this.viewModel,
    this.builder,
    this.headerView,
    this.footerView,
    this.decoration = const BoxDecoration(),
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.child,
    this.space = 0,
    this.runSpacing = 0,
    this.emptyMsg = '暂无数据!点我刷新',
    this.loadingTip = '加载中',
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => FastListViewRefreshBuilderState();
}

class FastListViewRefreshBuilderState
    extends State<FastListViewRefreshBuilder> {
  bool isPageLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.viewModel.addRequestListener(start: () {
      if (mounted) {
        setState(() {
          isPageLoading = true;
        });
      }
    }, finish: () {
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
      FastNotification.push('RefreshViewFinish');
    });
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.viewModel.dataList.length +
        (widget.headerView != null ? 1 : 0) +
        (widget.footerView != null ? 1 : 0);

    return Stack(
      children: <Widget>[
        Visibility(
          visible: widget.viewModel.dataList.length > 0 ||
              widget.headerView != null ||
              widget.footerView != null,
          child: Padding(
            padding: widget.padding,
            child: RefreshView(
              onRefresh: () => widget.viewModel.refreshData(),
              onLoading: () => widget.viewModel.loadMoreData(),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) {
                  if (widget.headerView != null) {
                    if (index == 0) {
                      return widget.headerView!;
                    } else {
                      return widget.viewModel.dataList.length > 0
                          ? widget.builder!(context, index - 1)
                          : Center(
                              child: InkWell(
                                onTap: () => widget.viewModel.refreshData(),
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
                                        style: TextStyle(
                                            color: Color(0xffCCCCCC),
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            );
                    }
                  } else if (widget.footerView != null && index == count - 1) {
                    return widget.footerView!;
                  } else {
                    return widget.builder!(context, index);
                  }
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 &&
              !isPageLoading &&
              widget.headerView == null &&
              widget.footerView == null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: Center(
              child: InkWell(
                onTap: () => widget.viewModel.refreshData(),
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
                        style:
                            TextStyle(color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: Center(
                  child: Text('${widget.loadingTip}',
                      style: TextStyle(fontSize: 13)))),
        ),
      ],
    );
  }
}

class FastDataBind extends StatelessWidget {
  final FastViewModel viewModel;
  final AsyncWidgetBuilder builder;
  final bool isShowEmpty;
  final String loadingTip;

  FastDataBind({
    required this.viewModel,
    required this.builder,
    this.isShowEmpty = false,
    this.loadingTip = '加载中',
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: viewModel.dataList.isNotEmpty || viewModel.datas != null
          ? viewModel.dataList.isNotEmpty
              ? viewModel.dataList
              : viewModel.datas
          : viewModel.getData(),
      stream: viewModel.stream,
      builder: (context, snapshot) {
        var data = snapshot.data;

        return Stack(
          children: <Widget>[
            Visibility(
              visible: (data is List && data.length > 0) ||
                  !(data is List) ||
                  !isShowEmpty,
              child: builder(context, snapshot),
            ),
            Visibility(
              visible: data is List && data.length == 0 && isShowEmpty,
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/ic_common_empty.png',
                      package: "fast_app",
                    ),
                    Text('$loadingTip',
                        style: TextStyle(color: Color(0xff888697))),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FastPageDataBind extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidget itemWidget;
  final Widget? emptyView;
  final String emptyMsg;
  final String loadingTip;

  FastPageDataBind({
    required this.viewModel,
    required this.itemWidget,
    this.emptyView,
    this.emptyMsg = '暂无数据!点我刷新',
    this.loadingTip = '加载中',
  });

  @override
  State<StatefulWidget> createState() => FastPageDataBindState();
}

class FastPageDataBindState extends State<FastPageDataBind> with PageMini {
  @override
  void initState() {
    super.initState();
    initPage();
    widget.viewModel.addRequestListener(start: () {
      if (mounted) {
        setState(() {
          isPageLoading = true;
        });
      }
    }, finish: () {
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
  }

  @override
  refreshData() => widget.viewModel.refreshData();

  @override
  loadMoreData() => widget.viewModel.loadMoreData();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData:
          widget.viewModel.dataList.isNotEmpty || widget.viewModel.datas != null
              ? widget.viewModel.dataList.isNotEmpty
                  ? widget.viewModel.dataList
                  : widget.viewModel.datas
              : widget.viewModel.getData(),
      stream: widget.viewModel.stream,
      builder: (context, snapshot) {
        List data = [];
        if (snapshot.data != null) {
          data = snapshot.data as List;
        }

        return Stack(
          children: <Widget>[
            Visibility(
              visible: data.length > 0,
              child: ListView(
                cacheExtent: 200,
                padding: EdgeInsets.all(0),
                controller: pageScrollController,
                children: data.map(widget.itemWidget).toList(growable: false),
              ),
            ),
            Visibility(
              visible: data.length == 0 && !isPageLoading,
              child: Center(
                child: InkWell(
                  onTap: () => refreshData(),
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
                          style: TextStyle(
                              color: Color(0xff888697), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: data.length == 0 && isPageLoading,
              child: Center(
                  child: Text('${widget.loadingTip}',
                      style: TextStyle(fontSize: 13))),
            ),
          ],
        );
      },
    );
  }
}

class BitmapCache extends StatelessWidget {
  BitmapCache({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => FutureBuilder<double>(
        future: Future<double>.value(1),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
            Transform.scale(
          scale: snapshot.hasData ? snapshot.data! : 0.0001,
          alignment: Alignment.topLeft,
          child: RepaintBoundary(child: child),
        ),
      );
}
