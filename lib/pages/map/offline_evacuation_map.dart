import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/marker.dart';

class EvacuationLocationMap extends StatefulWidget {
  final String locationName;
  final LatLng locationCoordinates;

  EvacuationLocationMap({
    required this.locationName,
    required this.locationCoordinates,
    super.key,
  });

  @override
  _EvacuationLocationMapState createState() => _EvacuationLocationMapState();
}

class _EvacuationLocationMapState extends State<EvacuationLocationMap> {
  final displayModel = DisplayModel(deviceScaleFactor: 2);
  final symbolCache = FileSymbolCache();
  final MarkerDataStore markerDataStore = MarkerDataStore();
  
  // Define the bounds for Muñoz, Nueva Ecija
  final LatLngBounds bounds = LatLngBounds(
    LatLng(15.717, 120.820), // Southwest corner
    LatLng(15.725, 121.060), // Northeast corner
  );

  Timer? _mapBoundsEnforcer;

  Future<MapModel> _createMapModel() async {
    ByteData content = await rootBundle.load(
        'assets/maps/munoz.map');
    final mapFile = await MapFile.using(content.buffer.asUint8List(), null, null);

    final renderTheme = await RenderThemeBuilder.create(
      displayModel,
      'assets/render_themes/defaultrender.xml',
    );

    final jobRenderer = MapDataStoreRenderer(mapFile, renderTheme, symbolCache, true);

    MapModel mapModel = MapModel(
      displayModel: displayModel,
      renderer: jobRenderer,
    );

    mapModel.markerDataStores.add(markerDataStore);
    return mapModel;
  }

  Future<ViewModel> _createViewModel() async {
    ViewModel viewModel = ViewModel(displayModel: displayModel);
    
    // Center the map within the bounds (Muñoz, Nueva Ecija)
    viewModel.setMapViewPosition(15.716, 120.936); // Center point of bounds
    viewModel.setZoomLevel(12);

    // Enforce map borders every 500ms
    _mapBoundsEnforcer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _enforceMapBounds(viewModel);
    });

    return viewModel;
  }

  // Function to enforce the map borders
  void _enforceMapBounds(ViewModel viewModel) {
    MapViewPosition? mapViewPosition = viewModel.mapViewPosition;

    // Check if mapViewPosition is not null
    if (mapViewPosition != null) {
      LatLng currentLatLng = LatLng(
        mapViewPosition.latitude ?? 0, // default to 0 if null
        mapViewPosition.longitude ?? 0, // default to 0 if null
      );

      // Check if current position is outside the bounds
      if (!bounds.contains(currentLatLng)) {
        // If outside bounds, clamp it to the closest boundary
        double clampedLat = currentLatLng.latitude;
        double clampedLng = currentLatLng.longitude;

        // Clamp latitude within the bounds
        if (currentLatLng.latitude < bounds.southWest.latitude) {
          clampedLat = bounds.southWest.latitude;
        } else if (currentLatLng.latitude > bounds.northEast.latitude) {
          clampedLat = bounds.northEast.latitude;
        }

        // Clamp longitude within the bounds
        if (currentLatLng.longitude < bounds.southWest.longitude) {
          clampedLng = bounds.southWest.longitude;
        } else if (currentLatLng.longitude > bounds.northEast.longitude) {
          clampedLng = bounds.northEast.longitude;
        }

        // Snap back to the clamped position within the bounds
        viewModel.setMapViewPosition(clampedLat, clampedLng);
      }
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _mapBoundsEnforcer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Evacuation Location Map")),
      body: MapviewWidget(
        displayModel: displayModel,
        createMapModel: _createMapModel,
        createViewModel: _createViewModel,
      ),
    );
  }
}

class _MarkerOverlay extends StatefulWidget {
  final MarkerDataStore markerDataStore;
  final ViewModel viewModel;
  final SymbolCache symbolCache;
  final DisplayModel displayModel;

  const _MarkerOverlay({
    required this.viewModel,
    required this.markerDataStore,
    required this.symbolCache,
    required this.displayModel,
  });

  @override
  State<StatefulWidget> createState() {
    return _MarkerOverlayState();
  }
}

class _MarkerOverlayState extends State<_MarkerOverlay> {
  PoiMarker? _marker;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TapEvent>(
      stream: widget.viewModel.observeLongTap,
      builder: (BuildContext context, AsyncSnapshot<TapEvent> snapshot) {
        if (snapshot.data == null) return const SizedBox();
        if (_marker != null) {
          widget.markerDataStore.removeMarker(_marker!);
        }

        _marker = PoiMarker(
          displayModel: widget.displayModel,
          src: 'assets/icons/marker.svg',
          height: 64,
          width: 48,
          latLong: snapshot.data!,
          position: Position.ABOVE,
        );

        _marker!.initResources(widget.symbolCache).then((value) {
          widget.markerDataStore.addMarker(_marker!);
          widget.markerDataStore.setRepaint();
        });

        return const SizedBox();
      },
    );
  }
}
