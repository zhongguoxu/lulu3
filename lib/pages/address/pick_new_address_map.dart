import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/models/address_model.dart';
import 'package:lulu3/pages/address/address_constants.dart';
import 'package:lulu3/pages/address/widgets/search_location_page.dart';
import 'package:lulu3/routes/route_helper.dart';

import '../../base/custom_button.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PickNewAddressMap extends StatefulWidget {
  const PickNewAddressMap({Key? key}) : super(key: key);

  @override
  _PickNewAddressMapState createState() => _PickNewAddressMapState();
}

class _PickNewAddressMapState extends State<PickNewAddressMap> {
  LatLng _initialPosition = LatLng(AddressConstants.lat, AddressConstants.lng);
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(AddressConstants.lat, AddressConstants.lng), zoom: AddressConstants.zoom_in);
  TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;

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
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: AddressConstants.zoom_in),
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      // _mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      //     target:
                      //     _initialPosition,
                      //     zoom: AddressConstants.zoom_in)));
                    },
                    // markers: {
                    //   Marker(markerId: MarkerId("selected"), position: _initialPosition),
                    // },
                    zoomControlsEnabled: false,
                    // onCameraMove: (CameraPosition cameraPosition) {
                    //   _cameraPosition=cameraPosition;
                    //   print("zack camera2 is moving " + cameraPosition.target.latitude.toString());
                    // },
                    // onCameraIdle: () {
                    // print("zack camera2 stop moving " + _cameraPosition.target.latitude.toString() + ' ' +_initialPosition.longitude.toString());
                    // Get.find<UserController>().updatePosition(_cameraPosition);
                    // },
                  ),
                  Center(
                      child: Image.asset("assets/image/pick_marker.png", height: 50, width: 50,)
                  ),
                  Positioned(
                      top: Dimensions.height45,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: InkWell(
                        onTap: () {
                          if (_mapController != null) {
                            Get.dialog(LocationDialogue(mapController: _mapController!));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.radius20 / 2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 25,
                                color: AppColors.yellowColor,),
                              Expanded(
                                child: Text(
                                  userController.dynamicAddress == null ? "Search address" : userController.dynamicAddress!.address,
                                  style: TextStyle(color: Colors.white, fontSize: Dimensions.font16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: Dimensions.width10,),
                              Icon(Icons.search, size: 25,
                                color: AppColors.yellowColor,),
                            ],
                          ),
                        ),
                      )
                  ),
                  Positioned(
                      bottom: 80,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: userController.saveNewAddress ? Center(child: CircularProgressIndicator(),) : CustomButton(
                        buttonText: AddressConstants.pick_new_address,
                        onPressed: () {
                          userController.setUpdate(true);
                          AddressModel addressModel = AddressModel(
                            addressType: "Home",
                            contactPersonName: userController.userModel?.name,
                            contactPersonNumber: userController.userModel?.phone,
                            address: userController.dynamicAddress?.address,
                            latitude: userController.dynamicAddress?.latitude,
                            longitude: userController.dynamicAddress?.longituge,
                          );
                          if (userController.addressList.isNotEmpty && userController.addressList.last.address == addressModel.address) {
                            Get.offNamed(RouteHelper.getInitial());
                            userController.setUpdate(false);
                            // Get.back();
                          } else {
                            userController.addAddress(addressModel).then((value) {
                              if (value.isSuccess) {
                                // Get.back();
                                // Get.offNamed(RouteHelper.getInitial());
                                Get.snackbar("Address", "Added successfully");
                              } else {
                                Get.snackbar("Address", "Couldn't save address");
                              }
                            });
                            Get.offNamed(RouteHelper.getInitial());
                          }
                          // if(widget.fromAddress) {
                          //   widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          //       target:
                          //   LatLng(double.parse(userController.dynamicAddress!.latitude),double.parse(userController.dynamicAddress!.longituge)),
                          //   zoom: AddressConstants.zoom_in)));
                          //   // userController.setAddAddressData();
                          //   userController.setUpdate(true);
                          //   Get.back();
                          // } else { // TODO: from signup
                          //
                          // }
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
