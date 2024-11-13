import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> currentWeather;
  final List<Map<String, dynamic>> forecastData;

  WeatherWidget({
    required this.currentWeather,
    required this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Current Weather
          Text(
            'Current Weather',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildCurrentWeatherSection(),
          SizedBox(height: 20),

          // Display Forecast Data
          Text(
            'Forecast',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildForecastSection(),
        ],
      ),
    );
  }

  // Helper method to display current weather data
  Widget _buildCurrentWeatherSection() {
    return currentWeather.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description: ${currentWeather['weather'][0]['description'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Temperature: ${currentWeather['main']['temp'] ?? 'N/A'}°C',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Feels Like: ${currentWeather['main']['feels_like'] ?? 'N/A'}°C',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Cloudiness: ${currentWeather['clouds']['all'] ?? 'N/A'}%',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Humidity: ${currentWeather['main']['humidity'] ?? 'N/A'}%',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Wind Speed: ${currentWeather['wind']['speed'] ?? 'N/A'} m/s',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        : Text(
            'No current weather data available.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          );
  }

  // Helper method to display forecast data
  Widget _buildForecastSection() {
    return forecastData.isNotEmpty
        ? Column(
            children: forecastData.map((forecast) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Description: ${forecast['weather'][0]['description'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Temperature: ${forecast['main']['temp'] ?? 'N/A'}°C',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Feels Like: ${forecast['main']['feels_like'] ?? 'N/A'}°C',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Cloudiness: ${forecast['clouds']['all'] ?? 'N/A'}%',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Humidity: ${forecast['main']['humidity'] ?? 'N/A'}%',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Wind Speed: ${forecast['wind']['speed'] ?? 'N/A'} m/s',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Text(
            'No forecast data available.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          );
  }
}
