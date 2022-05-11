import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/utils/api_services/server_constant.dart';

import 'server.dart';

class ApiManager {
  Dio dio = Dio();
  Future<void> dioGetMethod(
      BuildContext context,
      String url,
      Map<String, String> header,
      Map<String, dynamic> query,
      String contType,
      ServerOperationCompletion serverOperationCompletion,
      String method) async {
    try {
      var api_url = ServerConstant.baseUrl + url;
      // var body = json.encode(query);
      var formData = FormData.fromMap(query);
      var response = await dio
          .post(api_url,
              data: formData,
              options: Options(headers: header, contentType: contType))
          .then((value) {
        //print(value.statusCode);
        if (value.statusCode == 200) {
          serverOperationCompletion.onResponseReceived(
              url, value, context, null);
        }
      });
    } on DioError catch (e) {
      serverOperationCompletion.onErrorOccurred(
          url, 'Server Error', e.message, e.response!.statusCode!, context);
    }
  }
}
