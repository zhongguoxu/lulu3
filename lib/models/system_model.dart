class SystemModelList {
  late List<SystemModel> _systemModelList;

  List<SystemModel> get systemModelList => _systemModelList; // for public use

  SystemModelList({required systemModelList}) {
    this._systemModelList = systemModelList;
  }

  SystemModelList.fromJson(List<dynamic> json) {
    _systemModelList = <SystemModel>[];
    json.forEach((v) {
      _systemModelList.add(new SystemModel.fromJson(v));
    });
  }
}
class SystemModel {
  int? id;
  String? key;
  String? value;
  SystemModel({
    this.id,
    this.key,
    this.value,
  });
  SystemModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    key = json['key'];
    value = json['value'];
  }
  // Map<String, dynamic> toJson() {
  //   return {"id": this.id,
  //     "name": this.name,
  //     "price": this.price,
  //     "img": this.img,
  //     "quantity": this.quantity,
  //     "isExist": this.isExist,
  //     "time": this.time,
  //     "product": this.product!.toJson()};
  //
  // }
}