import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_app/main.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/providers/weather_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<WeatherProvider>().getuserCurrentPosition();
      await context.read<WeatherProvider>().getWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    var util = ScreenUtil();
    return SafeArea(
        child: Container(
      height: util.screenHeight,
      width: util.screenWidth,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          title: GestureDetector(
              onLongPress: () {
                context.read<WeatherProvider>().changeBoolvalue();
              },
              child: const Text("Weather App")),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<WeatherProvider>().getWeather();
                },
                icon: const Icon(
                  Icons.refresh_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  APICacheManager().deleteCache("weather");
                  Fluttertoast.showToast(
                      msg: "data deleted from cache",
                      backgroundColor: Colors.red);
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<WeatherProvider>(builder: (c, provider, _) {
          if (provider.state == WeatherState.initial) {
            return _loadingWidget();
          } else if (provider.state == WeatherState.loading) {
            return _loadingWidget();
          } else if (provider.state == WeatherState.loaded) {
            return provider.showGird
                ? _loadedWidget2(provider)
                : _loadedWidget(provider);
          } else if (provider.state == WeatherState.failed) {
            return _failedWidget();
          } else {
            return Container();
          }
        }),
      ),
    ));
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _failedWidget() {
    return const Center(
      child: Text("sorry something went wrong"),
    );
  }

  Widget _loadedWidget2(WeatherProvider provider) {
    var util = ScreenUtil();
    WeatherModel model = provider.weatherModel!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          model.weatherTitle.toString(),
          style: GoogleFonts.poppins(
              fontSize: 32.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          model.cityName.toString(),
          style: GoogleFonts.poppins(
              fontSize: 32.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: ScreenUtil().screenHeight * .2,
              width: ScreenUtil().screenWidth * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Column(children: [
                SizedBox(
                  height: util.screenHeight * .15,
                  width: util.screenWidth,
                  child: Lottie.asset("assets/gifs/wind.json"),
                ),
                Text("Wind" + " : " + model.wind.toString())
              ]),
            ),
            Container(
              height: ScreenUtil().screenHeight * .2,
              width: ScreenUtil().screenWidth * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Column(children: [
                SizedBox(
                  height: util.screenHeight * .15,
                  width: util.screenWidth,
                  child: Lottie.asset("assets/gifs/humidity.json"),
                ),
                Text("Humidity" + " : " + model.humidity.toString())
              ]),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().screenHeight * .05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: ScreenUtil().screenHeight * .2,
              width: ScreenUtil().screenWidth * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: util.screenHeight * .13,
                      width: util.screenWidth,
                      child: Lottie.asset("assets/gifs/cold.json"),
                    ),
                    Text("Temp Min" + " : " + model.tempMin.toString())
                  ]),
            ),
            Container(
              height: ScreenUtil().screenHeight * .2,
              width: ScreenUtil().screenWidth * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: util.screenHeight * .13,
                      width: util.screenWidth,
                      child: Lottie.asset("assets/gifs/hot.json"),
                    ),
                    Text("Temp Max" + " : " + model.tempMax.toString())
                  ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _loadedWidget(WeatherProvider provider) {
    var util = ScreenUtil();
    WeatherModel model = provider.weatherModel!;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        _customText(model.cityName.toString(), 20.sp),
        _sizedBox(),
        _customText(model.weatherTitle.toString(), 20.sp),
        _sizedBox(),
        _customText("Temp Min" + " : " + model.tempMin.toString(), 20.sp),
        _sizedBox(),
        _customText("Temp Max" + " : " + model.tempMax.toString(), 20.sp),
        _sizedBox(),
        _customText("Wind" + " : " + model.wind.toString(), 20.sp),
        _sizedBox(),
        _customText("Humidity" + " : " + model.humidity.toString(), 20.sp),
        _sizedBox(),
        _customText("Pressure" + " : " + model.pressure.toString(), 20.sp),
        _sizedBox(),
        _customText("Feels Like" + " : " + model.feelsLike.toString(), 20.sp),
        _sizedBox(),
        _customText("sunrise" + " : " + model.sunrise.toString(), 20.sp),
        _sizedBox(),
        _customText("Sunset" + " : " + model.sunset.toString(), 20.sp),
        _sizedBox(),
      ],
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      height: ScreenUtil().screenHeight * .020,
    );
  }

  Widget _customRow(String lottilePath, String title) {
    return SizedBox(
      height: ScreenUtil().screenHeight * .1,
      child: Row(
        children: [
          Lottie.asset("assets/gifs/$lottilePath"),
          Expanded(child: _customText(title, 18.sp))
        ],
      ),
    );
  }

  Widget _customText(String val, double? fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(val,
          style: GoogleFonts.poppins(
            fontSize: fontSize ?? 18.sp,
            color: Colors.black,
          )),
    );
  }
}
