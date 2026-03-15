import 'package:flutter/material.dart';

import '../../models/clothing_item.dart';
import 'services/wardrobe_service.dart';
import 'wardrobe_palette.dart';
import 'widgets/edit_clothing_item_sheet.dart';
import 'widgets/wardrobe_detail_info_tile.dart';
import 'widgets/wardrobe_detail_stat_chip.dart';
import 'widgets/wardrobe_tag.dart';

class WardrobeItemDetailScreen extends StatefulWidget {
  final ClothingItem item;

  const WardrobeItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<WardrobeItemDetailScreen> createState() =>
      _WardrobeItemDetailScreenState();
}

class _WardrobeItemDetailScreenState extends State<WardrobeItemDetailScreen> {
  final _service = WardrobeService();

  late ClothingItem _item;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final imageSection = _item.hasImage
        ? Image.network(
            _item.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildImageFallback(),
          )
        : _buildImageFallback();

    return Scaffold(
      backgroundColor: WardrobePalette.bg1,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: WardrobePalette.bg1,
                  surfaceTintColor: WardrobePalette.bg1,
                  pinned: true,
                  expandedHeight: 320,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  actions: [
                    IconButton(
                      tooltip: _item.isFavorite
                          ? 'Favorilerden çıkar'
                          : 'Favorilere ekle',
                      onPressed: _isBusy ? null : _toggleFavorite,
                      icon: Icon(
                        _item.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: WardrobePalette.textBrown,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Düzenle',
                      onPressed: _isBusy ? null : _openEditSheet,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: WardrobePalette.textBrown,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sil',
                      onPressed: _isBusy ? null : _deleteItem,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      child: imageSection,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _item.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: WardrobePalette.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_item.category} • ${_item.subcategory}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: WardrobePalette.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_item.isSharedItem)
                              _buildBadge(
                                text: 'Ortak',
                                icon: Icons.groups_rounded,
                              )
                            else
                              _buildBadge(
                                text: _item.isMine ? 'Benim' : _item.ownerName,
                                icon: Icons.person_outline_rounded,
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            WardrobeDetailStatChip(
                              icon: Icons.palette_outlined,
                              label: 'Renk',
                              value: _item.colorName,
                            ),
                            WardrobeDetailStatChip(
                              icon: Icons.repeat_rounded,
                              label: 'Kullanım',
                              value: '${_item.usageCount} kez',
                            ),
                            WardrobeDetailStatChip(
                              icon: Icons.schedule_rounded,
                              label: 'Son giyilme',
                              value: _formatLastWorn(_item.lastWornAt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Temel bilgiler'),
                        const SizedBox(height: 10),
                        WardrobeDetailInfoTile(
                          label: 'Sahip',
                          value: _item.isMine ? 'Benim' : _item.ownerName,
                        ),
                        const SizedBox(height: 10),
                        if (_item.hasSeason) ...[
                          WardrobeDetailInfoTile(
                            label: 'Sezon',
                            value: _item.season!,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (_item.hasBrand) ...[
                          WardrobeDetailInfoTile(
                            label: 'Marka',
                            value: _item.brand!,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (_item.hasMaterial) ...[
                          WardrobeDetailInfoTile(
                            label: 'Materyal',
                            value: _item.material!,
                          ),
                          const SizedBox(height: 10),
                        ],
                        WardrobeDetailInfoTile(
                          label: 'Oluşturulma tarihi',
                          value: _formatDate(_item.createdAt),
                        ),
                        const SizedBox(height: 10),
                        WardrobeDetailInfoTile(
                          label: 'Son güncelleme',
                          value: _formatDate(_item.updatedAt),
                        ),
                        if (_item.hasCareInstructions) ...[
                          const SizedBox(height: 20),
                          _buildSectionTitle('Bakım notu'),
                          const SizedBox(height: 10),
                          WardrobeDetailInfoTile(
                            label: 'Talimat',
                            value: _item.careInstructions!,
                          ),
                        ],
                        if (_item.hasNotes) ...[
                          const SizedBox(height: 20),
                          _buildSectionTitle('Notlar'),
                          const SizedBox(height: 10),
                          WardrobeDetailInfoTile(
                            label: 'Ek not',
                            value: _item.notes!,
                          ),
                        ],
                        if (_item.tags.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildSectionTitle('Etiketler'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _item.tags
                                .map((tag) => WardrobeTag(text: tag))
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isBusy ? null : _markAsWornToday,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WardrobePalette.textBrown,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.checkroom_outlined),
                            label: const Text(
                              'Bugün giydim',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isBusy ? null : _openEditSheet,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: WardrobePalette.textBrown,
                              side: const BorderSide(
                                color: WardrobePalette.textBrown,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text(
                              'Bilgileri düzenle',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isBusy)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.12),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: WardrobePalette.tileGradient,
      ),
      child: Center(
        child: Icon(
          _item.category == 'Ayakkabı' ? Icons.directions_walk : Icons.checkroom,
          size: 72,
          color: WardrobePalette.textBrown.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildBadge({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.74),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WardrobePalette.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: WardrobePalette.textBrown),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: WardrobePalette.textDark,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final newValue = !_item.isFavorite;
    setState(() => _isBusy = true);

    try {
      await _service.toggleFavorite(itemId: _item.id, isFavorite: newValue);
      if (!mounted) return;

      setState(() {
        _item = _item.copyWith(
          isFavorite: newValue,
          updatedAt: DateTime.now(),
        );
      });
    } catch (e) {
      _showError('Favori durumu güncellenemedi: $e');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _markAsWornToday() async {
    setState(() => _isBusy = true);

    try {
      await _service.incrementUsageCount(itemId: _item.id);
      if (!mounted) return;

      setState(() {
        _item = _item.copyWith(
          usageCount: _item.usageCount + 1,
          lastWornAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanım kaydı işlendi.')),
      );
    } catch (e) {
      _showError('Kullanım kaydı işlenemedi: $e');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _openEditSheet() async {
    final updated = await showModalBottomSheet<ClothingItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditClothingItemSheet(item: _item),
    );

    if (updated == null || !mounted) return;

    setState(() {
      _item = updated;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Giysi bilgileri güncellendi.')),
    );
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Giysi silinsin mi?'),
          content: const Text('Bu işlem geri alınamaz.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Sil',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _isBusy = true);

    try {
      await _service.deleteWardrobeItem(_item);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giysi silindi.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      _showError('Giysi silinemedi: $e');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatLastWorn(DateTime? date) {
    if (date == null) return 'Henüz yok';
    return _formatDate(date);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day.$month.$year • $hour:$minute';
  }
}
