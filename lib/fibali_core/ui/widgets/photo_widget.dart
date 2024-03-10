import 'dart:io' as io;
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:fibali/ui/pages/photo_view_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:google_fonts/google_fonts.dart';

class PhotoWidget extends StatelessWidget {
  final String? path;
  final PhotoCloudSize imageSize;
  final String? photoUrl;
  final String? photoUrl100x100;
  final String? photoUrl250x375;
  final String? photoUrl500x500;
  final io.File? file;
  final double? height;
  final double? width;
  final double? loadingHeight;
  final double? loadingWidth;
  final bool cache;
  final BoxShape boxShape;
  final BoxFit fit;
  final bool canDisplay;
  final Duration? cacheMaxAge;
  final BoxBorder? border;

  const PhotoWidget.network({
    super.key,
    this.path,
    this.imageSize = PhotoCloudSize.small,
    required this.photoUrl,
    this.photoUrl100x100,
    this.photoUrl250x375,
    this.photoUrl500x500,
    this.file,
    this.height,
    this.width,
    this.loadingHeight = 15,
    this.loadingWidth = 15,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.border,
    this.cache = true,
    this.cacheMaxAge = const Duration(days: 1),
    this.canDisplay = false,
  });

  const PhotoWidget.file({
    super.key,
    this.path,
    this.imageSize = PhotoCloudSize.original,
    this.photoUrl,
    this.photoUrl100x100,
    this.photoUrl250x375,
    this.photoUrl500x500,
    required this.file,
    this.height,
    this.width,
    this.loadingHeight = 15,
    this.loadingWidth = 15,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.border,
    this.cache = true,
    this.cacheMaxAge = const Duration(days: 1),
    this.canDisplay = false,
  });

  const PhotoWidget.asset({
    super.key,
    required this.path,
    this.imageSize = PhotoCloudSize.original,
    this.photoUrl,
    this.photoUrl100x100,
    this.photoUrl250x375,
    this.photoUrl500x500,
    this.file,
    this.height,
    this.width,
    this.loadingHeight = 15,
    this.loadingWidth = 15,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.border,
    this.cache = true,
    this.cacheMaxAge = const Duration(days: 1),
    this.canDisplay = false,
  });

  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return ExtendedImage.asset(
        path!,
        key: key,
        height: height,
        width: width,
        fit: fit,
        border: border,
        enableSlideOutPage: true,
        filterQuality: FilterQuality.high,
        shape: boxShape,
      );
    }

    if (file != null) {
      return kIsWeb
          ? ExtendedImage.network(
              file!.path,
              key: key,
              height: height,
              width: width,
              fit: fit,
              border: border,
              enableSlideOutPage: true,
              cache: cache,
              filterQuality: FilterQuality.high,
              shape: boxShape,
            )
          : ExtendedImage.memory(
              file!.readAsBytesSync(),
              key: key,
              height: height,
              width: width,
              fit: fit,
              border: border,
              enableSlideOutPage: true,
              filterQuality: FilterQuality.high,
              shape: boxShape,
            );
    }

    if (photoUrl != null) {
      return GestureDetector(
        onTap: canDisplay
            ? () {
                if (photoUrl != null) {
                  showPhotoViewPage(context, url: photoUrl!);
                }
              }
            : null,
        child: ExtendedImage.network(
          getPhotoUrl,
          key: key,
          height: height,
          width: width,
          fit: fit,
          border: border,
          cacheMaxAge: cacheMaxAge,
          cache: cache,
          enableSlideOutPage: true,
          filterQuality: FilterQuality.high,
          shape: boxShape,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.completed:
                return null;
              case LoadState.loading:
                if (photoUrl100x100 != null) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: ExtendedImage.network(
                      photoUrl100x100!,
                      key: key,
                      height: height,
                      width: width,
                      fit: fit,
                      border: border,
                      cacheMaxAge: cacheMaxAge,
                      cache: cache,
                      enableSlideOutPage: true,
                      filterQuality: FilterQuality.high,
                      shape: boxShape,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.completed:
                            return null;
                          case LoadState.loading:
                            return Container(
                              height: loadingHeight,
                              width: loadingWidth,
                              color: Colors.grey.shade100,
                            );
                          case LoadState.failed:
                            return GestureDetector(
                              child: Container(
                                height: loadingHeight,
                                width: loadingWidth,
                                color: Colors.grey.shade300,
                              ),
                              onTap: () {
                                state.reLoadImage();
                              },
                            );
                        }
                      },
                    ),
                  );
                } else {
                  return Container(
                    height: loadingHeight,
                    width: loadingWidth,
                    color: Colors.grey.shade100,
                  );
                }
              case LoadState.failed:
                return GestureDetector(
                  child: Container(
                    height: loadingHeight,
                    width: loadingWidth,
                    color: Colors.grey.shade300,
                  ),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
            }
          },
        ),
      );
    }

    return ExtendedImage.asset(
      'assets/profilephoto.png',
      key: key,
      height: height,
      width: width,
      fit: fit,
      border: border,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      shape: boxShape,
    );
  }

  String get getPhotoUrl {
    if (imageSize == PhotoCloudSize.tiny && photoUrl100x100 != null) {
      return photoUrl100x100!;
    } else if (imageSize == PhotoCloudSize.small && photoUrl250x375 != null) {
      return photoUrl250x375!;
    } else if (imageSize == PhotoCloudSize.medium && photoUrl500x500 != null) {
      return photoUrl500x500!;
    } else if (imageSize == PhotoCloudSize.large && photoUrl != null) {
      return photoUrl!;
    } else {
      return photoUrl!;
    }
  }
}

