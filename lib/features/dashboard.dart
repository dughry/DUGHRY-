part of dughry;

class RoleDashboardScreen extends StatefulWidget {
  final UserRoleType initialRole;
  final VoidCallback? onLocationUpdated;

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
  @override
  void initState() {
    super.initState();
    _activeRole = widget.initialRole;
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
          onRefresh: () => setState(() {}),
        );
    }
  }

  @override
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
            color: DughryColors.silverBright,
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
              '${gov.nameAr} - ${DughryLocationStore.selectedCenter}',
              style: const TextStyle(
                color: DughryColors.silverBright,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'تغيير المحافظة والمنطقة',
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
                    widget.onLocationUpdated?.call();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.location_on_rounded,
              color: DughryColors.silverPrimary,
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
        selectedItemColor: DughryColors.silverPrimary,
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
}class _HomeTabView extends StatelessWidget {
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
    final areaAvailable = DughryLocationStore.isCurrentAreaAvailable;
    final filteredProducts = !areaAvailable
        ? <DughryCatalogProduct>[]
        : DughryAppStateStore.sampleProducts.where((p) {
            final matchesArea = p.governorateAr == gov.nameAr;
            final matchesCategory = selectedCategoryId == null || p.categoryId == selectedCategoryId;
            return matchesArea && matchesCategory;
          }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: DughryColors.silverGradient,
                boxShadow: [
                  BoxShadow(
                    color: DughryColors.silverPrimary.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: DughryColors.royalNavyDeep,
                size: 25,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'دوجري | DUGHRY',
                    style: TextStyle(
                      color: DughryColors.silverBright,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'كل احتياجاتك في مكان واحد',
                    style: TextStyle(
                      color: DughryColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.auto_awesome_rounded,
              color: DughryColors.silverPrimary,
              size: 23,
            ),
          ],
        ),
        const SizedBox(height: 17),
        const _DughryAdsCarousel(),
        const SizedBox(height: 18),
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
                color: DughryColors.silverPrimary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  areaAvailable
                      ? 'متاح الآن في ${gov.nameAr} (${DughryLocationStore.selectedCenter})'
                      : 'الخدمات في ${gov.nameAr} - ${DughryLocationStore.selectedCenter} ستتاح قريباً',
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
            color: DughryColors.silverBright,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 112,
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
                  width: 104,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DughryColors.royalNavySurface
                        : DughryColors.royalNavyCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? DughryColors.silverPrimary
                          : DughryColors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedCategoryIcon(
                        category: cat,
                        size: 58,
                        phase: index,
                      ),
                      const SizedBox(height: 5),
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
                color: DughryColors.silverBright,
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
        if (filteredProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                areaAvailable ? 'لا توجد عروض مسجلة في هذا القسم حالياً.' : 'دوجري سيصل إلى منطقتك قريباً. يمكنك تصفح الأقسام الآن.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: DughryColors.textSecondary),
              ),
            ),
          ),
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
                child: Icon(prod.icon, color: DughryColors.silverPrimary),
              ),
              title: Text(
                prod.nameAr,
                style: const TextStyle(
                  color: DughryColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${prod.categoryTitleAr} • ${prod.governorateAr} • ${prod.unitLabel}\n${prod.price.toStringAsFixed(0)} ج.م (${prod.badge})',
                style: const TextStyle(
                  color: DughryColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () => onAddToCart(prod),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DughryColors.silverPrimary,
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



class _DughryAdsCarousel extends StatefulWidget {
  const _DughryAdsCarousel();

  @override
  State<_DughryAdsCarousel> createState() => _DughryAdsCarouselState();
}

class _DughryAdsCarouselState extends State<_DughryAdsCarousel> {
  final PageController _pageController =
      PageController(viewportFraction: 0.94);
  Timer? _rotationTimer;
  int _activePage = 0;

  static const List<String> _titles = [
    'كل احتياجات بيتك في مكان واحد',
    'اطلب فني موثوق بسهولة',
    'اكتشف عروض دوجري الجديدة',
  ];

  static const List<String> _subtitles = [
    'تسوق المنتجات والخدمات من أقسام دوجري',
    'صيانة وكهرباء وسباكة وخدمات منزلية',
    'مساحة إعلانية تجريبية قابلة للتحكم من الإدارة',
  ];

  static const List<IconData> _icons = [
    Icons.shopping_bag_rounded,
    Icons.home_repair_service_rounded,
    Icons.local_offer_rounded,
  ];

  static const List<Color> _colors = [
    Color(0xFF174477),
    Color(0xFF17615F),
    Color(0xFF59447F),
  ];

  @override
  void initState() {
    super.initState();
    _rotationTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      _activePage = (_activePage + 1) % _titles.length;
      _pageController.animateToPage(
        _activePage,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _titles.length,
            onPageChanged: (page) => setState(() => _activePage = page),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        _colors[index],
                        DughryColors.royalNavyDeep,
                      ],
                    ),
                    border: Border.all(
                      color: DughryColors.silverPrimary.withValues(alpha: 0.24),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -12,
                        bottom: -35,
                        child: Icon(
                          _icons[index],
                          size: 150,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: DughryColors.silverPrimary
                                        .withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'إعلان تجريبي',
                                    style: TextStyle(
                                      color: DughryColors.silverBright,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  _titles[index],
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _subtitles[index],
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: DughryColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              _icons[index],
                              color: DughryColors.silverBright,
                              size: 39,
                            ),
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
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _titles.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: _activePage == index ? 19 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _activePage == index
                    ? DughryColors.silverPrimary
                    : DughryColors.silverMuted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedCategoryIcon extends StatefulWidget {
  final DughryCategoryItem category;
  final double size;
  final int phase;

  const AnimatedCategoryIcon({
    super.key,
    required this.category,
    required this.size,
    this.phase = 0,
  });

  @override
  State<AnimatedCategoryIcon> createState() => _AnimatedCategoryIconState();
}

class _AnimatedCategoryIconState extends State<AnimatedCategoryIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1550 + (widget.phase % 4) * 230),
    )..repeat(reverse: true);
    _floatOffset = Tween<double>(begin: -3.5, end: 3.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatOffset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatOffset.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: DughryColors.silverPrimary.withValues(alpha: 0.85),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 9,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: Color(0x66FFFFFF),
              blurRadius: 3,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.category.icon,
            color: widget.category.accentColor,
            size: widget.size * 0.43,
          ),
        ),
      ),
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
        childAspectRatio: 1.02,
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
                AnimatedCategoryIcon(
                  category: cat,
                  size: 72,
                  phase: index,
                ),
                const SizedBox(height: 9),
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
                    style: const TextStyle(color: DughryColors.silverBright),
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
                  color: DughryColors.silverBright,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final created = DughryAppStateStore.checkoutCart(locationLabel);
                  if (created == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تعذر إتمام الطلب: راجع محتويات السلة والمحافظة المختارة.'),
                      ),
                    );
                    return;
                  }
                  onChanged();
                  onOrderPlaced();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: DughryColors.royalNavySurface,
                      content: Text('تم حفظ الطلب ${created.orderId} على الجهاز كتجربة؛ لم يُرسل إلى متجر أو خادم.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DughryColors.silverPrimary,
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
              'طلب #${o.orderId} • ${o.statusText}',
              style: const TextStyle(
                color: DughryColors.silverBright,
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
  final VoidCallback onRefresh;

  const _AccountAndAdminTabView({
    required this.activeRole,
    required this.onRoleChanged,
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
            color: DughryColors.silverBright,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DughryColors.royalNavyCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DughryColors.borderSubtle),
            ),
            child: const Text(
              'لوحة الإدارة محجوبة في هذه النسخة التجريبية. سيتم تفعيلها بعد ربط تسجيل دخول آمن وخادم لحفظ طلبات التجار والفنيين والأطباء.',
              style: TextStyle(color: DughryColors.textSecondary),
            ),
          ),
        ] else ...[
          DropdownButtonFormField<UserRoleType>(
            initialValue: _formRole,
            dropdownColor: DughryColors.royalNavyCard,
            decoration: const InputDecoration(
              labelText: 'نوع الحساب المطلوب تسجيله',
              filled: true,
              fillColor: DughryColors.royalNavyCard,
            ),
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
          const SizedBox(height: 12),
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
