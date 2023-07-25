import 'dart:convert';

import 'package:debt_frontend/models/transaction.dart';
import 'package:dio/dio.dart';

class TransactionRepository {
  static final TransactionRepository _repository = TransactionRepository._internal();

  factory TransactionRepository() {
    return _repository;
  }

  TransactionRepository._internal();

  final String baseUrl = "http://10.0.2.2:8080";
  String username = "Slark";
  String password = "1234";

  Future<void> makeTransaction(String friendUsername, CreatedTransaction transaction) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.post(
        "$baseUrl/transactions/make/$friendUsername",
        data: transaction.toJson()
      );
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }

  Future<List<Transaction>> getTransactions(String friendUsername) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await dio.get("$baseUrl/transactions/get/$friendUsername");
    var statusCode = response.statusCode;
    var responseData = response.data as List;

    return responseData.map((e) => Transaction.fromJson(e)).toList();
  }

  Future<void> deleteTransaction(int transactionId) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.delete(
        "$baseUrl/transactions/delete/$transactionId",
      );
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }
}