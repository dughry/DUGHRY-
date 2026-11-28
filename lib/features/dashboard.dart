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
    return _DughryHomeShowcase(
      gov: gov,
      selectedCategoryId: selectedCategoryId,
      onSelectCategory: onSelectCategory,
      onAddToCart: onAddToCart,
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
