import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/custom_loader.dart';
import 'package:lulu3/base/show_custom_snackbar.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/pages/auth/signup_page_new.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/custom_text_field.dart';

class SignInPageNew extends StatelessWidget {
  const SignInPageNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(UserController userController) {
      if (_formKey.currentState!.validate()) {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        userController.login(email, password).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: GetBuilder<UserController>(builder: (userController) {
        return !userController.isLoading
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
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: Dimensions.font26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(
                                "Sign in to continue",
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
                            width: double.infinity,
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
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: Dimensions.font26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height30),
                                    // Form fields
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
                                    SizedBox(height: Dimensions.height10),
                                    // Forgot password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // TODO: Implement forgot password
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontSize: Dimensions.font16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                    // Sign in button
                                    GestureDetector(
                                      onTap: () => _login(userController),
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
                                            "Sign In",
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
                                    // Sign up link
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: Dimensions.font16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Sign Up",
                                              style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => Get.to(()=>SignUpPageNew(), transition: Transition.fade),
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