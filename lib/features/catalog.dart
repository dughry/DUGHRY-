part of dughry;

class DughryCategoryItem {
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
      id: 'restaurants',
      titleAr: 'مطاعم',
      icon: Icons.restaurant_rounded,
      accentColor: Color(0xFFE8794A),
      groupType: 'مطاعم',
    ),
    DughryCategoryItem(
      id: 'clothing',
      titleAr: 'ملابس',
      icon: Icons.checkroom_rounded,
      accentColor: Color(0xFFBE123C),
      groupType: 'تسوق',
    ),
    DughryCategoryItem(
      id: 'technicians',
      titleAr: 'عمال فنيين',
      icon: Icons.handyman_rounded,
      accentColor: Color(0xFFB45309),
      groupType: 'خدمات',
    ),
    DughryCategoryItem(
      id: 'electrical_appliances',
      titleAr: 'أجهزة كهربائية',
      icon: Icons.electrical_services_rounded,
      accentColor: Color(0xFFD4AF37),
      groupType: 'تسوق',
    ),
    DughryCategoryItem(
      id: 'spare_parts',
      titleAr: 'قطع غيار',
      icon: Icons.settings_rounded,
      accentColor: Color(0xFF64748B),
      groupType: 'تسوق',
    ),
    DughryCategoryItem(
      id: 'doctor_booking',
      titleAr: 'حجز دكتور',
      icon: Icons.medical_services_rounded,
      accentColor: Color(0xFF0D9488),
      groupType: 'صحة',
    ),
    DughryCategoryItem(
      id: 'hotels',
      titleAr: 'فنادق',
      icon: Icons.hotel_rounded,
      accentColor: Color(0xFF7C3AED),
      groupType: 'حجوزات',
    ),
    DughryCategoryItem(
      id: 'home_tools',
      titleAr: 'أدوات منزلية',
      icon: Icons.kitchen_rounded,
      accentColor: Color(0xFF15803D),
      groupType: 'تسوق',
    ),
    DughryCategoryItem(
      id: 'transport',
      titleAr: 'مواصلات',
      icon: Icons.directions_car_rounded,
      accentColor: Color(0xFF0369A1),
      groupType: 'خدمات',
    ),
    DughryCategoryItem(
      id: 'open_market',
      titleAr: 'سوق دوجري المفتوح',
      icon: Icons.storefront_rounded,
      accentColor: Color(0xFFCA8A04),
      groupType: 'سوق مفتوح',
    ),
  ];

  static final List<DughryCartEntry> cartItems = [];
  static final List<DughryOrderRecord> orders = [];

  static int get totalCartCount {
    int total = 0;
    for (final item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  static double get cartSubtotal {
    double sum = 0;
    for (final item in cartItems) {
      sum += item.lineTotal;
    }
    return sum;
  }

  static void addToCart(DughryCatalogProduct? product) {
    if (product == null) return;
    for (final item in cartItems) {
      if (item.product.id == product.id) {
        item.quantity += 1;
        return;
      }
    }
    cartItems.add(DughryCartEntry(product: product, quantity: 1));
  }

  static void decrementOrRemove(String? productId) {
    if (productId == null) return;
    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      if (item.product.id == productId) {
        if (item.quantity > 1) {
          item.quantity -= 1;
        } else {
          cartItems.removeAt(i);
        }
        return;
      }
    }
  }

  static DughryOrderRecord? checkoutCart(String locationLabel) {
    if (cartItems.isEmpty) return null;
    final selectedGovernorate = DughryLocationStore.currentGovernorate.nameAr;
    if (cartItems.any((entry) => entry.product.governorateAr != selectedGovernorate)) {
      return null;
    }
    final amount = cartSubtotal;
    final count = totalCartCount;
    final record = DughryOrderRecord(
      orderId:
          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      createdAt: DateTime.now(),
      governorateAr: locationLabel,
      summaryText: 'طلب يحتوي على $count عنصر من دوجري',
      totalAmount: amount,
      statusText: 'محفوظ محلياً - بانتظار الربط بالخادم',
    );
    orders.insert(0, record);
    cartItems.clear();
    return record;
  }

  static const List<DughryCatalogProduct> sampleProducts = [
    DughryCatalogProduct(
      id: 'PRD-1',
      nameAr: 'طقم أدوات مطبخ تجريبي',
      categoryId: 'home_tools',
      categoryTitleAr: 'أدوات منزلية',
      governorateAr: 'القاهرة',
      price: 165.0,
      unitLabel: 'لكل 5 كجم',
      icon: Icons.shopping_bag_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-2',
      nameAr: 'خلاط كهربائي 900 واط',
      categoryId: 'electrical_appliances',
      categoryTitleAr: 'أجهزة كهربائية',
      governorateAr: 'الجيزة',
      price: 2450.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.soup_kitchen_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-3',
      nameAr: 'كشف جراحة وعظام',
      categoryId: 'doctor_booking',
      categoryTitleAr: 'حجز دكتور',
      governorateAr: 'المنيا',
      price: 300.0,
      unitLabel: 'لكل كشف',
      icon: Icons.medical_services_rounded,
      badge: 'بيانات تجريبية',
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
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-5',
      nameAr: 'وجبة مشويات مشكلة',
      categoryId: 'restaurants',
      categoryTitleAr: 'مطاعم',
      governorateAr: 'القاهرة',
      price: 185.0,
      unitLabel: 'لكل وجبة',
      icon: Icons.restaurant_menu_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-6',
      nameAr: 'بيتزا خضار وسط',
      categoryId: 'restaurants',
      categoryTitleAr: 'مطاعم',
      governorateAr: 'الجيزة',
      price: 145.0,
      unitLabel: 'لكل بيتزا',
      icon: Icons.local_pizza_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-7',
      nameAr: 'تيشيرت قطني رجالي',
      categoryId: 'clothing',
      categoryTitleAr: 'ملابس',
      governorateAr: 'القاهرة',
      price: 220.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.checkroom_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-8',
      nameAr: 'حذاء رياضي رجالي',
      categoryId: 'clothing',
      categoryTitleAr: 'ملابس',
      governorateAr: 'الجيزة',
      price: 850.0,
      unitLabel: 'لكل زوج',
      icon: Icons.shopping_bag_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-9',
      nameAr: 'مروحة حائط 16 بوصة',
      categoryId: 'electrical_appliances',
      categoryTitleAr: 'أجهزة كهربائية',
      governorateAr: 'القاهرة',
      price: 1290.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.toys_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-10',
      nameAr: 'فلتر زيت سيارة',
      categoryId: 'spare_parts',
      categoryTitleAr: 'قطع غيار',
      governorateAr: 'الجيزة',
      price: 180.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.settings_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-11',
      nameAr: 'بطارية سيارة 70 أمبير',
      categoryId: 'spare_parts',
      categoryTitleAr: 'قطع غيار',
      governorateAr: 'القاهرة',
      price: 2700.0,
      unitLabel: 'لكل بطارية',
      icon: Icons.battery_charging_full_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-12',
      nameAr: 'كشف باطنة تجريبي',
      categoryId: 'doctor_booking',
      categoryTitleAr: 'حجز دكتور',
      governorateAr: 'القاهرة',
      price: 350.0,
      unitLabel: 'لكل كشف',
      icon: Icons.medical_services_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-13',
      nameAr: 'غرفة فندقية لليلة',
      categoryId: 'hotels',
      categoryTitleAr: 'فنادق',
      governorateAr: 'القاهرة',
      price: 1200.0,
      unitLabel: 'لليلة',
      icon: Icons.hotel_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-14',
      nameAr: 'حجز غرفة فندقية',
      categoryId: 'hotels',
      categoryTitleAr: 'فنادق',
      governorateAr: 'الجيزة',
      price: 950.0,
      unitLabel: 'لليلة',
      icon: Icons.bed_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-15',
      nameAr: 'طقم أواني طهي',
      categoryId: 'home_tools',
      categoryTitleAr: 'أدوات منزلية',
      governorateAr: 'القاهرة',
      price: 680.0,
      unitLabel: 'لكل طقم',
      icon: Icons.kitchen_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-16',
      nameAr: 'مشوار داخل القاهرة',
      categoryId: 'transport',
      categoryTitleAr: 'مواصلات',
      governorateAr: 'القاهرة',
      price: 90.0,
      unitLabel: 'لكل مشوار',
      icon: Icons.local_taxi_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-17',
      nameAr: 'مشوار داخل الجيزة',
      categoryId: 'transport',
      categoryTitleAr: 'مواصلات',
      governorateAr: 'الجيزة',
      price: 110.0,
      unitLabel: 'لكل مشوار',
      icon: Icons.directions_car_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-18',
      nameAr: 'سماعة بلوتوث مستعملة',
      categoryId: 'open_market',
      categoryTitleAr: 'سوق دوجري المفتوح',
      governorateAr: 'القاهرة',
      price: 450.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.headphones_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-19',
      nameAr: 'مكتب خشب مستعمل',
      categoryId: 'open_market',
      categoryTitleAr: 'سوق دوجري المفتوح',
      governorateAr: 'الجيزة',
      price: 750.0,
      unitLabel: 'لكل قطعة',
      icon: Icons.chair_rounded,
      badge: 'بيانات تجريبية',
    ),
    DughryCatalogProduct(
      id: 'PRD-20',
      nameAr: 'زيارة سباك منزلية',
      categoryId: 'technicians',
      categoryTitleAr: 'عمال فنيين',
      governorateAr: 'الجيزة',
      price: 300.0,
      unitLabel: 'لكل زيارة',
      icon: Icons.plumbing_rounded,
      badge: 'بيانات تجريبية',
    ),
  ];
}
