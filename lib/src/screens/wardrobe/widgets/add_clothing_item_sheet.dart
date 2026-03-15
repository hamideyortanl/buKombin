import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/clothing_item.dart';
import '../services/wardrobe_service.dart';
import '../wardrobe_palette.dart';

class AddClothingItemSheet extends StatefulWidget {
  const AddClothingItemSheet({super.key});

  @override
  State<AddClothingItemSheet> createState() => _AddClothingItemSheetState();
}

class _AddClothingItemSheetState extends State<AddClothingItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _service = WardrobeService();
  final _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _materialController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _careController = TextEditingController();

  XFile? _selectedImage;

  String _ownerName = 'Benim';
  ClothingOwnerType _ownerType = ClothingOwnerType.self;
  String _category = 'Üst';
  String _subcategory = 'Günlük';
  String _colorName = 'Siyah';
  String _season = 'Dört Mevsim';
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
    'Üst': ['Tişört', 'Gömlek', 'Kazak', 'Sweatshirt', 'Bluz', 'Günlük'],
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
    _subcategory = _subcategoryMap[_category]!.first;
    _loadOwners();
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

      final cleaned = owners
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      final normalized = <String>[];
      for (final name in cleaned) {
        if (_isMineLabel(name)) {
          if (!normalized.contains('Benim')) {
            normalized.add('Benim');
          }
        } else {
          normalized.add(name);
        }
      }

      if (!normalized.contains('Benim')) {
        normalized.insert(0, 'Benim');
      }

      setState(() {
        _ownerOptions = normalized;
        if (!_ownerOptions.contains(_ownerName) && !_isShared) {
          _ownerName = _ownerOptions.first;
          _ownerType = _ownerName == 'Benim'
              ? ClothingOwnerType.self
              : ClothingOwnerType.familyMember;
        }
        _isLoadingOwners = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ownerOptions = const ['Benim'];
        _ownerName = 'Benim';
        _ownerType = ClothingOwnerType.self;
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
                    'Dolaba Giysi Ekle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: WardrobePalette.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fotoğraf seç, temel bilgileri gir ve dolabına kaydet.',
                    style: TextStyle(
                      color: WardrobePalette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildImagePickerCard(),
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
                    items: _categories,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _category = value;
                        _subcategory = _subcategoryMap[_category]!.first;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Alt kategori',
                    value: _subcategory,
                    items: _subcategoryMap[_category] ?? const [],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _subcategory = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Renk',
                    value: _colorName,
                    items: _colors,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _colorName = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'Sezon',
                    value: _season,
                    items: _seasons,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _season = value);
                    },
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
                          _ownerType = ClothingOwnerType.shared;
                          _ownerName = 'Ortak';
                        } else {
                          final fallbackOwner = _ownerOptions.isNotEmpty
                              ? _ownerOptions.first
                              : 'Benim';
                          _ownerName = fallbackOwner;
                          _ownerType = fallbackOwner == 'Benim'
                              ? ClothingOwnerType.self
                              : ClothingOwnerType.familyMember;
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
                        'Dolaba Kaydet',
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

  Widget _buildImagePickerCard() {
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
            'Giysi fotoğrafı',
            style: TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: WardrobePalette.tileGradient,
              ),
              child: _selectedImage == null
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 34,
                      color: WardrobePalette.textBrown,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Henüz fotoğraf seçilmedi',
                      style: TextStyle(
                        color: WardrobePalette.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Center(
                      child: Text(
                        'Fotoğraf önizleme yüklenemedi',
                        style: TextStyle(color: WardrobePalette.textMuted),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                  _isSaving ? null : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Kamera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                  _isSaving ? null : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeri'),
                ),
              ),
            ],
          ),
        ],
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
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
              ),
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
                'Bu ürün ortak giysi olarak kaydedilecek.',
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
                return _ownerChip(
                  label: owner,
                  selected: selected,
                  onTap: () {
                    setState(() {
                      _isShared = false;
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

  Widget _ownerChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: WardrobePalette.textBrown.withOpacity(0.14),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected
            ? WardrobePalette.textBrown
            : WardrobePalette.borderSoft,
      ),
      labelStyle: TextStyle(
        color: selected
            ? WardrobePalette.textBrown
            : WardrobePalette.textDark,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
          borderSide: const BorderSide(color: WardrobePalette.borderSoft),
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
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.74),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: WardrobePalette.borderSoft),
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

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 88,
      maxWidth: 1800,
    );

    if (picked == null) return;

    setState(() => _selectedImage = picked);
  }

  Future<void> _saveItem() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce bir fotoğraf seç.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await _service.createWardrobeItem(
        imageFile: _selectedImage!,
        ownerName: _ownerName,
        ownerType: _ownerType,
        name: _nameController.text,
        category: _category,
        subcategory: _subcategory,
        colorName: _colorName,
        isShared: _isShared,
        season: _season,
        material: _materialController.text,
        brand: _brandController.text,
        notes: _notesController.text,
        tags: _parseTags(_tagsController.text),
        careInstructions: _careController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt sırasında hata oluştu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  List<String> _parseTags(String raw) {
    return raw
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