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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _introController;
  Timer? _introTimer;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _introTimer = Timer(const Duration(seconds: 5), _openCustomerHome);
  }

  void _openCustomerHome() {
    if (!mounted) return;
    _introTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoleDashboardScreen(
          initialRole: UserRoleType.customer,
          onLocationUpdated: () {},
        ),
      ),
    );
  }

  void _openRole(UserRoleType role) {
    if (!mounted) return;
    _introTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoleDashboardScreen(
          initialRole: role,
          onLocationUpdated: () {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: DughryColors.royalBackgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _introController,
              curve: Curves.easeOutCubic,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'دوجري | DUGHRY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DughryColors.silverBright,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'كل احتياجاتك في مكان واحد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DughryColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _EgyptLandmarkHero(),
                  const SizedBox(height: 22),
                  const Text(
                    'مرحباً بك في دوجري',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DughryColors.silverBright,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'تسوق، خدمات، حجوزات وأكثر من مكان واحد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DughryColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 9,
                    runSpacing: 10,
                    children: UserRoleType.values.map((role) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 58) / 2,
                        child: OutlinedButton.icon(
                          onPressed: () => _openRole(role),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DughryColors.silverBright,
                            backgroundColor: role == UserRoleType.admin
                                ? DughryColors.crimsonDark
                                : DughryColors.royalNavyCard,
                            side: const BorderSide(
                              color: DughryColors.borderSubtle,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(
                            role.icon,
                            color: DughryColors.silverPrimary,
                            size: 19,
                          ),
                          label: Text(
                            role.labelAr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _openCustomerHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DughryColors.silverPrimary,
                      foregroundColor: DughryColors.royalNavyDeep,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'ابدأ التجربة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سيتم الانتقال تلقائياً إلى الصفحة الرئيسية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DughryColors.silverMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EgyptLandmarkHero extends StatelessWidget {
  const _EgyptLandmarkHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 218,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: DughryColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _EgyptLandmarkPainter()),
          Positioned(
            right: 16,
            top: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xAA07142B),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: DughryColors.borderSubtle),
              ),
              child: const Text(
                'صُنع ليجمع احتياجاتك',
                style: TextStyle(
                  color: DughryColors.silverBright,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 16,
            bottom: 13,
            child: Text(
              'EGYPT  •  DUGHRY',
              style: TextStyle(
                color: DughryColors.silverBright,
                fontSize: 10,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EgyptLandmarkPainter extends CustomPainter {
  const _EgyptLandmarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF173B69),
          Color(0xFF315B7C),
          Color(0xFFB58B68),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final sunPaint = Paint()..color = const Color(0xFFE8D5B2).withValues(alpha: 0.78);
    canvas.drawCircle(Offset(w * 0.19, h * 0.34), 23, sunPaint);

    final farGround = Paint()..color = const Color(0xFF9C8066);
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.77, w, h * 0.23),
      farGround,
    );

    final pyramidPaint = Paint()..color = const Color(0xFFD7C09B);
    final pyramidShadow = Paint()..color = const Color(0xFF9E8465);
    final leftPyramid = Path()
      ..moveTo(w * 0.06, h * 0.79)
      ..lineTo(w * 0.29, h * 0.27)
      ..lineTo(w * 0.48, h * 0.79)
      ..close();
    canvas.drawPath(leftPyramid, pyramidPaint);
    final leftShade = Path()
      ..moveTo(w * 0.29, h * 0.27)
      ..lineTo(w * 0.48, h * 0.79)
      ..lineTo(w * 0.29, h * 0.79)
      ..close();
    canvas.drawPath(leftShade, pyramidShadow);

    final rightPyramid = Path()
      ..moveTo(w * 0.39, h * 0.79)
      ..lineTo(w * 0.57, h * 0.42)
      ..lineTo(w * 0.72, h * 0.79)
      ..close();
    canvas.drawPath(rightPyramid, pyramidPaint);
    final rightShade = Path()
      ..moveTo(w * 0.57, h * 0.42)
      ..lineTo(w * 0.72, h * 0.79)
      ..lineTo(w * 0.57, h * 0.79)
      ..close();
    canvas.drawPath(rightShade, pyramidShadow);

    final towerPaint = Paint()
      ..color = const Color(0xFF102B4A)
      ..style = PaintingStyle.fill;
    final tower = Path()
      ..moveTo(w * 0.82, h * 0.79)
      ..quadraticBezierTo(w * 0.845, h * 0.48, w * 0.86, h * 0.29)
      ..lineTo(w * 0.89, h * 0.29)
      ..quadraticBezierTo(w * 0.91, h * 0.48, w * 0.94, h * 0.79)
      ..close();
    canvas.drawPath(tower, towerPaint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.875, h * 0.29),
        width: w * 0.055,
        height: 9,
      ),
      towerPaint,
    );
    final antenna = Paint()
      ..color = const Color(0xFFE4D8C3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.875, h * 0.25),
      Offset(w * 0.875, h * 0.13),
      antenna,
    );
    final lattice = Paint()
      ..color = const Color(0xFF8EA5B8).withValues(alpha: 0.65)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = h * (0.38 + i * 0.075);
      canvas.drawLine(Offset(w * 0.84, y), Offset(w * 0.91, y), lattice);
    }

    final foreground = Paint()..color = const Color(0xFF07142B);
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.91, w, h * 0.09),
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _EgyptLandmarkPainter oldDelegate) => false;
}
