import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/card_models.dart';

class CardImageWidget extends StatelessWidget {
  final CardImage cardImage;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CardImageWidget({
    super.key,
    required this.cardImage,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (cardImage.imageType == 'asset' && cardImage.assetType != null) {
      return Image.asset(
        cardImage.assetType!,
        width: width,
        height: height,
        fit: fit,
      );
    } else if ((cardImage.imageType == 'external' || cardImage.imageType == 'ext') && cardImage.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: cardImage.imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    }

    // Handle unknown image types or missing data
    return _buildErrorWidget();
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
