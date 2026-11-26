import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class DughryColors {
  static const Color royalNavyDeep = Color(0xFF07142B);
  static const Color royalNavyMid = Color(0xFF0D254C);
  static const Color royalNavyCard = Color(0xFF122E5C);
  static const Color royalNavySurface = Color(0xFF17386E);

  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3D778);
  static const Color goldDark = Color(0xFF9E7B1B);

  static const Color silverPrimary = Color(0xFFD0D7E2);
  static const Color silverBright = Color(0xFFF4F7FB);
  static const Color silverMuted = Color(0xFF8C9BB0);

  static const Color crimsonRed = Color(0xFFE11D48);
  static const Color crimsonDark = Color(0xFF9F1239);

  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color borderSubtle = Color(0x26D4AF37);
  static const Color successGreen = Color(0xFF10B981);

  static const LinearGradient royalBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      royalNavyMid,
      royalNavyDeep,
      Color(0xFF050E1E),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      goldLight,
      goldPrimary,
      goldDark,
    ],
  );
}

enum UserRoleType {
  customer('عميل', Icons.person_rounded),
  merchant('تاجر', Icons.storefront_rounded),
  technician('فني', Icons.handyman_rounded),
  doctor('دكتور', Icons.medical_services_rounded),
  admin('إدارة', Icons.admin_panel_settings_rounded);

  final String labelAr;
  final IconData icon;
  const UserRoleType(this.labelAr, this.icon);
}

class GovernorateItem {
  final String id;
  final String nameAr;
  final bool isAvailable;
  final List<String> availableCenters;
  final String comingSoonNote;
  final double lat;
  final double lng;

  const GovernorateItem({
    required this.id,
    required this.nameAr,
    required this.isAvailable,
    this.availableCenters = const [],
    this.comingSoonNote = 'قريباً',
    required this.lat,
    required this.lng,
  });
}

class DughryLocationStore {
  static const List<GovernorateItem> governorates = [
    GovernorateItem(
      id: 'cairo',
      nameAr: 'القاهرة',
      isAvailable: true,
      availableCenters: ['مدينة نصر', 'المعادي', 'مصر الجديدة', 'وسط البلد', 'التجمع الخامس'],
      lat: 30.0444,
      lng: 31.2357,
    ),
    GovernorateItem(
      id: 'giza',
      nameAr: 'الجيزة',
      isAvailable: true,
      availableCenters: ['الدقي', 'المهندسين', 'الهرم وفيصل', 'الشيخ زايد', '6 أكتوبر'],
      lat: 30.0131,
      lng: 31.2089,
    ),
    GovernorateItem(
      id: 'minya',
      nameAr: 'المنيا',
      isAvailable: true,
      availableCenters: ['مركز العدوة'],
      comingSoonNote: 'مركز العدوة متاحة حالياً - باقي المراكز قريباً',
      lat: 28.6095,
      lng: 30.7950,
    ),
    GovernorateItem(
      id: 'alexandria',
      nameAr: 'الإسكندرية',
      isAvailable: false,
      lat: 31.2001,
      lng: 29.9187,
    ),
    GovernorateItem(
      id: 'dakahlia',
      nameAr: 'الدقهلية',
      isAvailable: false,
      lat: 31.0409,
      lng: 31.3785,
    ),
    GovernorateItem(
      id: 'sharqia',
      nameAr: 'الشرقية',
      isAvailable: false,
      lat: 30.7327,
      lng: 31.7195,
    ),
    GovernorateItem(
      id: 'gharbia',
      nameAr: 'الغربية',
      isAvailable: false,
      lat: 30.8754,
      lng: 31.0335,
    ),
    GovernorateItem(
      id: 'qalyubia',
      nameAr: 'القليوبية',
      isAvailable: false,
      lat: 30.3292,
      lng: 31.2168,
    ),
    GovernorateItem(
      id: 'asyut',
      nameAr: 'أسيوط',
      isAvailable: false,
      lat: 27.1783,
      lng: 31.1859,
    ),
    GovernorateItem(
      id: 'sohag',
      nameAr: 'سوهاج',
      isAvailable: false,
      lat: 26.5569,
      lng: 31.6948,
    ),
  ];

  static String selectedGovernorateId = 'minya';
  static String selectedCenter = 'مركز العدوة';
  static bool isGpsSynced = true;

