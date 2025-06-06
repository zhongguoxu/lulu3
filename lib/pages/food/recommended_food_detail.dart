// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lulu3/controllers/popular_product_controller.dart';
// import 'package:lulu3/controllers/recommended_product_controller.dart';
// import 'package:lulu3/models/products_model.dart';
// import 'package:lulu3/pages/cart/cart_page.dart';
// import 'package:lulu3/routes/route_helper.dart';
// import 'package:lulu3/utils/app_constants.dart';
// import 'package:lulu3/utils/colors.dart';
// import 'package:lulu3/utils/dimensions.dart';
// import 'package:lulu3/widgets/app_icon.dart';
// import 'package:lulu3/widgets/big_text.dart';
// import 'package:lulu3/widgets/expandable_text.dart';
//
// import '../../controllers/cart_controller.dart';
//
// class RecommendedFoodDetail extends StatelessWidget {
//   final int pageId;
//   final String page;
//   const RecommendedFoodDetail({Key? key, required this.pageId, required this.page}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var product = Get.find<RecommendedProductController>().recommendedProductList[pageId] as ProductModel;
//     Get.find<PopularProductController>().initProduct(Get.find<CartController>(), product);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             toolbarHeight: 80,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   child: AppIcon(icon: Icons.clear),
//                   onTap: () {
//                     if (page == "cartPage") {
//                       Get.toNamed(RouteHelper.getCartPage());
//                     } else {
//                       Get.toNamed(RouteHelper.getInitial());
//                     }
//                   },
//                 ),
//                 GetBuilder<PopularProductController>(builder: (controller) {
//                   return GestureDetector(
//                     onTap: () {
//                       if (controller.totalItems > 0) {
//                         Get.toNamed(RouteHelper.getCartPage());
//                       }
//                     },
//                     child: Stack(
//                       children: [
//                         AppIcon(icon: Icons.shopping_cart_outlined),
//                         controller.totalItems > 0 ?
//                         Positioned(
//                           right: 0, top: 0,
//                           child: AppIcon(icon: Icons.circle, size: 20, iconColor: Colors.transparent,backgroundColor: AppColors.mainColor,),
//                         ) : Container(
//
//                         ),
//                         controller.totalItems > 0 ?
//                         Positioned(
//                           right: 3, top: 3,
//                           child: BigText(text: Get.find<PopularProductController>().totalItems.toString(),size: 12, color: Colors.white,),
//                         ) : Container(
//
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//                 // AppIcon(icon: Icons.shopping_cart_outlined)
//               ],
//             ),
//             bottom: PreferredSize(
//               preferredSize: Size.fromHeight(15,),
//               child: Container(
//                 child: Center(child: BigText(text: product.name!, size: Dimensions.font26,)),
//                 width: double.maxFinite,
//                 padding: EdgeInsets.only(top: 5, bottom: 10),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(Dimensions.radius20),
//                       topRight: Radius.circular(Dimensions.radius20),
//                     )
//                 ),
//               ),
//             ),
//             pinned: true,
//             backgroundColor: AppColors.yellowColor,
//             expandedHeight: 300,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                 AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!,
//                 width: double.maxFinite,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
//                     child: ExpandableTextWidget(text: product.description!,),
//                   )
//                 ],
//               ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.only(left: Dimensions.width20*2.5,
//                   right: Dimensions.width20*2.5,
//                   top: Dimensions.height10,
//                   bottom: Dimensions.height10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         controller.setQuantity(false);
//                       },
//                       child: AppIcon(icon: Icons.remove, backgroundColor: AppColors.mainColor, iconColor: Colors.white, iconSize: Dimensions.iconSize24,)),
//                   BigText(text: "\$ ${product.price} *  ${controller.inCartItems}", color: AppColors.mainBlackColor, size: Dimensions.font26,),
//                   GestureDetector(
//                       onTap: () {
//                         controller.setQuantity(true);
//                       },
//                       child: AppIcon(icon: Icons.add, backgroundColor: AppColors.mainColor, iconColor: Colors.white, iconSize: Dimensions.iconSize24))
//                 ],
//               ),
//             ),
//             Container(
//               height: Dimensions.bottomHeightBar,
//               padding: EdgeInsets.only(top: Dimensions.height30, bottom: Dimensions.height30, left: Dimensions.width20, right: Dimensions.width20),
//               decoration: BoxDecoration(
//                   color: AppColors.buttonBackgroundColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(Dimensions.radius20*2),
//                     topRight: Radius.circular(Dimensions.radius20*2),
//                   )
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(Dimensions.radius20),
//                       color: Colors.white,
//                     ),
//                     child: Icon(
//                       Icons.favorite, color: AppColors.mainColor,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       controller.addItem(product);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
//                       child: BigText(text: "\$ ${product.price!} | Add to cart", color: Colors.white,),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(Dimensions.radius20),
//                         color: AppColors.mainColor,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       },),
//     );
//   }
// }
