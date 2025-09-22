import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utils {
  static bool isTablet = false;
  static final key = en.Key.fromUtf8('3Df7G9uWq8s2BxM4Tz1pV5cK7nL0yQ6h');
  static final iv = en.IV.fromLength(16);

  static String getDuration(DateTime? val) {
    final duration = DateTime.now().difference(val ?? DateTime.now());
    var min = duration.inMinutes;
    var hour = duration.inHours;
    var days = duration.inDays;
    var month = days ~/ 30;
    var year = days ~/ 365;
    if (min.isNegative) {
      min = min * -1;
    }
    if (hour.isNegative) {
      hour = hour * -1;
    }
    if (days.isNegative) {
      days = days * -1;
    }
    if (month.isNegative) {
      month = month * -1;
    }
    if (year.isNegative) {
      year = year * -1;
    }

    if (min < 60) {
      return '$min Mins Ago';
    }
    if (hour < 60) {
      return '$hour Hrs Ago';
    }
    if (days < 30) {
      return '$days Days Ago';
    }
    if (month < 12) {
      return '$days Days Ago';
    }

    return '$year Years Ago';
  }

  static String checkClosed(String? startTime, String? endTime) {
    if (startTime != null && endTime != null) {
      return '${timeFormat(startTime)} - ${timeFormat(endTime)}';
    } else {
      return 'Closed';
    }
  }

  static String timeFormat(String val) {
    final hour = int.parse(val.split(':')[0]);
    final min = int.parse(val.split(':')[1]);
    return TimeOfDay(hour: hour, minute: min).format(MyBackyardApp.appRouter.navigatorKey.currentContext!);
  }

  static const String mDY = 'MM-dd-yyyy';
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  static const googleApiKey = 'AIzaSyBmaS0B0qwokES4a_CiFNVkVJGkimXkNsk';

  static Future<ByteData> getCircularImageByteData(ui.Image image) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(
      pictureRecorder,
      Rect.fromPoints(const Offset(0, 0), Offset(image.width.toDouble(), image.height.toDouble())),
    );

    // Draw the image inside a circular clip
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = CustomColors.primaryGreenColor
          ..strokeWidth = 15.0;

    final radius = image.width / 2;

    // Clip the canvas to a circular shape
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(image.width / 2, image.height / 2), radius: radius)),
    );

    // Draw the image inside the circular path
    canvas.drawImage(image, const Offset(0, 0), paint);

    // Draw the stroke (circle border) around the clipped area
    canvas.drawCircle(Offset(image.width / 2, image.height / 2), radius, paint);

    // Convert the canvas to an image and then to ByteData
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!;
  }

  static Future<Uint8List?> loadNetWorkImage(String path) async {
    final completer = Completer<ImageInfo>();
    final image = CachedNetworkImageProvider(path);

    image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  static Future<BitmapDescriptor> getNetworkImageMarker(String imageUrl) async {
    final image = await loadNetWorkImage(imageUrl);
    final markerImageCodec = await ui.instantiateImageCodec(
      image!.buffer.asUint8List(),
      targetHeight: 100,
      targetWidth: 100,
    );
    final frameInfo = await markerImageCodec.getNextFrame();
    final byteData = await getCircularImageByteData(frameInfo.image);
    await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedImageMarker = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageMarker);
  }

  static Future<BitmapDescriptor> createBitmapDescriptorWithText(String text, {bool smaller = false}) async {
    final random = Random(text.hashCode);
    final color = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0, 0), smaller ? const Offset(50, 50) : const Offset(100, 100)),
    );

    // Paint for the circle
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw the circle
    canvas.drawCircle(smaller ? const Offset(25, 25) : const Offset(50, 50), 50, paint);

    // Paint for the text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.white, fontSize: smaller ? 30 : 40, fontWeight: FontWeight.bold),
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      smaller
          ? Offset(25 - textPainter.width / 2, 25 - textPainter.height / 2)
          : Offset(50 - textPainter.width / 2, 50 - textPainter.height / 2),
    );

    // Convert the canvas to image bytes
    final picture = recorder.endRecording();
    final img = smaller ? await picture.toImage(50, 50) : await picture.toImage(100, 100);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes); // Return the bitmap descriptor
  }

  FutureOr<TimeOfDay?> selectTime(BuildContext context) async {
    final pickedTime = await DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      onChanged: (date) {},
      onConfirm: (date) {},
      theme: picker.DatePickerTheme(doneStyle: TextStyle(color: CustomColors.primaryGreenColor, fontSize: 16)),
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
    if (pickedTime != null) {
      return TimeOfDay.fromDateTime(pickedTime);
    }
    return null;
  }
}
