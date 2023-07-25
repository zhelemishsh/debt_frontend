import 'dart:convert';

import 'package:dio/dio.dart';

class AccountsRepository {
  static final AccountsRepository _repository = AccountsRepository._internal();

  factory AccountsRepository() {
    return _repository;
  }

  AccountsRepository._internal();

  final String baseUrl = "http://10.0.2.2:8080";

  Future<void> loginAccount(String username, String password) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.get(
          "$baseUrl/accounts/get");
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }
}