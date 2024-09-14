// class WeatherData {
//   final String name;
//   final WTemperature temperature;
//   final int humidity;
//   final Wind wind;
//   final double feelsLike;
//   final int pressure;
//   final int seaLevel;
//   final List<WeatherInfo> weather;
//   // i have alreadt create a mode her according to my requirement you can also create mode according to your requiremnet
//   // if you need like my model all the source code are is in description. you can follow we me.
  
//   WeatherData({
//     required this.name,
//     required this.temperature,
//     required this.humidity,
//     required this.wind,
   
//     required this.feelsLike,
//     required this.pressure,
//     required this.seaLevel,
//     required this.weather,
    
//   });

//   factory WeatherData.fromJson(Map<String, dynamic> json) {
//     return WeatherData(
//       name: json['name'],
//      temperature: WTemperature.fromJson(json['main']['temp']),
//       humidity: json['main']['humidity'],
//       wind: Wind.fromJson(json['wind']),

//       feelsLike: (json['main']['feels_like'] - 273.15), // Kelvin to Celsius
//       pressure: json['main']['pressure'],
//       seaLevel: json['main']['sea_level'] ?? 0,
//       weather: List<WeatherInfo>.from(
//         json['weather'].map(
//           (weather) => WeatherInfo.fromJson(weather),
//         ),
//       ),
//     );
//   }
// }

// class WeatherInfo {
//   final String main;
//   final String description;
//   final String icon;

//   WeatherInfo({
//     required this.main,
//     required this.description,
//     required this.icon,
//   });

//   factory WeatherInfo.fromJson(Map<String, dynamic> json) {
//     return WeatherInfo(
//       main: json['main'],
//       description: json['description'],
//       icon: json['icon'],
//     );
//   }
// }

// class WTemperature {
//   final double current;

//   WTemperature({required this.current});

//   factory WTemperature.fromJson(dynamic json) {
//     return WTemperature(
//       current: (json - 273.15), // Kelvin to Celsius
//     );
//   }
// }

// class Wind {
//   final double speed;

//   Wind({required this.speed});

//   factory Wind.fromJson(Map<String, dynamic> json) {
//     return Wind(speed: json['speed']);
//   }
// }