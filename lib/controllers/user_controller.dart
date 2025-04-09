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
  }

  void setDynamicAddress(double lat, double lng, String address) {
    _dynamicAddress = AddressModel(addressType: "Home", latitude: lat.toString(), longitude: lng.toString(), address: address);
    update();
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "Unknown Location Found";
    http.Response response = await userRepo.getAddressFromGeocode(latLng);
    _address = jsonDecode(response.body)["results"][0]['formatted_address'].toString();
    return _address;
  }

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
    http.Response response = await userRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getUserAddressList(_userModel!.id);
      responseModel = ResponseModel(true, "Successful");
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

  setUpdateLoading(bool loading) {
    _isLoading=loading;
    update();
  }

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
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
    } else {
      responseModel = ResponseModel(false, "Login fails");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  saveUserAccount(UserModel userModel) async {
    userRepo.saveUserAccount(userModel);
    update();
  }

  Future<ResponseModel> updateCustomerId(String email, String customerId) async {
    http.Response response = await userRepo.updateCustomerId(email, customerId);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, "Update customer_id successfully");
    } else {
      responseModel = ResponseModel(false, "Fails to update customer_id");
    }
    return responseModel;
  }

  Future<ResponseModel> updatePayment(String email, String paymentId, String last4) async {
    _isLoading = true;
    update();
    http.Response response = await userRepo.updateCustomerPayment(email, paymentId, last4);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, "Update payment_method_id successfully");
    } else {
      responseModel = ResponseModel(false, "Fails to update customer_id");
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