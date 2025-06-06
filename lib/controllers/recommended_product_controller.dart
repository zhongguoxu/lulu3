import 'dart:convert';

import 'package:get/get.dart';
import 'package:lulu3/models/products_model.dart';
import '../data/repository/recommended_product_repo.dart';
import 'package:http/http.dart' as http;

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;
  RecommendedProductController({required this.recommendedProductRepo});
  List<dynamic> _recommendedProductList = []; // underscore means private variable
  List<dynamic> get recommendedProductList => _recommendedProductList;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  Future<void> getRecommendedProductList() async {
    _isLoaded = false;
    http.Response response = await recommendedProductRepo.getRecommendedProductList();
    if (response.statusCode==200) { // most http call return 200 for successful response
      try {
        _recommendedProductList = [];
        _recommendedProductList.addAll(Product.fromJson(jsonDecode(response.body)).products);
      } catch (e) {
        _recommendedProductList = [];
      }
      _isLoaded = true;
      update();
    } else {
      _recommendedProductList = [];
      _isLoaded = true;
      update();
    }
  }
}