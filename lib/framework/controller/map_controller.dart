import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class MapController extends ChangeNotifier {
  /// controller
  Completer<GoogleMapController> controller = Completer();

  /// api key
  String googleAPiKey = 'AIzaSyCtumA5CYFBJ9oy9zUJhDjQ781SfiP9k0c';

  /// this is for camera position
  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(23.0225, 72.5714), zoom: 8);

  /// new position
  LatLng markerPosition1 = const LatLng(23.0250, 72.5744);
  LatLng markerPosition2 = const LatLng(21.1679, 72.7883);

  /// for markers
  List<Marker> markers = [];

  /// set polyline on drag of marker
  Future<void> setPolyline() async {
    addPolyline(
      Polyline(
          polylineId: const PolylineId('bus route polyline'),
          points: await getRoutePolyline(
          markerPosition1.latitude, markerPosition1.longitude, markerPosition2.latitude, markerPosition2.longitude),
      width: 5,
      color: Colors.red,
      visible: true,
    ),
    );
  }

  /// for polyline
  late Set<Polyline> polylines = {Polyline(polylineId: const PolylineId('1'),visible: true, points: coordinates, color: Colors.cyan, width: 3)};
  final List<LatLng> coordinates = [
    const LatLng(23.0250, 72.5744),
    const LatLng(22.9952, 72.6321),
    const LatLng(22.3135, 73.1810),
    const LatLng(21.7314, 73.0282),
    const LatLng( 21.6274549, 72.9997237),
    const LatLng(21.269190,  72.958649),
  ];


  /// add marker
  void addMarker(Marker marker){
    markers.add(marker);
    notifyListeners();
  }

  /// add polyline
  void addPolyline(Polyline polyline){
    polylines.add(polyline);
    notifyListeners();
  }





  /// to change camera position
  void changeCameraPosition(LatLng? latLng) async {
    GoogleMapController googleMapController = await controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: latLng ?? const LatLng(21.4645, 70.4579), zoom: 12)));
    notifyListeners();
  }

  /// to get current location
  Future<Position> getCurrentPosition() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('Error.......................................................$error');
    });
    return await Geolocator.getCurrentPosition();
  }

  /// set camera position to current location
  void setCurrentPosition() {
    getCurrentPosition().then((value) {
      LatLng latLng = LatLng(value.latitude, value.longitude);
      markers.add(Marker(
          markerId: const MarkerId('current location'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Current Location')));
      changeCameraPosition(latLng);
    });
    notifyListeners();
  }

  /// draw polyline from start ans end point
  Future<List<LatLng>> getRoutePolyline(double originLatitude, double originLongitude, double destLatitude, double destLongitude) async{
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(originLatitude, originLongitude),
        PointLatLng(destLatitude, destLongitude),
        travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );
    debugPrint('result got');
    debugPrint(result.errorMessage);

    if (result.points.isNotEmpty) {
      debugPrint('points not empty');
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      debugPrint(polylineCoordinates.toString());
    }
    else{
      debugPrint(result.errorMessage);
      debugPrint('Could not get route');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Your origin and destination is not valid'))
      // );
    }

    return polylineCoordinates;
  }

  /// -------------------------- custom marker from image url in marker -------------------------- ///
  late BitmapDescriptor customIcon;

  Future<BitmapDescriptor> createCustomMarkerBitmapWithImage(String imagePath, Size size) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    /// Add shadow circle
    Paint circle = Paint()..style=PaintingStyle.fill;
    circle.color = Colors.red.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width*0.5,size.height*0.5),size.width*0.4,circle);

    ///* Do your painting of the custom icon here, including drawing text, shapes, etc. */
    Rect oval = Rect.fromCircle(center: Offset(size.width*0.5,size.height*0.5), radius: size.width*0.35 );

    /// ADD  PATH TO OVAL IMAGE
    canvas.clipPath(Path()..addOval(oval));

    ui.Image image = await getImageFromPath(imagePath);
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fill);

    ui.Picture p = recorder.endRecording();
    ByteData? pngBytes = await (await p.toImage(300, 300))
        .toByteData(format: ui.ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes!.buffer);

    return BitmapDescriptor.fromBytes(data);
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = File(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String image) async {
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(image);
      Size s = const Size(220, 220);

      var icon = await createCustomMarkerBitmapWithImage(
          markerImageFile.path, s);

      return icon;
    }
}
