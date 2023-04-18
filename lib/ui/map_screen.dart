import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_api_demo_k/framework/controller/controller_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final mapWatch = ref.watch(mapProvider);
      mapWatch.addMarker(
        Marker(
            markerId: const MarkerId('1'),
            draggable: true,
            onDragEnd: (newPosition) {
              mapWatch.markerPosition1 = newPosition;
              mapWatch.setPolyline();
            },
            position: mapWatch.markerPosition1,
            infoWindow: const InfoWindow(title: 'Ahmedabad')),
      );
      mapWatch.addMarker(
        Marker(
            markerId: const MarkerId('2'),
            draggable: true,
            onDragEnd: (newPosition) {
              mapWatch.markerPosition2 = newPosition;
              mapWatch.setPolyline();
            },
            position: mapWatch.markerPosition2,
            infoWindow: const InfoWindow(title: 'pasodara')),
      );

      mapWatch.addMarker(
        Marker(
          markerId: const MarkerId('4'),
          position: const LatLng(21.4645, 70.4579),
          infoWindow: const InfoWindow(title: 'Girnar'),
          icon: await mapWatch.getMarkerIcon(
              'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2940&q=80'),
        ),
      );

      /// polyline route of bus
      mapWatch.setPolyline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapWatch = ref.watch(mapProvider);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: mapWatch.cameraPosition,
        mapType: MapType.normal,
        markers: Set.of(mapWatch.markers),
        polylines: mapWatch.polylines,
        onMapCreated: (controller) {
          mapWatch.controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mapWatch.setCurrentPosition(),
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
