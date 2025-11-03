import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  double latitude = 23.1136;
  double longitude = -82.3666;
  bool _mapReady = false;

  // Lista de puntos marcados en el mapa
  final List<LatLng> _markers = [];

  // Ubicación en tiempo real
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('El servicio de ubicación está deshabilitado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permiso de ubicación permanentemente denegado.');
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void _zoomIn() {
    if(_mapReady)
      {
        setState(() {
          _currentZoom += 1;
          _mapController.move(LatLng(latitude, longitude), _currentZoom);
        });
      }
  }

  void _zoomOut() {
    if(_mapReady)
      {
        setState(() {
          _currentZoom -= 1;
          _mapController.move(LatLng(latitude, longitude), _currentZoom);
        });
      }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir la URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(latitude, longitude),
              initialZoom: 13.0,
              onMapReady: () {
                setState(() {
                  _mapReady = true;
                });
              },
              onLongPress: (tapPosition, point) {
                setState(() {
                  _markers.add(point); // Agrega marcador en el punto tocado
                });
              },
          ),
          children: [
            TileLayer( // Bring your own tiles
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
              userAgentPackageName: 'aac.personal.taxi_calc', // Add your app identifier
              // And many more recommended properties!
            ),
            RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => _launchUrl('https://openstreetmap.org/copyright'), // (external)
                ),
                // Also add images...
              ],
            ),
            MarkerLayer(
              markers: _markers.map((point) {
                return Marker(
                  point: point,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                );
              }).toList(),
            ),
            // Marcador de ubicación en tiempo real
            if (_currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation!,
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Zoom -
            GestureDetector(
              onTap: _zoomOut,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.remove, size: 28, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 20),
            // Botón Zoom +
            GestureDetector(
              onTap: _zoomIn,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, size: 28, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_currentLocation == null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ubicación no disponible'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
            else
          {
            _mapController.move(_currentLocation!, _currentZoom);
          }
          // if (_markers.isNotEmpty) {
          //   final last = _markers.last;
          //   _mapController.move(last, _currentZoom);
          // }
        },
        backgroundColor: _currentLocation != null
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
        tooltip: 'Increment',
        child: Icon(Icons.location_on, color: Colors.white),
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2.0,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
