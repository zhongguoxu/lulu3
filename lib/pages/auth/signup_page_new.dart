import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/custom_loader.dart';
import 'package:lulu3/base/show_custom_snackbar.dart';
import 'package:lulu3/controllers/payment_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/models/signup_body_model.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/custom_text_field.dart';

class SignUpPageNew extends StatelessWidget {
  const SignUpPageNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();

    void _registration(UserController userController) {
      if (_formKey.currentState!.validate()) {
        String name = nameController.text.trim();
        String phone = phoneController.text.trim();
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        SignUpBody signUpBody = SignUpBody(
          name: name,
          phone: phone,
          email: email,
          password: password,
          created_at: DateTime.now().toString(),
        );

        userController.setUpdateLoading(true);
        userController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            Get.find<PaymentController>().addStripeCustomer(name, email, phone).then((response) {
              if (response.isSuccess) {
                userController.updateCustomerId(email, response.message).then((value) async {
                  if (value.isSuccess) {
                    userController.userModel!.customer_id = response.message;
                    await userController.saveUserAccount(userController.userModel!);
                    userController.setUpdateLoading(false);
                    Get.offNamed(RouteHelper.getInitial());
                  } else {
                    userController.setUpdateLoading(false);
                    showCustomSnackBar(value.message);
                  }
                });
              } else {
                userController.setUpdateLoading(false);
                showCustomSnackBar(response.message);
              }
            });
          } else {
            userController.setUpdateLoading(false);
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: GetBuilder<UserController>(builder: (_userController) {
        return !_userController.isLoading
            ? Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.mainColor.withOpacity(0.8),
                          AppColors.mainColor,
                        ],
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Column(
                      children: [
                        // Top section with logo and welcome text
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20,
                            vertical: Dimensions.height20,
                          ),
                          child: Column(
                            children: [
                              // Logo or App Name
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/image/splash.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Text(
                                "Welcome to Lulu",
                                style: TextStyle(
                                  fontSize: Dimensions.font26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(
                                "Create your account to continue",
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Form section
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: Dimensions.height20),
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width20,
                              vertical: Dimensions.height30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimensions.radius30),
                                topRight: Radius.circular(Dimensions.radius30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: Dimensions.font26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height30),
                                    // Form fields
                                    CustomTextField(
                                      textController: nameController,
                                      hintText: "Full Name",
                                      prefixIcon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomTextField(
                                      textController: emailController,
                                      hintText: "Email Address",
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!GetUtils.isEmail(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomTextField(
                                      textController: phoneController,
                                      hintText: "Phone Number",
                                      prefixIcon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomTextField(
                                      textController: passwordController,
                                      hintText: "Password",
                                      prefixIcon: Icons.lock_outline,
                                      isPassword: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 3) {
                                          return 'Password must be at least 3 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: Dimensions.height30),
                                    // Sign up button
                                    GestureDetector(
                                      onTap: () => _registration(_userController),
                                      child: Container(
                                        width: double.infinity,
                                        height: Dimensions.screenHeight / 13,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.mainColor,
                                              AppColors.mainColor.withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.mainColor.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Create Account",
                                            style: TextStyle(
                                              fontSize: Dimensions.font20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                    // Login link
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: Dimensions.font16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Login",
                                              style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const CustomLoader();
      }),
    );
  }
} 