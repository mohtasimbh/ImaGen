import 'package:cached_network_image/cached_network_image.dart';
import 'package:imagen/core/extension/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../../features/home/model/ai_model.dart';
import 'glass_box.dart';

class ImageContainer extends Container {
  final BuildContext context;
  final DallEModel? model;
  final int index;
  ImageContainer({
    super.key,
    required this.context,
    required this.model,
    required this.index,
  }) : super(
          padding: context.paddingLow,
          margin: context.paddingLow,
          child: ClipRRect(
            borderRadius: context.containerRadius,
            child: SizedBox(
              width: context.width * .9,
              height: context.height * .9,
              child: CachedNetworkImage(
                imageUrl: model?.data?[index].url ?? "",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    GlassContainer(
                  height: context.height * .4,
                  child: Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),
        );
}
