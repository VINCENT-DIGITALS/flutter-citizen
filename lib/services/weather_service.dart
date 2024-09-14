// import 'dart:convert';
// import 'package:citizen/models/weather_model.dart' as local;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class WeatherServices {
//   static int apiCallCount = 0; // Initialize the API call counter

//   fetchWeather() async {
//     final String? apiKey = dotenv.env['API_KEY'];
//     final String? baseUrl = dotenv.env['BASE_URL'];
//     final String lat = '15.7295';
//     print('API : ');
//     print(dotenv.env['API_KEY']);
//     final String lon = '120.8729';

//     if (apiKey == null || baseUrl == null) {
//       throw Exception('API not found!');
//     }
  
//     final response = await http.get(
//       Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey'),
//     );

//     try {
//       if (response.statusCode == 200) {
//         apiCallCount++; // Increment the API call count
//         var json = jsonDecode(response.body);
//         return local.WeatherData.fromJson(json);
//       } else {
//         throw Exception('Failed to load Weather data');
//       }
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
//   int getApiCallCount() {
//     return apiCallCount;
//   }
// }
