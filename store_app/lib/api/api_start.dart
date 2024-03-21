import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/models/login.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:store_app/models/register.dart';
import 'package:store_app/models/reset_password.dart';
import 'package:store_app/models/send_otp.dart';

class ApiStart {
  final storage = const FlutterSecureStorage();

  Future<Object> login(Login userData) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/login',
    );
    Map<String, String> body = {
      'email': userData.email,
      'password': userData.password,
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      await storage.deleteAll();

      await storage.write(
        key: 'access-token',
        value: resData['token'],
      );

      await storage.write(
        key: 'email',
        value: userData.email,
      );

      final token = await storage.read(key: 'access-token');
      print(token);

      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Object> register(Register userData) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/register',
    );
    Map<String, String> body = {
      'name': userData.name,
      'email': userData.email,
      'password': userData.password,
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Object> sendOtp(SendOTP data) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/check',
    );
    Map<String, dynamic> body = {
      'email': data.email,
      'otp': data.otp,
    };
    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Object> forgotPassword(String email) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/password/forgot/mobile',
    );
    Map<String, dynamic> body = {
      'email': email,
    };
    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<Object> resetPassword(ResetPassword data) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/password/reset',
    );
    Map<String, dynamic> body = {
      'otp': data.otp,
      'password': data.password,
      'confirmPassword': data.confirmPassword,
    };
    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
