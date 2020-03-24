class PageOptionModel {
  int page = 1;
  int pageSize = 15;
  bool isFirstPage = true;
  bool isLoading = true;

  PageOptionModel.empty();

  int firstPage() {
    isFirstPage = true;
    isLoading = true;
    return this.page;
  }

  int nextPage() {
    isFirstPage = false;
    isLoading = true;
    return this.page++;
  }
}

class PageResultModel {
  bool hasNextPage = true;

  PageResultModel(
    this.hasNextPage,
  );

  PageResultModel.empty();
}

class PageControlModel {
  PageOptionModel pageOptionModel = new PageOptionModel.empty();
  PageResultModel pageResultModel = new PageResultModel.empty();
}
