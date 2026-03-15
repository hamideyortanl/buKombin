import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../services/wardrobe_service.dart';
import '../wardrobe_palette.dart';

class EditClothingItemSheet extends StatefulWidget {
  final ClothingItem item;

  const EditClothingItemSheet({
    super.key,
    required this.item,
  });

  @override
  State<EditClothingItemSheet> createState() => _EditClothingItemSheetState();
}

class _EditClothingItemSheetState extends State<EditClothingItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _service = WardrobeService();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _materialController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _careController = TextEditingController();

  String? _ownerName;
  ClothingOwnerType _ownerType = ClothingOwnerType.self;
  String? _category;
  String? _subcategory;
  String? _colorName;
  String? _season;
  bool _isShared = false;

  bool _isSaving = false;
  bool _isLoadingOwners = true;

  List<String> _ownerOptions = const ['Benim'];

  final List<String> _categories = const [
    'Üst',
    'Alt',
    'Elbise',
    'Ayakkabı',
    'Dış Giyim',
    'Aksesuar',
  ];

  final Map<String, List<String>> _subcategoryMap = const {
    'Üst': ['Tişört', 'Gömlek', 'Bluz', 'Kazak', 'Sweatshirt'],
    'Alt': ['Pantolon', 'Etek', 'Şort', 'Jean', 'Eşofman'],
    'Elbise': ['Günlük', 'Klasik', 'Abiye', 'Yazlık'],
    'Ayakkabı': ['Sneaker', 'Topuklu', 'Bot', 'Sandalet', 'Terlik'],
    'Dış Giyim': ['Ceket', 'Kaban', 'Mont', 'Yağmurluk', 'Hırka'],
    'Aksesuar': ['Çanta', 'Şapka', 'Kemer', 'Takı', 'Atkı'],
  };

  final List<String> _colors = const [
    'Siyah',
    'Beyaz',
    'Krem',
    'Bej',
    'Kahverengi',
    'Gri',
    'Mavi',
    'Lacivert',
    'Kırmızı',
    'Yeşil',
    'Pembe',
    'Mor',
    'Sarı',
    'Turuncu',
  ];

  final List<String> _seasons = const [
    'Dört Mevsim',
    'Yaz',
    'Kış',
    'İlkbahar',
    'Sonbahar',
  ];

  @override
  void initState() {
    super.initState();
    _seedForm();
    _loadOwners();
  }

  void _seedForm() {
    final item = widget.item;

    _nameController.text = item.name;
    _brandController.text = item.brand ?? '';
    _materialController.text = item.material ?? '';
    _notesController.text = item.notes ?? '';
    _tagsController.text = item.tags.join(', ');
    _careController.text = item.careInstructions ?? '';

    _ownerName = item.isSharedItem ? 'Ortak' : (item.isMine ? 'Benim' : item.ownerName);
    _ownerType = item.ownerType;
    _category = item.category;
    _subcategory = item.subcategory;
    _colorName = item.colorName;
    _season = item.season;
    _isShared = item.isSharedItem;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _materialController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _careController.dispose();
    super.dispose();
  }

  Future<void> _loadOwners() async {
    try {
      final owners = await _service.fetchFamilyOwnerNames();
      if (!mounted) return;

      final normalized = <String>['Benim'];
      for (final owner in owners) {
        final trimmed = owner.trim();
        if (trimmed.isEmpty) continue;
        if (_isMineLabel(trimmed)) continue;
        if (!normalized.contains(trimmed)) {
          normalized.add(trimmed);
        }
      }

      setState(() {
        _ownerOptions = normalized;
        if (!_isShared && _ownerName != null && !normalized.contains(_ownerName)) {
          _ownerOptions = [...normalized, _ownerName!];
        }
        _isLoadingOwners = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ownerOptions = _ownerName == null ? const ['Benim'] : ['Benim', _ownerName!];
        _isLoadingOwners = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: WardrobePalette.bg1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: WardrobePalette.borderSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Giysi Bilgilerini Düzenle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: WardrobePalette.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Temel alanları güncelle. Görsel değiştirme sonraki adımda eklenecek.',
                    style: TextStyle(color: WardrobePalette.textMuted),
                  ),
                  const SizedBox(height: 20),
                  _buildCurrentImageCard(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Giysi adı',
                    hint: 'Örn. Siyah oversize ceket',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Giysi adı zorunludur.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Kategori',
                    value: _category,
                    hint: 'Seçiniz',
                    items: _categories,
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                        if (!(_subcategoryMap[value]?.contains(_subcategory) ?? false)) {
                          _subcategory = null;
                        }
                      });
                    },
                    validator: (value) => value == null ? 'Kategori seçiniz.' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Alt kategori',
                    value: _subcategory,
                    hint: 'Seçiniz',
                    items: _category == null ? const [] : (_subcategoryMap[_category] ?? const []),
                    onChanged: (value) => setState(() => _subcategory = value),
                    validator: (value) => value == null ? 'Alt kategori seçiniz.' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Renk',
                    value: _colorName,
                    hint: 'Seçiniz',
                    items: _colors,
                    onChanged: (value) => setState(() => _colorName = value),
                    validator: (value) => value == null ? 'Renk seçiniz.' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Sezon',
                    value: _season,
                    hint: 'Seçiniz',
                    items: _seasons,
                    onChanged: (value) => setState(() => _season = value),
                    validator: (value) => value == null ? 'Sezon seçiniz.' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildOwnerSection(),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: WardrobePalette.borderSoft),
                    ),
                    title: const Text(
                      'Ortak giysi olarak işaretle',
                      style: TextStyle(
                        color: WardrobePalette.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Aile dolabında ortak ürün olarak görünsün.',
                      style: TextStyle(color: WardrobePalette.textMuted),
                    ),
                    value: _isShared,
                    onChanged: (value) {
                      setState(() {
                        _isShared = value;
                        if (value) {
                          _ownerName = 'Ortak';
                          _ownerType = ClothingOwnerType.shared;
                        } else {
                          _ownerName = 'Benim';
                          _ownerType = ClothingOwnerType.self;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _brandController,
                    label: 'Marka',
                    hint: 'Opsiyonel',
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _materialController,
                    label: 'Materyal',
                    hint: 'Örn. Pamuk, Keten, Deri',
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _tagsController,
                    label: 'Etiketler',
                    hint: 'Virgülle ayır. Örn. günlük, ofis, favori',
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _careController,
                    label: 'Bakım notu',
                    hint: 'Örn. 30 derecede yıka, düşük ısı ütüle',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notlar',
                    hint: 'Opsiyonel not ekleyebilirsin',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WardrobePalette.textBrown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Değişiklikleri Kaydet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentImageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WardrobePalette.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mevcut görsel',
            style: TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: widget.item.hasImage
                  ? Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageFallback(),
                    )
                  : _buildImageFallback(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: WardrobePalette.tileGradient,
      ),
      child: const Center(
        child: Icon(
          Icons.checkroom,
          size: 34,
          color: WardrobePalette.textBrown,
        ),
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WardrobePalette.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kime ait?',
            style: TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingOwners)
            const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text(
                  'Aile üyeleri yükleniyor...',
                  style: TextStyle(color: WardrobePalette.textMuted),
                ),
              ],
            )
          else if (_isShared)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: WardrobePalette.textBrown.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: WardrobePalette.textBrown),
              ),
              child: const Text(
                'Bu ürün ortak giysi olarak güncellenecek.',
                style: TextStyle(
                  color: WardrobePalette.textBrown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ownerOptions.map((owner) {
                final selected = _ownerName == owner;
                return ChoiceChip(
                  label: Text(owner),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _ownerName = owner;
                      _ownerType = owner == 'Benim'
                          ? ClothingOwnerType.self
                          : ClothingOwnerType.familyMember;
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.74),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: WardrobePalette.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: WardrobePalette.textBrown),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      hint: Text(hint),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.74),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: WardrobePalette.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: WardrobePalette.textBrown),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ),
          )
          .toList(),
    );
  }

  Future<void> _saveItem() async {
    if (!_isShared && _ownerName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ürünün kime ait olduğunu seç.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedItem = widget.item.copyWith(
      ownerName: _isShared ? 'Ortak' : _ownerName!,
      ownerType: _isShared ? ClothingOwnerType.shared : _ownerType,
      name: _nameController.text.trim(),
      category: _category,
      subcategory: _subcategory,
      colorName: _colorName,
      isShared: _isShared,
      season: _cleanNullable(_season),
      material: _cleanNullable(_materialController.text),
      brand: _cleanNullable(_brandController.text),
      notes: _cleanNullable(_notesController.text),
      tags: _parseTags(_tagsController.text),
      careInstructions: _cleanNullable(_careController.text),
      updatedAt: DateTime.now(),
    );

    try {
      await _service.updateWardrobeItem(updatedItem);

      if (!mounted) return;
      Navigator.of(context).pop(updatedItem);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme sırasında hata oluştu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _cleanNullable(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  List<String> _parseTags(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  bool _isMineLabel(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'benim' ||
        normalized == 'ben' ||
        normalized == 'kendim' ||
        normalized == 'self';
  }
}
