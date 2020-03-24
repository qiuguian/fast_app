import 'dart:html' as html;

storeKV(k, v) async {
  html.window.localStorage['$k'] = v;

//  html.window.localStorage['key'];
//  html.window.sessionStorage['key'];
//  html.window.document.cookie;
}

Future<String> getStoreByKey(String k) async {

  if(html.window.localStorage.containsKey("$k")){
    return html.window.localStorage['$k'];
  }

  return null;
}
