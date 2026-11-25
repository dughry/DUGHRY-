import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const DughryApp());
}

class DughryApp extends StatelessWidget {
  const DughryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دوجري | DUGHRY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D254C), // أزرق ملكي داكن
          primary: const Color(0xFF0D254C),
          secondary: const Color(0xFFD4AF37), // ذهبي مصري
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D254C),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// 1. النماذج والبيانات الأساسية (Models & Data)
// ==========================================

enum UserRole {
  customer('عميل', 'تسوق واطلب الخدمات بسهولة', Icons.person),
  merchant('تاجر', 'فترة سماح مجانية من 15 يوماً إلى شهر', Icons.storefront),
  technician('فني', 'استقبل طلبات الصيانة والخدمات القريبة', Icons.handyman),
  admin('إدارة', 'لوحة التحكم وإدارة المنصة والمحافظات', Icons.admin_panel_settings);

  final String title;
  final String subtitle;
  final IconData icon;
  const UserRole(this.title, this.subtitle, this.icon);
}

class GovernorateModel {
  final String name;
  final bool isAvailable;
  final String note;

  const GovernorateModel({
    required this.name,
    required this.isAvailable,
    this.note = '',
  });
}

class CategoryModel {
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final String type; // 'منتجات' أو 'خدمات'

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class ProductItem {
  final String id;
  final String title;
  final String categoryName;
  final double price;
  final String unit;
  final IconData icon;

  const ProductItem({
    required this.id,
    required this.title,
    required this.categoryName,
    required this.price,
    required this.unit,
    required this.icon,
  });
}

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class OrderModel {
  final String id;
  final String date;
  final double total;
  final String status;
  final String governorate;

  const OrderModel({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.governorate,
  });
}

// قائمة المحافظات
const List<GovernorateModel> kGovernorates = [
  GovernorateModel(name: 'القاهرة', isAvailable: true, note: 'تغطية شاملة لجميع الأحياء'),
  GovernorateModel(name: 'الجيزة', isAvailable: true, note: 'تغطية شاملة لجميع المناطق'),
  GovernorateModel(name: 'المنيا - مركز العدوة', isAvailable: true, note: 'المدينة والقرى التابعة'),
  GovernorateModel(name: 'الإسكندرية', isAvailable: false, note: 'قريباً'),
  GovernorateModel(name: 'الدقهلية', isAvailable: false, note: 'قريباً'),
  GovernorateModel(name: 'الشرقية', isAvailable: false, note: 'قريباً'),
  GovernorateModel(name: 'أسيوط', isAvailable: false, note: 'قريباً'),
  GovernorateModel(name: 'سوهاج', isAvailable: false, note: 'قريباً'),
  GovernorateModel(name: 'باقي المحافظات', isAvailable: false, note: 'قريباً في جميع أنحاء الجمهورية'),
];

// الأقسام الـ 12
const List<CategoryModel> kCategories = [
  CategoryModel(id: 1, name: 'سوبر ماركت وبقالة', icon: Icons.local_grocery_store, color: Color(0xFF2E7D32), type: 'منتجات'),
  CategoryModel(id: 2, name: 'مطاعم ومأكولات', icon: Icons.restaurant, color: Color(0xFFD84315), type: 'منتجات'),
  CategoryModel(id: 3, name: 'صيدليات وعناية', icon: Icons.local_pharmacy, color: Color(0xFF00838F), type: 'منتجات'),
  CategoryModel(id: 4, name: 'خضروات وفواكه', icon: Icons.eco, color: Color(0xFF558B2F), type: 'منتجات'),
  CategoryModel(id: 5, name: 'ملابس وأزياء', icon: Icons.checkroom, color: Color(0xFF6A1B9A), type: 'منتجات'),
  CategoryModel(id: 6, name: 'إلكترونيات وموبايلات', icon: Icons.devices, color: Color(0xFF1565C0), type: 'منتجات'),
  CategoryModel(id: 7, name: 'أجهزة منزلية', icon: Icons.kitchen, color: Color(0xFF37474F), type: 'منتجات'),
  CategoryModel(id: 8, name: 'صيانة سباكة وكهرباء', icon: Icons.plumbing, color: Color(0xFFEF6C00), type: 'خدمات'),
  CategoryModel(id: 9, name: 'تكييف وتبريد', icon: Icons.ac_unit, color: Color(0xFF0277BD), type: 'خدمات'),
  CategoryModel(id: 10, name: 'نجارة وألوميتال', icon: Icons.carpenter, color: Color(0xFF5D4037), type: 'خدمات'),
  CategoryModel(id: 11, name: 'نقل وتوصيل ومشاوير', icon: Icons.local_shipping, color: Color(0xFFC62828), type: 'خدمات'),
  CategoryModel(id: 12, name: 'عقارات وتشطيبات', icon: Icons.home_work, color: Color(0xFF283593), type: 'خدمات'),
];

// عروض ومنتجات تجريبية
const List<ProductItem> kSampleItems = [
  ProductItem(id: 'p1', title: 'كرتونة مواد غذائية متكاملة', categoryName: 'سوبر ماركت وبقالة', price: 450, unit: 'كرتونة', icon: Icons.shopping_basket),
  ProductItem(id: 'p2', title: 'كشف وصيانة تكييف سبليت', categoryName: 'تكييف وتبريد', price: 200, unit: 'زيارة', icon: Icons.ac_unit),
  ProductItem(id: 'p3', title: 'وجبة مشويات عائلية دوجري', categoryName: 'مطاعم ومأكولات', price: 380, unit: 'وجبة', icon: Icons.kebab_dining),
  ProductItem(id: 'p4', title: 'تأسيس وإصلاح أعطال كهرباء', categoryName: 'صيانة سباكة وكهرباء', price: 150, unit: 'معاينة', icon: Icons.electrical_services),
  ProductItem(id: 'p5', title: 'بوكس فاكهة الموسم الطازجة', categoryName: 'خضروات وفواكه', price: 120, unit: '5 كجم', icon: Icons.apple),
  ProductItem(id: 'p6', title: 'نقل عفش وبضائع داخل المحافظة', categoryName: 'نقل وتوصيل ومشاوير', price: 600, unit: 'نقلة', icon: Icons.local_shipping),
];

// ==========================================
// 2. شاشة البدء (Splash Screen) بالأهرامات وبرج القاهرة
// ==========================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RoleAndLocationSetupScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071630),
              Color(0xFF0D254C),
              Color(0xFF1A3A6E),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 60),
              // الشعار والاسم
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'دوجري',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFD4AF37),
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'DUGHRY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'كل احتياجاتك في مكان واحد',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'منتجات • خدمات • صيانة • توصيل',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ],
              ),

              // رسم الأهرامات وبرج القاهرة المدمج بدون صور خارجية
              SizedBox(
                height: 230,
                width: double.infinity,
                child: CustomPaint(
                  painter: EgyptLandmarksPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EgyptLandmarksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // توهج الشمس/القمر الذهبي في الخلفية
    final sunPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), 85, sunPaint);

    // 1. رسم برج القاهرة (على اليسار)
    final towerX = w * 0.24;
    final towerPaint = Paint()
      ..color = const Color(0xFFE0C068)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final towerFill = Paint()
      ..color = const Color(0xFF102A54)
      ..style = PaintingStyle.fill;

    // جسم البرج الأسطواني
    final towerRect = Rect.fromLTWH(towerX - 12, h * 0.22, 24, h * 0.78);
    canvas.drawRect(towerRect, towerFill);
    canvas.drawRect(towerRect, towerPaint);

    // زهرة اللوتس أعلى برج القاهرة
    final crownPath = Path()
      ..moveTo(towerX - 18, h * 0.22)
      ..lineTo(towerX - 12, h * 0.14)
      ..lineTo(towerX + 12, h * 0.14)
      ..lineTo(towerX + 18, h * 0.22)
      ..close();
    canvas.drawPath(crownPath, towerFill);
    canvas.drawPath(crownPath, towerPaint);

    // هوائي البرج
    canvas.drawLine(
      Offset(towerX, h * 0.14),
      Offset(towerX, h * 0.04),
      towerPaint,
    );

    // خطوط الشبكة المميزة لبرج القاهرة
    for (double y = h * 0.25; y < h; y += 14) {
      canvas.drawLine(Offset(towerX - 12, y), Offset(towerX + 12, y + 10), towerPaint);
      canvas.drawLine(Offset(towerX + 12, y), Offset(towerX - 12, y + 10), towerPaint);
    }

    // 2. رسم الأهرامات الثلاثة (في المنتصف واليمين)
    final pyramidLight = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;

    final pyramidShadow = Paint()
      ..color = const Color(0xFF9E7E1E)
      ..style = PaintingStyle.fill;

    // الهرم الأكبر (خوفو)
    _drawPyramid(
      canvas,
      apex: Offset(w * 0.56, h * 0.32),
      leftBase: Offset(w * 0.34, h),
      rightBase: Offset(w * 0.78, h),
      splitX: w * 0.60,
      lightPaint: pyramidLight,
      shadowPaint: pyramidShadow,
    );

    // الهرم الأوسط (خفرع)
    _drawPyramid(
      canvas,
      apex: Offset(w * 0.77, h * 0.44),
      leftBase: Offset(w * 0.60, h),
      rightBase: Offset(w * 0.94, h),
      splitX: w * 0.80,
      lightPaint: pyramidLight,
      shadowPaint: pyramidShadow,
    );

    // الهرم الأصغر (منكاورع)
    _drawPyramid(
      canvas,
      apex: Offset(w * 0.90, h * 0.64),
      leftBase: Offset(w * 0.79, h),
      rightBase: Offset(w * 1.02, h),
      splitX: w * 0.92,
      lightPaint: pyramidLight,
      shadowPaint: pyramidShadow,
    );

    // خط الأرض الذهبي
    final groundPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, h - 1.5), Offset(w, h - 1.5), groundPaint);
  }

  void _drawPyramid(
    Canvas canvas, {
    required Offset apex,
    required Offset leftBase,
    required Offset rightBase,
    required double splitX,
    required Paint lightPaint,
    required Paint shadowPaint,
  }) {
    final leftFace = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(leftBase.dx, leftBase.dy)
      ..lineTo(splitX, leftBase.dy)
      ..close();

    final rightFace = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(splitX, rightBase.dy)
      ..lineTo(rightBase.dx, rightBase.dy)
      ..close();

    canvas.drawPath(leftFace, lightPaint);
    canvas.drawPath(rightFace, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 3. شاشة اختيار المحافظة ونوع الصلاحية
// ==========================================

class RoleAndLocationSetupScreen extends StatefulWidget {
  const RoleAndLocationSetupScreen({super.key});

  @override
  State<RoleAndLocationSetupScreen> createState() => _RoleAndLocationSetupScreenState();
}

class _RoleAndLocationSetupScreenState extends State<RoleAndLocationSetupScreen> {
  GovernorateModel _selectedGov = kGovernorates[0];
  UserRole _selectedRole = UserRole.customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعداد حساب دوجري | DUGHRY'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختيار المحافظة
            const Text(
              '1. اختر محافظتك / منطقتك',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: kGovernorates.map((gov) {
                  final isSelected = _selectedGov.name == gov.name;
                  return ListTile(
                    onTap: () {
                      if (!gov.isAvailable) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${gov.name} ستتوفر قريباً! متاح حالياً: القاهرة، الجيزة، والمنيا (مركز العدوة).'),
                            backgroundColor: const Color(0xFF0D254C),
                          ),
                        );
                        return;
                      }
                      setState(() => _selectedGov = gov);
                    },
                    leading: Icon(
                      gov.isAvailable ? Icons.location_on : Icons.access_time,
                      color: gov.isAvailable ? const Color(0xFF0D254C) : Colors.grey,
                    ),
                    title: Text(
                      gov.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: gov.isAvailable ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      gov.note,
                      style: TextStyle(
                        fontSize: 12,
                        color: gov.isAvailable ? Colors.green.shade700 : Colors.orange.shade800,
                      ),
                    ),
                    trailing: gov.isAvailable
                        ? Radio<String>(
                            value: gov.name,
                            groupValue: _selectedGov.name,
                            activeColor: const Color(0xFF0D254C),
                            onChanged: (_) => setState(() => _selectedGov = gov),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: const Text(
                              'قريباً',
                              style: TextStyle(fontSize: 11, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                            ),
                          ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // اختيار الصلاحية
            const Text(
              '2. اختر نوع الحساب (الصلاحية)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
            ),
            const SizedBox(height: 8),
            ...UserRole.values.map((role) {
              final isSelected = _selectedRole == role;
              return Card(
                elevation: isSelected ? 3 : 0.5,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => setState(() => _selectedRole = role),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? const Color(0xFF0D254C) : Colors.grey.shade200,
                    child: Icon(role.icon, color: isSelected ? const Color(0xFFD4AF37) : Colors.black54),
                  ),
                  title: Text(
                    role.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    role.subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: role == UserRole.merchant ? Colors.green.shade800 : Colors.black54,
                      fontWeight: role == UserRole.merchant ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: Radio<UserRole>(
                    value: role,
                    groupValue: _selectedRole,
                    activeColor: const Color(0xFF0D254C),
                    onChanged: (val) => setState(() => _selectedRole = val!),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D254C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => MainShellScreen(
                        initialGovernorate: _selectedGov,
                        initialRole: _selectedRole,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle, color: Color(0xFFD4AF37)),
                label: const Text(
                  'دخول إلى تطبيق دوجري',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. الشاشة الرئيسية وشريط التنقل السفلي (5 تبويبات)
// ==========================================

class MainShellScreen extends StatefulWidget {
  final GovernorateModel initialGovernorate;
  final UserRole initialRole;

  const MainShellScreen({
    super.key,
    required this.initialGovernorate,
    required this.initialRole,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  late GovernorateModel _currentGov;
  late UserRole _currentRole;

  // بيانات السلة والطلبات
  final List<CartItem> _cart = [];
  final List<OrderModel> _orders = [
    const OrderModel(
      id: 'DGH-1042',
      date: 'اليوم - 04:30 م',
      total: 450,
      status: 'جاري التجهيز',
      governorate: 'القاهرة',
    ),
  ];

  // إعداد فترة السماح للتاجر (من 15 إلى 30 يوماً)
  int _merchantGraceDays = 30;

  @override
  void initState() {
    super.initState();
    _currentGov = widget.initialGovernorate;
    _currentRole = widget.initialRole;
  }

  void _addToCart(ProductItem product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة "${product.title}" إلى السلة'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF0D254C),
      ),
    );
  }

  void _placeOrder() {
    if (_cart.isEmpty) return;
    final total = _cart.fold<double>(0, (sum, item) => sum + (item.product.price * item.quantity));
    setState(() {
      _orders.insert(
        0,
        OrderModel(
          id: 'DGH-${1043 + _orders.length}',
          date: 'الآن',
          total: total,
          status: 'تم استلام الطلب',
          governorate: _currentGov.name,
        ),
      );
      _cart.clear();
      _currentIndex = 3; // الانتقال إلى تبويب طلباتي
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تأكيد طلبك بنجاح!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showGovernoratePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختر المحافظة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: kGovernorates.map((gov) {
                    return ListTile(
                      leading: Icon(
                        gov.isAvailable ? Icons.location_on : Icons.lock_clock,
                        color: gov.isAvailable ? const Color(0xFF0D254C) : Colors.grey,
                      ),
                      title: Text(gov.name),
                      subtitle: Text(gov.note),
                      trailing: gov.isAvailable
                          ? (_currentGov.name == gov.name
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null)
                          : const Chip(
                              label: Text('قريباً', style: TextStyle(fontSize: 11)),
                            ),
                      onTap: () {
                        if (gov.isAvailable) {
                          setState(() => _currentGov = gov);
                          Navigator.pop(ctx);
                        } else {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${gov.name}: قريباً بإذن الله')),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      _buildCategoriesTab(),
      _buildCartTab(),
      _buildOrdersTab(),
      _buildAccountTab(),
    ];

    final totalCartCount = _cart.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('دوجري', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD4AF37))),
            const SizedBox(width: 6),
            const Text('DUGHRY', style: TextStyle(fontSize: 14, letterSpacing: 1.5)),
          ],
        ),
        actions: [
          InkWell(
            onTap: _showGovernoratePicker,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 4),
                  Text(
                    _currentGov.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD4AF37).withOpacity(0.25),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF0D254C)),
            label: 'الرئيسية',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded, color: Color(0xFF0D254C)),
            label: 'الأقسام',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: totalCartCount > 0,
              label: Text('$totalCartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: totalCartCount > 0,
              label: Text('$totalCartCount'),
              child: const Icon(Icons.shopping_cart, color: Color(0xFF0D254C)),
            ),
            label: 'السلة',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: Color(0xFF0D254C)),
            label: 'طلباتي',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF0D254C)),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // تبويب 1: الرئيسية
  // ==========================================
  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // بانر الترحيب والشعار
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D254C), Color(0xFF1B3F7A)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'حساب: ${_currentRole.title}',
                      style: const TextStyle(
                        color: Color(0xFF0D254C),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    _currentGov.name,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'كل احتياجاتك في مكان واحد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'اطلب مقاضي بيتك أو احجز أقرب فني صيانة في دقائق وبسعر دوجري.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        // بطاقة خاصة بصلاحية التاجر (فترة سماح 15 يوماً إلى شهر)
        if (_currentRole == UserRole.merchant) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade400),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'باقة التاجر المميزة نشطة',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        'تتمتع بفترة سماح مجانية بدون عمولة لمدة $_merchantGraceDays يوماً (قابلة للتعديل من 15 إلى 30 يوماً).',
                        style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // بطاقة خاصة بالفني أو الإدارة
        if (_currentRole == UserRole.technician || _currentRole == UserRole.admin) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4AF37)),
            ),
            child: Row(
              children: [
                Icon(_currentRole.icon, color: const Color(0xFF0D254C), size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentRole == UserRole.technician
                        ? 'وضع الفني مفعل في ${_currentGov.name}: أنت جاهز لاستقبال طلبات الصيانة القريبة.'
                        : 'وضع الإدارة مفعل: يمكنك متابعة المحافظات النشطة (القاهرة، الجيزة، المنيا - العدوة) والتجار.',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // معاينة الأقسام الـ 12
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأقسام الرئيسية (12 قسماً)',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
            ),
            TextButton(
              onPressed: () => setState(() => _currentIndex = 1),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.95,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final cat = kCategories[index];
            return InkWell(
              onTap: () => setState(() => _currentIndex = 1),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: cat.color.withOpacity(0.12),
                      child: Icon(cat.icon, color: cat.color),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // الأكثر طلباً في المحافظة المختارة
        Text(
          'الأكثر طلباً في ${_currentGov.name}',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
        ),
        const SizedBox(height: 10),
        ...kSampleItems.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0D254C).withOpacity(0.1),
                child: Icon(item.icon, color: const Color(0xFF0D254C)),
              ),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('${item.categoryName} • ${item.price.toInt()} ج.م / ${item.unit}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D254C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () => _addToCart(item),
                child: const Text('أضف'),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // تبويب 2: الأقسام الـ 12 كاملة
  // ==========================================
 Widget _buildCategoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'كل الأقسام (12)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0254C3)),
          ),
          const SizedBox(height: 4),
          Text(
            'متاح في: ${_currentGov.name}',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: kCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final cat = kCategories[index];
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('قسم ${cat.name} (${cat.type}) - ${_currentGov.name}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cat.color.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  }

  Widget _buildCartTab() {
    return const Center(
      child: Text('السلة'),
    );
  }

  Widget _buildOrdersTab() {
    return const Center(
      child: Text('طلباتي'),
    );
  }

  Widget _buildAccountTab() {
    return const Center(
      child: Text('حسابي'),
    );
  }

