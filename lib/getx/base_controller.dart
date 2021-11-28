import 'package:get/get.dart';

/// BaseController
class BaseController<T> extends GetxController {
  /// 当前第几页
  int page = 1;

  /// 每页请求15条数据
  int pageSize = 15;

  /// 是否是下一页
  bool get isFirstPage => page == 1;

  /// 是否还有数据
  bool hasNextPage = true;

  /// 查询数据
  List<T> dataList = [];

  /// 当前页数据
  List<T> currentPageData = [];

  /// 请求数据
  Future<void> onLoadData() async {
    if (this.isFirstPage) {
      dataList.clear();
    }
    hasNextPage = currentPageData.isNotEmpty && currentPageData.length >= pageSize;
    dataList.addAll(currentPageData);
    this.update();
  }

  /// 重新刷新数据
  Future<void> reloadData() async {
    hasNextPage = true;
    page = 1;
  }

  /// 加载下一页数据
  Future<void> loadMoreData() async {
    page++;
  }
}
