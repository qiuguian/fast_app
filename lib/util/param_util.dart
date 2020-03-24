///
/// param_util.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///
///
///
part of 'fast_util.dart';

/*
* FastValidate
*
* */
class FastValidate {
  /*
  * 验证参数是否为空
  *
  * */
  static bool isNull(value) {
    return value == null || value.toString().trim().length == 0;
  }

  /*
  * 验证参数是否为空
  *
  * */
  static bool isNotNull(value) {
    return value != null && value.toString().trim().length > 0;
  }

  /*
  * 验证手机号
  *
  * */
  static bool isMobilePhone(String value) {
    RegExp mobile = new RegExp(r"(0|86|17951)?(1[0-9][0-9])[0-9]{8}");
    return mobile.hasMatch(value);
  }

  /*
  * 验证手机号
  *
  * */
  static bool isWebUrl(String value) {
    RegExp url = new RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+");
    return url.hasMatch(value);
  }

  /*
  * 正则表达式
  *
  * */
  static bool expHasMatch(String value,String express) {

    if(express == null){
       throw '正则表达式不能为空';
    }

    String exp = 'r"$express"';
    RegExp url = new RegExp(exp);
    return url.hasMatch(value);
  }
}

/*
* FastFormat
*
* */
class FastFormat {

  static String deleteHtmlTag(String context){
     String _context = '';

     var document = parse('${context??''}');

     _context = parse(document.body.text).documentElement.text;

     return _context;
  }

  /*
  * 时间戳转换格式
  *
  * */
  static String timeStampToString(timestamp, format) {
    assert(timestamp != null);

    int time = 0;

    if (timestamp is int) {
      time = timestamp;
    } else {
      time = int.parse(timestamp.toString());
    }

    if (format == null) {
      format = 'yyyy-MM-dd HH:mm:ss';
    }

    DateFormat dateFormat = new DateFormat(format);

    var date = new DateTime.fromMillisecondsSinceEpoch(time);

    return dateFormat.format(date);
  }

  static int getMilliseconds({String formartDate = "1970-10-01 00:00:00"}) {
    //年必须大于1970年
    String mYear = formartDate.substring(0, 4);
    if (int.parse(mYear) < 1970) {
      mYear = "1970";
    }
    var result;
    try {
      result = mYear +
          "-" +
          formartDate.substring(5, 7) +
          "-" +
          formartDate.substring(8, 10);
      if (formartDate.toString().length >= 13 &&
          formartDate.substring(10, 13) != null) {
        result += "" + formartDate.substring(10, 13);
      }
      if (formartDate.toString().length >= 17 &&
          formartDate.toString().substring(14, 16) != null) {
        result += ":" + formartDate.substring(14, 16);
      }
      if (formartDate.toString().length >= 19 &&
          formartDate.substring(17, 19) != null) {
        result += ":" + formartDate.substring(17, 19);
      }
      print(result);
      var dateTime = DateTime.parse(result);
      return dateTime.millisecondsSinceEpoch;
    } catch (e) {
      throw e;
    }
  }

  static DateTime getDateTime({String formartDate = "1970-10-01 00:00:00"}) {
    //年必须大于1970年
    String mYear = formartDate.substring(0, 4);
    if (int.parse(mYear) < 1970) {
      mYear = "1970";
    }
    var result;
    try {
      result = mYear +
          "-" +
          formartDate.substring(5, 7) +
          "-" +
          formartDate.substring(8, 10);
      if (formartDate.toString().length >= 13 &&
          formartDate.substring(10, 13) != null) {
        result += "" + formartDate.substring(10, 13);
      }
      if (formartDate.toString().length >= 17 &&
          formartDate.toString().substring(14, 16) != null) {
        result += ":" + formartDate.substring(14, 16);
      }
      if (formartDate.toString().length >= 19 &&
          formartDate.substring(17, 19) != null) {
        result += ":" + formartDate.substring(17, 19);
      }
      var dateTime = DateTime.parse(result);
      return dateTime;
    } catch (e) {
      throw e;
    }
  }
}


