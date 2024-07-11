import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiUser {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getProfile() async {
    final jwtToken = await storage.read(key: 'access-token');
    print(jwtToken);
    final url = Uri.https(
      host,
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
    final url = Uri.https(
      host,
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
    final url = Uri.https(
      host,
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

    final url = Uri.https(
      host,
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

    final url = Uri.https(
      host,
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

    final url = Uri.https(
      host,
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

  Future<dynamic> addShippingAddress(ShippingAddress shippingAddress) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/me/createShippingInfo',
    );
    Map<String, dynamic> body = {
      'address': shippingAddress.address.trim(),
      'city': shippingAddress.city.trim(),
      'phoneNo': shippingAddress.phoneNo.trim(),
      'zipCode': shippingAddress.zipCode.trim(),
      'country': shippingAddress.country.displayNameNoCountryCode.trim(),
      'latitude': shippingAddress.place.latitude.toString(),
      'longitude': shippingAddress.place.longitude.toString(),
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
      if (response.statusCode != 201) {
        throw HttpException(resData['message'] as String);
      }
      return resData['shippingInfo'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getShippingAddresses() async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.https(
      host,
      'api/v1/mobile/me/getShippingInfo',
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
      if (response.statusCode != 200) {
        throw HttpException(resData['message'] as String);
      }
      return resData['shippingInfo'] as List<dynamic>;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> updateShippingAddress(
    ShippingAddress shippingAddress,
  ) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.https(
      host,
      'api/v1/mobile/me/updateShippingInfo/${shippingAddress.id}',
    );
    Map<String, dynamic> body = {
      'address': shippingAddress.address.trim(),
      'city': shippingAddress.city.trim(),
      'phoneNo': shippingAddress.phoneNo.trim(),
      'zipCode': shippingAddress.zipCode.trim(),
      'country': shippingAddress.country.displayNameNoCountryCode.trim(),
      'latitude': shippingAddress.place.latitude.toString(),
      'longitude': shippingAddress.place.longitude.toString(),
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
        throw HttpException(resData['message'] as String);
      }
      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> deleteShippingAddress(String shippingAddressId) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.https(
      host,
      'api/v1/mobile/me/deleteShippingInfo/$shippingAddressId',
    );

    try {
      Response response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message'] as String);
      }
      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> updateDefaultShippingAddress(String shippingAddressId) async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.https(
      host,
      'api/v1/mobile/me/addressDefault/$shippingAddressId',
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
      if (response.statusCode != 200) {
        throw HttpException(resData['message'] as String);
      }
      return resData['message'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getDefaultShippingAddress() async {
    final jwtToken = await storage.read(key: 'access-token');

    final url = Uri.https(
      host,
      'api/v1/mobile/me/getAddressDefault',
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
      if (response.statusCode != 200) {
        return null;
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> updatePoint(int point) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/updatePoint',
    );
    Map<String, dynamic> body = {
      'point': point,
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

  Future<dynamic> getAmountOfUser(int year) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/me/getAmount/$year',
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
      if (response.statusCode != 200) {
        throw HttpException(resData['message']);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> uploadAvatar(String image) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
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
    final url = Uri.https(
      host,
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
