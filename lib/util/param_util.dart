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
    return value == null || value
        .toString()
        .trim()
        .length == 0;
  }

  /*
  * 验证参数是否为空
  *
  * */
  static bool isNotNull(value) {
    return value != null && value
        .toString()
        .trim()
        .length > 0;
  }

  /*
  * 验证参数是否为空
  *
  * */
  static bool isNumberNotNull(value) {
    return value != null && value
        .toString()
        .trim()
        .length > 0 && value.toString().trim() != '0';
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
  static bool expHasMatch(String value, String express) {
    if (express == null) {
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

  static String deleteHtmlTag(String context) {
    String _context = '';

    var document = parse('${context ?? ''}');

    _context = parse(document.body.text).documentElement.text;

    return _context;
  }

  /*
  * 时间戳转换格式
  *
  * */
  static String stringToString(v, format) {
    return FastFormat.timeStampToString(
        FastFormat.getMilliseconds(formartDate: v), format);
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
    formartDate.replaceAll("T", " ");

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
      if (formartDate
          .toString()
          .length >= 13 &&
          formartDate.substring(10, 13) != null) {
        result += "" + formartDate.substring(10, 13);
      }
      if (formartDate
          .toString()
          .length >= 17 &&
          formartDate.toString().substring(14, 16) != null) {
        result += ":" + formartDate.substring(14, 16);
      }
      if (formartDate
          .toString()
          .length >= 19 &&
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
    if (formartDate == null || formartDate == '') {
      return DateTime.now();
    }

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
      if (formartDate
          .toString()
          .length >= 13 &&
          formartDate.substring(10, 13) != null) {
        result += "" + formartDate.substring(10, 13);
      }
      if (formartDate
          .toString()
          .length >= 17 &&
          formartDate.toString().substring(14, 16) != null) {
        result += ":" + formartDate.substring(14, 16);
      }
      if (formartDate
          .toString()
          .length >= 19 &&
          formartDate.substring(17, 19) != null) {
        result += ":" + formartDate.substring(17, 19);
      }
      var dateTime = DateTime.parse(result);
      return dateTime;
    } catch (e) {
      throw e;
    }
  }

  static String getWeek(int week, [type = 2]) {
    String weekString;
    List data = new List();

    List data1 = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    List data2 = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List data3 = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];

    if (type == 1) {
      data = data1;
    } else if (type == 2) {
      data = data2;
    } else if (type == 3) {
      data = data3;
    }

    if (0 < week && week < 8) {
      weekString = data[week - 1];
    }

    return weekString;
  }

  static String getMonth(int month, [type = 2]) {
    String monthString;
    List data = new List();

    List data1 = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    List data2 = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (type == 1) {
      data = data1;
    } else if (type == 2) {
      data = data2;
    }

    if (0 < month && month < 13) {
      monthString = data[month - 1];
    }

    return monthString;
  }

  static String stringDisposeWithDouble(v, [fix = 2]) {
    double b = double.parse(v.toString());
    String vStr = b.toStringAsFixed(fix);
    int len = vStr.length;
    for (int i = 0; i < len; i++) {
      if (vStr.contains('.') && vStr.endsWith('0')) {
        vStr = vStr.substring(0, vStr.length - 1);
      } else {
        break;
      }
    }

    if (vStr.endsWith('.')) {
      vStr = vStr.substring(0, vStr.length - 1);
    }

    return vStr;
  }

  static String timeFromNow(timeStamp) {
    int time = 0;

    if (timeStamp is int) {
      time = timeStamp;
    } else {
      time = int.parse(timeStamp.toString());
    }

    if (time < 13) {
      time = time * 1000;
    }

    var oldTime = DateTime.fromMillisecondsSinceEpoch(time);
    var nowTime = DateTime.now();

    var timeSting = '1秒前';

    if (oldTime.isBefore(nowTime)) {
      Duration duration = nowTime.difference(oldTime);
      int day = duration.inDays;
      int hour = duration.inHours.remainder(Duration.hoursPerDay);
      int minute = duration.inMinutes.remainder(Duration.minutesPerHour);
      int second = duration.inSeconds.remainder(Duration.secondsPerMinute);

      if (minute < 1 && second > 0) {
        timeSting = '$second秒前';
      } else if (hour < 1 && minute >= 1) {
        timeSting = '$minute分前';
      } else if (day < 1 && hour >= 1) {
        timeSting = '$hour小时前';
      } else if (day < 1 && day >= 1) {
        timeSting = '$day天前';
      } else if (day >= 1) {
        timeSting = '${timeStampToString(timeStamp, 'yyyy-MM-dd HH:mm')}';
      }
    }

    return timeSting;
  }
}


