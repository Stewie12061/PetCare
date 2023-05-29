import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geolocator;

import '../const.dart';
import '../utils/styles.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final LatLng _center = const LatLng(0, 0); // Update with desired coordinates

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkerFromAddress('828 Sư Vạn Hạnh, Phường 12, Quận 10, TP HCM');
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _addMarkerFromAddress(String address) async {
    try {
      final locations = await geocoding.locationFromAddress(address);
      final location = locations.first;
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('store_location'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: const InfoWindow(title: 'PetCare'),
          ),
        );
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 14.0,
            ),
          ),
        );
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Styles.highlightColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            ),
          ),
          title: Text(
            'Our Location',
            style: poppin.copyWith(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 0.0,
          ),
          markers: markers,
        ),
    );
  }
}
