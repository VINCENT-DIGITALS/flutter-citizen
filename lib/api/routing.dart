import 'package:flutter_dotenv/flutter_dotenv.dart';

/// OPENROUTESERVICE DIRECTION SERVICE REQUEST
/// Parameters are: startPoint, endPoint, and API key

String baseUrl = dotenv.env['ROUTING_BASE_URL'] ?? 'No Base URL found';
String apiKey = dotenv.env['ROUTING_MAP_KEY'] ?? 'No API Key found';

getRouteUrl(String startPoint, String endPoint) {
  if (baseUrl == 'No Base URL found' || apiKey == 'No API Key found') {
    print('Error: Base URL or API key not found.');
    return Uri.parse(''); // Return an empty URI if API details are missing
  }
  return Uri.parse('$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint');
}
