

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_place_api_demo_k/framework/Repository/rest_client.dart';

import 'package:uuid/uuid.dart';


class AddressController extends ChangeNotifier{
  
  late String strAddress;
  String _sessionToken = '123456';
  
  List placesList = [];

  Future<void> setAddressController(String val) async {
    strAddress = val;
    _sessionToken ??= const Uuid().v4();
    print('calling rest client');
    var response = await RestClient.getApi(val, _sessionToken);
    print(response.toString());
    if(response != null) {
      placesList = jsonDecode(response.toString())['predictions'];
    }
    notifyListeners();
  }

}