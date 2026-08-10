import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';
import '../models/svg_path_data.dart';

class SvgParserResult {
  final List<SvgPathData> pathList;
  final Rect totalBounds;

  const SvgParserResult({required this.pathList, required this.totalBounds});
}

class SvgParser {
  static Future<SvgParserResult> parseAsset(
    String assetPath, {
    Color defaultColor = Colors.black,
  }) async {
    final svgString = await rootBundle.loadString(assetPath);
    final document = XmlDocument.parse(svgString);
    final pathElements = document.findAllElements('path');

    final List<SvgPathData> list = [];
    Path combinedPathForBounds = Path();

    for (final element in pathElements) {
      final dAttribute = element.getAttribute('d');
      if (dAttribute != null && dAttribute.isNotEmpty) {
        final path = parseSvgPathData(dAttribute);

        String? styleAttr = element.getAttribute('style');
        String? fillAttr = element.getAttribute('fill');
        String? strokeAttr = element.getAttribute('stroke');

        Color fillColor = _parseColor(fillAttr, defaultColor);
        fillColor = _extractColorFromStyle(styleAttr, 'fill', fillColor);

        Color strokeColor = _parseColor(strokeAttr, fillColor);
        strokeColor = _extractColorFromStyle(styleAttr, 'stroke', strokeColor);

        if (strokeColor == Colors.transparent &&
            fillColor != Colors.transparent) {
          strokeColor = fillColor;
        }

        list.add(
          SvgPathData(
            path: path,
            fillColor: fillColor,
            strokeColor: strokeColor,
          ),
        );

        combinedPathForBounds.addPath(path, Offset.zero);
      }
    }

    return SvgParserResult(
      pathList: list,
      totalBounds: combinedPathForBounds.getBounds(),
    );
  }

  static Color _parseColor(String? colorStr, Color defaultColor) {
    if (colorStr == null || colorStr.isEmpty || colorStr == 'none') {
      return Colors.transparent;
    }
    try {
      String hex = colorStr.replaceAll('#', '').trim();
      if (hex.length == 3) {
        hex = hex.split('').map((c) => '$c$c').join();
      }
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return defaultColor;
  }

  static Color _extractColorFromStyle(
    String? style,
    String key,
    Color fallbackColor,
  ) {
    if (style == null || style.isEmpty) return fallbackColor;
    final pairs = style.split(';');
    for (var pair in pairs) {
      final kv = pair.split(':');
      if (kv.length == 2 && kv[0].trim() == key) {
        return _parseColor(kv[1].trim(), fallbackColor);
      }
    }
    return fallbackColor;
  }
}
