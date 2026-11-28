library dughry;

import 'dart:math' as math;
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
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
