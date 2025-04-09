import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/custom_loader.dart';
import 'package:lulu3/base/show_custom_snackbar.dart';
import 'package:lulu3/controllers/auth_controller.dart';
import 'package:lulu3/controllers/payment_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/models/signup_body_model.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/app_text_field.dart';
import 'package:lulu3/widgets/big_text.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      't.png',
      'f.png',
      'g.png',
    ];
    void _registration(UserController userController) {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone number");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email address", title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in valid email address", title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than six characters", title: "Password");
      } else {
        SignUpBody signUpBody = SignUpBody(
            name: name,
            phone: phone,
            email: email,
            password: password,
            created_at: DateTime.now().toString(),
        );
        // update database
        userController.setUpdateLoading(true);
        userController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            // update stripe
            Get.find<PaymentController>().addStripeCustomer(name, email, phone).then((response) {
              if (response.isSuccess) {
                // update database
                userController.updateCustomerId(email, response.message).then((value) async {
                  if (value.isSuccess) {
                    // update memory
                    userController.userModel!.customer_id = response.message;
                    await userController.saveUserAccount(userController.userModel!);
                    print("new user model after update customerId");
                    print(userController.userModel!);
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
      backgroundColor: Colors.white,
      body: GetBuilder<UserController>(builder: (_userController) {
        return !_userController.isLoading ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.05,),
              Container(
                height: Dimensions.screenHeight*0.25,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage(
                        "assets/image/test0.png"
                    ),
                  ),
                ),
              ),
              AppTextField(
                  textController: emailController,
                  hintText: "Email",
                  icon: Icons.email
              ),
              SizedBox(height: Dimensions.height20,),
              AppTextField(
                  textController: passwordController,
                  hintText: "Password",
                  icon: Icons.password_sharp
              ),
              SizedBox(height: Dimensions.height20,),
              AppTextField(
                  textController: nameController,
                  hintText: "Name",
                  icon: Icons.person
              ),
              SizedBox(height: Dimensions.height20,),
              AppTextField(
                  textController: phoneController,
                  hintText: "Phone",
                  icon: Icons.phone
              ),
              SizedBox(height: Dimensions.height20,),
              // sign up btn
              GestureDetector(
                onTap: () {
                  _registration(_userController);
                },
                child: Container(
                  width: Dimensions.screenWidth/2,
                  height: Dimensions.screenHeight/13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  child: Center(child: BigText(text: "Sign up",size: Dimensions.font20*1.5,color: Colors.white,)),
                ),
              ),
              SizedBox(height: Dimensions.height10,),
              RichText(
                  text: TextSpan(
                      recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                      text: "Have an account already?",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20*0.75,
                      )
                  )
              ),
              SizedBox(height: Dimensions.screenHeight*0.05,),
              RichText(
                  text: TextSpan(
                      text: "Sign up using of the following methods",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font16,
                      )
                  )
              ),
              Wrap(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: Dimensions.radius30,
                    backgroundImage: AssetImage(
                        "assets/image/"+signUpImages[index]
                    ),
                  ),
                )),
              )
            ],
          ),
        ) : CustomLoader();
      },),
    );


  }
}
