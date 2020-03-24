import 'dart:io';

String getPlatform (){
  return Platform.isIOS ? "ios" : 'android';
}