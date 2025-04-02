// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lulu/data/api/api_checker.dart';
// import 'package:lulu/data/repository/location_repo.dart';
// import 'package:lulu/models/address_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:lulu/models/response_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator_platform_interface/src/models/position.dart';
// import 'package:lulu/pages/address/address_constants.dart';
// import '../models/address_model.dart';
// import 'package:google_maps_webservice/src/places.dart';
//
// class LocationController extends GetxController implements GetxService {
//   LocationRepo locationRepo;
//   LocationController({required this.locationRepo});
//
//   bool _loading = false;
//   bool get loading=>_loading;
//   bool _isLoading = false; // for service zone
//   bool get isLoading=>_isLoading;
//   bool _inZone = true;
//   bool get inZone=>_inZone;
//   bool _buttonDisable = false; // change this to true when you activate getZone function
//   bool get buttonDisable=>_buttonDisable;
//
//   late Position _position;
//   late Position _pickPosition;
//   Position get position=>_position;
//   Position get pickPosition=>_pickPosition;
//   Placemark _placemark = Placemark();
//   Placemark _pickPlaceMark = Placemark();
//   Placemark get placemark=>_placemark;
//   Placemark get pickPlaceMark=>_pickPlaceMark;
//   late GoogleMapController _mapController;
//   GoogleMapController get mapController=>_mapController;
//
//   List<AddressModel> _addressList = [];
//   List<AddressModel> get addressList=>_addressList;
//   late List<AddressModel> _allAddressList;
//   List<AddressModel> get allAddressList=>_addressList;
//   List<String> _addressType=["home","office","others"];
//   List<String> get addressTypeList => _addressType;
//   int _addressTypeIndex=0;
//   int get addressTypeIndex=>_addressTypeIndex;
//   bool _updateAddressData = true;
//   bool _changeAddress = true;
//
//   List<Prediction> _predictionList = [];
//
//   void setMapController(GoogleMapController mapController) {
//     // print("location controller @ setMapController");
//     _mapController = mapController;
//   }
//
//   void updatePosition(CameraPosition position, bool fromAddress) async {
//     // print("location controller @ updatePosition");
//     if (_updateAddressData) {
//       _loading = true;
//       update();
//       try {
//         if (fromAddress) {
//           _position=Position(
//               longitude: position.target.longitude,
//               latitude: position.target.latitude,
//               timestamp: DateTime.now(),
//               accuracy: 1,
//               altitude: 1,
//               heading: 1,
//               speed: 1,
//               speedAccuracy: 1,
//               altitudeAccuracy: 1,
//               headingAccuracy: 1,
//           );
//         } else {
//           _pickPosition=Position(
//             longitude: position.target.longitude,
//             latitude: position.target.latitude,
//             timestamp: DateTime.now(),
//             accuracy: 1,
//             altitude: 1,
//             heading: 1,
//             speed: 1,
//             speedAccuracy: 1,
//             altitudeAccuracy: 1,
//             headingAccuracy: 1,
//           );
//         }
//         // ResponseModel _responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), false);
//         // // if button is false, we are in the service area
//         // _buttonDisable=!_responseModel.isSuccess;
//         if (_changeAddress) {
//           String _address = await getAddressFromGeocode(
//             LatLng(position.target.latitude, position.target.longitude)
//           );
//           // print("placemark from address");
//           fromAddress ? _placemark=Placemark(name: _address) : _pickPlaceMark=Placemark(name: _address);
//         }
//       } catch (e) {
//         print(e);
//       }
//
//       _loading = false;
//       update();
//     } else {
//       _updateAddressData=true;
//     }
//   }
//
//   Future<String> getAddressFromGeocode(LatLng latLng) async {
//     // print("location controller @ getAddressFromGeocode");
//     String _address = "Unknown Location Found";
//     http.Response response = await locationRepo.getAddressFromGeocode(latLng);
//     // if(response.body =='OK') {
//     _address = jsonDecode(response.body)["results"][0]['formatted_address'].toString();
//     // } else {
//     //   print("Error geting the google api");
//     // }
//     return _address;
//   }
//
//   late Map<String, dynamic> _getAddress;
//   Map get getAddress=>_getAddress;
//
//   AddressModel getUserAddress() {
//     // print("location controller @ getUserAddress");
//     late AddressModel _addressModel;
//     _getAddress = jsonDecode(locationRepo.getuserAddress());
//     try {
//       _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getuserAddress()));
//     } catch (e) {
//       print(e);
//     }
//     return _addressModel;
//   }
//
//   void setAddressTypeIndex(int index) {
//     // print("location controller @ setAddressTypeIndex");
//     _addressTypeIndex = index;
//     update();
//   }
//
//   Future<ResponseModel> addAddress(AddressModel addressModel) async {
//     // print("location controller @ addAddress");
//     _loading = true;
//     update();
//     http.Response response = await locationRepo.addAddress(addressModel);
//     ResponseModel responseModel;
//     if (response.statusCode == 200) {
//       await getAddressList();
//       // String message = response.body
//       responseModel = ResponseModel(true, "Successful");
//       await saveUserAddress(addressModel);
//     } else {
//       // print("couldn't save the address");
//       responseModel = ResponseModel(false, "Fail");
//     }
//     _loading = false;
//     update();
//     return responseModel;
//   }
//
//   Future<void> getAddressList() async {
//     // print("location controller @ getAddressList");
//     http.Response response = await locationRepo.getAllAddress();
//     if (response.statusCode == 200) {
//       _addressList = [];
//       _allAddressList = [];
//       _addressList.addAll(AddressList.fromJson(jsonDecode(response.body)).addresses);
//       _allAddressList.addAll(AddressList.fromJson(jsonDecode(response.body)).addresses);
//     } else {
//       _addressList = [];
//       _allAddressList = [];
//     }
//     update();
//   }
//
//   Future<bool> saveUserAddress(AddressModel addressModel) async {
//     // print("location controller @ saveUserAddress");
//     String userAddress = jsonEncode(addressModel.toJson());
//     return await locationRepo.saveUserAddress(userAddress);
//   }
//
//   String getUserAddressFromLocalStorage() {
//     // print("location controller @ getUserAddressFromLocalStorage");
//     return locationRepo.getuserAddress();
//   }
//
//   setAddAddressData() {
//     // print("location controller @ setAddAddressData");
//     _position=_pickPosition;
//     _placemark=_pickPlaceMark;
//     _updateAddressData=false;
//     update();
//   }
//
//   Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
//     // print("location controller @ getZone : "+lat+' '+lng);
//     late ResponseModel _responseModel;
//     if (markerLoad) {
//       _loading = true;
//     } else {
//       _isLoading = true;
//     }
//     update();
//     // Response _response = await locationRepo.getZone(lat, lng);
//     // print('getZone response '+_response.toString());
//     // if (_response.statusCode == 200) {
//     //   _responseModel = ResponseModel(true, _response.body["zone_id"].toString());
//     //   _inZone = true;
//     // } else {
//     //   _responseModel = ResponseModel(true, _response.body["zone_id"].toString());
//     //   _inZone = false;
//     // }
//     _responseModel = ResponseModel(true, "1");
//     _inZone = true;
//     if (markerLoad) {
//       _loading = false;
//     } else {
//       _isLoading = false;
//     }
//     update();
//     return _responseModel;
//   }
//   // Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
//   //   print("location controller @ searchLocation");
//   //   if (text.isNotEmpty) {
//   //     Response response = await locationRepo.searchLocation(text);
//   //     if (response.statusCode == 200 && response.body['status']=='OK') {
//   //       _predictionList=[];
//   //       //Part 5: 42:35
//   //       response.body['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
//   //     } else {
//   //       // ApiChecker.checkApi(response);
//   //     }
//   //   }
//   //   // return _predictionList;
//   //   return [];
//   // }
//
//   Future<List<Prediction>> searchLocationByHttp(String text) async {
//     // print("location controller @ searchLocationByHttp");
//     if (text.isNotEmpty) {
//       http.Response response = await locationRepo.searchLocationByHttp(text);
//       if (response.statusCode == 200) {
//         _predictionList=[];
//         //Part 5: 42:35
//         var jd = jsonDecode(response.body);
//         jd['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
//         return _predictionList;
//       }
//     }
//     return [];
//   }
//
//   setLocationByHttp(String placeID, String address, GoogleMapController mapController) async {
//     _loading=true;
//     update();
//     PlacesDetailsResponse detail;
//     http.Response response = await locationRepo.setLocationByHttp(placeID);
//     detail = PlacesDetailsResponse.fromJson(jsonDecode(response.body));
//     _pickPosition = Position(
//       latitude: detail.result.geometry!.location.lat,
//       longitude: detail.result.geometry!.location.lng,
//       timestamp: DateTime.now(),
//       accuracy: 1,
//       altitude: 1,
//       heading: 1,
//       speed: 1,
//       speedAccuracy: 1,
//       altitudeAccuracy: 1,
//       headingAccuracy: 1,
//     );
//     _pickPlaceMark = Placemark(name: address);
//     _changeAddress = false;
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(target: LatLng(
//         detail.result.geometry!.location.lat,
//         detail.result.geometry!.location.lng,
//       ), zoom: AddressConstants.zoom_in)
//     ));
//     _loading = false;
//     update();
//   }
// }