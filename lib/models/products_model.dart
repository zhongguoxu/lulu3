class Product {
  // int? _totalSize;
  // int? _typeId;
  // int? _offset;
  late List<ProductModel> _products;
  List<ProductModel> get products=>_products; // for public use

  Product({required products}) {
  // Product({required totalSize, required typeId, required offset, required products}) {
    // this._totalSize = totalSize;
    // this._typeId = typeId;
    // this._offset = offset;
    this._products = products;
  }

  Product.fromJson(List<dynamic> json) {
    _products = <ProductModel>[];
    json.forEach((v) {
      _products.add(new ProductModel.fromJson(v));
    });
  }

  // Product.fromJson(Map<String, dynamic> json) {
  //   // _totalSize=json['total_size'];
  //   // _typeId=json['type_id'];
  //   // _offset=json['offset'];
  //   if (json['products'] != null) {
  //     _products = <ProductModel>[];
  //     json['products'].forEach((v) {
  //       _products.add(new ProductModel.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String,dynamic>();
  //   data['total_size'] = this.totalSize;
  //   data['type_id'] = this.typeId;
  //   data['offset'] = this.offset;
  //   if (this.products != null) {
  //     data['products'] = this.products!.map((e) => e.toJson()).toList();
  //   }
  //   return data;
  // }
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  double? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;
  double? originalPrice;
  double? envFee;
  double? serviceFee;
  String ? subName;
  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stars,
    this.img,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.typeId,
    this.originalPrice,
    this.envFee,
    this.serviceFee,
    this.subName,
  });
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    description = json['description'];
    price = double.parse(json['price'].toString());
    stars = int.parse(json['stars'].toString());
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = int.parse(json['type_id'].toString());
    originalPrice = double.parse(json['original_price'].toString());
    envFee = double.parse(json['env_fee'].toString());
    serviceFee = double.parse(json['service_fee'].toString());
    subName = json['sub_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['stars'] = this.stars;
    data['img'] = this.img;
    data['location'] = this.location;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type_id'] = this.typeId;
    data['original_price'] = this.originalPrice;
    data['env_fee'] = this.envFee;
    data['service_fee'] = this.serviceFee;
    data['sub_name'] = this.subName;
    return data;
  }
}