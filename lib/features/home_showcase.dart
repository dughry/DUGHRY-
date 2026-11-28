part of dughry;

class _DughryHomeShowcase extends StatefulWidget {
  final GovernorateItem gov;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<DughryCatalogProduct> onAddToCart;

  const _DughryHomeShowcase({
    required this.gov,
    required this.selectedCategoryId,
    required this.onSelectCategory,
    required this.onAddToCart,
  });

  @override
  State<_DughryHomeShowcase> createState() => _DughryHomeShowcaseState();
}

class _DughryHomeShowcaseState extends State<_DughryHomeShowcase> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areaAvailable = DughryLocationStore.isCurrentAreaAvailable;
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredProducts = !areaAvailable
        ? <DughryCatalogProduct>[]
        : DughryAppStateStore.sampleProducts.where((product) {
            final matchesArea = product.governorateAr == widget.gov.nameAr;
            final matchesCategory = widget.selectedCategoryId == null ||
                product.categoryId == widget.selectedCategoryId;
            final matchesQuery = normalizedQuery.isEmpty ||
                product.nameAr.toLowerCase().contains(normalizedQuery) ||
                product.categoryTitleAr.toLowerCase().contains(normalizedQuery);
            return matchesArea && matchesCategory && matchesQuery;
          }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
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
              const Icon(Icons.verified_rounded,
                  color: DughryColors.silverPrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  areaAvailable
                      ? 'متاح الآن في ${widget.gov.nameAr} (${DughryLocationStore.selectedCenter})'
                      : 'الخدمات في ${widget.gov.nameAr} - ${DughryLocationStore.selectedCenter} ستتاح قريباً',
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
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: DughryColors.textLight),
          decoration: InputDecoration(
            hintText: 'ابحث عن مطعم أو منتج أو قسم أو خدمة...',
            hintStyle: const TextStyle(
              color: DughryColors.silverMuted,
              fontSize: 12,
            ),
            prefixIcon: const Icon(Icons.search_rounded,
                color: DughryColors.silverPrimary),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    icon: const Icon(Icons.close_rounded,
                        color: DughryColors.silverMuted),
                  ),
            filled: true,
            fillColor: DughryColors.royalNavyCard,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DughryColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: DughryColors.silverPrimary),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _DughryPromoCarousel(),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'أقسام دوجري',
              style: TextStyle(
                color: DughryColors.silverBright,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${DughryAppStateStore.categories.length} أقسام',
              style: const TextStyle(
                color: DughryColors.silverMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: DughryAppStateStore.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 1.22,
          ),
          itemBuilder: (context, index) {
            final category = DughryAppStateStore.categories[index];
            final selected = widget.selectedCategoryId == category.id;
            return _DughryAnimatedCategoryTile(
              category: category,
              selected: selected,
              onTap: () => widget.onSelectCategory(category.id),
            );
          },
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _query.isEmpty ? 'العروض والخدمات المتاحة' : 'نتائج البحث',
                style: const TextStyle(
                  color: DughryColors.silverBright,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.selectedCategoryId != null || _query.isNotEmpty)
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                  if (widget.selectedCategoryId != null) {
                    widget.onSelectCategory(widget.selectedCategoryId!);
                  }
                },
                child: const Text('عرض الكل',
                    style: TextStyle(color: DughryColors.silverBright)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (filteredProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Center(
              child: Text(
                _query.isNotEmpty
                    ? 'لا توجد نتائج مطابقة في البيانات التجريبية حالياً.'
                    : areaAvailable
                        ? 'لا توجد عروض مسجلة في هذا القسم حالياً.'
                        : 'دوجري سيصل إلى منطقتك قريباً. يمكنك تصفح الأقسام الآن.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: DughryColors.textSecondary),
              ),
            ),
          ),
        ...filteredProducts.map(
          (product) => Card(
            color: DughryColors.royalNavyCard,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: DughryColors.borderSubtle),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(product.icon, color: product.icon == Icons.medical_services_rounded
                    ? const Color(0xFF0D9488)
                    : DughryColors.royalNavyMid),
              ),
              title: Text(
                product.nameAr,
                style: const TextStyle(
                  color: DughryColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${product.categoryTitleAr} • ${product.governorateAr} • ${product.unitLabel}\n${product.price.toStringAsFixed(0)} ج.م (${product.badge})',
                style: const TextStyle(
                  color: DughryColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () => widget.onAddToCart(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DughryColors.silverPrimary,
                  foregroundColor: DughryColors.royalNavyDeep,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text('إضافة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DughryPromoCarousel extends StatefulWidget {
  const _DughryPromoCarousel();

  @override
  State<_DughryPromoCarousel> createState() => _DughryPromoCarouselState();
}

class _DughryPromoCarouselState extends State<_DughryPromoCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.94);
  Timer? _timer;
  int _currentPage = 0;

  static const List<_DughryPromoData> _banners = [
    _DughryPromoData(
      title: 'كل طلباتك في مكان واحد',
      subtitle: 'اكتشف المتاجر والخدمات القريبة منك',
      label: 'دوجري يجمعهالك',
      icon: Icons.shopping_bag_rounded,
      colors: [Color(0xFF176B87), Color(0xFF0B2545)],
    ),
    _DughryPromoData(
      title: 'خدمات فنية أسرع',
      subtitle: 'وصل للفني المناسب لاحتياجك',
      label: 'خدمات موثوقة',
      icon: Icons.handyman_rounded,
      colors: [Color(0xFF168A72), Color(0xFF073B4C)],
    ),
    _DughryPromoData(
      title: 'بيع واشتري بسهولة',
      subtitle: 'منتجات جديدة ومستعملة في سوق دوجري',
      label: 'سوق دوجري المفتوح',
      icon: Icons.storefront_rounded,
      colors: [Color(0xFFB66A19), Color(0xFF542B56)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 154,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: banner.colors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: banner.colors.first.withValues(alpha: 0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -18,
                        top: -26,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.07),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: -24,
                        child: Icon(banner.icon,
                            size: 132,
                            color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      banner.label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    banner.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    banner.subtitle,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Color(0xFFEAF2F8),
                                      fontSize: 11,
                                      height: 1.4,
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
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(banner.icon,
                                  color: banner.colors.first, size: 40),
                            ),
                          ],
                        ),
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
          children: List.generate(_banners.length, (index) {
            final active = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: active ? 22 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active
                    ? DughryColors.silverBright
                    : DughryColors.silverMuted.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _DughryPromoData {
  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final List<Color> colors;

  const _DughryPromoData({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.icon,
    required this.colors,
  });
}

class _DughryAnimatedCategoryTile extends StatefulWidget {
  final DughryCategoryItem category;
  final bool selected;
  final VoidCallback onTap;

  const _DughryAnimatedCategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DughryAnimatedCategoryTile> createState() =>
      _DughryAnimatedCategoryTileState();
}

class _DughryAnimatedCategoryTileState
    extends State<_DughryAnimatedCategoryTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1450 + (widget.category.id.length * 90)),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? DughryColors.royalNavySurface
                : DughryColors.royalNavyCard.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.selected
                  ? DughryColors.silverPrimary
                  : DughryColors.borderSubtle,
              width: widget.selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                ),
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: category.accentColor.withValues(alpha: 0.18),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: category.accentColor.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(category.icon,
                      color: category.accentColor, size: 31),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.titleAr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DughryColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category.groupType,
                maxLines: 1,
                style: const TextStyle(
                  color: DughryColors.silverMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
