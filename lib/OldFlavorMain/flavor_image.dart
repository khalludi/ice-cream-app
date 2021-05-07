import 'package:flutter/material.dart';

/// The [FlavorImage] widget, if given a pngFileName, displays the file as an image.
/// Otherwise returns an empty widget which sizes itself to the smallest area possible.
 
class FlavorImage extends StatelessWidget {
  final String pngFileName;
  FlavorImage(this.pngFileName);

  String getPath(String fileName) {
    return 'lib/flavor_images/' + pngFileName;
  }

  @override
  Widget build(BuildContext context) {
   return pngFileName != null ?
   Image(image: AssetImage(getPath(pngFileName)))
   : SizedBox.shrink(); // if no png, return empty view
  }
}