// Draws the launcher icon PNGs for Android 7.x (API 24–25), which cannot
// use the adaptive vector icon. Same design as
// android/app/src/main/res/drawable/ic_launcher_foreground.xml: navy square,
// gold check (SPEC §8.10). Run once when the design changes:
//
//   flutter test tool/generate_icons_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/theme/tokens.dart';

const densities = {
  'mdpi': 48,
  'hdpi': 72,
  'xhdpi': 96,
  'xxhdpi': 144,
  'xxxhdpi': 192,
};

Future<List<int>> drawIcon(int size) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = size.toDouble();

  // Navy rounded square filling the legacy icon.
  canvas.drawRRect(
    RRect.fromRectAndRadius(Offset.zero & Size(s, s), Radius.circular(s * 0.2)),
    Paint()..color = AppColors.navy,
  );

  // The vector uses a 108-unit canvas whose visible middle is 18..90; map that
  // middle onto the whole legacy icon so the check has the same proportions.
  final scale = s / 72;
  Offset p(double x, double y) => Offset((x - 18) * scale, (y - 18) * scale);
  canvas.drawPath(
    Path()
      ..moveTo(p(37, 55).dx, p(37, 55).dy)
      ..lineTo(p(49, 67).dx, p(49, 67).dy)
      ..lineTo(p(72, 42).dx, p(72, 42).dy),
    Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );

  final image = await recorder.endRecording().toImage(size, size);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

void main() {
  testWidgets('generate launcher PNGs', (tester) async {
    await tester.runAsync(() async {
      for (final MapEntry(key: density, value: size) in densities.entries) {
        final file = File(
          'android/app/src/main/res/mipmap-$density/ic_launcher.png',
        );
        await file.writeAsBytes(await drawIcon(size));
      }
    });
  });
}
