class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String orderCount;
  String status;
  String email_verified_at;
  String password;
  String remember_token;
  String created_at;
  String updated_at;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orderCount,
    required this.email_verified_at,
    required this.password,
    required this.remember_token,
    required this.created_at,
    required this.updated_at,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['f_name'],
      email: json['email'],
      phone: json['phone'],
      orderCount: json['order_count'],
      status: json['status'],
      email_verified_at: json['email_verified_at'],
      password: json['password'],
      remember_token: json['remember_token'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['order_count'] = this.orderCount;
    data['status'] = this.status;
    data['email_verified_at'] = this.email_verified_at;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['password'] = this.password;
    data['remember_token'] = this.remember_token;
    return data;
  }
}