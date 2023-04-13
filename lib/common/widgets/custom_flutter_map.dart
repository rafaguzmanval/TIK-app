import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tree_timer_app/constants/utils.dart';

class CustomMap extends StatefulWidget {

  final mapController = MapController();
  LatLng currentPosition;
  final double zoom = 18;

  CustomMap({
    super.key,
    required this.currentPosition,
  });

  @override
  State<CustomMap> createState() => CustomMapState();
}

class CustomMapState extends State<CustomMap> {

  void updateCurrentLocation(LatLng currentPosition) async {
    // Use the controller to move the map and view the new location
      widget.mapController.move(currentPosition, widget.zoom);
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Container(
            height: 300,
            child: FlutterMap(
                // Add controller to interact with the map, such as panning, zooming and rotating 
                mapController: widget.mapController,
                options: MapOptions(
                    screenSize: Size(300, 300),
                    center: LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                    zoom: widget.zoom,
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'tree_timer_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        // To make sure if map initilize, marker showup in coordinates 90, 90
                        point: widget.currentPosition!.latitude == 0.0 && widget.currentPosition!.longitude == 0.0 ?
                               LatLng(90, 90) :
                               LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                        width: 80,
                        height: 80,
                        builder: (context) => Container(
                          child: Icon(Icons.location_on),
                        ),
                      ),
                    ],
                  )
                ],
            ),
          ),
        ],
      );
  }
}
 