// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:lulu/data/repository/auth_repo.dart';
// import 'package:lulu/models/response_model.dart';
// import 'package:lulu/models/signup_body_model.dart';
// import 'package:http/http.dart' as http;
//
// import '../models/user_model.dart';
//
// class AuthController extends GetxController implements GetxService {
//   final AuthRepo authRepo;
//   AuthController({
//     required this.authRepo,
//   });
//
//   bool _isLoading = false;
//   bool get isLoading=>_isLoading;
//
//   Future<ResponseModel> registration(SignUpBody signUpBody) async {
//     _isLoading = true;
//     update();
//     http.Response response = await authRepo.registration(signUpBody);
//     late ResponseModel responseModel;
//     if (response.statusCode == 200) {
//       authRepo.saveUserAccount(UserModel.fromJson(jsonDecode(response.body)));
//       responseModel = ResponseModel(true, "Registration successfully");
//       print("registration successfully");
//     } else {
//       responseModel = ResponseModel(false, "Registration fails");
//       print("registration fails");
//     }
//     _isLoading = false;
//     update();
//     return responseModel;
//   }
//
//   Future<ResponseModel> login(String email, String password) async {
//     _isLoading = true;
//     update();
//     http.Response response = await authRepo.login(email, password);
//     late ResponseModel responseModel;
//     if (response.statusCode == 200) {
//       authRepo.saveUserAccount(UserModel.fromJson(jsonDecode(response.body)));
//       responseModel = ResponseModel(true, "Login successfully");
//       print("login successfully");
//     } else {
//       responseModel = ResponseModel(false, "Login fails");
//       print("login fails");
//     }
//     _isLoading = false;
//     update();
//     return responseModel;
//   }
//
//   // void saveUserNumberandPassword(String number, String password) async {
//   //   authRepo.saveUserNumberandPassword(number, password);
//   // }
//
//   bool userHasLoggedIn() {
//     return authRepo.userHasLoggedIn();
//   }
//
//   bool clearSharedData() {
//     authRepo.clearSharedData();
//     return true;
//   }
// }