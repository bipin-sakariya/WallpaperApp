import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_services.dart';

class Server {
  getInstant(
    BuildContext context,
    String url,
    Map<String, String> header,
    Map<String, dynamic> query,
    String contType,
    ServerOperationCompletion serverOperationCompletion,
    String method,
  ) {
    if (url == "" && method == 'Get') {
      ApiManager().dioGetMethod(context, url, header, query, contType,
          serverOperationCompletion, method);
    }
  }
}

abstract class ServerOperationCompletion {
  void onResponseReceived(String url, Response? response, BuildContext context,
      String? fileAPIResponse) {}

  void onErrorOccurred(
      String url, String title, String errormsg, int code, BuildContext context,
      [var value]) {}
}