  static GovernorateItem get currentGovernorate {
    return governorates.firstWhere(
      (g) => g.id == selectedGovernorateId,
      orElse: () => governorates[2],
    );
  }
}class DughryApp extends StatelessWidget {
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
  }void _openLocationSelectorSheet() {
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
    final landmarkHeight = (usableHeight * 0.25).clamp(150.0, 225.0);

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
                        width: (math.max(260.0, size.width - 46)) / 2,
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
}enum RegistrationStatus {
  active('نشط ومفعل فوراً'),
  pendingAdmin('بانتظار موافقة الإدارة'),
  rejected('مرفوض - يرجى مراجعة البيانات');

  final String labelAr;
  const RegistrationStatus(this.labelAr);
}

class RegistrationRequestRecord {
  final String id;
  final UserRoleType role;
  final String fullName;
  final String phone;
  final String governorateAr;
  final String addressOrCenter;
  final String primaryDetail;
  final String secondaryDetail;
  final int gracePeriodDays;
  final RegistrationStatus status;
  final DateTime createdAt;

  RegistrationRequestRecord({
    required this.id,
    required this.role,
    required this.fullName,
    required this.phone,
    required this.governorateAr,
    required this.addressOrCenter,
    required this.primaryDetail,
    required this.secondaryDetail,
    this.gracePeriodDays = 0,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class DughryPortalStore {
  static final List<RegistrationRequestRecord> records = [
    RegistrationRequestRecord(
      id: 'REQ-101',
      role: UserRoleType.merchant,
      fullName: 'محمود عبد الله',
      phone: '01012345678',
      governorateAr: 'المنيا',
      addressOrCenter: 'مركز العدوة - شارع الجمهورية',
      primaryDetail: 'مستلزمات منزلية وأجهزة',
      secondaryDetail: 'قسم المستلزمات المنزلية',
      gracePeriodDays: 30,
      status: RegistrationStatus.pendingAdmin,
    ),
    RegistrationRequestRecord(
      id: 'REQ-102',
      role: UserRoleType.doctor,
      fullName: 'د. سارة منصور',
      phone: '01122334455',
      governorateAr: 'المنيا',
      addressOrCenter: 'مركز العدوة - عيادة السلام الطبية',
      primaryDetail: 'باطنة وجهاز هضمي',
      secondaryDetail: 'قيد النقابة: 184920',
      gracePeriodDays: 0,
      status: RegistrationStatus.pendingAdmin,
    ),
    RegistrationRequestRecord(
      id: 'REQ-103',
      role: UserRoleType.technician,
      fullName: 'كريم حسن علي',
      phone: '01298765432',
      governorateAr: 'القاهرة',
      addressOrCenter: 'مدينة نصر - الحي السابع',
      primaryDetail: 'صيانة تكييف وتبريد',
      secondaryDetail: 'خبرة 7 سنوات - نطاق مدينة نصر ومصر الجديدة',
      gracePeriodDays: 0,
      status: RegistrationStatus.active,
    ),
  ];

  static RegistrationRequestRecord? latestCustomerSession;
  static final List<String> adminPasscodes = ['1234', 'dughry2026'];

  static bool verifyAdminPasscode(String input) {
    return adminPasscodes.contains(input.trim());
  }

  static void addRequest(RegistrationRequestRecord record) {
    records.insert(0, record);
    if (record.role == UserRoleType.customer) {
      latestCustomerSession = record;
    }
  }

  static void updateStatus(String id, RegistrationStatus newStatus) {
    final idx = records.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final old = records[idx];
      records[idx] = RegistrationRequestRecord(
        id: old.id,
        role: old.role,
        fullName: old.fullName,
        phone: old.phone,
        governorateAr: old.governorateAr,
        addressOrCenter: old.addressOrCenter,
        primaryDetail: old.primaryDetail,
        secondaryDetail: old.secondaryDetail,
        gracePeriodDays: old.gracePeriodDays,
        status: newStatus,
        createdAt: old.createdAt,
      );
    }
  }
}

class RoleRegistrationForm extends StatefulWidget {
  final UserRoleType role;
  final VoidCallback onSubmitted;

  const RoleRegistrationForm({
    super.key,
    required this.role,
    required this.onSubmitted,
  });

  @override
  State<RoleRegistrationForm> createState() => _RoleRegistrationFormState();
}

class _RoleRegistrationFormState extends State<RoleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _activityOrSpecCtrl = TextEditingController();
  final _secondaryCtrl = TextEditingController();

  String _selectedGov = DughryLocationStore.currentGovernorate.nameAr;
  String _merchantCategory = 'مواد غذائية وسوبر ماركت';
  int _graceDays = 15;
  int _experienceYears = 3;

  final List<String> _merchantCategories = [
    'مواد غذائية وسوبر ماركت',
    'مستلزمات منزلية وأجهزة',
    'ملابس وأحذية',
    'مواد بناء وتشطيبات',
    'إلكترونيات وهواتف',
  ];

  final List<String> _medicalSpecialties = [
    'طب عام وأسرة',
    'باطنة وقلب',
    'أطفال وحديثي الولادة',
    'عظام وعلاج طبيعي',
    'أسنان وجراحة فم',
    'نساء وتوليد',
  ];

  final List<String> _technicianCrafts = [
    'كهرباء منازل ولوحات',
    'سباكة وصيانة صحية',
    'تكييف وتبريد',
    'نجارة وألوميتال',
    'صيانة أجهزة منزلية وموبايل',
  ];

  @override
  void initState() {
    super.initState();
    _addressCtrl.text = DughryLocationStore.selectedCenter;
    if (widget.role == UserRoleType.doctor) {
      _activityOrSpecCtrl.text = _medicalSpecialties.first;
    } else if (widget.role == UserRoleType.technician) {
      _activityOrSpecCtrl.text = _technicianCrafts.first;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _activityOrSpecCtrl.dispose();
    _secondaryCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isCustomer = widget.role == UserRoleType.customer;
    final primaryDetail = switch (widget.role) {
      UserRoleType.merchant => _merchantCategory,
      UserRoleType.doctor => _activityOrSpecCtrl.text.trim().isEmpty
          ? _medicalSpecialties.first
          : _activityOrSpecCtrl.text.trim(),
      UserRoleType.technician => _activityOrSpecCtrl.text.trim().isEmpty
          ? _technicianCrafts.first
          : _activityOrSpecCtrl.text.trim(),
      UserRoleType.customer => 'حساب عميل مباشر',
      UserRoleType.admin => 'إدارة المنصة',
    };

    final secondaryDetail = switch (widget.role) {
      UserRoleType.merchant => _activityOrSpecCtrl.text.trim().isEmpty
          ? 'نشاط تجاري معتمد في $_selectedGov'
          : _activityOrSpecCtrl.text.trim(),
      UserRoleType.doctor => _secondaryCtrl.text.trim().isEmpty
          ? 'قيد نقابة الأطباء'
          : _secondaryCtrl.text.trim(),
      UserRoleType.technician =>
        'خبرة $_experienceYears سنوات - ${_secondaryCtrl.text.trim().isEmpty ? _addressCtrl.text.trim() : _secondaryCtrl.text.trim()}',
      UserRoleType.customer => _secondaryCtrl.text.trim(),
      UserRoleType.admin => _secondaryCtrl.text.trim(),
    };

    final record = RegistrationRequestRecord(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      role: widget.role,
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      governorateAr: _selectedGov,
      addressOrCenter: _addressCtrl.text.trim(),
      primaryDetail: primaryDetail,
      secondaryDetail: secondaryDetail,
      gracePeriodDays: widget.role == UserRoleType.merchant ? _graceDays : 0,
      status: isCustomer
          ? RegistrationStatus.active
          : RegistrationStatus.pendingAdmin,
    );

    DughryPortalStore.addRequest(record);
    widget.onSubmitted();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: DughryColors.royalNavyCard,
        content: Text(
          isCustomer
              ? 'تم تفعيل حساب العميل بنجاح'
              : 'تم إرسال طلب التسجيل (${record.status.labelAr})',
          style: const TextStyle(color: DughryColors.textLight),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final govNames = DughryLocationStore.governorates
        .map((g) => g.nameAr)
        .toSet()
        .toList();
    if (!govNames.contains(_selectedGov) && govNames.isNotEmpty) {
      _selectedGov = govNames.first;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تسجيل حساب ${widget.role.labelAr}',
            style: const TextStyle(
              color: DughryColors.goldLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'الاسم الكامل',
              filled: true,
              fillColor: DughryColors.royalNavyCard,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'يرجى إدخال الاسم' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              filled: true,
              fillColor: DughryColors.royalNavyCard,
            ),
            validator: (v) =>
                (v == null || v.trim().length < 8) ? 'رقم هاتف غير صحيح' : null,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedGov,
            dropdownColor: DughryColors.royalNavyCard,
            decoration: const InputDecoration(
              labelText: 'المحافظة',
              filled: true,
              fillColor: DughryColors.royalNavyCard,
            ),
            items: govNames
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedGov = val);
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressCtrl,
            decoration: const InputDecoration(
              labelText: 'المركز أو العنوان التفصيلي',
              filled: true,
              fillColor: DughryColors.royalNavyCard,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'يرجى إدخال العنوان' : null,
          ),
          if (widget.role == UserRoleType.merchant) ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _merchantCategory,
              dropdownColor: DughryColors.royalNavyCard,
              decoration: const InputDecoration(
                labelText: 'تصنيف النشاط التجاري',
                filled: true,
                fillColor: DughryColors.royalNavyCard,
              ),
              items: _merchantCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _merchantCategory = val);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('فترة سماح مجانية (بالأيام):')),
                ChoiceChip(
                  label: const Text('15 يوم'),
                  selected: _graceDays == 15,
                  onSelected: (_) => setState(() => _graceDays = 15),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('30 يوم'),
                  selected: _graceDays == 30,
                  onSelected: (_) => setState(() => _graceDays = 30),
                ),
              ],
            ),
          ],
          if (widget.role == UserRoleType.doctor ||
              widget.role == UserRoleType.technician) ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: _activityOrSpecCtrl,
              decoration: InputDecoration(
                labelText: widget.role == UserRoleType.doctor
                    ? 'التخصص الطبي'
                    : 'الحرفة / مجال الصيانة',
                filled: true,
                fillColor: DughryColors.royalNavyCard,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _secondaryCtrl,
              decoration: InputDecoration(
                labelText: widget.role == UserRoleType.doctor
                    ? 'رقم القيد أو بيانات العيادة'
                    : 'نطاق العمل أو ملاحظات الخبرة',
                filled: true,
                fillColor: DughryColors.royalNavyCard,
              ),
            ),
          ],
          if (widget.role == UserRoleType.technician) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('سنوات الخبرة: '),
                Expanded(
                  child: Slider(
                    value: _experienceYears.toDouble(),
                    min: 1,
                    max: 25,
                    divisions: 24,
                    label: '$_experienceYears',
                    onChanged: (v) =>
                        setState(() => _experienceYears = v.round()),
                  ),
                ),
                Text('$_experienceYears سنة'),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: DughryColors.goldPrimary,
              foregroundColor: DughryColors.royalNavyDeep,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'إرسال الطلب',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}class DughryCategoryItem {
  final String id;
  final String titleAr;
  final IconData icon;
  final Color accentColor;
  final String groupType;

  const DughryCategoryItem({
    required this.id,
    required this.titleAr,
    required this.icon,
    required this.accentColor,
    required this.groupType,
  });
}

