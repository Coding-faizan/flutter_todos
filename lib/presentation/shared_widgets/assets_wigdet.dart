import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetImageWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final String? semanticLabel;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AssetImageWidget({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.semanticLabel,
    this.margin,
    this.onTap,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: path.endsWith('svg')
            ? SvgPicture.asset(
                path,
                width: width,
                height: height,
                colorFilter: color != null
                    ? ColorFilter.mode(color!, BlendMode.srcIn)
                    : null,
                fit: fit ?? BoxFit.contain,
                errorBuilder: errorBuilder,
              )
            : Image.asset(
                path,
                width: width,
                height: height,
                color: color,
                fit: fit,
                errorBuilder: errorBuilder,
              ),
      ),
    );
  }
}

class AssetNetworkImageWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final String? semanticLabel;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AssetNetworkImageWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.semanticLabel,
    this.margin,
    this.onTap,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      color: color,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
