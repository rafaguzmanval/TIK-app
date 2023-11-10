import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomMap extends StatefulWidget {

  LatLng currentPosition;
  final double zoom = 18;
  MapType mapType = MapType.hybrid;

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

  // Changes the map type between hybrid and normal
  void changeMapType() {
    setState(() {
      // Check the current map type
      if (widget.mapType == MapType.hybrid) {
        // If it's hybrid, change it to normal
        widget.mapType = MapType.normal;
      } else if (widget.mapType == MapType.normal) {
        // If it's normal, change it to hybrid
        widget.mapType = MapType.hybrid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Container(
            height: 300,
            child: GoogleMap(
              // This gestures allow us to move around the map using screen touchs
              gestureRecognizers: Set()
                ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
              // Marker of current position
              markers: {Marker(
                  markerId: MarkerId('CurrentPosition'),
                  position: LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude),
                  infoWindow: InfoWindow(title: AppLocalizations.of(context)!.tree),
              )},
              // Satelital type map
              mapType: widget.mapType,
              // Init position
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
 