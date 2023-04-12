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
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {

  void _getCurrentLocation() async {
    // Request permission from user
    final permissionStatus = await Permission.location.request();
    
    // If user allow permission, obtain location
    if (permissionStatus.isGranted) {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        widget.currentPosition!.latitude = position.latitude;
        widget.currentPosition!.longitude = position.longitude;
        // Use the controller to move the map and view the new location
        widget.mapController.move(widget.currentPosition, widget.zoom);
      });
    } else {// Show error permission
      showSnackBar(context, "Ha denegado el permiso de localización");
    }

    
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          const Text("Localización", style: const TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade200)),
            onPressed: _getCurrentLocation,
            child: Text('Obtener posición')
          ),
          SizedBox(height: 10,),
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
                        point: LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
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
 