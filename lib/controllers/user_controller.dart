import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lulu3/data/repository/user_repo.dart';
import 'package:lulu3/models/response_model.dart';
import 'package:lulu3/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/pages/address/address_constants.dart';

import '../models/address_model.dart';
import 'package:google_maps_webservice/src/places.dart';

import '../models/signup_body_model.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({
    required this.userRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _finishLoadingAddressList = false;
  bool get finishLoadingAddressList => _finishLoadingAddressList;
  bool _saveNewAddress = false;
  bool get saveNewAddress => _saveNewAddress;

  // bool _updateAddress = false;
  // bool get updateAddress => _updateAddress;
  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList=>_addressList;
  AddressModel? _currentAddress;
  AddressModel? get currentAddress=>_currentAddress;
  AddressModel? _dynamicAddress;
  AddressModel? get dynamicAddress=>_dynamicAddress;

  List<Prediction> _predictionList = [];

  Future<ResponseModel> getUserInfo() async {
    http.Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(jsonDecode(response.body));
      _isLoading = true;
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, "get user info fails");
    }
    update();
    return responseModel;
  }

  Future<void> getUserAddressList(String userId) async {
    print("zack get user address list from user controller: ");
    http.Response response = await userRepo.getUserAddresses(userId);
    if (response.statusCode == 200) {
      _addressList = [];
      _addressList.addAll(AddressList.fromJson(jsonDecode(response.body)).addresses);
      if (_addressList.isNotEmpty) {
        AddressModel lastAddress = _addressList.last;
        setDynamicAddress(double.parse(lastAddress.latitude), double.parse(lastAddress.longituge), lastAddress.address);
      }
    } else {
      _addressList = [];
    }
    _finishLoadingAddressList = true;
    update();
  }
  //
  void setCurrentAddress(double lat, double lng, String address) {
    _currentAddress = AddressModel(addressType: "Home", latitude: lat.toString(), longitude: lng.toString(), address: address);
    update();
    print('zack test output: '+_currentAddress!.address);
    print(currentAddress.toString());
  }

  void setDynamicAddress(double lat, double lng, String address) {
    _dynamicAddress = AddressModel(addressType: "Home", latitude: lat.toString(), longitude: lng.toString(), address: address);
    update();
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    // print("location controller @ getAddressFromGeocode");
    String _address = "Unknown Location Found";
    http.Response response = await userRepo.getAddressFromGeocode(latLng);
    // if(response.body =='OK') {
    _address = jsonDecode(response.body)["results"][0]['formatted_address'].toString();
    // }
    return _address;
  }

  // void updatePosition(CameraPosition position) async {
  //   try {
  //     print("zack update position " +position.target.latitude.toString() + ' ' + position.target.longitude.toString());
  //     String _address = await getAddressFromGeocode(
  //         LatLng(position.target.latitude, position.target.longitude)
  //     );
  //     // setCurrentAddress(position.target.latitude, position.target.longitude, _address);
  //     setDynamicAddress(position.target.latitude, position.target.longitude, _address);
  //     print("zack update position " +_address);
  //   } catch (e) {
  //     print(e);
  //     // setCurrentAddress(AddressConstants.lat, AddressConstants.lng, AddressConstants.unknown_address);
  //   }
  //   update();
  // }

  Future<void> setLocationByHttp(String placeID, String address, GoogleMapController mapController) async {
    PlacesDetailsResponse detail;
    http.Response response = await userRepo.setLocationByHttp(placeID);
    detail = PlacesDetailsResponse.fromJson(jsonDecode(response.body));

    // setCurrentAddress(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng, address);
    setDynamicAddress(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng, address);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(
          detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng,
        ), zoom: AddressConstants.zoom_in)
    ));
    update();
    print("zack update address");
    print(_dynamicAddress!.address);
  }

  Future<List<Prediction>> searchLocationByHttp(String text) async {
    if (text.isNotEmpty) {
      http.Response response = await userRepo.searchLocationByHttp(text);
      if (response.statusCode == 200) {
        _predictionList=[];
        //Part 5: 42:35
        var jd = jsonDecode(response.body);
        jd['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
        return _predictionList;
      }
    }
    return [];
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    // print("location controller @ addAddress");
    http.Response response = await userRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getUserAddressList(_userModel!.id);
      // String message = response.body
      responseModel = ResponseModel(true, "Successful");
      // await saveUserAddress(addressModel);
      _addressList.add(addressModel);
    } else {
      // print("couldn't save the address");
      responseModel = ResponseModel(false, "Fail");
    }
    setUpdate(false);
    update();
    return responseModel;
  }

  // Future<bool> saveUserAddress(AddressModel addressModel) async {
  //   String userAddress = jsonEncode(addressModel.toJson());
  //   return await userRepo.saveUserAddress(userAddress);
  // }

  // AddressModel getUserAddress() {
  //   // print("location controller @ getUserAddress");
  //   late AddressModel _addressModel;
  //   // _getAddress = jsonDecode(userRepo.getUserAddress());
  //   try {
  //     _addressModel = AddressModel.fromJson(jsonDecode(userRepo.getUserAddress()));
  //   } catch (e) {
  //     print(e);
  //   }
  //   return _addressModel;
  // }

  setUpdate(bool updateAddress) {
    // _updateAddress=updateAddress;
    _saveNewAddress=updateAddress;
    update();
  }

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    http.Response response = await userRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      userRepo.saveUserAccount(UserModel.fromJson(jsonDecode(response.body)));
      _userModel = UserModel.fromJson(jsonDecode(response.body));
      responseModel = ResponseModel(true, "Registration successfully");
      print("registration successfully");
    } else {
      responseModel = ResponseModel(false, "Registration fails");
      print("registration fails");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    http.Response response = await userRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      userRepo.saveUserAccount(UserModel.fromJson(jsonDecode(response.body)));
      _userModel = UserModel.fromJson(jsonDecode(response.body));
      responseModel = ResponseModel(true, "Login successfully");
      print("login successfully");
    } else {
      responseModel = ResponseModel(false, "Login fails");
      print("login fails");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool userHasLoggedIn() {
    return userRepo.userHasLoggedIn();
  }

  bool clearSharedData() {
    userRepo.clearSharedData();
    return true;
  }

  UserModel? getUserModelFromLocal() {
    return userRepo.getUserAccount();
  }
}