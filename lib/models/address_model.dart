class AddressList {
  // int? _totalSize;
  // int? _typeId;
  // int? _offset;
  late List<AddressModel> _addresses;
  List<AddressModel> get addresses=>_addresses; // for public use

  AddressList({required addresses}) {
    // Product({required totalSize, required typeId, required offset, required products}) {
    // this._totalSize = totalSize;
    // this._typeId = typeId;
    // this._offset = offset;
    this._addresses = addresses;
  }

  AddressList.fromJson(List<dynamic> json) {
    _addresses = <AddressModel>[];
    json.forEach((v) {
      _addresses.add(new AddressModel.fromJson(v));
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
class AddressModel {
  late String? _id;
  late String _addressType;
  late String? _contactPersonName;
  late String? _contactPersonNumber;
  late String _address;
  late String _latitude;
  late String _longitude;
  String get latitude=>_latitude;
  String get longituge=>_longitude;

  AddressModel({
    id,
    required addressType,
    contactPersonName,
    contactPersonNumber,
    address,
    latitude,
    longitude,
  }){
    _id=id;
    _addressType = addressType;
    _contactPersonName=contactPersonName;
    _contactPersonNumber=contactPersonNumber;
    _address=address;
    _longitude=longitude;
    _latitude=latitude;
  }
  String get address=>_address;
  String get addressType=>_addressType;
  String? get contactPersonName=>_contactPersonName;
  String? get contactPersonNumber=>_contactPersonNumber;

  AddressModel.fromJson(Map<String, dynamic> json) {
    _id=json['id'];
    _addressType=json['address_type']??"";
    _contactPersonNumber=json['contact_person_number']??"";
    _contactPersonName=json['contact_person_name']??"";
    _address=json['address'];
    _latitude=json['latitude'];
    _longitude=json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['address_type'] = this._addressType;
    data['contact_person_number'] = this._contactPersonNumber;
    data['contact_person_name'] = this._contactPersonName;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    return data;
  }
}