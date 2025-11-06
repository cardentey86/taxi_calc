import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_calc/modules/map/widgets/calculate_control_widget.dart';
import 'package:taxi_calc/modules/map/widgets/info_widget.dart';
import 'package:taxi_calc/modules/map/widgets/orientation_control_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  final MapController _mapController = MapController();
  double _currentZoom = 15.0;
  double latitude = 23.1136;
  double longitude = -82.3666;
  bool _mapReady = false;
  double _heading = 0.0; // Dirección del dispositivo en grados
  bool _followUser = true;

  // Lista de puntos marcados en el mapa
  final List<LatLng> _markers = [];

  // Ubicación en tiempo real
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
    _checkPermissions();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final permission = await Geolocator.checkPermission();
    debugPrint('Estado del permiso: $permission');
  }

  Future<void> _initLocationTracking() async {
    // 🔹 Verifica si el servicio de ubicación está activado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, activa el GPS')),
      );
      return;
    }

    // 🔹 Revisa permisos
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso denegado permanentemente, actívalo en Ajustes'),
        ),
      );
      await Geolocator.openAppSettings();
      return;
    }

    // 🔹 Si se concedió el permiso, obtener la ubicación actual
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      latitude = position.latitude;
      longitude = position.longitude;
    });

    // 🔹 Escuchar cambios en tiempo real
    _positionStream?.cancel(); // Cancela cualquier stream anterior
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;
        _heading = position.heading; // 🔸 nuevo
      });

      // 🔹 Mantener el marcador en el centro si el seguimiento está activo
      if (_mapReady && _followUser) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          _currentZoom,
        );
      }
    });
  }

  void _zoomIn() {
    if(_mapReady)
      {
        _currentZoom = _mapController.camera.zoom;
        setState(() {
          _currentZoom += 1;
          _mapController.move(LatLng(latitude, longitude), _currentZoom);
        });
      }
  }

  void _zoomOut() {
    if(_mapReady)
      {
        _currentZoom = _mapController.camera.zoom;
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

    LatLng centerPoint = LatLng(latitude, longitude);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(latitude, longitude),
              initialZoom: _currentZoom,
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
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    centerPoint = position.center!;
                    latitude = position.center!.latitude;
                    longitude = position.center!.longitude;
                    _currentZoom = position.zoom ?? _currentZoom;
                  });
                }
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
                    width: 60,
                    height: 60,
                    child: Transform.rotate(
                      angle: _heading * (3.141592653589793 / 180),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 🔹 Capa "borde blanco"
                          Icon(
                            Icons.navigation,
                            color: Colors.white,
                            size: 38, // un poco más grande para simular el borde
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          // 🔹 Capa principal (flecha azul)
                          const Icon(
                            Icons.navigation,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Círculo exterior
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(128.0, 0) // Mueve el widget (x, y)
                    ..rotateZ(1.55), // Rota en radianes (sentido horario)
                  alignment: Alignment.center, // Centro de rotación
                  child: Container(
                    width: 100,
                    height: 50,
                    child: const Center(child: Text('250 m')),
                  ),
                ),
                // Punto central
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                ),
              ],
            ),
          ),
          // 🔼 Botones arriba a la izquierda
          Positioned(
            top: 20,
            left: -10,
            child: OrientationControls(onModeChanged: (mode) {
              // Acción al cambiar el modo de orientación
            }),
          ),
          // 🔼 Botones arriba a la derecha
          Positioned(
            top: 20,
            right: 10,
            child: InfoWidget(),
          ),
          Positioned(
            bottom: 90,
            left: 20,
            child: CalculateControl(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔧 Botón Settings alineado a la izquierda
                GestureDetector(
                  onTap: () {
                    // Acción al presionar el botón de configuración
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
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
                    child: Icon(Icons.settings, color: Colors.black87),
                  ),
                ),

                // 📍 Contenedor centrado con los dos botones de zoom
                Row(
                  mainAxisSize: MainAxisSize.min,
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

                // Espaciador invisible a la derecha (para balancear el Row)
                const SizedBox(width: 50),
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
            setState(() {
              // 🔹 Al presionar, activa seguimiento
              _followUser = true;
              _mapController.move(_currentLocation!, _currentZoom);
              latitude = _currentLocation!.latitude;
              longitude = _currentLocation!.longitude;
            });
          }
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
