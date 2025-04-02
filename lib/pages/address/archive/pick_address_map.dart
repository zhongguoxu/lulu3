// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lulu/base/custom_button.dart';
// import 'package:lulu/controllers/location_controller.dart';
// import 'package:lulu/pages/address/widgets/search_location_page.dart';
// import 'package:lulu/routes/route_helper.dart';
// import 'package:lulu/utils/app_constants.dart';
// import 'package:lulu/utils/colors.dart';
// import 'package:lulu/utils/dimensions.dart';
//
// class PickAddressMap extends StatefulWidget {
//   final bool fromSignup;
//   final bool fromAddress;
//   final  GoogleMapController? googleMapController;
//   const PickAddressMap({Key? key, required this.fromSignup, required this.fromAddress, this.googleMapController}) : super(key: key);
//
//   @override
//   _PickAddressMapState createState() => _PickAddressMapState();
// }
//
// class _PickAddressMapState extends State<PickAddressMap> {
//   late LatLng _initialPosition;
//   late GoogleMapController _mapController;
//   late CameraPosition _cameraPosition;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (Get.find<LocationController>().addressList.isEmpty) {
//       _initialPosition = LatLng(53.5461,-113.4937);
//       _cameraPosition = CameraPosition(target: _initialPosition, zoom: AppConstants.ZOOM_IN);
//     } else {
//       if (Get.find<LocationController>().addressList.isNotEmpty) {
//         _initialPosition = LatLng(
//             double.parse(Get.find<LocationController>().getAddress["latitude"]),
//             double.parse(Get.find<LocationController>().getAddress["longitude"])
//         );
//         _cameraPosition = CameraPosition(target: _initialPosition, zoom: AppConstants.ZOOM_IN);
//       }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LocationController>(builder: (locationController) {
//       return Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: SizedBox(
//               width: double.maxFinite,
//               child: Stack(
//                 children: [
//                   GoogleMap(initialCameraPosition:
//                   CameraPosition(
//                       target: _initialPosition, zoom: AppConstants.ZOOM_IN
//                   ),
//                     zoomControlsEnabled: false,
//                     onCameraMove: (CameraPosition cameraPosition) {
//                       _cameraPosition = cameraPosition;
//                     },
//                     onCameraIdle: () {
//                       Get.find<LocationController>().updatePosition(_cameraPosition, false);
//                     },
//                     onMapCreated: (GoogleMapController mapController) {
//                       _mapController = mapController;
//
//                     },
//                   ),
//                   Center(
//                     // child: Image.asset("assets/image/pick_marker.png", height: 50, width: 50,),
//                     child: !locationController.loading ?
//                     Image.asset("assets/image/pick_marker.png", height: 50, width: 50,) :
//                     CircularProgressIndicator(),
//                   ),
//                   /*
//                   show and select addresses
//                    */
//                   Positioned(
//                     top: Dimensions.height45,
//                     left: Dimensions.width20,
//                     right: Dimensions.width20,
//                     child: InkWell(
//                       onTap: () => Get.dialog(LocationDialogue(mapController: _mapController)),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: AppColors.mainColor,
//                           borderRadius: BorderRadius.circular(Dimensions.radius20/2),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.location_on, size: 25,color: AppColors.yellowColor,),
//                             Expanded(
//                               child: Text('${locationController.pickPlaceMark.name??''}', style: TextStyle(color: Colors.white, fontSize: Dimensions.font16),maxLines: 1, overflow: TextOverflow.ellipsis, ),
//
//                             ),
//                             SizedBox(width: Dimensions.width10,),
//                             Icon(Icons.search, size: 25, color: AppColors.yellowColor,),
//                           ],
//                         ),
//                       ),
//                     )
//                   ),
//                   Positioned(
//                     bottom: 80,
//                     left: Dimensions.width20,
//                     right: Dimensions.width20,
//                     child: locationController.isLoading ? Center(child: CircularProgressIndicator(),) : CustomButton(
//                       buttonText: locationController.inZone ? (widget.fromAddress ? "Pick Address" : "Pick Location") : "Service is not available in your area",
//                       onPressed: (locationController.buttonDisable || locationController.loading) ? null : () {
//                         if(locationController.pickPosition.latitude!=0&&locationController.pickPlaceMark.name!=null) {
//                           if(widget.fromAddress) {
//                             if(widget.googleMapController!=null) {
//                               print("Now you can click on this");
//                               widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target:
//                               LatLng(locationController.pickPosition.latitude,locationController.pickPosition.longitude))));
//                               locationController.setAddAddressData();
//                             }
//                             //Get.back() creates update problem
//                             Get.toNamed(RouteHelper.getAddressPage());
//                           }
//                         }
//                       },
//                     )
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