class PhotoWidgetNetwork extends StatelessWidget {
  final String? photoUrl;
  final String? photoUrl100x100;
  final String? photoUrl250x375;
  final String? photoUrl500x500;
  final String? label;
  final io.File? file;
  final double? height;
  final double? width;
  final double? loadingHeight;
  final double? loadingWidth;
  final BoxShape boxShape;
  final BoxFit fit;
  final bool canDisplay;
  final BoxBorder? border;
  final Duration? cacheMaxAge;
  final bool cache;
  final void Function(Canvas canvas, Rect rect, Image image, Paint paint)? afterPaintImage;

  const PhotoWidgetNetwork({
    super.key,
    required this.photoUrl,
    this.photoUrl100x100,
    this.photoUrl250x375,
    this.photoUrl500x500,
    required this.label,
    this.file,
    this.height,
    this.width,
    this.loadingHeight = 15,
    this.loadingWidth = 15,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.border,
    this.cache = true,
    this.cacheMaxAge = const Duration(days: 1),
    this.canDisplay = false,
    this.afterPaintImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canDisplay
          ? () {
              if (photoUrl?.isNotEmpty == true) {
                showPhotoViewPage(context, url: photoUrl!);
              }
            }
          : null,
      child: ExtendedImage.network(
        photoUrl ?? '',
        key: key,
        height: height,
        width: width,
        fit: fit,
        border: border,
        cache: cache,
        enableSlideOutPage: true,
        filterQuality: FilterQuality.high,
        shape: boxShape,
        cacheMaxAge: cacheMaxAge,
        afterPaintImage: afterPaintImage,
        loadStateChanged: (ExtendedImageState state) {
          if (photoUrl?.isNotEmpty != true) {
            return Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.black, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Center(
                child: SizedBox.expand(
                  child: FittedBox(
                      child: Text(
                    label ?? '?',
                    style: GoogleFonts.fredokaOne(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  )),
                ),
              ),
            );
          }
          switch (state.extendedImageLoadState) {
            case LoadState.completed:
              return null;
            case LoadState.loading:
              if (photoUrl100x100 != null) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ExtendedImage.network(
                    photoUrl100x100!,
                    key: key,
                    height: height,
                    width: width,
                    fit: fit,
                    border: border,
                    cacheMaxAge: cacheMaxAge,
                    cache: cache,
                    enableSlideOutPage: true,
                    filterQuality: FilterQuality.high,
                    shape: boxShape,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.completed:
                          return null;
                        case LoadState.loading:
                          return Container(
                            height: loadingHeight,
                            width: loadingWidth,
                            color: Colors.grey.shade100,
                          );
                        case LoadState.failed:
                          return GestureDetector(
                            child: Container(
                              height: loadingHeight,
                              width: loadingWidth,
                              color: Colors.grey.shade300,
                            ),
                            onTap: () {
                              state.reLoadImage();
                            },
                          );
                      }
                    },
                  ),
                );
              } else {
                return Container(
                  height: loadingHeight,
                  width: loadingWidth,
                  color: Colors.grey.shade100,
                );
              }
            case LoadState.failed:
              return GestureDetector(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Colors.black, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                    child: Center(
                        child: SizedBox.expand(
                      child: FittedBox(
                          child: Text(
                        label ?? '?',
                        style: GoogleFonts.fredokaOne(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )),
                    ))),
                onTap: () {
                  state.reLoadImage();
                },
              );
          }
        },
      ),
    );
  }
}

enum PhotoCloudSize { tiny, small, medium, large, original }
