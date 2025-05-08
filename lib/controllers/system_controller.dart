
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lulu3/data/repository/system_repo.dart';
import 'package:lulu3/models/product_type_model.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/models/system_model.dart';

class SystemController extends GetxController {
  final SystemRepo systemRepo;

  SystemController({required this.systemRepo});

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<SystemModel> _systemInfo = [];
  List<SystemModel> get systemInfo=>_systemInfo;
  List<ProductTypeModel> _productTypes = [];
  List<ProductTypeModel> get productTypes=>_productTypes;

  Future<void> getSystemInfo() async {
    _isLoaded = false;
    http.Response response = await systemRepo.getSystemInfo();
    if (response.statusCode == 200) {
      try {
        _systemInfo = [];
        _systemInfo.addAll(SystemModelList.fromJson(jsonDecode(response.body)).systemModelList);
      } catch (e) {
        _systemInfo = [];
      }
      _isLoaded = true;
      update();
    } else {
      _systemInfo = [];
      _isLoaded = true;
      update();
    }
  }

  Future<void> getProductType() async {
    _isLoaded = false;
    http.Response response = await systemRepo.getProductType();
    if (response.statusCode == 200) {
      try {
        _productTypes = [];
        _productTypes.addAll(ProductTypes.fromJson(jsonDecode(response.body)).productTypes);
      } catch (e) {
        _productTypes = [];
      }
      _isLoaded = true;
      update();
    } else {
      _productTypes = [];
      _isLoaded = true;
      update();
    }
  }
}