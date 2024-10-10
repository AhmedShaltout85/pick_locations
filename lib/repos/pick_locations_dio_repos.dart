
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/pick_locations_constants.dart';

class UsersDioRepos {
  Future getLoc() async {
    var dio = Dio();
    try{
        var response = await dio.get(url2);
    return response.data;
    }catch(e){
      debugPrint(e.toString());
      throw Exception(e);
    }
  
  }

}