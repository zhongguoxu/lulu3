
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lulu3/data/repository/system_repo.dart';
import 'package:lulu3/models/product_type_model.dart';
import 'package:lulu3/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/models/system_model.dart';

class SystemController extends GetxController {
  final SystemRepo systemRepo;

  SystemController({required this.systemRepo});

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<SystemModel> _systemInfo = [];
  List<SystemModel> get systemInfo=>_systemInfo;

  // ProductTypeModel _productTypeModel = ProductTypeModel(
  //   id: 0,
  //   title: "",
  //   order: 0,
  //   description: ""
  // );
  // ProductTypeModel get productType=>_productTypeModel;
  List<ProductTypeModel> _productTypes = [];
  List<ProductTypeModel> get productTypes=>_productTypes;

  Future<void> getSystemInfo() async {
    http.Response response = await systemRepo.getSystemInfo();
    if (response.statusCode == 200) {
      _systemInfo = [];
      _systemInfo.addAll(SystemModelList.fromJson(jsonDecode(response.body)).systemModelList);
      _isLoaded = true;
      print("zack system info is ready: " + _systemInfo.toString());
      update();
    } else {

    }
  }

  Future<void> getProductType() async {
    http.Response response = await systemRepo.getProductType();
    if (response.statusCode == 200) {
      _productTypes = [];
      _productTypes.addAll(ProductTypes.fromJson(jsonDecode(response.body)).productTypes);
      _isLoaded = true;
      print("zack product type is ready: " + _productTypes.length.toString());
      update();
    } else {

    }
  }
}