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
          primary: DughryColors.goldPrimary,
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
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  int unreadNotificationsCount = 3;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DughryColors.royalNavyMid,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_rounded,
                      color: DughryColors.goldPrimary,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'إشعارات دوجري | DUGHRY',
                        style: TextStyle(
                          color: DughryColors.textLight,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => unreadNotificationsCount = 0);
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'تحديد الكل كمقروء',
                        style: TextStyle(
                          color: DughryColors.goldLight,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: DughryColors.borderSubtle),
                const _NotificationTile(
                  title: 'مرحباً بك في المنيا - مركز العدوة',
                  subtitle: 'الخدمات متاحة الآن في مركز العدوة، والقاهرة والجيزة.',
                  badgeText: 'جديد',
                  badgeColor: DughryColors.goldPrimary,
                ),
                const _NotificationTile(
                  title: 'تحديث منظومة الفنيين والأطباء',
                  subtitle: 'حجز فوري ومباشر بأعلى معايير الجودة.',
                  badgeText: 'تنبيه',
                  badgeColor: DughryColors.crimsonRed,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openLocationSelectorSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DughryColors.royalNavyMid,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return _GovernorateGpsSheet(
          onLocationChanged: () {
            setState(() {});
          },
        );
      },
    );
  }

  void _onQuickRoleTap(UserRoleType role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoleDashboardScreen(
          initialRole: role,
          onLocationUpdated: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final usableHeight = size.height - padding.top - padding.bottom;
    final landmarkHeight = (usableHeight * 0.25).clamp(150.0, 225.0).toDouble();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: DughryColors.royalBackgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _openLocationSelectorSheet,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: DughryColors.royalNavyCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: DughryColors.borderSubtle,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: DughryColors.goldPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${DughryLocationStore.currentGovernorate.nameAr} - ${DughryLocationStore.selectedCenter}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: DughryColors.textLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: DughryColors.silverMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: _openNotificationsSheet,
                            style: IconButton.styleFrom(
                              backgroundColor: DughryColors.royalNavyCard,
                              side: const BorderSide(
                                color: DughryColors.borderSubtle,
                              ),
                            ),
                            icon: const Icon(
                              Icons.notifications_rounded,
                              color: DughryColors.goldLight,
                            ),
                          ),
                          if (unreadNotificationsCount > 0)
                            Positioned(
                              top: -2,
                              left: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: DughryColors.crimsonRed,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unreadNotificationsCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: landmarkHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            DughryColors.royalNavySurface,
                            DughryColors.royalNavyCard,
                          ],
                        ),
                        border: Border.all(
                          color: DughryColors.borderSubtle,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: DughryColors.goldGradient,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'دوجري | DUGHRY',
                              style: TextStyle(
                                color: DughryColors.royalNavyDeep,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'كل احتياجاتك في مكان واحد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: DughryColors.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'تجارة، خدمات فنية، أطباء وطلبات مباشرة في محافظتك',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: DughryColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'اختر دورك للدخول السريع',
                    style: TextStyle(
                      color: DughryColors.goldLight,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: UserRoleType.values.map((role) {
                      return SizedBox(
                        width: (math.max(260.0, size.width - 46) / 2).toDouble(),
                        child: ElevatedButton.icon(
                          onPressed: () => _onQuickRoleTap(role),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: role == UserRoleType.admin
                                ? DughryColors.crimsonDark
                                : DughryColors.royalNavyCard,
                            foregroundColor: DughryColors.textLight,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: DughryColors.borderSubtle,
                              ),
                            ),
                          ),
                          icon: Icon(
                            role.icon,
                            color: DughryColors.goldPrimary,
                          ),
                          label: Text(
                            role.labelAr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
