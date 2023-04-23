import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatefulWidget {

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

  final Completer<GoogleMapController> mapController =
    Completer<GoogleMapController>();

  void updateCurrentLocation(LatLng currentPosition) async {
    // Use the controller to move the map and set the new location
    final GoogleMapController controller = await mapController.future;
    await controller.animateCamera(CameraUpdate.newLatLng(LatLng(currentPosition.latitude, currentPosition.longitude)));
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Container(
            height: 300,
            child: GoogleMap(
              markers: {Marker(
                  markerId: MarkerId('CurrentPosition'),
                  position: LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude),
                  infoWindow: InfoWindow(title: 'Árbol'),
              )},
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(target: LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude), zoom: widget.zoom),
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
            ),
          ),
        ],
      );
  }
}
 