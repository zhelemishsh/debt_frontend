import 'dart:convert';

import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/friend_request.dart';
import 'package:dio/dio.dart';

class FriendsRepository {
  static final FriendsRepository _repository = FriendsRepository._internal();

  factory FriendsRepository() {
    return _repository;
  }

  FriendsRepository._internal();

  final String baseUrl = "http://10.0.2.2:8080";
  String username = "Slark";
  String password = "1234";

  Future<List<Friend>> getFriends() async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await dio.get("$baseUrl/friends/get");
    var statusCode = response.statusCode;
    var responseData = response.data as List;

    return responseData.map((e) => Friend.fromJson(e)).toList();
  }

  Future<Friend> getFriend(String friendUsername) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await dio.get("$baseUrl/friends/get/$friendUsername");
    var statusCode = response.statusCode;

    return Friend.fromJson(response.data);
  }

  Future<void> sendFriendRequest(String friendUsername) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.post(
          "$baseUrl/friends/requests/send/$friendUsername");
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }

  Future<void> rejectFriendRequest(String friendUsername) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.post(
          "$baseUrl/friends/requests/reject/$friendUsername");
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }

  Future<String> renameFriend(String friendUsername, String newName) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.put(
          "$baseUrl/friends/rename/$friendUsername/$newName");
      return newName;
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }

  Future<void> removeFriend(String friendUsername) async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      Response response = await dio.delete(
          "$baseUrl/friends/delete/$friendUsername");
    } on DioException catch (e) {
      throw Exception(e.response?.statusCode);
    }
  }

  Future<List<FriendRequest>> getFriendRequests() async {
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await dio.get("$baseUrl/friends/requests/get");
    var statusCode = response.statusCode;
    var responseData = response.data as List;

    return responseData.map((e) => FriendRequest.fromJson(e)).toList();
  }
}