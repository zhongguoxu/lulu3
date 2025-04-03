// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lulu3/base/custom_app_bar.dart';
// import 'package:lulu3/controllers/user_controller.dart';
// import 'package:lulu3/pages/address/address_constants.dart';
// import 'package:lulu3/pages/address/pick_new_address_map.dart';
// import 'package:lulu3/routes/route_helper.dart';
// import 'package:lulu3/utils/app_constants.dart';
// import 'package:lulu3/utils/colors.dart';
// import 'package:lulu3/utils/dimensions.dart';
// import 'package:lulu3/widgets/app_text_field.dart';
// import 'package:lulu3/widgets/big_text.dart';
//
// import '../../models/address_model.dart';
//
// class AddNewAddressPage extends StatefulWidget {
//   const AddNewAddressPage({Key? key}) : super(key: key);
//
//   @override
//   _AddNewAddressPageState createState() => _AddNewAddressPageState();
// }
//
// class _AddNewAddressPageState extends State<AddNewAddressPage> {
//   TextEditingController _addressController = TextEditingController();
//   final TextEditingController _contactPersonName = TextEditingController();
//   final TextEditingController _contactPersonNumber = TextEditingController();
//   LatLng _initialPosition = LatLng(AddressConstants.lat, AddressConstants.lng);
//   CameraPosition _cameraPosition = CameraPosition(target: LatLng(AddressConstants.lat, AddressConstants.lng), zoom: AddressConstants.zoom_in);
//   GoogleMapController? _mapController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _contactPersonName.text=Get.find<UserController>().userModel!.name;
//     _contactPersonNumber.text=Get.find<UserController>().userModel!.phone;
//     Get.find<UserController>().getUserAddressList(Get.find<UserController>().userModel!.id).then((_) {
//       print("zack initialize address text");
//       if(Get.find<UserController>().addressList.isEmpty) {
//         print("zack default value");
//         _addressController.text = AddressConstants.address;
//       } else {
//         print("zack get value from server");
//         // _initialPosition = LatLng(double.parse(Get.find<UserController>().addressList.last.latitude), double.parse(Get.find<UserController>().addressList.last.longituge));
//         _addressController.text = Get.find<UserController>().addressList.last.address;
//         // _cameraPosition = CameraPosition(target: _initialPosition, zoom: AddressConstants.zoom_in);
//       }
//       // Get.find<UserController>().setCurrentAddress(_initialPosition.latitude, _initialPosition.longitude, _addressController.text);
//       // Get.find<UserController>().setDynamicAddress(_initialPosition.latitude, _initialPosition.longitude, _addressController.text);
//       // if (_mapController != null) {
//       //   _mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       //       target:
//       //       LatLng(_initialPosition.latitude,_initialPosition.longitude),
//       //       zoom: AddressConstants.zoom_in)));
//       // }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Address",
//       ),
//       body: GetBuilder<UserController>(builder: (userController) {
//         // you can change the value of the variables used in the widget
//         _addressController.text = userController.dynamicAddress?.address??AddressConstants.address;
//         print("zack get address text from build: "+_addressController.text);
//         return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: Dimensions.height20*7,
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: 5,right: 5,top: 5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(
//                         width: 2,
//                         color: AppColors.mainColor,
//                       )
//                   ),
//                   child: Stack(
//                     children: [
//                       GoogleMap(
//                         initialCameraPosition: CameraPosition(target: _initialPosition, zoom: AddressConstants.zoom_in),
//                         onMapCreated: (GoogleMapController controller) {
//                           print("zack created the google map with: "+_initialPosition.latitude.toString());
//                           _mapController = controller;
//                           _mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//                               target:
//                               _initialPosition,
//                               zoom: AddressConstants.zoom_in)));
//                         },
//                         // onTap: (_) {
//                         //   Get.toNamed(
//                         //       RouteHelper.getPickAddressPage(),
//                         //       arguments: PickNewAddressMap(
//                         //         fromSignup: false,
//                         //         fromAddress: true,
//                         //         googleMapController: _mapController,//userController.mapController,
//                         //       )
//                         //   );
//                         // },
//                         zoomControlsEnabled: false,
//                         onCameraMove: (CameraPosition cameraPosition) {
//                           print("zack camera is moving " + cameraPosition.target.latitude.toString());
//                           _cameraPosition=cameraPosition;
//                           },
//                         onCameraIdle: () {
//                           print("zack camera stop moving " + _cameraPosition.target.latitude.toString() + ' ' +_initialPosition.longitude.toString());
//                           if (userController.updateAddress) { // this branch is used to update the delivery address when the address in Pick page changes.
//                             userController.updatePosition(CameraPosition(target: LatLng(double.parse(userController.dynamicAddress!.latitude), double.parse(userController.dynamicAddress!.longituge)), zoom: AddressConstants.zoom_in));
//                             userController.setUpdate(false);
//                           } else {
//                             userController.updatePosition(_cameraPosition);
//                           }
//                         },
//                       ),
//                       Center(
//                         // child: Image.asset("assets/image/pick_marker.png", height: 50, width: 50,),
//                         child: !userController.isLoading ?
//                         Image.asset("assets/image/pick_marker.png", height: 50, width: 50,) :
//                         CircularProgressIndicator(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: Dimensions.height15,),
//                 Padding(
//                   padding: EdgeInsets.only(left: Dimensions.width20),
//                   child: BigText(text: "Delivery Address"),
//                 ),
//                 SizedBox(height: Dimensions.height10,),
//                 AppTextField(textController: _addressController, hintText: "Your address", icon: Icons.map),
//                 SizedBox(height: Dimensions.height15,),
//                 Padding(
//                   padding: EdgeInsets.only(left: Dimensions.width20),
//                   child: BigText(text: "Contact me"),
//                 ),
//                 SizedBox(height: Dimensions.height10,),
//                 AppTextField(textController: _contactPersonName, hintText: "Your name", icon: Icons.person),
//                 SizedBox(height: Dimensions.height15,),
//                 Padding(
//                   padding: EdgeInsets.only(left: Dimensions.width20),
//                   child: BigText(text: "Your number"),
//                 ),
//                 SizedBox(height: Dimensions.height10,),
//                 AppTextField(textController: _contactPersonNumber, hintText: "Your phone", icon: Icons.phone),
//               ],
//             ),
//           );
//       }),
//       bottomNavigationBar: GetBuilder<UserController> (builder: (userController) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: Dimensions.height20*5,
//               padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10, left: Dimensions.width10, right: Dimensions.width10),
//               decoration: BoxDecoration(
//                   color: AppColors.buttonBackgroundColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(Dimensions.radius20*2),
//                     topRight: Radius.circular(Dimensions.radius20*2),
//                   )
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // controller.addItem(product);
//                       AddressModel _addressModel = AddressModel(
//                         addressType: "Home",
//                         contactPersonName: _contactPersonName.text,
//                         contactPersonNumber: _contactPersonNumber.text,
//                         address: _addressController.text,
//                         latitude: userController.dynamicAddress?.latitude,
//                         longitude: userController.dynamicAddress?.longituge,
//                       );
//                       if (userController.addressList.isNotEmpty && userController.addressList.last.address == _addressController.text) {
//                         Get.offNamed(RouteHelper.getInitial());
//                       } else {
//                         userController.addAddress(_addressModel).then((value) {
//                           if (value.isSuccess) {
//                             // Get.back();
//                             Get.offNamed(RouteHelper.getInitial());
//                             Get.snackbar("Address", "Added successfully");
//                           } else {
//                             Get.snackbar("Address", "Couldn't save address");
//                           }
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
//                       child: BigText(text: "Save address", color: Colors.white, size: 20,),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(Dimensions.radius20),
//                         color: AppColors.mainColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
//
