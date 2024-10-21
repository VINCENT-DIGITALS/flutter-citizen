import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadManager {
  bool isPaused = false;
  CancelToken? cancelToken;

  // Method to download tiles for offline use
  Future<void> downloadTiles(
    int minZoom,
    int maxZoom,
    Function(double, String) onProgressUpdate, // Update function signature
  ) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      cancelToken = CancelToken(); // Initialize cancel token
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final tilesDir = Directory('${appDocDir.path}/map_tiles');
      if (!tilesDir.existsSync()) {
        tilesDir.createSync(recursive: true);
        print('Created directory: ${tilesDir.path}');
      }

      const urlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      final bounds = LatLngBounds(
        LatLng(15.717, 120.820), // Southwest corner
        LatLng(15.725, 121.060), // Northeast corner
      );

      int totalTiles = 0;
      int totalBytesDownloaded = 0;

      // Calculate the total number of tiles
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final startX = _lngToTileX(bounds.southWest.longitude, zoom);
        final endX = _lngToTileX(bounds.northEast.longitude, zoom);
        final startY = _latToTileY(bounds.northEast.latitude, zoom);
        final endY = _latToTileY(bounds.southWest.latitude, zoom);

        totalTiles += (endX - startX + 1) * (endY - startY + 1);
      }

      int downloadedTiles = 0;

      // Download the tiles
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final startX = _lngToTileX(bounds.southWest.longitude, zoom);
        final endX = _lngToTileX(bounds.northEast.longitude, zoom);
        final startY = _latToTileY(bounds.northEast.latitude, zoom);
        final endY = _latToTileY(bounds.southWest.latitude, zoom);

        for (int x = startX; x <= endX; x++) {
          for (int y = startY; y <= endY; y++) {
            if (isPaused) {
              await Future.delayed(const Duration(milliseconds: 500));
              return; // Exit the loop if paused
            }

            final tileUrl = urlTemplate
                .replaceAll('{z}', zoom.toString())
                .replaceAll('{x}', x.toString())
                .replaceAll('{y}', y.toString());

            final tileFile = File('${tilesDir.path}/$zoom-$x-$y.png');
            if (!tileFile.existsSync()) {
              try {
                final response = await dio.download(
                  tileUrl,
                  tileFile.path,
                  cancelToken: cancelToken, // Attach cancel token
                  onReceiveProgress: (received, total) {
                    // Increment the total bytes downloaded
                    totalBytesDownloaded += received;

                    // Calculate overall progress as a percentage
                    downloadedTiles += 1;
                    double overallProgress = downloadedTiles / totalTiles;

                    // Calculate the data usage in KB/MB/GB dynamically
                    String dataUsed = _formatBytes(totalBytesDownloaded);

                    // Update the progress UI with percentage and data used
                    onProgressUpdate(overallProgress, dataUsed);
                    print(
                        'Progress: ${(overallProgress * 100).toStringAsFixed(2)}%, Data used: $dataUsed');
                  },
                );
                if (response.statusCode == 200) {
                  print('Tile downloaded: $zoom-$x-$y');
                }
              } on DioException catch (e) {
                if (CancelToken.isCancel(e)) {
                  print("Download canceled: $e");
                  return;
                } else {
                  print("Failed to download tile: $zoom-$x-$y. Error: $e");
                }
              }
            }
          }
        }
      }
    } else {
      print("Storage permission denied.");
    }
  }

// Helper function to format bytes into KB, MB, or GB
  String _formatBytes(int bytes) {
    const int KB = 1024;
    const int MB = 1024 * KB;
    const int GB = 1024 * MB;

    if (bytes >= GB) {
      return '${(bytes / GB).toStringAsFixed(2)} GB';
    } else if (bytes >= MB) {
      return '${(bytes / MB).toStringAsFixed(2)} MB';
    } else if (bytes >= KB) {
      return '${(bytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes B';
    }
  }

  // Convert longitude to tile X coordinate
  int _lngToTileX(double lng, int zoom) {
    return ((lng + 180) / 360 * (1 << zoom)).floor();
  }

  // Convert latitude to tile Y coordinate
  int _latToTileY(double lat, int zoom) {
    return ((1 - (log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi)) /
            2 *
            (1 << zoom))
        .floor();
  }

  // Method to estimate total size of tiles
  Future<double> estimateTotalSize(int minZoom, int maxZoom) async {
    const double averageTileSize = 256.0; // Average size of a tile in KB
    int totalTiles = 0;

    final bounds = LatLngBounds(
      LatLng(15.717, 120.820), // Southwest corner
      LatLng(15.725, 121.060), // Northeast corner
    );

    for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
      final startX = _lngToTileX(bounds.southWest.longitude, zoom);
      final endX = _lngToTileX(bounds.northEast.longitude, zoom);
      final startY = _latToTileY(bounds.northEast.latitude, zoom);
      final endY = _latToTileY(bounds.southWest.latitude, zoom);

      totalTiles += (endX - startX + 1) * (endY - startY + 1);
    }

    return totalTiles * averageTileSize; // Size in KB
  }

  // Check if any map tiles exist
  Future<bool> hasDownloadedTiles() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final tilesDir = Directory('${appDocDir.path}/map_tiles');

    return tilesDir.existsSync() && tilesDir.listSync().isNotEmpty;
  }

  // Method to delete map tiles from device storage
  Future<void> deleteMapTiles() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final tilesDir = Directory('${appDocDir.path}/map_tiles');

    if (tilesDir.existsSync()) {
      tilesDir.deleteSync(recursive: true); // Delete all files in the directory
      print("Map tiles deleted successfully.");
    } else {
      print("No map tiles found to delete.");
    }
  }

  // Method to handle cancel download
  void cancelDownload() {
    if (cancelToken != null && !cancelToken!.isCancelled) {
      cancelToken!.cancel("Download canceled by user.");
    }
  }

  // Method to handle pause download
  void pauseDownload() {
    isPaused = true;
  }
}
