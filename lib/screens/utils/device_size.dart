import 'dart:ffi';

class DeviceSize {
  final Size size;
  final double width;
  final double height;
  final double aspectRatio;

  DeviceSize({required this.size, required this.width, required this.height, required this.aspectRatio});
}