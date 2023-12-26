import 'package:flutter/material.dart';

Widget greenIntroWidget() {
  return Container(
    //child:
    child: Image(
      image: AssetImage('assets/images/image.png'),
      width: double.infinity, // Set width to fill available space horizontally
      height:
          300, // Set a specific height or use double.infinity to fill vertically
      fit: BoxFit
          .fitHeight, // Use BoxFit.cover to scale and crop the image as needed
    ),
  );
}