class DughryCatalogProduct {
  final String id;
  final String nameAr;
  final String categoryId;
  final String categoryTitleAr;
  final String governorateAr;
  final double price;
  final String unitLabel;
  final IconData icon;
  final String badge;

  const DughryCatalogProduct({
    required this.id,
    required this.nameAr,
    required this.categoryId,
    required this.categoryTitleAr,
    required this.governorateAr,
    required this.price,
    required this.unitLabel,
    required this.icon,
    required this.badge,
  });
}

class DughryCartEntry {
  final DughryCatalogProduct product;
  int quantity;

  DughryCartEntry({
    required this.product,
    this.quantity = 1,
  });

  double get lineTotal => product.price * quantity;
}

class DughryOrderRecord {
  final String orderId;
  final DateTime createdAt;
  final String governorateAr;
  final String summaryText;
  final double totalAmount;
  final String statusText;

  const DughryOrderRecord({
    required this.orderId,
    required this.createdAt,
    required this.governorateAr,
    required this.summaryText,
    required this.totalAmount,
    required this.statusText,
  });
}

class DughryAppStateStore {
  static const List<DughryCategoryItem> categories = [
    DughryCategoryItem(
      id: 'groceries',
      titleAr: 'سوبر ماركت',
      icon: Icons.shopping_cart_rounded,
      accentColor: Color(0xFF15803D),
      groupType: 'منتجات',
    ),
    DughryCategoryItem(
      id: 'home_appliances',
      titleAr: 'مستلزمات المنزل',
      icon: Icons.kitchen_rounded,
      accentColor: Color(0xFFD4AF37),
      groupType: 'منتجات',
    ),DughryCategoryItem(
      id: 'fashion',
      titleAr: 'أزياء وموضة',
      icon: Icons.checkroom_rounded,
      accentColor: Color(0xFFBE123C),
      groupType: 'منتجات',
    ),
    DughryCategoryItem(
      id: 'electronics',
      titleAr: 'إلكترونيات',
      icon: Icons.devices_other_rounded,
      accentColor: Color(0xFF1D4ED8),
      groupType: 'منتجات',
    ),
    DughryCategoryItem(
      id: 'doctors',
      titleAr: 'عيادات وأطباء',
      icon: Icons.medical_services_rounded,
      accentColor: Color(0xFF0D9488),
      groupType: 'أطباء',
    ),
    DughryCategoryItem(
      id: 'pharmacy_labs',
      titleAr: 'تحاليل وصحة',
      icon: Icons.biotech_rounded,
      accentColor: Color(0xFF7C3AED),
      groupType: 'أطباء',
    ),
    DughryCategoryItem(
      id: 'maintenance',
      titleAr: 'صيانة وفنيون',
      icon: Icons.handyman_rounded,
      accentColor: Color(0xFFB45309),
      groupType: 'صيانة',
    ),
    DughryCategoryItem(
      id: 'ac_plumbing',
      titleAr: 'تكييف وسباكة',
      icon: Icons.plumbing_rounded,
      accentColor: Color(0xFF0369A1),
      groupType: 'صيانة',
    ),
    DughryCategoryItem(
      id: 'delivery',
      titleAr: 'توصيل سريع',
      icon: Icons.delivery_dining_rounded,
      accentColor: Color(0xFFE11D48),
      groupType: 'توصيل',
    ),
    DughryCategoryItem(
      id: 'shipping',
      titleAr: 'شحن وطلبات',
      icon: Icons.local_shipping_rounded,
      accentColor: Color(0xFF4338CA),
      groupType: 'توصيل',
    ),
    DughryCategoryItem(
      id: 'home_services',
      titleAr: 'خدمات منزلية',
      icon: Icons.cleaning_services_rounded,
      accentColor: Color(0xFF0F766E),
      groupType: 'خدمات',
    ),
    DughryCategoryItem(
      id: 'building',
      titleAr: 'مواد وتشطيب',
      icon: Icons.foundation_rounded,
      accentColor: Color(0xFF92400E),
      groupType: 'خدمات',
    ),
  ];
static const List<DughryCatalogProduct> sampleProducts = [
    DughryCatalogProduct(
      id: 'PRD-1',
      nameAr: 'أرز مصري فاخر 5 كجم',
      categoryId: 'groceries',
      categoryTitleAr: 'سوبر ماركت',
      governorateAr: 'القاهرة',
      price: 165.0,
      unitLabel: 'لكل 5 كجم',
      icon: Icons.shopping_bag_rounded,
      badge: 'الأكثر طلباً',
    ),
    DughryCatalogProduct(
      id: 'PRD-2',
      nameAr: 'خلاط كهربائي 900 واط',
      categoryId: 'home_appliances',
      categoryTitleAr: 'أجهزة كهربائية',
      governorateAr: 'الجيزة',
      price: 2450.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.soup_kitchen_rounded,
      badge: 'عرض دوجري',
    ),
    DughryCatalogProduct(
      id: 'PRD-3',
      nameAr: 'كشف جراحة وعظام',
      categoryId: 'doctors',
      categoryTitleAr: 'عيادات ودكاترة',
      governorateAr: 'المنيا',
      price: 300.0,
      unitLabel: 'لكل كشف',
      icon: Icons.medical_services_rounded,
      badge: 'حجز فوري',
    ),
    DughryCatalogProduct(
      id: 'PRD-4',
      nameAr: 'صيانة وتنظيف تكييف سبليت',
      categoryId: 'technicians',
      categoryTitleAr: 'عمال فنيين',
      governorateAr: 'القاهرة',
      price: 450.0,
      unitLabel: 'لكل زيارة',
      icon: Icons.home_repair_service_rounded,
      badge: 'متاح اليوم',
    ),
  ];
}

