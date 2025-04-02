import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:lulu3/utils/app_constants.dart';

import '../../models/cart_model.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<String> cart=[];
  List<String> cartHistory=[];
  void addToCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    // sharedPreferences.remove(AppConstants.CART_LIST);
    var time = DateTime.now().toString();
    cart = [];
    cartList.forEach((element)  {
      element.time = time;
      return cart.add(jsonEncode(element));
    });

    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    // print(sharedPreferences.getStringList(AppConstants.CART_LIST));
    // getCartList();
  }

  void addToCartHistoryList() {
    cartHistory = [];
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    cart = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      cart = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
    }
    for(int i=0;i<cart.length;i++) {
      cartHistory.add(cart[i]);
    }
    sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistory);
  }
  
  List<CartModel> getCartList () {
    List<String> carts=[];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
    }
    List<CartModel> cartList = [];
    carts.forEach((element) => cartList.add(CartModel.fromJson(jsonDecode(element))));
    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory=[];
      cartHistory=sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    List<CartModel> cartListHistory = [];
    cartHistory.forEach((element)=>cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }

  // void removeCart() {
  //   cart = [];
  //   sharedPreferences.remove(AppConstants.CART_LIST);
  // }
  void clearCartHistory() {
    cartHistory=[];
    try {
      sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    } on Exception catch (_) {

    }
  }

  void clearCart() {
    cart = [];
    try {
      sharedPreferences.remove(AppConstants.CART_LIST);
    } on Exception catch (_) {

    }
  }
}