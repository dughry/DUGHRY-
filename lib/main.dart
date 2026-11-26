// ============================================================================
// تطبيق دوجري | DUGHRY - ملف lib/main.dart (الجزء 1 من 3)
// واجهة RTL كاملة - هوية ملكية داكنة - محافظات + GPS - شاشة بدء متزنة
// ============================================================================

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

// ----------------------------------------------------------------------------
// 1. الهوية والألوان الملكية (دوجري | DUGHRY)
// ----------------------------------------------------------------------------
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

// ----------------------------------------------------------------------------
// 2. بيانات المحافظات والمراكز (مع دعم GPS)
// ----------------------------------------------------------------------------
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
}

// ----------------------------------------------------------------------------
// 3. التطبيق الرئيسي وثيم RTL
// ----------------------------------------------------------------------------
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

// ----------------------------------------------------------------------------
// 4. شاشة البدء (SplashScreen) - مقاسات متزنة بدون قص
// ----------------------------------------------------------------------------
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
    final landmarkHeight = (usableHeight * 0.25).clamp(150.0, 225.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: DughryColors.royalBackgroundGradient,
        ),
        child: SafeArea(
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
// تطبيق دوجري | DUGHRY - ملف lib/main.dart (الجزء 2 من 3)
// نماذج التسجيل المنفصلة - حالة الانتظار - حماية الإدارة واعتماد/رفض الطلبات
// ============================================================================

enum RegistrationStatus {
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
  final String governorate;
  final String centerOrAddress;
  final String primarySpecialtyOrActivity;
  final String secondaryDetail;
  final int freeGraceDays;
  final RegistrationStatus status;
  final DateTime createdAt;

  RegistrationRequestRecord({
    required this.id,
    required this.role,
    required this.fullName,
    required this.phone,
    required this.governorate,
    required this.centerOrAddress,
    required this.primarySpecialtyOrActivity,
    required this.secondaryDetail,
    this.freeGraceDays = 0,
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
      governorate: 'المنيا',
      centerOrAddress: 'مركز العدوة - شارع الجمهورية',
      primarySpecialtyOrActivity: 'مستلزمات منزلية وأجهزة',
      secondaryDetail: 'قسم المستلزمات المنزلية',
      freeGraceDays: 30,
      status: RegistrationStatus.pendingAdmin,
    ),
    RegistrationRequestRecord(
      id: 'REQ-102',
      role: UserRoleType.doctor,
      fullName: 'د. سارة منصور',
      phone: '01122334455',
      governorate: 'المنيا',
      centerOrAddress: 'مركز العدوة - عيادة السلام الطبية',
      primarySpecialtyOrActivity: 'باطنة وجهاز هضمي',
      secondaryDetail: 'قيد النقابة: 184920',
      freeGraceDays: 0,
      status: RegistrationStatus.pendingAdmin,
    ),
    RegistrationRequestRecord(
      id: 'REQ-103',
      role: UserRoleType.technician,
      fullName: 'كريم حسن علي',
      phone: '01298765432',
      governorate: 'القاهرة',
      centerOrAddress: 'مدينة نصر - الحي السابع',
      primarySpecialtyOrActivity: 'صيانة تكييف وتبريد',
      secondaryDetail: 'خبرة 7 سنوات - نطاق مدينة نصر ومصر الجديدة',
      freeGraceDays: 0,
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
        governorate: old.governorate,
        centerOrAddress: old.centerOrAddress,
        primarySpecialtyOrActivity: old.primarySpecialtyOrActivity,
        secondaryDetail: old.secondaryDetail,
        freeGraceDays: old.freeGraceDays,
        status: newStatus,
        createdAt: old.createdAt,
      );
    }
  }
}

