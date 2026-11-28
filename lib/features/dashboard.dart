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
  bool _adminUnlocked = false;
  final _adminPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeRole = widget.initialRole;
    _adminUnlocked = false;
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
                  content: Text('دخول الإدارة غير مفعّل بعد؛ يلزم ربط نظام دخول آمن.'),
                ),
              );
            }
          },
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
              '${gov.nameAr} - ${DughryLocationStore.selectedCenter}',
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
                    widget.onLocationUpdated?.call();
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
              'طلب #${o.orderId} • ${o.statusText}',
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
              style: TextStyle(
                color: DughryColors.goldLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...DughryPortalStore.records.map(
              (req) => Card(
                color: DughryColors.royalNavyCard,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${req.fullName} (${req.role.labelAr})',
                    style: const TextStyle(
                      color: DughryColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${req.governorateAr} - ${req.addressOrCenter}\n${req.primaryDetail} • ${req.status.labelAr}',
                    style: const TextStyle(
                      color: DughryColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<RegistrationStatus>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: DughryColors.goldLight,
                    ),
                    onSelected: (st) {
                      DughryPortalStore.updateStatus(req.id, st);
                      widget.onRefresh();
                      setState(() {});
                    },
                    itemBuilder: (_) => RegistrationStatus.values
                        .map(
                          (st) => PopupMenuItem(
                            value: st,
                            child: Text(st.labelAr),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
         ],
        ] else ...[
          DropdownButtonFormField<UserRoleType>(
            value: _formRole,
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
