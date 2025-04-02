import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lulu3/controllers/recommended_product_controller.dart';
import 'package:lulu3/models/products_model.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:lulu3/widgets/icon_and_text.dart';
import 'package:lulu3/widgets/small_text.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';

class SearchProductPage extends StatelessWidget {
  const SearchProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            //header
            Positioned(
                top: Dimensions.height20*3,
                left: Dimensions.width20,
                right: Dimensions.width20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: AppIcon(icon: Icons.arrow_back_ios,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                      onTap: () => Get.back(),
                    ),
                    // SizedBox(width: Dimensions.width20*5,),

                  ],
                )
            ),
            //body
            GetBuilder<RecommendedProductController>(builder: (_recommendedController) {
              return Positioned(
                top: Dimensions.height20*5,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.only(top: Dimensions.height15),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _recommendedController.recommendedProductList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: (){
                                      // Get.toNamed(RouteHelper.getRecommendedFood(index, "type"));
                                      Get.toNamed(RouteHelper.getFoodDetail(index, "recommend", 0));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                                      child: Row(
                                        children: [
                                          //Image section
                                          Container(
                                            width: Dimensions.listViewImgSize,
                                            height: Dimensions.listViewImgSize,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                color: Colors.white38,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        AppConstants.BASE_URL+AppConstants.UPLOAD_URL+(_recommendedController.recommendedProductList[index] as ProductModel).img!
                                                    )
                                                )
                                            ),
                                          ),
                                          //text container
                                          Expanded(
                                            child: Container(
                                              height: Dimensions.listViewTextContainerSize,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius20), bottomRight: Radius.circular(Dimensions.radius20)),
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    BigText(text: (_recommendedController.recommendedProductList[index] as ProductModel).name!),
                                                    SizedBox(height: Dimensions.height10,),
                                                    SmallText(text: "With Chinese characteristics"),
                                                    SizedBox(height: Dimensions.height10,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        IconAndTextWidget(icon: Icons.circle_sharp,
                                                            text: "Normal",
                                                            iconColor: AppColors.iconColor1),
                                                        IconAndTextWidget(icon: Icons.location_on,
                                                            text: "1.7km",
                                                            iconColor: AppColors.mainColor),
                                                        IconAndTextWidget(icon: Icons.access_time_rounded,
                                                            text: "32min",
                                                            iconColor: AppColors.iconColor2)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                      ),),),
                );
            })
          ],
        ),
    );;
  }
}
