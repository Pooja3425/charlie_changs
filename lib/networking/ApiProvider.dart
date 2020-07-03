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
  final String _baseUrl = "https://charliechangs.in/api/";
  //final String _baseUrl = "https://finolex.brandzgarage.com/api/";

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
      'Authorization':token
    };

    var responseJson;
    try {
      print("URL ${_baseUrl+url}  ${headers}");
      final response = await http.get(_baseUrl + url,headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> post(String url,var bodyData) async {
    var responseJson;
    Map<String,String> headers = {'Content-Type':'application/json'};
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
      'Authorization':token
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
        print("200");
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        print("400");
       // var responseJson = json.decode(response.body.toString());
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
