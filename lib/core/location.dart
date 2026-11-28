part of dughry;

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
      id: 'alexandria',
      nameAr: 'الإسكندرية',
      isAvailable: false,
      lat: 31.2001,
      lng: 29.9187,
    ),
    GovernorateItem(
      id: 'qalyubia',
      nameAr: 'القليوبية',
      isAvailable: false,
      lat: 30.3292,
      lng: 31.2168,
    ),
    GovernorateItem(
      id: 'sharqia',
      nameAr: 'الشرقية',
      isAvailable: false,
      lat: 30.7327,
      lng: 31.7195,
    ),
    GovernorateItem(
      id: 'dakahlia',
      nameAr: 'الدقهلية',
      isAvailable: false,
      lat: 31.0409,
      lng: 31.3785,
    ),
    GovernorateItem(
      id: 'gharbia',
      nameAr: 'الغربية',
      isAvailable: false,
      lat: 30.8754,
      lng: 31.0335,
    ),
    GovernorateItem(
      id: 'monufia',
      nameAr: 'المنوفية',
      isAvailable: false,
      lat: 30.5972,
      lng: 30.9876,
    ),
    GovernorateItem(
      id: 'beheira',
      nameAr: 'البحيرة',
      isAvailable: false,
      lat: 30.8481,
      lng: 30.3436,
    ),
    GovernorateItem(
      id: 'kafr_el_sheikh',
      nameAr: 'كفر الشيخ',
      isAvailable: false,
      lat: 31.1107,
      lng: 30.94,
    ),
    GovernorateItem(
      id: 'damietta',
      nameAr: 'دمياط',
      isAvailable: false,
      lat: 31.4175,
      lng: 31.8144,
    ),
    GovernorateItem(
      id: 'port_said',
      nameAr: 'بورسعيد',
      isAvailable: false,
      lat: 31.2653,
      lng: 32.3019,
    ),
    GovernorateItem(
      id: 'ismailia',
      nameAr: 'الإسماعيلية',
      isAvailable: false,
      lat: 30.5965,
      lng: 32.2715,
    ),
    GovernorateItem(
      id: 'suez',
      nameAr: 'السويس',
      isAvailable: false,
      lat: 29.9668,
      lng: 32.5498,
    ),
    GovernorateItem(
      id: 'north_sinai',
      nameAr: 'شمال سيناء',
      isAvailable: false,
      lat: 30.5833,
      lng: 33.0833,
    ),
    GovernorateItem(
      id: 'south_sinai',
      nameAr: 'جنوب سيناء',
      isAvailable: false,
      lat: 28.2417,
      lng: 33.6222,
    ),
    GovernorateItem(
      id: 'new_valley',
      nameAr: 'الوادي الجديد',
      isAvailable: false,
      lat: 25.4479,
      lng: 30.5464,
    ),
    GovernorateItem(
      id: 'matrouh',
      nameAr: 'مطروح',
      isAvailable: false,
      lat: 31.3543,
      lng: 27.2373,
    ),
    GovernorateItem(
      id: 'fayoum',
      nameAr: 'الفيوم',
      isAvailable: false,
      lat: 29.3084,
      lng: 30.8428,
    ),
    GovernorateItem(
      id: 'beni_suef',
      nameAr: 'بني سويف',
      isAvailable: false,
      lat: 29.0661,
      lng: 31.0994,
    ),
    GovernorateItem(
      id: 'minya',
      nameAr: 'المنيا',
      isAvailable: false,
      availableCenters: ['مركز العدوة'],
      comingSoonNote: 'مركز العدوة متاح حالياً - باقي مراكز المنيا قريباً',
      lat: 28.1099,
      lng: 30.7503,
    ),
    GovernorateItem(
      id: 'assiut',
      nameAr: 'أسيوط',
      isAvailable: false,
      lat: 27.1809,
      lng: 31.1837,
    ),
    GovernorateItem(
      id: 'sohag',
      nameAr: 'سوهاج',
      isAvailable: false,
      lat: 26.5569,
      lng: 31.6948,
    ),
    GovernorateItem(
      id: 'qena',
      nameAr: 'قنا',
      isAvailable: false,
      lat: 26.1551,
      lng: 32.716,
    ),
    GovernorateItem(
      id: 'luxor',
      nameAr: 'الأقصر',
      isAvailable: false,
      lat: 25.6872,
      lng: 32.6396,
    ),
    GovernorateItem(
      id: 'aswan',
      nameAr: 'أسوان',
      isAvailable: false,
      lat: 24.0889,
      lng: 32.8998,
    ),
    GovernorateItem(
      id: 'red_sea',
      nameAr: 'البحر الأحمر',
      isAvailable: false,
      lat: 27.2579,
      lng: 33.8116,
    ),
  ];

  static String selectedGovernorateId = 'cairo';
  static String selectedCenter = 'مدينة نصر';
  // اختيار المنطقة لا يعني أن GPS تم تشغيله أو التحقق منه.
  static bool isGpsSynced = false;

  static bool get isCurrentAreaAvailable => currentGovernorate.isAvailable || (currentGovernorate.id == 'minya' && selectedCenter == 'مركز العدوة');

  static GovernorateItem get currentGovernorate {
    return governorates.firstWhere(
      (g) => g.id == selectedGovernorateId,
      orElse: () => governorates[2],
    );
  }
}
