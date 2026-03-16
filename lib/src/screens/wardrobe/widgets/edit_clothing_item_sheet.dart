import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../services/wardrobe_service.dart';
import '../wardrobe_metadata.dart';
import '../wardrobe_palette.dart';

class EditClothingItemSheet extends StatefulWidget {
  final ClothingItem item;

  const EditClothingItemSheet({super.key, required this.item});

  @override
  State<EditClothingItemSheet> createState() => _EditClothingItemSheetState();
}

class _EditClothingItemSheetState extends State<EditClothingItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _service = WardrobeService();

  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _fabricBlendController;
  late final TextEditingController _notesController;
  late final TextEditingController _tagsController;
  late final TextEditingController _careController;

  late String _ownerName;
  late String? _category;
  late String? _subcategory;
  late String? _colorName;
  late String? _season;
  late String? _material;
  late bool _careLabelKnown;
  late bool _isShared;
  bool _isSaving = false;
  List<String> _ownerOptions = const ['Benim'];

  List<String> get _subcategories => _category == null
      ? const []
      : (WardrobeMetadata.subcategoryMap[_category] ?? const []);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _brandController = TextEditingController(text: widget.item.brand ?? '');
    _fabricBlendController = TextEditingController(text: widget.item.fabricBlend ?? '');
    _notesController = TextEditingController(text: widget.item.notes ?? '');
    _tagsController = TextEditingController(text: widget.item.tags.join(', '));
    _careController = TextEditingController(text: widget.item.careInstructions ?? '');
    _ownerName = widget.item.ownerName;
    _category = widget.item.category;
    _subcategory = widget.item.subcategory;
    _colorName = widget.item.colorName;
    _season = widget.item.season;
    _material = widget.item.material;
    _careLabelKnown = widget.item.careLabelKnown;
    _isShared = widget.item.isShared;
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
      if (!_ownerOptions.contains(_ownerName)) {
        _ownerOptions = [..._ownerOptions, _ownerName];
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final updated = widget.item.copyWith(
        name: _nameController.text.trim(),
        ownerName: _ownerName,
        ownerType: _isShared
            ? ClothingOwnerType.shared
            : (_ownerName == 'Benim' ? ClothingOwnerType.self : ClothingOwnerType.familyMember),
        category: _category,
        subcategory: _subcategory,
        colorName: _colorName,
        season: _season,
        material: _material,
        fabricBlend: _cleanNullable(_fabricBlendController.text),
        brand: _cleanNullable(_brandController.text),
        notes: _cleanNullable(_notesController.text),
        tags: _parseTags(_tagsController.text),
        careInstructions: _cleanNullable(_careController.text),
        careLabelKnown: _careLabelKnown,
        isShared: _isShared,
      );
      await _service.updateWardrobeItem(updated);
      if (!mounted) return;
      Navigator.of(context).pop(updated.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
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
          color: WardrobePalette.bg1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: SizedBox(width: 42, child: Divider(thickness: 4, color: WardrobePalette.borderSoft))),
                const SizedBox(height: 12),
                const Text('Giysi Düzenle', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WardrobePalette.textDark)),
                const SizedBox(height: 16),
                _buildTextField(_nameController, 'Ürün adı', validator: _required),
                const SizedBox(height: 12),
                _buildDropdown(value: _ownerName, label: 'Sahip', items: _ownerOptions, onChanged: (v) => setState(() => _ownerName = v ?? 'Benim')),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: _isShared,
                  onChanged: (value) => setState(() => _isShared = value),
                  title: const Text('Ortak giysi olarak işaretle'),
                  contentPadding: EdgeInsets.zero,
                ),
                _buildDropdown(value: _category, label: 'Kategori', items: WardrobeMetadata.categories, onChanged: (v) => setState(() { _category = v; _subcategory = null; }), validator: _required),
                const SizedBox(height: 12),
                _buildDropdown(value: _subcategory, label: 'Alt kategori', items: _subcategories, onChanged: (v) => setState(() => _subcategory = v), validator: _required),
                const SizedBox(height: 12),
                _buildDropdown(value: _colorName, label: 'Renk', items: WardrobeMetadata.colors, onChanged: (v) => setState(() => _colorName = v), validator: _required),
                const SizedBox(height: 12),
                _buildDropdown(value: _season, label: 'Sezon', items: WardrobeMetadata.seasons, onChanged: (v) => setState(() => _season = v)),
                const SizedBox(height: 12),
                _buildDropdown(value: _material, label: 'Kumaş / materyal', items: WardrobeMetadata.materials, onChanged: (v) => setState(() => _material = v)),
                const SizedBox(height: 12),
                _buildTextField(_brandController, 'Marka (opsiyonel)'),
                const SizedBox(height: 12),
                _buildTextField(_fabricBlendController, 'Kumaş karışımı (opsiyonel)'),
                const SizedBox(height: 12),
                _buildTextField(_tagsController, 'Etiketler (virgülle)', maxLines: 2),
                const SizedBox(height: 12),
                _buildTextField(_notesController, 'Notlar', maxLines: 3),
                const SizedBox(height: 12),
                _buildTextField(_careController, 'Bakım etiketi notu', maxLines: 2),
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
                    style: ElevatedButton.styleFrom(backgroundColor: WardrobePalette.textBrown, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    child: _isSaving ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4)) : const Text('Kaydet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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

  Widget _buildDropdown({required String? value, required String label, required List<String> items, required ValueChanged<String?> onChanged, String? Function(String?)? validator}) {
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
