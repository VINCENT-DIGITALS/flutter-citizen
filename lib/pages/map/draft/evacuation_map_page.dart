// import 'dart:io'; // For file operations
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:connectivity_plus/connectivity_plus.dart'; // For internet connectivity check
// // import '../../models/map_tile_downloader.dart';
// import 'package:path_provider/path_provider.dart'; // For accessing file directories

// class EvacuationPlaceMapPage extends StatefulWidget {
//   final String locationName;
//   final LatLng MyLocationCoordinates;
//   final LatLng evacuationCoords;

//   const EvacuationPlaceMapPage({
//     required this.locationName,
//     required this.MyLocationCoordinates,
//     required this.evacuationCoords,
//     super.key,
//   });

//   @override
//   State<EvacuationPlaceMapPage> createState() => _EvacuationPlaceMapPageState();
// }

// class _EvacuationPlaceMapPageState extends State<EvacuationPlaceMapPage> {
//   double downloadProgress = 0.0;
//   bool isDownloading = false;
//   bool isPaused = false;
//   bool showDataUsage = true;
//   bool showDeleteButton = false;
//   String dataUsed = '0 KB'; // Store data usage here
//   // final DownloadManager downloadManager = DownloadManager();
//   bool hasInternet = true; // Track internet status
//   late Future<String> offlineTilesPath; // For storing offline tiles path

//   @override
//   void initState() {
//     super.initState();
//     checkForDownloadedTiles();
//     checkInternetConnectivity();
//     offlineTilesPath = _getOfflineTilesPath(); // Initialize offline path
//   }

//   // Check internet connection status
//   Future<void> checkInternetConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     setState(() {
//       hasInternet = connectivityResult != ConnectivityResult.none;
//     });
//   }

//   // Get the path to offline tiles folder asynchronously
//   Future<String> _getOfflineTilesPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/map_tiles';
//   }

//   Future<void> checkForDownloadedTiles() async {
//     bool hasTiles = await downloadManager.hasDownloadedTiles();
//     setState(() {
//       showDeleteButton = hasTiles;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.locationName),
//         actions: [
//           if (showDeleteButton)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () async {
//                 bool confirmed = await _showDeleteConfirmationDialog();
//                 if (confirmed) {
//                   await downloadManager.deleteMapTiles();
//                   setState(() {
//                     showDeleteButton = false;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Map tiles deleted successfully."),
//                     ),
//                   );
//                 }
//               },
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           FutureBuilder<String>(
//             future: offlineTilesPath, // Load offline path asynchronously
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return const Center(
//                     child: Text('Error loading offline tiles.'));
//               } else {
//                 final offlinePath = snapshot.data!;
//                 return FlutterMap(
//                   options: MapOptions(
//                     initialCenter: widget.MyLocationCoordinates,
//                     initialZoom: 15,
//                     maxZoom: 20,
//                     minZoom: 14,
//                   ),
//                   children: [
//                     _buildTileLayer(offlinePath),
//                     MarkerLayer(
//                       markers: getMarkers(),
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//           if (isDownloading) _buildDownloadUI(),
//         ],
//       ),
//       floatingActionButton: isDownloading
//           ? null
//           : FloatingActionButton(
//               onPressed: _startDownload,
//               tooltip: 'Download offline map',
//               child: const Icon(Icons.download),
//             ),
//     );
//   }

// // Build the tile layer (switch between online and offline)
//   TileLayer _buildTileLayer(String offlinePath) {
//     bool tileLoadError = false; // Flag to track errors

//     return hasInternet
//         ? TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.app',
//           )
//         : TileLayer(
//             tileProvider: FileTileProvider(),
//             urlTemplate: '$offlinePath/{z}-{x}-{y}.png',
//             userAgentPackageName: 'com.example.app',
//             errorTileCallback: (tile, error, stackTrace) {
//               tileLoadError = true; // Set flag to true if there's an error
//               print(
//                 'Tile not found: $offlinePath',
//               );
//               // Display error feedback (e.g., tile not found)
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Failed to load some map tiles.'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//           );
//   }

// // // Add this method to display success after map tiles are loaded
// //   void _displayMapLoadSuccess(bool hasInternet, bool tileLoadError) {
// //     if (!hasInternet && !tileLoadError) {
// //       // If offline and no errors occurred, show success message
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Offline map loaded successfully.'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //     }
// //   }

// // Helper function to check if the tile file exists
//   bool _tileExists(String tilePath) {
//     final file = File(tilePath);
//     return file.existsSync();
//   }

//   // Build download UI overlay
//   Widget _buildDownloadUI() {
//     return Positioned(
//       bottom: 80,
//       left: 20,
//       right: 20,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Downloading: ${(downloadProgress * 100).toStringAsFixed(0)}%',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           LinearProgressIndicator(
//             value: downloadProgress,
//             backgroundColor: Colors.grey[300],
//             color: Colors.blue,
//             minHeight: 8,
//           ),
//           const SizedBox(height: 10),
//           if (showDataUsage)
//             Text(
//               'Data Used: $dataUsed',
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 showDataUsage = !showDataUsage;
//               });
//             },
//             child: Text(showDataUsage ? 'Hide Data Usage' : 'Show Data Usage'),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     isPaused = true;
//                   });
//                   downloadManager.pauseDownload();
//                 },
//                 child: const Text('Pause'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   downloadManager.cancelDownload();
//                   setState(() {
//                     isDownloading = false;
//                   });
//                 },
//                 child: const Text('Cancel'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Do not leave the page, turn off your phone, or exit the app during the download.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   // Handle download process
//   void _startDownload() async {
//     double estimatedSizeMB =
//         await downloadManager.estimateTotalSize(10, 18) / 1024;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Estimated Download Size"),
//           content: Text(
//               "The estimated size of the download is ${estimatedSizeMB.toStringAsFixed(2)} MB. Do you want to continue?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   isDownloading = true;
//                   isPaused = false;
//                 });
//                 downloadManager.downloadTiles(14, 20, (progress, usedData) {
//                   setState(() {
//                     downloadProgress = progress;
//                     dataUsed = usedData;
//                   });
//                 });
//               },
//               child: const Text("Download"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<bool> _showDeleteConfirmationDialog() async {
//     return await showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text("Confirm Deletion"),
//               content: const Text(
//                   "Are you sure you want to delete the downloaded map tiles?"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: const Text("Delete"),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;
//   }

//   List<Marker> getMarkers() {
//     return [
//       Marker(
//         point: widget.MyLocationCoordinates,
//         child: const Icon(
//           Icons.person_pin_circle,
//           color: Colors.blue,
//           size: 40,
//         ),
//       ),
//       Marker(
//         point: widget.evacuationCoords,
//         child: const Icon(
//           Icons.location_on,
//           color: Colors.red,
//           size: 40,
//         ),
//       ),
//     ];
//   }
// }
