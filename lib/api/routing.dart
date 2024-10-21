import 'package:flutter_dotenv/flutter_dotenv.dart';

/// OPENROUTESERVICE DIRECTION SERVICE REQUEST 
/// Parameters are : startPoint, endPoint and api key

String baseUrl = dotenv.env['ROUTING_BASE_URL'] ?? 'No API Key found';
String apiKey = dotenv.env['ROUTING_MAP_KEY'] ?? 'No API Key found';


getRouteUrl(String startPoint, String endPoint){
  return Uri.parse('$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint');
}