class RoleDashboardScreen extends StatefulWidget {

  const RoleDashboardScreen({
    super.key,
    required this.initialRole,
    required this.onLocationUpdated,
  });

  @override
  State<RoleDashboardScreen> createState() => _RoleDashboardScreenState();
}

class _RoleDashboardScreenState extends State<RoleDashboardScreen> {
  late UserRoleType _activeRole;
  int _bottomNavIndex = 0;
  String? _selectedCategoryFilterId;
  bool _adminUnlocked = false;
  final _adminPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeRole = widget.initialRole;
    _adminUnlocked = _activeRole == UserRoleType.admin ? false : false;
  }

  @override
  void dispose() {
    _adminPassCtrl.dispose();
    super.dispose();
  }

  Widget _buildCurrentTabBody(GovernorateItem gov) {
    switch (_bottomNavIndex) {
      case 0:
        return _HomeTabView(
          gov: gov,
          selectedCategoryId: _selectedCategoryFilterId,
          onSelectCategory: (catId) {
            setState(() {
              _selectedCategoryFilterId =
                  (_selectedCategoryFilterId == catId) ? null : catId;
            });
          },
          onAddToCart: (prod) {
            DughryAppStateStore.addToCart(prod);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: DughryColors.royalNavyCard,
                content: Text(
                  'تمت إضافة ${prod.nameAr} إلى السلة',
                  style: const TextStyle(color: DughryColors.textLight),
                ),
              ),
            );
          },
        );
      case 1:
        return _CategoriesTabView(
          selectedCategoryId: _selectedCategoryFilterId,
          onPickCategory: (catId) {
            setState(() {
              _selectedCategoryFilterId = catId;
              _bottomNavIndex = 0;
            });
          },
        );
      case 2:
        return _CartTabView(
          locationLabel:
              '${gov.nameAr} - ${DughryLocationStore.selectedCenter}',
          onChanged: () => setState(() {}),
          onOrderPlaced: () => setState(() => _bottomNavIndex = 3),
        );
      case 3:
        return const _OrdersTabView();
      case 4:
      default:
        return _AccountAndAdminTabView(
          activeRole: _activeRole,
          onRoleChanged: (newRole) => setState(() => _activeRole = newRole),
          adminUnlocked: _adminUnlocked,
          adminPassCtrl: _adminPassCtrl,
          onUnlockAdmin: () {
            if (DughryPortalStore.verifyAdminPasscode(_adminPassCtrl.text)) {
              setState(() => _adminUnlocked = true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: DughryColors.crimsonDark,
                  content: Text('رمز الدخول الإداري غير صحيح'),
                ),
              );
            }
          },
          onRefresh: () => setState(() {}),
        );
    }
  }@override
  Widget build(BuildContext context) {
    final gov = DughryLocationStore.currentGovernorate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DughryColors.royalNavyDeep,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_forward_rounded,
            color: DughryColors.goldLight,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'دوجري | ${_activeRole.labelAr}',
              style: const TextStyle(
                color: DughryColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${gov.nameAr} -${DughryLocationStore.selectedCenter}',
              style: const TextStyle(
                color: DughryColors.goldLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: DughryColors.royalNavyMid,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                builder: (_) => _GovernorateGpsSheet(
                  onLocationChanged: () {
                    setState(() {});
                    widget.onLocationUpdated();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.my_location_rounded,
              color: DughryColors.goldPrimary,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: DughryColors.royalBackgroundGradient,
        ),
        child: _buildCurrentTabBody(gov),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (idx) => setState(() => _bottomNavIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: DughryColors.royalNavyDeep,
        selectedItemColor: DughryColors.goldPrimary,
        unselectedItemColor: DughryColors.silverMuted,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'الأقسام',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: DughryAppStateStore.totalCartCount > 0,
              label: Text('${DughryAppStateStore.totalCartCount}'),
              child: const Icon(Icons.shopping_bag_rounded),
            ),
            label: 'السلة',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'طلباتي',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

class _HomeTabView extends StatelessWidget {
  final GovernorateItem gov;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<DughryCatalogProduct> onAddToCart;

  const _HomeTabView({
    required this.gov,
    required this.selectedCategoryId,
    required this.onSelectCategory,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategoryId == null
        ? DughryAppStateStore.sampleProducts
        : DughryAppStateStore.sampleProducts
            .where((p) => p.categoryId == selectedCategoryId)
            .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: DughryColors.royalNavyCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: DughryColors.borderSubtle),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: DughryColors.goldPrimary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  gov.isAvailable
                      ? 'متاح الآن في ${gov.nameAr} (${DughryLocationStore.selectedCenter})'
                      : 'محافظة ${gov.nameAr} متاحة قريباً في دوجري',
                  style: const TextStyle(
                    color: DughryColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'أقسام دوجري السريعة',
          style: TextStyle(
            color: DughryColors.goldLight,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: DughryAppStateStore.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final cat = DughryAppStateStore.categories[index];
              final isSelected = selectedCategoryId == cat.id;
              return InkWell(
                onTap: () => onSelectCategory(cat.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DughryColors.royalNavySurface
                        : DughryColors.royalNavyCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? DughryColors.goldPrimary
                          : DughryColors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, color: cat.accentColor, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        cat.titleAr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DughryColors.textLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'العروض والخدمات المتاحة',
              style: TextStyle(
                color: DughryColors.goldLight,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (selectedCategoryId != null)
              TextButton(
                onPressed: () => onSelectCategory(selectedCategoryId!),
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(color: DughryColors.silverBright),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...filteredProducts.map(
          (prod) => Card(
            color: DughryColors.royalNavyCard,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: DughryColors.borderSubtle),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: DughryColors.royalNavySurface,
                child: Icon(prod.icon, color: DughryColors.goldPrimary),
              ),
              title: Text(
                prod.nameAr,
                style: const TextStyle(
                  color: DughryColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${prod.categoryTitleAr} • ${prod.governorateAr} •${prod.unitLabel}\n${prod.price.toStringAsFixed(0)} ج.م (${prod.badge})',
                style: const TextStyle(
                  color: DughryColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () => onAddToCart(prod),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DughryColors.goldPrimary,
                  foregroundColor: DughryColors.royalNavyDeep,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text(
                  'إضافة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoriesTabView extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String> onPickCategory;

  const _CategoriesTabView({
    required this.selectedCategoryId,
    required this.onPickCategory,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemCount: DughryAppStateStore.categories.length,
      itemBuilder: (_, index) {
        final cat = DughryAppStateStore.categories[index];
        return InkWell(
          onTap: () => onPickCategory(cat.id),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: DughryColors.royalNavyCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: DughryColors.borderSubtle),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat.icon, color: cat.accentColor, size: 32),
                const SizedBox(height: 8),
                Text(
                  cat.titleAr,
                  style: const TextStyle(
                    color: DughryColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cat.groupType,
                  style: const TextStyle(
                    color: DughryColors.silverMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartTabView extends StatelessWidget {
  final String locationLabel;
  final VoidCallback onChanged;
  final VoidCallback onOrderPlaced;

  const _CartTabView({
    required this.locationLabel,
    required this.onChanged,
    required this.onOrderPlaced,
  });

  @override
  Widget build(BuildContext context) {
    final items = DughryAppStateStore.cartItems;
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'السلة فارغة حالياً',
          style: TextStyle(color: DughryColors.textSecondary, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final entry = items[i];
              return Card(
                color: DughryColors.royalNavyCard,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    entry.product.nameAr,
                    style: const TextStyle(
                      color: DughryColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${entry.lineTotal.toStringAsFixed(0)} ج.م (الكمية: ${entry.quantity})',
                    style: const TextStyle(color: DughryColors.goldLight),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          DughryAppStateStore.decrementOrRemove(entry.product.id);
                          onChanged();
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: DughryColors.crimsonRed,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          DughryAppStateStore.addToCart(entry.product);
                          onChanged();
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: DughryColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: DughryColors.royalNavyCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'الإجمالي: ${DughryAppStateStore.cartSubtotal.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  color: DughryColors.goldLight,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final created = DughryAppStateStore.checkoutCart(locationLabel);
                  if (created != null) {
                    onChanged();
                    onOrderPlaced();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: DughryColors.royalNavySurface,
                        content: Text('تم تأكيد الطلب ${created.orderId}'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DughryColors.goldPrimary,
                  foregroundColor: DughryColors.royalNavyDeep,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'إتمام الطلب الآن',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrdersTabView extends StatelessWidget {
  const _OrdersTabView();

  @override
  Widget build(BuildContext context) {
    final orders = DughryAppStateStore.orders;
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد طلبات سابقة بعد',
          style: TextStyle(color: DughryColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final o = orders[i];
        return Card(
          color: DughryColors.royalNavyCard,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(
              'طلب #${o.orderId} •${o.statusText}',
              style: const TextStyle(
                color: DughryColors.goldLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${o.summaryText}\n${o.governorateAr} • الإجمالي: ${o.totalAmount.toStringAsFixed(0)} ج.م',
              style: const TextStyle(color: DughryColors.textSecondary, fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class _AccountAndAdminTabView extends StatefulWidget {
  final UserRoleType activeRole;
  final ValueChanged<UserRoleType> onRoleChanged;
  final bool adminUnlocked;
  final TextEditingController adminPassCtrl;
  final VoidCallback onUnlockAdmin;
  final VoidCallback onRefresh;

  const _AccountAndAdminTabView({
    required this.activeRole,
    required this.onRoleChanged,
    required this.adminUnlocked,
    required this.adminPassCtrl,
    required this.onUnlockAdmin,
    required this.onRefresh,
  });

  @override
  State<_AccountAndAdminTabView> createState() => _AccountAndAdminTabViewState();
}

class _AccountAndAdminTabViewState extends State<_AccountAndAdminTabView> {
  UserRoleType _formRole = UserRoleType.customer;

  @override
  void initState() {
    super.initState();
    _formRole = widget.activeRole == UserRoleType.admin
        ? UserRoleType.customer
        : widget.activeRole;
  }

  @override
  Widget build(BuildContext context) {
    final isAdminMode = widget.activeRole == UserRoleType.admin;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'تبديل الدور النشط',
          style: TextStyle(
            color: DughryColors.goldLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UserRoleType.values.map((r) {
            final selected = widget.activeRole == r;
            return ChoiceChip(
              label: Text(r.labelAr),
              selected: selected,
              onSelected: (_) {
                widget.onRoleChanged(r);
                if (r != UserRoleType.admin) {
                  setState(() => _formRole = r);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        if (isAdminMode) ...[
          if (!widget.adminUnlocked) ...[
            TextField(
              controller: widget.adminPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'رمز الدخول الإداري',
                filled: true,
                fillColor: DughryColors.royalNavyCard,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onUnlockAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: DughryColors.goldPrimary,
                foregroundColor: DughryColors.royalNavyDeep,
              ),
              child: const Text('دخول لوحة الإدارة'),
            ),
          ] else ...[
            const Text(
              'طلبات التسجيل والمراجعة الإدارية',
              style: TextStyle(const SizedBox(width: 8),
              DropdownButton<UserRoleType>(
                value: _formRole,
                dropdownColor: DughryColors.royalNavyCard,
                items: UserRoleType.values
                    .where((r) => r != UserRoleType.admin)
                    .map(
                      (r) => DropdownMenuItem(value: r, child: Text(r.labelAr)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _formRole = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          RoleRegistrationForm(
            role: _formRole,
            onSubmitted: () {
              widget.onRefresh();
              setState(() {});
            },
          ),
        ],
      ],
    );
  }
}

class _GovernorateGpsSheet extends StatefulWidget {
  final VoidCallback onLocationChanged;

  const _GovernorateGpsSheet({required this.onLocationChanged});

  @override
  State<_GovernorateGpsSheet> createState() => _GovernorateGpsSheetState();
}class _GovernorateGpsSheetState extends State<_GovernorateGpsSheet> {
  late String _tempGovId;
  late String _tempCenter;

  @override
  void initState() {
    super.initState();
    _tempGovId = DughryLocationStore.selectedGovernorateId;
    _tempCenter = DughryLocationStore.selectedCenter;
  }

  @override
  Widget build(BuildContext context) {
    final gov = DughryLocationStore.governorates.firstWhere(
      (g) => g.id == _tempGovId,
      orElse: () => DughryLocationStore.governorates[2],
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'اختيار المحافظة والمركز',
              style: TextStyle(
                color: DughryColors.goldLight,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tempGovId,
              dropdownColor: DughryColors.royalNavyCard,
              decoration: const InputDecoration(
                labelText: 'المحافظة',
                filled: true,
                fillColor: DughryColors.royalNavyCard,
              ),
              items: DughryLocationStore.governorates
                  .map(
                    (g) => DropdownMenuItem(
                      value: g.id,
                      child: Text(
                        g.isAvailable ? g.nameAr : '${g.nameAr} (قريباً)',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                final picked = DughryLocationStore.governorates.firstWhere(
                  (g) => g.id == val,
                  orElse: () => gov,
                );
                setState(() {
                  _tempGovId = picked.id;
                  _tempCenter = picked.availableCenters.isNotEmpty
                      ? picked.availableCenters.first
                      : 'المركز الرئيسي';
                });
              },
            ),
            const SizedBox(height: 12),
            if (gov.availableCenters.isNotEmpty)
              DropdownButtonFormField<String>(
                value: gov.availableCenters.contains(_tempCenter)
                    ? _tempCenter
                    : gov.availableCenters.first,
                dropdownColor: DughryColors.royalNavyCard,
                decoration: const InputDecoration(
                  labelText: 'المركز أو المنطقة',
                  filled: true,
                  fillColor: DughryColors.royalNavyCard,
                ),
                items: gov.availableCenters
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _tempCenter = val);
                },
              )
            else
              Text(
                gov.comingSoonNote,
                style: const TextStyle(color: DughryColors.textSecondary),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                DughryLocationStore.selectedGovernorateId = _tempGovId;
                DughryLocationStore.selectedCenter = _tempCenter;
                DughryLocationStore.isGpsSynced = true;
                widget.onLocationChanged();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DughryColors.goldPrimary,
                foregroundColor: DughryColors.royalNavyDeep,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'حفظ الموقع',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: DughryColors.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: DughryColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: badgeColor),
        ),
        child: Text(
          badgeText,
          style: TextStyle(
            color: badgeColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
