class SignUpBody {
  String name;
  String phone;
  String email;
  String password;
  String created_at;
  SignUpBody({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.created_at,
  });

  Map<String, dynamic> toJson() {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['f_name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['created_at'] = created_at;
    return data;
  }
}