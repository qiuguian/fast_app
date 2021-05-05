part of fast_app_ui;

typedef Widget ItemWidget(item);

class FastListView extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidget builder;
  final Widget headerView;
  final Widget footerView;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final double space;
  final double runSpacing;
  final String emptyMsg;
  final String loadingTip;
  final ScrollController controller;

  FastListView({
    this.viewModel,
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
  State<StatefulWidget> createState() => new FastListViewState();
}

class FastListViewState extends State<FastListView> with PageMini {
  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      pageScrollController = widget.controller;
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
    return new Stack(
      children: <Widget>[
        new Visibility(
          visible: widget.viewModel.dataList.length > 0,
          child: new Container(
            decoration: widget.decoration,
            padding: widget.padding,
            margin: widget.margin,
            child: new SingleChildScrollView(
              controller: pageScrollController,
              physics: const BouncingScrollPhysics(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.headerView ?? new Container(),
                  widget.builder != null
                      ? new Wrap(
                          spacing: widget.space,
                          runSpacing: widget.runSpacing,
                          children: widget.viewModel.dataList
                              .map(widget.builder)
                              .toList(growable: false),
                        )
                      : widget.child,
                  widget.footerView ?? new Container(),
                ],
              ),
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 && !isPageLoading,
          child: new Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: new Center(
              child: new InkWell(
                onTap: () => refreshData(),
                child: new Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/ic_common_empty.png',
                      package: "fast_app",
                    ),
                    new Text('${widget.emptyMsg}',
                        style: new TextStyle(
                            color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: new Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: new Center(
                  child: new Text('${widget.loadingTip}',
                      style: new TextStyle(fontSize: 13)))),
        ),
      ],
    );
  }
}

typedef Widget ItemWidgetBuilder(context, position);

class FastListViewBuilder extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidgetBuilder builder;
  final Widget headerView;
  final Widget footerView;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final double space;
  final double runSpacing;
  final String emptyMsg;
  final String loadingTip;
  final ScrollController controller;

  FastListViewBuilder({
    this.viewModel,
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
  State<StatefulWidget> createState() => new FastListViewBuilderState();
}

class FastListViewBuilderState extends State<FastListViewBuilder>
    with PageMini {
  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      pageScrollController = widget.controller;
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

    return new Stack(
      children: <Widget>[
        new Visibility(
          visible: widget.viewModel.dataList.length > 0 ||
              widget.headerView != null ||
              widget.footerView != null,
          child: new Padding(
            padding: widget.padding,
            child: new ListView.builder(
              padding: EdgeInsets.all(0),
              controller: pageScrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: count,
              itemBuilder: (context, index) {
                if (widget.headerView != null) {
                  if (index == 0) {
                    return widget.headerView;
                  } else {
                    return widget.viewModel.dataList.length > 0
                        ? widget.builder(context, index - 1)
                        : new Center(
                            child: new InkWell(
                              onTap: () => refreshData(),
                              child: new Wrap(
                                direction: Axis.vertical,
                                spacing: 8.0,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/ic_common_empty.png',
                                    package: "fast_app",
                                  ),
                                  new Text('${widget.emptyMsg}',
                                      style: new TextStyle(
                                          color: Color(0xffCCCCCC),
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                  }
                } else if (widget.footerView != null && index == count - 1) {
                  return widget.footerView;
                } else {
                  return widget.builder(context, index);
                }
              },
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 &&
              !isPageLoading &&
              widget.headerView == null &&
              widget.footerView == null,
          child: new Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: new Center(
              child: new InkWell(
                onTap: () => refreshData(),
                child: new Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/ic_common_empty.png',
                      package: "fast_app",
                    ),
                    new Text('${widget.emptyMsg}',
                        style: new TextStyle(
                            color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: new Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: new Center(
                  child: new Text('${widget.loadingTip}',
                      style: new TextStyle(fontSize: 13)))),
        ),
      ],
    );
  }
}

class FastListViewRefreshBuilder extends StatefulWidget {
  final FastViewModel viewModel;
  final ItemWidgetBuilder builder;
  final Widget headerView;
  final Widget footerView;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final double space;
  final double runSpacing;
  final String emptyMsg;
  final String loadingTip;
  final ScrollController controller;

  FastListViewRefreshBuilder({
    this.viewModel,
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
  State<StatefulWidget> createState() => new FastListViewRefreshBuilderState();
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

    return new Stack(
      children: <Widget>[
        new Visibility(
          visible: widget.viewModel.dataList.length > 0 ||
              widget.headerView != null ||
              widget.footerView != null,
          child: new Padding(
            padding: widget.padding,
            child: RefreshView(
              onRefresh: () => widget.viewModel.refreshData(),
              onLoading: () => widget.viewModel.loadMoreData(),
              child: new ListView.builder(
                padding: EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) {
                  if (widget.headerView != null) {
                    if (index == 0) {
                      return widget.headerView;
                    } else {
                      return widget.viewModel.dataList.length > 0
                          ? widget.builder(context, index - 1)
                          : new Center(
                              child: new InkWell(
                                onTap: () => widget.viewModel.refreshData(),
                                child: new Wrap(
                                  direction: Axis.vertical,
                                  spacing: 8.0,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    new Image.asset(
                                      'assets/ic_common_empty.png',
                                      package: "fast_app",
                                    ),
                                    new Text('${widget.emptyMsg}',
                                        style: new TextStyle(
                                            color: Color(0xffCCCCCC),
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            );
                    }
                  } else if (widget.footerView != null && index == count - 1) {
                    return widget.footerView;
                  } else {
                    return widget.builder(context, index);
                  }
                },
              ),
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 &&
              !isPageLoading &&
              widget.headerView == null &&
              widget.footerView == null,
          child: new Padding(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            child: new Center(
              child: new InkWell(
                onTap: () => widget.viewModel.refreshData(),
                child: new Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/ic_common_empty.png',
                      package: "fast_app",
                    ),
                    new Text('${widget.emptyMsg}',
                        style: new TextStyle(
                            color: Color(0xffCCCCCC), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        new Visibility(
          visible: widget.viewModel.dataList.length == 0 && isPageLoading,
          child: new Padding(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              child: new Center(
                  child: new Text('${widget.loadingTip}',
                      style: new TextStyle(fontSize: 13)))),
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
    this.viewModel,
    this.builder,
    this.isShowEmpty = false,
    this.loadingTip = '加载中',
  });

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      initialData: viewModel.dataList.isNotEmpty || viewModel.datas != null
          ? viewModel.dataList.isNotEmpty
              ? viewModel.dataList
              : viewModel.datas
          : viewModel.getData(),
      stream: viewModel.stream,
      builder: (context, snapshot) {
        var data = snapshot.data;

        return new Stack(
          children: <Widget>[
            new Visibility(
              visible: (data is List && data.length > 0) ||
                  !(data is List) ||
                  !isShowEmpty,
              child: builder(context, snapshot),
            ),
            new Visibility(
              visible: data is List && data.length == 0 && isShowEmpty,
              child: new Center(
                child: new Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/ic_common_empty.png',
                      package: "fast_app",
                    ),
                    new Text('$loadingTip',
                        style: new TextStyle(color: Color(0xff888697))),
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
  final Widget emptyView;
  final String emptyMsg;
  final String loadingTip;

  FastPageDataBind({
    this.viewModel,
    this.itemWidget,
    this.emptyView,
    this.emptyMsg = '暂无数据!点我刷新',
    this.loadingTip = '加载中',
  });

  @override
  State<StatefulWidget> createState() => new FastPageDataBindState();
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
    return new StreamBuilder(
      initialData:
          widget.viewModel.dataList.isNotEmpty || widget.viewModel.datas != null
              ? widget.viewModel.dataList.isNotEmpty
                  ? widget.viewModel.dataList
                  : widget.viewModel.datas
              : widget.viewModel.getData(),
      stream: widget.viewModel.stream,
      builder: (context, snapshot) {
        List data = snapshot.data ?? [];

        return new Stack(
          children: <Widget>[
            new Visibility(
              visible: data.length > 0,
              child: new ListView(
                cacheExtent: 200,
                padding: EdgeInsets.all(0),
                controller: pageScrollController,
                children: data.map(widget.itemWidget).toList(growable: false),
              ),
            ),
            new Visibility(
              visible: data.length == 0 && !isPageLoading,
              child: new Center(
                child: new InkWell(
                  onTap: () => refreshData(),
                  child: new Wrap(
                    direction: Axis.vertical,
                    spacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        'assets/ic_common_empty.png',
                        package: "fast_app",
                      ),
                      new Text('${widget.emptyMsg}',
                          style: new TextStyle(
                              color: Color(0xff888697), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: data.length == 0 && isPageLoading,
              child: new Center(
                  child: new Text('${widget.loadingTip}',
                      style: new TextStyle(fontSize: 13))),
            ),
          ],
        );
      },
    );
  }
}

class BitmapCache extends StatelessWidget {
  BitmapCache({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => FutureBuilder<double>(
        future: Future<double>.value(1),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
            Transform.scale(
          scale: snapshot.hasData ? snapshot.data : 0.0001,
          alignment: Alignment.topLeft,
          child: RepaintBoundary(child: child),
        ),
      );
}
