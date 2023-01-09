// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/repository/weather_repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

enum WeatherState { initial, loading, loaded, failed }

class WeatherProvider with ChangeNotifier {
  WeatherRepo weatherRepo = GetIt.I.get<WeatherRepo>();
  WeatherModel? _weatherModel;
  WeatherModel? get weatherModel => _weatherModel;

  WeatherState _state = WeatherState.initial;
  WeatherProvider({
    required this.weatherRepo,
  });
  WeatherState get state => _state;
  String? _locationName;
  String? get locationName => _locationName;

  double _customLatitude = 0.0;
  double _customLongtitude = 0.0;

  bool showGird = false;

  changeBoolvalue() {
    showGird = !showGird;
    notifyListeners();
  }

  //* fetch Weather Api
  Future<WeatherModel?> getWeather() async {
    _state = WeatherState.loading;
    notifyListeners();
    try {
      _weatherModel = await WeatherRepo.getWeatherRepo(
          latitude: _customLatitude, longtitude: _customLongtitude);
      _state = WeatherState.loaded;
      notifyListeners();
      log("printing from  provider.................");
      log(_weatherModel!.toJson().toString());
    } catch (e) {
      _state = WeatherState.failed;
      notifyListeners();
      log(e.toString());
    }
    return _weatherModel;
  }

  //initial location
  Future<Position> getuserCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.denied) {
      return Future.error("location permission are denied");
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location Permissions are denied forever");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _customLatitude = position.latitude;
    _customLongtitude = position.longitude;

    List<Placemark> placeMark =
        await placemarkFromCoordinates(_customLatitude, _customLongtitude);
    _locationName = placeMark[0].name.toString() +
        "," +
        placeMark[0].subLocality.toString();
    // _locationName = placeMark[0].street.toString();
    debugPrint(
        "---------------------------------------------------------------------------");

    debugPrint(_locationName.toString());
    debugPrint(placeMark[0].administrativeArea.toString());
    debugPrint(
        "---------------------------------------------------------------------------");

    debugPrint(_customLatitude.toString());
    debugPrint(_customLongtitude.toString());

    setLocationAddress(latitude: _customLatitude, lng: _customLongtitude);
    setLocationName(name: _locationName.toString());
    notifyListeners();

    return position;
  }

  //* location address
  setLocationAddress({required double latitude, required double lng}) {
    _customLatitude = latitude;
    _customLongtitude = lng;
    notifyListeners();
  }

  //* location name
  setLocationName({required String name}) {
    _locationName = name;
    notifyListeners();
  }
}
