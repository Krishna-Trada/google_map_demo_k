import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_place_api_demo_k/framework/controller/map_controller.dart';
import 'package:google_place_api_demo_k/framework/controller/polyline_controller.dart';
import 'address_controller.dart';

final addressProvider = ChangeNotifierProvider((ref) => AddressController());
final mapProvider = ChangeNotifierProvider((ref) => MapController());
final polylineProvider = ChangeNotifierProvider((ref) => PolylineController());
