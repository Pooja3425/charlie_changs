import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'CustomException.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';


class ApiProvider {

  //DEV
  // final String _baseUrl = "https://charliechangs.in/dev/api/";
  // static const String BASE_URL_FOR_WEB = "https://charliechangs.in/dev/";
  // static const String BASE_URL = "https://charliechangs.in/dev/api/";

  //LIVE
  final String _baseUrl = "https://charliechangs.in/api/";
  static const String BASE_URL_FOR_WEB = "https://charliechangs.in/";
  static const String BASE_URL = "https://charliechangs.in/api/";

  //Test Env Token and Api key for instaMojo url on checkout_screen
  // static const String TEST_X_API_KEY = "test_ba7b1358c28a4a61f1687270c6c";
  // static const String TEST_X_AUTH_TOKEN = "test_4552674a5d9717da7e586441905";

  //Live Env Token and Api key for instaMojo url on checkout_screen
  static const String LIVE_X_API_KEY = "9d8a8ce6ac9f6f42792a7e403a915de6";
  static const String LIVE_X_AUTH_TOKEN = "4886bf4f24632581c2821a7e7094fe90";

  // static const String instaMojoTestUrl = "https://test.instamojo.com/api/1.1/payments/";
  static const String instaMojoLiveUrl = "https://www.instamojo.com/api/1.1/payments/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getHeader(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    Map<String , String> headers = {
      'Accept':'application/json',
      'Authorization':token,
      "Connection": "keep-alive",
    };

    var responseJson;
    try {
      //print("URL ${_baseUrl+url}  ${headers}");
      final response = await http.get(_baseUrl + url,headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> post(String url,var bodyData) async {
    var responseJson;
    Map<String,String> headers = {'Content-Type':'application/json',"Connection": "keep-alive",};
    print("URL ${_baseUrl+url}  ${bodyData} ");
    try {
      final response = await http.post(_baseUrl + url,body: bodyData,headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putRequest(String url) async {
    var responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var header = {"Authorization": 'Bearer ${token}"'};
    print("URL ${_baseUrl+url}  ");
    try {
      final response = await http.put(_baseUrl + url,headers: header);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putRequestWithBody(String url,Map<String, dynamic> bodyData) async {
    var responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var header = {"Authorization": 'Bearer ${token}"'};
    print("URL ${_baseUrl+url}  $bodyData $header");
    try {
      final response = await http.put(_baseUrl + url,headers: header,body: bodyData);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> deleteRequest(String url,var header) async {
    var responseJson;
    print("URL ${_baseUrl+url}  ${header}");
    try {
      final response = await http.delete(_baseUrl + url,headers: header);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> postToken(String url,var bodyData) async {
    var responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    Map<String , String> headers = {
      'Accept':'application/json',
      'Authorization':token,
      "Connection": "keep-alive",
    };
    print("HEEE ${headers} ${bodyData} ${_baseUrl+url}");

    try {
      final response = await http.post(_baseUrl + url,body: bodyData,headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putToken(String url,Map<String, dynamic> bodyData,var header) async {
    var responseJson;
    print("URL ${_baseUrl+url}  ${header}");
    try {
      final response = await http.put(_baseUrl + url,body: bodyData,headers: header);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
       // print("${response.body.toString()}");
        var responseJson = json.decode(response.body.toString());
       // print(responseJson);
        return responseJson;
      case 400:
        print("400");
        var responseJson = json.decode(response.body.toString());
       // return responseJson;
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
