import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Dynamic Media Viewer that automatically resolves and renders images and vector graphics (SVGs)
/// from network, local assets, or file paths.
class UIMediaViewer extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  const UIMediaViewer({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isSvg => source.toLowerCase().endsWith('.svg');

  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');

  bool get _isAsset =>
      source.startsWith('assets/') ||
      source.startsWith('packages/') ||
      !_isNetwork && !source.startsWith('/');

  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder = placeholder ??
        SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          ),
        );

    final defaultError = errorWidget ??
        SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                color: Colors.grey, size: 20.0),
          ),
        );

    try {
      if (_isSvg) {
        if (_isNetwork) {
          return SvgPicture.network(
            source,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (BuildContext context) => defaultPlaceholder,
          );
        } else if (_isAsset) {
          return SvgPicture.asset(
            source,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (BuildContext context) => defaultPlaceholder,
          );
        } else {
          return SvgPicture.file(
            File(source),
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (BuildContext context) => defaultPlaceholder,
          );
        }
      } else {
        // Raster formats
        if (_isNetwork) {
          return Image.network(
            source,
            width: width,
            height: height,
            fit: fit,
            color: color,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return defaultPlaceholder;
            },
            errorBuilder: (context, error, stackTrace) => defaultError,
          );
        } else if (_isAsset) {
          return Image.asset(
            source,
            width: width,
            height: height,
            fit: fit,
            color: color,
            errorBuilder: (context, error, stackTrace) => defaultError,
          );
        } else {
          return Image.file(
            File(source),
            width: width,
            height: height,
            fit: fit,
            color: color,
            errorBuilder: (context, error, stackTrace) => defaultError,
          );
        }
      }
    } catch (_) {
      return defaultError;
    }
  }
}
