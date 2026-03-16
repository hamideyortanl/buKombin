import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/clothing_item.dart';
import '../services/wardrobe_service.dart';
import '../wardrobe_metadata.dart';
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
  final _fabricBlendController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _careController = TextEditingController();

  XFile? _selectedImage;
  String _ownerName = 'Benim';
  ClothingOwnerType _ownerType = ClothingOwnerType.self;
  String? _category;
  String? _subcategory;
  String? _colorName;
  String? _season;
  String? _material;
  bool _careLabelKnown = false;
  bool _isShared = false;
  bool _isSaving = false;
  List<String> _ownerOptions = const ['Benim'];

  List<String> get _subcategories => _category == null
      ? const []
      : (WardrobeMetadata.subcategoryMap[_category] ?? const []);

  @override
  void initState() {
    super.initState();
    _loadOwners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _fabricBlendController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _careController.dispose();
    super.dispose();
  }

  Future<void> _loadOwners() async {
    final owners = await _service.fetchFamilyOwnerNames();
    if (!mounted) return;
    setState(() {
      _ownerOptions = ['Benim', ...owners.where((e) => e.trim().isNotEmpty)];
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 88);
    if (picked == null || !mounted) return;
    setState(() => _selectedImage = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir ürün görseli seç.')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.createWardrobeItem(
        imageFile: _selectedImage!,
        ownerName: _ownerName,
        ownerType: _ownerName == 'Benim' ? ClothingOwnerType.self : ClothingOwnerType.familyMember,
        name: _nameController.text.trim(),
        category: _category!,
        subcategory: _subcategory!,
        colorName: _colorName!,
        isShared: _isShared,
        season: _season,
        material: _material,
        fabricBlend: _cleanNullable(_fabricBlendController.text),
        brand: _cleanNullable(_brandController.text),
        notes: _cleanNullable(_notesController.text),
        tags: _parseTags(_tagsController.text),
        careInstructions: _cleanNullable(_careController.text),
        careLabelKnown: _careLabelKnown,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giysi eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: SizedBox(
                    width: 42,
                    child: Divider(thickness: 4, color: WardrobePalette.borderSoft),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Giysi Ekle', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WardrobePalette.textDark)),
                const SizedBox(height: 6),
                const Text('Kullanıcı sadece temel bilgileri girer; bakım önerilerini sistem üretir.', style: TextStyle(color: WardrobePalette.textMuted)),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _isSaving ? null : _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: WardrobePalette.borderSoft),
                      gradient: WardrobePalette.tileGradient,
                    ),
                    child: _selectedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, color: WardrobePalette.textBrown, size: 34),
                              SizedBox(height: 10),
                              Text('Görsel seç', style: TextStyle(color: WardrobePalette.textDark, fontWeight: FontWeight.w700)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(_nameController, 'Ürün adı', validator: _required),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _ownerName,
                  label: 'Sahip',
                  items: _ownerOptions,
                  onChanged: (value) => setState(() => _ownerName = value ?? 'Benim'),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: _isShared,
                  onChanged: (value) => setState(() => _isShared = value),
                  title: const Text('Ortak giysi olarak işaretle'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                _buildDropdown(
                  value: _category,
                  label: 'Kategori',
                  items: WardrobeMetadata.categories,
                  onChanged: (value) => setState(() {
                    _category = value;
                    _subcategory = null;
                  }),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _subcategory,
                  label: 'Alt kategori',
                  items: _subcategories,
                  onChanged: (value) => setState(() => _subcategory = value),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _colorName,
                  label: 'Renk',
                  items: WardrobeMetadata.colors,
                  onChanged: (value) => setState(() => _colorName = value),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _season,
                  label: 'Sezon',
                  items: WardrobeMetadata.seasons,
                  onChanged: (value) => setState(() => _season = value),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: _material,
                  label: 'Kumaş / materyal',
                  items: WardrobeMetadata.materials,
                  onChanged: (value) => setState(() => _material = value),
                ),
                const SizedBox(height: 12),
                _buildTextField(_brandController, 'Marka (opsiyonel)'),
                const SizedBox(height: 12),
                _buildTextField(_fabricBlendController, 'Kumaş karışımı (opsiyonel)'),
                const SizedBox(height: 12),
                _buildTextField(_tagsController, 'Etiketler (virgülle)', maxLines: 2),
                const SizedBox(height: 12),
                _buildTextField(_notesController, 'Notlar', maxLines: 3),
                const SizedBox(height: 12),
                _buildTextField(_careController, 'Bakım etiketi notu (opsiyonel)', maxLines: 2),
                SwitchListTile.adaptive(
                  value: _careLabelKnown,
                  onChanged: (value) => setState(() => _careLabelKnown = value),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bakım etiketini kontrol ettim'),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WardrobePalette.textBrown,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4))
                        : const Text('Kaydet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: items.isEmpty ? null : onChanged,
      validator: validator,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? 'Bu alan zorunlu.' : null;
  String? _cleanNullable(String value) => value.trim().isEmpty ? null : value.trim();
  List<String> _parseTags(String raw) => raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}
