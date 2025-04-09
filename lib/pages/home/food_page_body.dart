import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/popular_product_controller.dart';
import 'package:lulu3/controllers/recommended_product_controller.dart';
import 'package:lulu3/controllers/system_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/models/products_model.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/app_column.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:lulu3/widgets/icon_and_text.dart';
import 'package:lulu3/widgets/small_text.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue=0.0;
  double scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  @override
  void initState() {
    super.initState();
    // Get.find<UserController>().clearSharedData();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
        // print("Current value is " + _currPageValue.toString());
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // slider section
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return popularProducts.isLoaded ? Container(
            height: Dimensions.pageView,
            child: PageView.builder(
                controller: pageController,
                itemCount: popularProducts.popularProductList.length,
                itemBuilder: (context, position) {
                  return _buildPageItem(position, popularProducts.popularProductList[position]);
                }),
          ) : CircularProgressIndicator(
            color: AppColors.mainColor,
          );
        }),
        // indicator dots
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return new DotsIndicator(
            dotsCount: popularProducts.popularProductList.length > 0 ? popularProducts.popularProductList.length : 1,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        // list of categories
        SizedBox(height: Dimensions.height30,),
        GetBuilder<SystemController>(builder: (systemController) {
          // print("zack type # is: " + systemController.productTypes.where((element) => element.id!>3).toList().length.toString());
          // Map<int, String> productCategoryTypeMap = {
          //   4: "/images/vegetable.png",
          //   5: "/images/meat.png",
          //   6: "/images/dairy.png",
          //   7: "/images/sauce.png",
          //   8: "/images/beverage.png",
          //   9: "/images/pet.png",
          // };
          var productTypes = systemController.productTypes.where((element) => element.id!>3).toList();
          return Container(
            height: Dimensions.height10*12,
            child: ListView.builder(
                // physics: ClampingScrollPhysics(),
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: productTypes.length,
                itemBuilder: (context, index) {
                  // return Container(
                  //   margin: EdgeInsets.all(10),
                  //   width: Dimensions.height10*10,
                  //   color: index == 2 ? AppColors.mainColor : Colors.black,
                  // );
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getFoodTypePage(productTypes[index].id!));
                    },
                    child: Container(
                      width: Dimensions.height10*10,
                      margin: EdgeInsets.all(1),
                      child: Column(
                        children: [
                          //Image section
                          Container(
                            padding: EdgeInsets.all(Dimensions.width10*0.9),
                            width: Dimensions.height10*8,
                            height: Dimensions.height10*8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5
                                ),
                                color: Colors.transparent,
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  matchTextDirection: true,
                                  repeat: ImageRepeat.noRepeat,
                                  image: NetworkImage(
                                      AppConstants.BASE_URL+AppConstants.UPLOAD_URL+productTypes[index].img!
                                  ),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          Text(productTypes[index].title!, style: TextStyle(fontSize: Dimensions.font20/2*1.2),),
                          //text container
                        ],
                      ),
                    ),
                  );
                }),
          );
        }),
        // popular text
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Popular"),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(text: ".", color: Colors.black26,),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                child: SmallText(text: "Food pairing",),
              )
            ],
          ),
        ),
        // list of food and images
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct) {
          return recommendedProduct.isLoaded ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recommendedProduct.recommendedProductList.length,
              itemBuilder: (context, index) {
                var thisProduct = recommendedProduct.recommendedProductList[index] as ProductModel;
                var inPromotion = thisProduct.originalPrice! != thisProduct.price!;
                return GestureDetector(
                  onTap: (){
                    // Get.toNamed(RouteHelper.getRecommendedFood(index, "home"));
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
                                      AppConstants.BASE_URL+AppConstants.UPLOAD_URL+thisProduct.img!
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
                                  BigText(text: thisProduct.name!),
                                  SizedBox(height: Dimensions.height10,),
                                  SmallText(text: thisProduct.subName!),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(inPromotion ? Icons.discount : Icons.discount_outlined, color: AppColors.iconColor1, size: Dimensions.iconSize24,),
                                      SizedBox(width: Dimensions.width10/5,),
                                      inPromotion ? Row(
                                        children: [
                                          Text(thisProduct.originalPrice!.toStringAsFixed(2), style: TextStyle(
                                            color: const Color(0xFFccc7c5),
                                            fontSize: 12,
                                            height: 1.2,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: Colors.red,
                                          ),),
                                          SizedBox(width: Dimensions.width10/2,),
                                          SmallText(text: thisProduct.price!.toStringAsFixed(2), size: 16,),
                                        ],
                                      ) : SmallText(text: thisProduct.price!.toStringAsFixed(2), size: 16,),


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
              }) : CircularProgressIndicator(
            color: AppColors.mainColor,
          );
        }),
      ],
    );
  }
  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1-(_currPageValue-index) * (1-scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor()+1) {
      var currScale = scaleFactor+(_currPageValue-index+1)*(1-scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor()-1) {
      var currScale = 1-(_currPageValue-index) * (1-scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Get.toNamed(RouteHelper.getPopularFood(index, "home"));
              Get.toNamed(RouteHelper.getFoodDetail(index, "popular", 0));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          AppConstants.BASE_URL+AppConstants.UPLOAD_URL+popularProduct.img!
                      )
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      offset: Offset(0, 6),
                      blurRadius: 5.0,
                    )
                  ]
              ),
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height15*0.2, left: Dimensions.height15, right: Dimensions.height15),
                child: AppColumn(text: popularProduct.name!,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
