import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_shop/models/my_location.dart';

class MapScreen extends StatefulWidget {
  final MyLocation myLocation;

  const MapScreen({
    Key? key,
    required this.myLocation,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.myLocation != null
            ? widget.myLocation.address
            : 'Mening Manzilim'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onTap: (location) => _pickedLocation = location,
        markers: {
          Marker(
            markerId: const MarkerId('1'),
            position: _pickedLocation ??
                LatLng(
                  widget.myLocation.latitude,
                  widget.myLocation.longitude,
                ),
          ),
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.myLocation.latitude,
            widget.myLocation.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }
}
