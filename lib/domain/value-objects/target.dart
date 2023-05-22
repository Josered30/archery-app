import 'package:flutter/widgets.dart';

class TargetException implements Exception {
  String cause;
  TargetException(this.cause);
}

class TargetLayer {
  final double radius;
  final Color color;
  const TargetLayer({required this.radius, required this.color});
}

class Target {
  final double width;
  final int layers;
  final List<TargetLayer> targetLayers;

  const Target._({
    required this.layers,
    required this.width,
    required this.targetLayers,
  });

  static Target build(int layers, double width, List<Color> colors) {
    if (layers / colors.length != 2) {
      throw TargetException("There must a color per 2 layers");
    }
    List<TargetLayer> targetLayers = _targetLayers(width, layers, colors);
    return Target._(layers: layers, width: width, targetLayers: targetLayers);
  }

  static List<TargetLayer> _targetLayers(
      double width, int layers, List<Color> colors) {
    List<TargetLayer> targetLayers = List.empty(growable: true);
    double radius = width / 2;

    double offset = 1;
    double layerOffset = 1 / layers;

    for (int i = 0; i < layers; ++i) {
      targetLayers.add(
          TargetLayer(radius: radius * offset, color: colors[(i / 2).floor()]));
      offset -= layerOffset;
    }
    return targetLayers;
  }
}
