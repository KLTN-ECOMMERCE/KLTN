import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shipping_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiUser {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getProfile() async {
    final jwtToken = await storage.read(key: 'access-token');
    print(jwtToken);
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me',
    );
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      print(resData);
      if (response.statusCode != 200) throw HttpException(resData['message']);
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> changePassword(String oldPassword, String newPassword) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/password/update',
    );
    Map<String, String> body = {
      'oldPassword': oldPassword,
      'password': newPassword,
    };
    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> changeName(String name, String email) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me/update',
    );
    Map<String, String> body = {
      'name': name,
      'email': email,
    };

    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> changeEmail(String email, String name) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me/update',
    );
    Map<String, String> body = {
      'name': name,
      'email': email,
    };

    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> checkOtpChangeEmail(int otp) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me/checkOtpChangeEmail',
    );
    Map<String, dynamic> body = {
      'otp': otp,
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> checkOtpNewEmail(int otp) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me/checkOtpNewEmail',
    );
    Map<String, dynamic> body = {
      'otp': otp,
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData['result'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> uploadAvatar(String image) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/me/upload_avatar',
    );

    Map<String, dynamic> body = {
      'avatar': image,
    };

    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );

      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> findUser(String userId) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/findUser/$userId',
    );
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
