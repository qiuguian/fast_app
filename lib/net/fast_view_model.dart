import 'dart:async';
export 'fast_respone_model.dart';
import  'fast_page_option.dart';
import 'package:scoped_model/scoped_model.dart';

//typedef Response(int code,String msg);

typedef ApiCallBack();

class FastViewModel extends Model with PageControlModel{

  ApiCallBack? finishCallBack;
  ApiCallBack? startCallBack;

  bool isLoading = true;

  var dataController = new StreamController<dynamic>.broadcast();

  Sink get inDataController => dataController;

  List dataList = [];
  var datas;

  Stream<dynamic> get stream => dataController.stream.map((data){
    dataList.addAll(data);
    return dataList;
  });

  dynamic getData() => null;

  void refreshData(){}

  void loadMoreData(){}

  void dispose() {
    dataController.close();
  }

  void dataModelFromJson(data, model,[dataController]){

    List repData = data['data'];

    assert(repData is List);

    List list = [];

    repData.forEach((json) => list.add(model.from(json)));

    inDataController.add(list);

  }

  List dataModelListFromJson(data, model,[dataController]){

    List repData = data;

    List list = [];

    repData.forEach((json) => list.add(model.from(json)));

    return list;
  }

  void updateViewModel() => notifyListeners();

  void addRequestListener({ApiCallBack? start,ApiCallBack? finish,ApiCallBack? lastCallBack}){
    startCallBack = start;
    finishCallBack = finish;
  }

  void start(){
    if(startCallBack != null){
      isLoading = true;
      startCallBack?.call();
    }
  }

  void finish(){
    if(finishCallBack != null){
      new Future.delayed(new Duration(milliseconds: 200),(){
        isLoading = false;
        finishCallBack?.call();
      });
    }
  }
}