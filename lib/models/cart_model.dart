import 'package:lulu3/models/products_model.dart';

class CartModel {
  int? id;
  String? name;
  double? price;
  String? img;
  int? quantity;
  // bool? isExist;
  String? time;
  // ProductModel? product;
  double? envFee;
  double? serviceFee;
  double? originalPrice;
  CartModel({
    this.id,
    this.name,
    this.price,
    this.img,
    this.quantity,
    // this.isExist,
    this.time,
    // this.product,
    this.envFee,
    this.serviceFee,
    this.originalPrice,
  });
  CartModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    price = double.parse(json['price'].toString());
    img = json['img'];
    quantity = int.parse(json['quantity'].toString());
    // isExist = json['isExist'];
    time = json['time'];
    // product = ProductModel.fromJson(json['product']);
    envFee = double.parse(json['env_fee'].toString());
    serviceFee = double.parse(json['service_fee'].toString());
    originalPrice = double.parse(json['original_price'].toString());
  }
  Map<String, dynamic> toJson() {
    return {"id": this.id,
      "name": this.name,
      "price": this.price,
      "img": this.img,
      "quantity": this.quantity,
      // "isExist": this.isExist,
      "time": this.time,
      // "product": this.product!.toJson(),
      "env_fee": this.envFee,
      "service_fee": this.serviceFee,
      "original_price": this.originalPrice,
    };
  }
}