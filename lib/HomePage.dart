import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(31.55460609999999, 74.35715809999999),
    zoom: 14.4746,
  );
  double lat = 0.0, lng = 0.0;
// on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];
  Position? position;
// created method for getting user current location
  getUserCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _kGoogle = CameraPosition(
      target: LatLng(position!.latitude, position!.longitude),
      zoom: 14.4746,
    );
    setState(() {
      _markers.clear();
      lat = position!.latitude;
      lng = position!.longitude;
      _markers.add(Marker(
        markerId: const MarkerId("2"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(
          title: 'My Current Location',
        ),
      ));
    });
  }

  @override
  void initState() {
    getUserCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // on below line creating google maps
        child: GoogleMap(
          initialCameraPosition: _kGoogle,
          markers: Set<Marker>.of(_markers),
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation();
          _markers.add(Marker(
            markerId: const MarkerId("2"),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(
              title: 'My Current Location',
            ),
          ));
          setState(() {});
        },
        child: const Icon(Icons.local_activity),
      ),
    );
  }
}
