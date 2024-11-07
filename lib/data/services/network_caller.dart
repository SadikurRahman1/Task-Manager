import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../models/network_response.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': AuthController.accessToken.toString(),
      };
      PrintRequest(url, null, headers);
      final Response response = await get(
        uri,
        headers: headers,
      );

      PrintResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodeData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  // static Future<NetworkResponse> getRequest({
  //   required String url,
  //   bool requiresToken = false,
  // }) async {
  //   try {
  //     Uri uri = Uri.parse(url);
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //     };
  //
  //     // যদি টোকেন প্রয়োজন হয়, তাহলে টোকেন হেডারে যুক্ত করা হবে
  //     if (requiresToken) {
  //       headers['token'] = AuthController.accessToken.toString();
  //     }
  //
  //     PrintRequest(url, null, headers);
  //     final Response response = await get(
  //       uri,
  //       headers: headers,
  //     );
  //
  //     PrintResponse(url, response);
  //     if (response.statusCode == 200) {
  //       final decodeData = jsonDecode(response.body);
  //       return NetworkResponse(
  //         isSuccess: true,
  //         statusCode: response.statusCode,
  //         responseData: decodeData,
  //       );
  //     } else {
  //       return NetworkResponse(
  //         isSuccess: false,
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } catch (e) {
  //     return NetworkResponse(
  //       isSuccess: false,
  //       statusCode: -1,
  //       errorMassage: e.toString(),
  //     );
  //   }
  // }


  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': AuthController.accessToken.toString(),
      };

      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      PrintRequest(url, body, headers);
      PrintResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData['status'] == 'fail') {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: decodeData['data'],
          );
        }
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodeData,
        );

      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: 'Unauthenticated!');
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  static void PrintRequest(
      String url, Map<String, dynamic>? body, Map<String, dynamic>? headers) {
    debugPrint('REQUEST\nURL: $url\nBODY : $body\nHEADERS: $headers');
  }

  static void PrintResponse(String url, Response response) {
    debugPrint(
        'URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}');
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(TaskManager.NavigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => SignInScreen()), (p) => false);
  }
}
