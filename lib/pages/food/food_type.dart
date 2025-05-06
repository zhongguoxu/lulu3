import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/custom_app_bar.dart';
import 'package:lulu3/controllers/food_type_controller.dart';
import 'package:lulu3/controllers/system_controller.dart';
import 'package:lulu3/models/product_type_model.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:lulu3/widgets/icon_and_text.dart';
import 'package:lulu3/widgets/small_text.dart';

import '../../models/products_model.dart';

class FoodType extends StatefulWidget {
  final int typeId;
  const FoodType({Key? key, required this.typeId}) : super(key: key);

  @override
  _FoodTypeState createState() => _FoodTypeState();
}

class _FoodTypeState extends State<FoodType> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<FoodTypeController>().getFoodPerTypeProductList(widget.typeId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: CustomAppBar(
              title: Get.find<SystemController>().productTypes.firstWhere((element) => element.id == widget.typeId).title!,
            ),
            body: GetBuilder<FoodTypeController>(builder: (foodTypeController) {
              return Column(
                children: [
                  SizedBox(height: Dimensions.height20,),
                  foodTypeController.isLoaded ?
                  Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: foodTypeController.foodPerTypeList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Get.toNamed(RouteHelper.getFoodDetail(index, "type", widget.typeId));
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
                                                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+(foodTypeController.foodPerTypeList[index] as ProductModel).img!
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
                                                BigText(text: (foodTypeController.foodPerTypeList[index] as ProductModel).name!),
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
                  )
                      :
                  Center(
                    child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),)
                ],
              );
            },)
        );
  }
}

