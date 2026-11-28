library dughry;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show PlatformDispatcher;
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
// ignore: deprecated_member_use
import 'package:flutter_localizations/flutter_localizations.dart';

part 'core/theme.dart';
part 'core/location.dart';
part 'app/shell.dart';
part 'features/accounts.dart';
part 'features/catalog.dart';
part 'features/dashboard.dart';
part 'features/location_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Startup diagnostics: keep the original app flow and report uncaught errors.
  debugPrint('DUGHRY_DIAGNOSTIC: main() entered');

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('DUGHRY_FLUTTER_ERROR: ${details.exception}');
    if (details.stack != null) {
      debugPrint('DUGHRY_FLUTTER_STACK: ${details.stack}');
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('DUGHRY_PLATFORM_ERROR: $error');
    debugPrint('DUGHRY_PLATFORM_STACK: $stack');
    return false;
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: DughryColors.royalNavyDeep,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DughryApp());
}
