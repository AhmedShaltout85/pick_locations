import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pick_locations/model/pick_locations_model.dart';

import '../utils/pick_locations_constants.dart';

class PickLocationsDioRepos {
  Future getLoc() async {
    var dio = Dio();
    try {
      var response = await dio.get(getUrl);
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future addLoc(PickLocationModel addLocation) async {
    var dio = Dio();
    try {
      var response = await dio.post(addUrl, data: {
        "address": addLocation.address,
        "latitude": addLocation.latitude,
        "longitude": addLocation.longitude,
        "flag": addLocation.flag,
        "real_address": addLocation.realAddress
      });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future updateLoc(
      int id, String latitude, String longitude, String realAddress) async {
    var dio = Dio();
    try {
      var response = await dio.put("$updateUrl/$id", data: {
        "latitude": latitude,
        "longitude": longitude,
        "flag": 1,
        "real_address": realAddress
      });
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
