import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/pages/address/address_constants.dart';
import 'package:lulu3/pages/address/widgets/search_location_page.dart';

import '../../base/custom_button.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PickNewAddressMap extends StatefulWidget {
  const PickNewAddressMap({Key? key}) : super(key: key);

  @override
  _PickNewAddressMapState createState() => _PickNewAddressMapState();
}

class _PickNewAddressMapState extends State<PickNewAddressMap> {
  // late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(AddressConstants.lat, AddressConstants.lng);
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(AddressConstants.lat, AddressConstants.lng), zoom: AddressConstants.zoom_in);
  TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;
  String _selectedAddress = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Get.find<UserController>().addressList.isEmpty) {
      print("zack default value");
      _addressController.text = AddressConstants.address;
    } else {
      print("zack get value from server");
      _initialPosition = LatLng(double.parse(Get.find<UserController>().addressList.last.latitude), double.parse(Get.find<UserController>().addressList.last.longituge));
      _addressController.text = Get.find<UserController>().addressList.last.address;
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: AddressConstants.zoom_in);
    }

    // Get.find<UserController>().setCurrentAddress(_initialPosition.latitude, _initialPosition.longitude, _addressController.text);
    // Get.find<UserController>().setDynamicAddress(_initialPosition.latitude, _initialPosition.longitude, _addressController.text);
    // if (_mapController != null) {
    //   _mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //       target:
    //       LatLng(_initialPosition.latitude,_initialPosition.longitude),
    //       zoom: AddressConstants.zoom_in)));
    // }
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Google Map with Search")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // onTap: _searchPlace,
                // readOnly: true, // Prevent manual typing
                controller: TextEditingController(text: _selectedAddress),
                decoration: InputDecoration(
                  hintText: "Enter address",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
                onMapCreated: (controller) => _mapController = controller,
                markers: {
                  Marker(markerId: MarkerId("selected"), position: _initialPosition),
                },
                onCameraMove: (position) {
                  // Do nothing when moving the map
                },
              ),
            ),
          ],
        ),
      );
    // return Scaffold(
    //     body: SafeArea(
    //       child: Center(
    //         child: SizedBox(
    //           width: double.maxFinite,
    //           child: Stack(
    //             children: [
    //               GoogleMap(
    //                 initialCameraPosition: CameraPosition(
    //                     target: _initialPosition,
    //                     zoom: AddressConstants.zoom_in),
    //                 onMapCreated: (GoogleMapController mapController) {
    //                   _mapController = mapController;
    //                   // _mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //                   //     target:
    //                   //     _initialPosition,
    //                   //     zoom: AddressConstants.zoom_in)));
    //                 },
    //                 zoomControlsEnabled: false,
    //                 // onCameraMove: (CameraPosition cameraPosition) {
    //                 //   _cameraPosition=cameraPosition;
    //                 //   print("zack camera2 is moving " + cameraPosition.target.latitude.toString());
    //                 // },
    //                 // onCameraIdle: () {
    //                 //   print("zack camera2 stop moving " + _cameraPosition.target.latitude.toString() + ' ' +_initialPosition.longitude.toString());
    //                 //   Get.find<UserController>().updatePosition(_cameraPosition);
    //                 // },
    //               ),
    //               // Center(
    //               //   // child: Image.asset("assets/image/pick_marker.png", height: 50, width: 50,),
    //               //   child: Get.find<UserController>().isLoading ?
    //               //   Image.asset("assets/image/pick_marker.png", height: 50, width: 50,) :
    //               //   CircularProgressIndicator(),
    //               // ),
    //               // Positioned(
    //               //     top: Dimensions.height45,
    //               //     left: Dimensions.width20,
    //               //     right: Dimensions.width20,
    //               //     child: InkWell(
    //               //       // onTap: () => Get.dialog(LocationDialogue(mapController: _mapController)),
    //               //       child: Container(
    //               //         padding: EdgeInsets.symmetric(
    //               //             horizontal: Dimensions.width10),
    //               //         height: 50,
    //               //         decoration: BoxDecoration(
    //               //           color: AppColors.mainColor,
    //               //           borderRadius: BorderRadius.circular(
    //               //               Dimensions.radius20 / 2),
    //               //         ),
    //               //         child: Row(
    //               //           children: [
    //               //             Icon(Icons.location_on, size: 25,
    //               //               color: AppColors.yellowColor,),
    //               //             Expanded(
    //               //               child: Text(
    //               //                 // userController.dynamicAddress!.address,
    //               //                 "Here",
    //               //                 style: TextStyle(color: Colors.white, fontSize: Dimensions.font16),
    //               //                 maxLines: 1,
    //               //                 overflow: TextOverflow.ellipsis,
    //               //               ),
    //               //             ),
    //               //             SizedBox(width: Dimensions.width10,),
    //               //             Icon(Icons.search, size: 25,
    //               //               color: AppColors.yellowColor,),
    //               //           ],
    //               //         ),
    //               //       ),
    //               //     )
    //               // ),
    //               // Positioned(
    //               //     bottom: 80,
    //               //     left: Dimensions.width20,
    //               //     right: Dimensions.width20,
    //               //     child: Get.find<UserController>().isLoading ? Center(child: CircularProgressIndicator(),) : CustomButton(
    //               //       buttonText: AddressConstants.pick_new_address,
    //               //       onPressed: () {
    //               //         // if(widget.fromAddress) {
    //               //         //   widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //               //         //       target:
    //               //         //   LatLng(double.parse(userController.dynamicAddress!.latitude),double.parse(userController.dynamicAddress!.longituge)),
    //               //         //   zoom: AddressConstants.zoom_in)));
    //               //         //   // userController.setAddAddressData();
    //               //         //   userController.setUpdate(true);
    //               //         //   Get.back();
    //               //         // } else { // TODO: from signup
    //               //         //
    //               //         // }
    //               //       },
    //               //     )
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    // );
  }
}
