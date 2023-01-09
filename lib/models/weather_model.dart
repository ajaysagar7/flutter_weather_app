// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherModel {
  double temp;
  double tempMin;
  double tempMax;
  double wind;
  String weatherTitle;
  String weatherDescription;
  int humidity;
  int pressure;
  dynamic sunrise;
  dynamic sunset;
  double feelsLike;
  String cityName;
  WeatherModel({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.wind,
    required this.weatherTitle,
    required this.weatherDescription,
    required this.humidity,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.feelsLike,
    required this.cityName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        temp: json["main"]["temp"],
        tempMin: json["main"]["temp_min"],
        tempMax: json["main"]["temp_max"],
        wind: json["wind"]["speed"],
        feelsLike: json["main"]["feels_like"],
        sunrise: json["sys"]["sunrise"],
        sunset: json["sys"]["sunset"],
        weatherTitle: json["weather"][0]["main"],
        weatherDescription: json["weather"][0]["description"],
        humidity: json["main"]["humidity"],
        pressure: json["main"]["humidity"],
        cityName: json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "temp": temp,
      "tempMin": tempMin,
      "tempMax": tempMax,
      "wind": wind,
      "sunset": sunset,
      "sunrise": sunrise,
      "weatherTitle": weatherTitle,
      "weatherDescription": weatherDescription,
      "humidity": humidity,
      "pressure": pressure,
      "feelsLike": feelsLike,
      "cityName": cityName
    };
  }
}
