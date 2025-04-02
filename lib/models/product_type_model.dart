class ProductTypes {
  // int? _totalSize;
  // int? _typeId;
  // int? _offset;
  late List<ProductTypeModel> _productTypes;
  List<ProductTypeModel> get productTypes=>_productTypes; // for public use

  ProductTypes({required productTypes}) {
    // Product({required totalSize, required typeId, required offset, required products}) {
    // this._totalSize = totalSize;
    // this._typeId = typeId;
    // this._offset = offset;
    this._productTypes = productTypes;
  }

  ProductTypes.fromJson(List<dynamic> json) {
    _productTypes = <ProductTypeModel>[];
    json.forEach((v) {
      _productTypes.add(new ProductTypeModel.fromJson(v));
    });
  }
}
class ProductTypeModel {
  int? id;
  String? title;
  int? order;
  String? description;
  String? img;
  ProductTypeModel({
    this.id,
    this.title,
    this.order,
    this.description,
    this.img,
  });
  ProductTypeModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    title = json['title'];
    order = int.parse(json['order'].toString());
    description = json['description'];
    img = json['img'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['order'] = this.order;
    data['description'] = this.description;
    data['img'] = this.img;
    return data;
  }
}