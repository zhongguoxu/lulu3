import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lulu3/controllers/location_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/utils/dimensions.dart';
// import 'package:google_maps_webservice/src/places.dart';

class LocationDialogue extends StatelessWidget {
  // final GoogleMapController mapController;
  // const LocationDialogue({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20/2),

        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          // child: TypeAheadField(
          //   textFieldConfiguration: TextFieldConfiguration(
          //     controller: _controller,
          //     textInputAction: TextInputAction.search,
          //     autofocus: true,
          //     textCapitalization: TextCapitalization.words,
          //     keyboardType: TextInputType.streetAddress,
          //     decoration: InputDecoration(
          //       hintText: "search location",
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(Dimensions.radius20/2),
          //         borderSide: BorderSide(
          //           style: BorderStyle.none,
          //           width: 0,
          //         )
          //       ),
          //       hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
          //         color: Theme.of(context).disabledColor,
          //         fontSize: Dimensions.font16,
          //       ),
          //     )
          //   ),
          //   // as we type, we get suggestions
          //   suggestionsCallback: (String pattern) async {
          //     // return await Get.find<UserController>().searchLocationByHttp(pattern);
          //   },
          //   onSuggestionSelected: (Prediction suggestion) {
          //     Get.find<UserController>().setLocationByHttp(suggestion.placeId!, suggestion.description!, mapController);
          //     Get.back();
          //   },
          //   itemBuilder: (BuildContext context, Prediction suggestion) {
          //     return Padding(
          //       padding: EdgeInsets.all(Dimensions.width10),
          //       child: Row(
          //         children: [
          //           Icon(Icons.location_on),
          //           Expanded(
          //               child: Text(
          //                 suggestion.description!,
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          //                   color: Theme.of(context).textTheme.bodyLarge?.color,
          //                   fontSize: Dimensions.font16,
          //                 ),
          //               ),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          //
          // ),
        ),
      ),
    );
  }
}
