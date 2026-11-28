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
  final String? profileImagePath;
  final bool acceptedContract;
  final String? contractVersion;
  final DateTime? acceptedAt;

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
    this.profileImagePath,
    this.acceptedContract = false,
    this.contractVersion,
    this.acceptedAt,
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
        profileImagePath: old.profileImagePath,
        acceptedContract: old.acceptedContract,
        contractVersion: old.contractVersion,
        acceptedAt: old.acceptedAt,
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
  File? _profileImage;
  bool _acceptedContract = false;
  final ImagePicker _imagePicker = ImagePicker();

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

  Future<void> _pickProfileImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (picked != null && mounted) {
        setState(() => _profileImage = File(picked.path));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الاستوديو. حاول مرة أخرى.')),
      );
    }
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isCustomer = widget.role == UserRoleType.customer;
    if (!isCustomer && !_acceptedContract) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب قراءة اتفاقية دوجري والموافقة عليها أولاً.'),
        ),
      );
      return;
    }
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
      profileImagePath: _profileImage?.path,
      acceptedContract: !isCustomer && _acceptedContract,
      contractVersion: isCustomer ? null : 'DEMO-1.0',
      acceptedAt: isCustomer ? null : DateTime.now(),
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
              color: DughryColors.silverBright,
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
          if (widget.role != UserRoleType.customer &&
              widget.role != UserRoleType.admin) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DughryColors.royalNavyCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DughryColors.borderSubtle),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: DughryColors.royalNavySurface,
                    backgroundImage: _profileImage == null
                        ? null
                        : FileImage(_profileImage!),
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person_rounded,
                            color: DughryColors.silverBright,
                            size: 28,
                          )
                        : null,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الصورة الشخصية أو شعار النشاط',
                          style: TextStyle(
                            color: DughryColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'اختياري - يمكنك إضافتها أو تخطيها',
                          style: TextStyle(
                            color: DughryColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _pickProfileImage,
                          icon: const Icon(Icons.photo_library_outlined, size: 17),
                          label: const Text('اختيار من الاستوديو'),
                        ),
                      ],
                    ),
                  ),
                  if (_profileImage != null)
                    IconButton(
                      tooltip: 'حذف الصورة',
                      onPressed: () => setState(() => _profileImage = null),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: DughryColors.crimsonRed,
                      ),
                    ),
                ],
              ),
            ),
          ],
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
          if (widget.role != UserRoleType.customer &&
              widget.role != UserRoleType.admin) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: DughryColors.royalNavyCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DughryColors.silverPrimary.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اتفاقية مقدم الخدمة - إصدار تجريبي 1.0',
                    style: TextStyle(
                      color: DughryColors.silverBright,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'التسجيل في دوجري مجاني حالياً، والعمولة الحالية 0%. أي رسوم أو نسب مستقبلية يجب توضيحها في اتفاقية جديدة والحصول على موافقتك قبل تطبيقها.',
                    style: TextStyle(
                      color: DughryColors.textSecondary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  CheckboxListTile(
                    value: _acceptedContract,
                    onChanged: (value) => setState(
                      () => _acceptedContract = value ?? false,
                    ),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: DughryColors.silverPrimary,
                    checkColor: DughryColors.royalNavyDeep,
                    title: const Text(
                      'قرأت الشروط وأوافق على اتفاقية دوجري',
                      style: TextStyle(
                        color: DughryColors.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: DughryColors.silverPrimary,
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
