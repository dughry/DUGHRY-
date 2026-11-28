part of dughry;

class DughryApp extends StatelessWidget {
  const DughryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دوجري | DUGHRY',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DughryColors.royalNavyDeep,
        colorScheme: const ColorScheme.dark(
          primary: DughryColors.silverPrimary,
          secondary: DughryColors.silverPrimary,
          error: DughryColors.crimsonRed,
          surface: DughryColors.royalNavyMid,
          onPrimary: DughryColors.royalNavyDeep,
          onSurface: DughryColors.textLight,
        ),
        fontFamily: 'Cairo',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: DughryColors.textLight,
            fontWeight: FontWeight.w800,
          ),
          titleLarge: TextStyle(
            color: DughryColors.textLight,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            color: DughryColors.textLight,
          ),
          bodyMedium: TextStyle(
            color: DughryColors.textSecondary,
          ),
        ),
      ),
      home: RoleDashboardScreen(
        initialRole: UserRoleType.customer,
        onLocationUpdated: () {},
      ),
    );
  }
}
