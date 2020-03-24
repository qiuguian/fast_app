import 'package:fast_app/net/fast_config.dart';
import 'package:fast_app/util/enum_util.dart';

class FastApp {
  /*
  * 配置应用
  * 
  * @param environment 环境
  * @param address api 请求地址
  * @param port 端口
  * @param showLog 是否显示日记 默认false
  * @param proxy 代理
  * @param grpc 默认不使用 false
  * @param restful 默认使用 true, grpc与restful不可同时为true
  * */
  static setEnvironment({
    FastAppEnvironment environment,
    bool showLog,
    String proxy,
    bool grpc,
    bool restful,
    String devAddress,
    String testAddress,
    String productAddress,
  }) {
    environmentConfig = new EnvironmentConfig(
      environment: environment,
      showLog: showLog,
      proxy: proxy,
      grpc: grpc,
      restful: restful,
    );

    fastApiHostConfig = new FastApiHostConfig(
      devAddress: devAddress,
      testAddress: testAddress,
      productAddress: productAddress,
    );
  }
}