// ----------------------------------------------------------------------------
// 6. نموذج التسجيل المخصص لكل دور (عميل / تاجر / دكتور / فني)
// ----------------------------------------------------------------------------
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
class _RoleRegistrationFormState extends State<_RoleRegistrationForm> {
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
    ),
    DughryCategoryItem(
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
      governorateAr: 'المنيا',
      price: 165.0,
      unitLabel: 'عبوة 5 كجم',
      icon: Icons.shopping_bag_rounded,
      badge: 'الأكثر طلباً',
    ),
    DughryCatalogProduct(
      id: 'PRD-2',
      nameAr: 'طقم أواني جرانيت 9 قطع',
      categoryId: 'home_appliances',
      categoryTitleAr: 'مستلزمات المنزل',
      governorateAr: 'المنيا',
      price: 2450.0,
      unitLabel: 'طقم كامل',
      icon: Icons.soup_kitchen_rounded,
      badge: 'عرض دوجري',
    ),
    DughryCatalogProduct(
      id: 'PRD-3',
      nameAr: 'كشف عيادة باطنة وجهاز هضمي',
      categoryId: 'doctors',
      categoryTitleAr: 'عيادات وأطباء',
      governorateAr: 'المنيا',
      price: 200.0,
      unitLabel: 'حجز كشف',
      icon: Icons.medical_information_rounded,
      badge: 'متاح اليوم',
    ),
    DughryCatalogProduct(
      id: 'PRD-4',
      nameAr: 'صيانة وتنظيف تكييف سبليت',
      categoryId: 'maintenance',
      categoryTitleAr: 'صيانة وفنيون',
      governorateAr: 'القاهرة',
      price: 350.0,
      unitLabel: 'زيارة فني',
      icon: Icons.ac_unit_rounded,
      badge: 'فني معتمد',
    ),
    DughryCatalogProduct(
      id: 'PRD-5',
      nameAr: 'توصيل طلبات فوري داخل المركز',
      categoryId: 'delivery',
      categoryTitleAr: 'توصيل سريع',
      governorateAr: 'الجيزة',
      price: 35.0,
      unitLabel: 'مشوار توصيل',
      icon: Icons.two_wheeler_rounded,
      badge: 'سريع',
    ),
    DughryCatalogProduct(
      id: 'PRD-6',
      nameAr: 'سماعة لاسلكية أصلية عالية النقاء',
      categoryId: 'electronics',
      categoryTitleAr: 'إلكترونيات',
      governorateAr: 'القاهرة',
      price: 890.0,
      unitLabel: 'قطعة',
      icon: Icons.headphones_rounded,
      badge: 'ضمان عام',
    ),
  ];

  static final List<DughryCartEntry> cartItems = [
    DughryCartEntry(
      product: sampleProducts[0],
      quantity: 1,
    ),
  ];

  static final List<DughryOrderRecord> orders = [
    DughryOrderRecord(
      orderId: 'ORD-8091',
      createdAt: DateTime(2026, 11, 20, 14, 30),
      governorateAr: 'المنيا - مركز العدوة',
      summaryText: 'أرز مصري فاخر 5 كجم × 1',
      totalAmount: 165.0,
      statusText: 'تم التسليم',
    ),
  ];

  static void addToCart(DughryCatalogProduct product) {
    final idx = cartItems.indexWhere((e) => e.product.id == product.id);
    if (idx != -1) {
      cartItems[idx].quantity += 1;
    } else {
      cartItems.add(DughryCartEntry(product: product, quantity: 1));
    }
  }

  static void decrementOrRemove(String productId) {
    final idx = cartItems.indexWhere((e) => e.product.id == productId);
    if (idx == -1) return;
    if (cartItems[idx].quantity > 1) {
      cartItems[idx].quantity -= 1;
    } else {
      cartItems.removeAt(idx);
    }
  }

  static double get cartSubtotal {
    return cartItems.fold(0.0, (sum, entry) => sum + entry.lineTotal);
  }

  static int get totalCartCount {
    return cartItems.fold(0, (sum, entry) => sum + entry.quantity);
  }

  static DughryOrderRecord? checkoutCart(String locationLabel) {
    if (cartItems.isEmpty) return null;
    final summary = cartItems
        .map((e) => '${e.product.nameAr} ×${e.quantity}')
        .join(' ، ');
    final order = DughryOrderRecord(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      createdAt: DateTime.now(),
      governorateAr: locationLabel,
      summaryText: summary,
      totalAmount: cartSubtotal,
      statusText: 'قيد التنفيذ والتوصيل',
    );
    orders.insert(0, order);
    cartItems.clear();
    return order;
  }
}

// ----------------------------------------------------------------------------
// 8. شاشة الأدوار الرئيسية (الرئيسية / الأقسام / السلة / طلباتي / حسابي)
// ----------------------------------------------------------------------------
class RoleDashboardScreen extends StatefulWidget {
  final UserRoleType initialRole;
  final VoidCallback onLocationUpdated;

  const RoleDashboardScreen({
    super.key,
    required this.initialRole,
    required this.onLocationUpdated,
  });

  @override
  State<RoleDashboardScreen> createState() => _RoleDashboardScreenState();
}

  Widget _buildCurrentTabBody(GovernorateItem gov) {
    switch (_bottomNavIndex) {
      case 0:
      default:
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
                  'محافظة ${gov.nameAr} متاحة قريباً في دوجري',
                  style: const TextStyle(color: DughryColors.textLight),
                ),
              ),
            );
          },
        );
    }
  }
}
