import 'package:fast_app/net/fast_page_option.dart';
import 'package:flutter/material.dart';

typedef PageMiniListener(double pixels);

class PageMini {
  ScrollController pageScrollController = new ScrollController();
  bool isPageLoading = false;

  PageOptionModel pageOptionModel = new PageOptionModel.empty();
  PageResultModel pageResultModel = new PageResultModel.empty();

  initPage([PageMiniListener pageMiniListener]) {
    print('======> 000');
    if (pageScrollController != null) {
      pageScrollController.addListener(() {
        if (pageScrollController.position.pixels >=
                pageScrollController.position.maxScrollExtent - 100 &&
            !isPageLoading) {
          isPageLoading = true;
          loadMoreData();
        }
        if (pageScrollController.position.pixels ==
                pageScrollController.position.minScrollExtent &&
            !isPageLoading) {
          isPageLoading = true;
          refreshData();
        }

        if (pageMiniListener != null && pageMiniListener is PageMiniListener) {
          pageMiniListener(pageScrollController.position.pixels);
        }
      });
    }
  }

  @protected
  refreshData() {}

  @protected
  loadMoreData() {}
}
