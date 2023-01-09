import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/repository/dioclient/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class WeatherRepo {
  static Future<WeatherModel?> getWeatherRepo(
      {required double latitude, required double longtitude}) async {
    WeatherModel? weatherModel;
    var url = Uri.parse(ApiConstants.basicUrl);
    var isCacheExists = await APICacheManager().isAPICacheKeyExist("weather");

    if (!isCacheExists) {
      Fluttertoast.showToast(msg: "Data Loaded From API");
      log("data loaded from url");
      try {
        final response = await http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longtitude&appid=fae9438fed9e701d12dcf0538b8bedcc"));

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          APICacheDBModel dbModel =
              APICacheDBModel(key: "weather", syncData: response.body);
          await APICacheManager().addCacheData(dbModel);
          weatherModel = WeatherModel.fromJson(responseBody);
          log(weatherModel.toJson().toString());
        } else {
          log("no data found................");
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      log("data loaded from cacheeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      Fluttertoast.showToast(msg: "Data Loaded From Local Cache");
      var cachedData = await APICacheManager().getCacheData("weather");
      weatherModel = WeatherModel.fromJson(jsonDecode(cachedData.syncData));
    }

    return weatherModel;
  }
}
