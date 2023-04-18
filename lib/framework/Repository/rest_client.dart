import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RestClient{
  static const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String kPLACES_API_KEY = 'AIzaSyCtumA5CYFBJ9oy9zUJhDjQ781SfiP9k0c';


  static Future<dynamic> getApi(String input, String sessionToken) async {
    String url = '$baseUrl?input=$input&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';

    var response = await Dio().get(url);
    if(response.statusCode == 200){
      return response;
    }
    else{
      throw Exception('unable to load');
    }
  }
}