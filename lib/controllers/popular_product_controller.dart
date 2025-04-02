import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/data/repository/popular_product_repo.dart';
import 'package:lulu3/models/cart_model.dart';
import 'package:lulu3/models/products_model.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:http/http.dart' as http;

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});
  List<dynamic> _popularProductList = []; // underscore means private variable
  List<dynamic> get popularProductList => _popularProductList;
  late CartController _cartController;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  int _quantity=0;
  int get quantity=>_quantity;
  int _inCartItems=0;
  int get inCartItems=>_inCartItems+_quantity;
  Future<void> getPopularProductList() async {
    http.Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode==200) { // most http call return 200 for successful response
      _popularProductList = [];
      _popularProductList.addAll(Product.fromJson(jsonDecode(response.body)).products);
      // _popularProductList.addAll(ProductModel.fromJson(jsonDecode(response.body)));
      _isLoaded = true;
      update();
    } else {

    }
  }

  void setQuantity(bool isIncrement) {
    if(isIncrement) {
      _quantity = checkQuantity(_quantity+1);
    } else {
      _quantity = checkQuantity(_quantity-1);
    }
    update();
  }
  int checkQuantity(int quantity) {
    if(quantity+_inCartItems<0){
      Get.snackbar("Item count", "You can't reduce more!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      if (_inCartItems>0) {
        _quantity=-_inCartItems;
        return _quantity;
      }
      return 0;
    } else if (quantity+_inCartItems>20) {
      Get.snackbar("Item count", "You can't add more!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(CartController cartController, ProductModel product) {
    _quantity=0;
    _inCartItems=0;
    // get from storage _inCartItems
    _cartController=cartController;
    var exist = false;
    exist = _cartController.existInCart(product);
    if (exist) {
      _inCartItems=_cartController.getQuantity(product);
    }

  }

  void addItem(ProductModel product) {
      _cartController.addItem(product, _quantity);
      _quantity=0;
      _inCartItems=_cartController.getQuantity(product);
      update();
  }

  int get totalItems {
    return _cartController.totalItems;
  }

  List<CartModel> get getItems {
    return _cartController.getItems;
  }
}