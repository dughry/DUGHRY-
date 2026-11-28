part of dughry;

class _GovernorateGpsSheet extends StatefulWidget {
  final VoidCallback onLocationChanged;

  const _GovernorateGpsSheet({required this.onLocationChanged});

  @override
  State<_GovernorateGpsSheet> createState() => _GovernorateGpsSheetState();
}

class _GovernorateGpsSheetState extends State<_GovernorateGpsSheet> {
  late String _tempGovId;
  late String _tempCenter;

  @override
  void initState() {
    super.initState();
    _tempGovId = DughryLocationStore.selectedGovernorateId;
    _tempCenter = DughryLocationStore.selectedCenter;
  }

  @override
  Widget build(BuildContext context) {
    final gov = DughryLocationStore.governorates.firstWhere(
      (g) => g.id == _tempGovId,
      orElse: () => DughryLocationStore.governorates[2],
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
             'اختيار المحافظة والمركز',
              style: TextStyle(
                color: DughryColors.goldLight,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'كل محافظات مصر',
              style: TextStyle(color: DughryColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 230,
              child: GridView.builder(
                itemCount: DughryLocationStore.governorates.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  final item = DughryLocationStore.governorates[index];
                  final selected = item.id == _tempGovId;
                  final label = item.id == 'minya'
                      ? '${item.nameAr} (جزئي)'
                      : item.isAvailable
                          ? item.nameAr
                          : '${item.nameAr} (قريباً)';
                  return ChoiceChip(
                    label: Text(label, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _tempGovId = item.id;
                        _tempCenter = item.availableCenters.isNotEmpty
                            ? item.availableCenters.first
                            : 'قريباً';
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (gov.availableCenters.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: gov.availableCenters.contains(_tempCenter)
                    ? _tempCenter
                    : gov.availableCenters.first,
                dropdownColor: DughryColors.royalNavyCard,
                decoration: const InputDecoration(
                  labelText: 'المركز أو المنطقة',
                  filled: true,
                  fillColor: DughryColors.royalNavyCard,
                ),
                items: gov.availableCenters
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _tempCenter = val);
                },
              )
            else
              Text(
                gov.comingSoonNote,
                style: const TextStyle(color: DughryColors.textSecondary),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                DughryLocationStore.selectedGovernorateId = _tempGovId;
                DughryLocationStore.selectedCenter = _tempCenter;
                DughryLocationStore.isGpsSynced = false;
                widget.onLocationChanged();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DughryColors.goldPrimary,
                foregroundColor: DughryColors.royalNavyDeep,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'حفظ الموقع',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: DughryColors.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: DughryColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: badgeColor),
        ),
        child: Text(
          badgeText,
          style: TextStyle(
            color: badgeColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
