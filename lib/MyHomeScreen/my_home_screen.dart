import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(53.42072414545633, -113.63240734162835),
    zoom: 14,
  );
  final List<Marker> myMarker = [];
  final List<Marker> markerList = [];
  final Marker myCurrentMarker = Marker(
    markerId: MarkerId("My home"), // this is just id, not text string shown
    position: LatLng(53.42072414545633, -113.63240734162835),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markerList.add(myCurrentMarker);
    myMarker.addAll(markerList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(53.42092874281874, -113.61833110840585),
              zoom: 14
            ),
          ));
        },
      ),
    );
  }
}
