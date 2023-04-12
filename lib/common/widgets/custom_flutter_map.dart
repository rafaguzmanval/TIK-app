import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatelessWidget {

  final double lat;
  final double lng;

  const CustomMap({
    super.key,
    required this.mapController,
    required this.lat,
    required this.lng,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          const Text("Localización", style: const TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade200)),
            onPressed: () {
            },
            child: Text('Obtener posición')
          ),
          SizedBox(height: 10,),
          Container(
            height: 300,
            child: FlutterMap(
                // Add controller to interact with the map, such as panning, zooming and rotating 
                mapController:  MapController(),
                options: MapOptions(
                    screenSize: Size(300, 300),
                    center: LatLng(lat, lng),
                    zoom: 12,
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'tree_timer_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lng),
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
 