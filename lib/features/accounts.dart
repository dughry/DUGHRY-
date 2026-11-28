part of dughry;

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
  static final List<RegistrationRequestRecord> records = [];

  static RegistrationRequestRecord? latestCustomerSession;
  // لا توجد كلمات مرور تجريبية مضمنة؛ يجب ربط الإدارة بمصادقة خادمية آمنة.

  static bool verifyAdminPasscode(String input) {
    return false; // لوحة الإدارة مقفولة حتى تنفيذ المصادقة الآمنة على الخادم.
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
              ? 'تم إنشاء سجل حساب تجريبي على هذا الجهاز'
              : 'تم حفظ طلب التسجيل تجريبياً على هذا الجهاز (${record.status.labelAr})',
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
            initialValue: _selectedGov,
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
              initialValue: _merchantCategory,
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
}
