import 'package:flutter/material.dart';
//import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fui_lib/fui_lib.dart';

class BasedCircleImage extends StatelessWidget {
  const BasedCircleImage({
    required this.altText,
    this.colorBackground = Colors.orange,
    this.colorText = Colors.cyan,
    this.radius = 80,
    required this.src,
  });
  final String altText;
  final Color colorBackground;
  final Color colorText;
  final double radius;
  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BasedFadeInImage(
          altText: altText,
          colorBackground: colorBackground,
          colorText: colorText,
          height: radius * 2,
          width: radius * 2,
          src: src,
        ),
      ),
    );
  }
}

class BasedSizedImage extends StatelessWidget {
  const BasedSizedImage(
      {required this.altText,
      this.colorBackground = Colors.grey,
      this.height = 120,
      this.usePhotoview = false,
      required this.src,
      this.width});
  final String altText;
  final Color colorBackground;
  final double height;
  final bool usePhotoview;
  final String src;
  final double? width;

  @override
  Widget build(BuildContext context) {
    var fadeInImage = BasedFadeInImage(
        altText: altText,
        colorBackground: colorBackground,
        height: height,
        src: src,
        width: width);

    if (usePhotoview) {
      const Text('TODO photoview');
      //return PhotoView.customChild(
      //child: Container(
      //height: height,
      //width: width,
      //color: colorBackground,
      //child: fadeInImage,
      //),
      //);
    }
    return fadeInImage;
  }
}

class BasedFadeInImage extends StatelessWidget {
  const BasedFadeInImage({
    this.altText = '',
    this.colorBackground = Colors.grey,
    this.colorText = Colors.black,
    this.height = 120,
    this.fontSize = 20,
    required this.src,
    this.useLoadingOnError = false,
    this.width,
  });
  final String altText;
  final Color colorBackground;
  final Color colorText;
  final double height;
  final double fontSize;
  final String src;
  final bool useLoadingOnError;
  final double? width;

  @override
  Widget build(BuildContext context) {
    var king = King.of(context);
    //final url = king.conf.fixImageSrc(src);
    final url = src;
    final loading = king.conf.loadingImageUrl;
    CachedNetworkImage.evictFromCache(url);

    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => useLoadingOnError
            ? Image.network(loading)
            : Container(
                height: height,
                width: width,
                color: colorBackground,
                child: Center(
                  child: Text(
                    altText,
                    style: TextStyle(
                      fontSize: (height / 4),
                      color: colorText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
