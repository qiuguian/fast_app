///
/// fast_config.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///
///

import 'package:fast_app/util/enum_util.dart';

export 'package:fast_app/util/enum_util.dart';

EnvironmentConfig environmentConfig = EnvironmentConfig();

class EnvironmentConfig {
  FastAppEnvironment environment;
  String address;
  bool showLog;
  String proxy;
  bool grpc;
  bool restful;

  EnvironmentConfig({
    this.environment = FastAppEnvironment.product,
    this.address = '',
    this.showLog = false,
    this.proxy = '',
    this.grpc = false,
    this.restful = true,
  });

  factory EnvironmentConfig.share() {

    switch(environmentConfig.environment){
      case FastAppEnvironment.dev:
        environmentConfig.address = fastApiHostConfig.devAddress;
        break;
      case FastAppEnvironment.test:
        environmentConfig.address = fastApiHostConfig.testAddress;
        break;
      case FastAppEnvironment.local:
        environmentConfig.address = "http://localhost.com";
        break;
      case FastAppEnvironment.product:
        environmentConfig.address = fastApiHostConfig.productAddress;
        break;
      case FastAppEnvironment.guest:
        environmentConfig.address = fastApiHostConfig.geustAddress;
        break;
    }

    return environmentConfig;
  }
}

FastApiHostConfig fastApiHostConfig = new FastApiHostConfig();

class FastApiHostConfig {
  final String devAddress;
  final String testAddress;
  final String productAddress;
  final String geustAddress;

  FastApiHostConfig({
    this.devAddress = '',
    this.testAddress = '',
    this.productAddress = '',
    this.geustAddress = '',
  });

  factory FastApiHostConfig.share() => fastApiHostConfig;
}
