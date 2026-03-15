import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/clothing_item.dart';
import '../../state/app_state.dart';
import 'wardrobe_palette.dart';
import 'widgets/add_item_button.dart';
import 'widgets/category_chips.dart';
import 'widgets/family_scope_chips.dart';
import 'widgets/items_grid.dart';
import 'widgets/items_list.dart';
import 'widgets/smart_care_section.dart';
import 'widgets/wardrobe_header.dart';
import 'widgets/add_clothing_item_sheet.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  bool _grid = true;
  String _query = '';
  String _filter = 'Tümü';
  String _scope = 'Benim';

  late final List<ClothingItem> _items = List.generate(
    18,
        (i) {
      final isJacket = i % 2 == 0;
      final ownerName = i % 3 == 0
          ? 'Anne'
          : (i % 4 == 0 ? 'Baba' : 'Benim');
      final category = i % 3 == 0
          ? 'Üst'
          : (i % 3 == 1 ? 'Alt' : 'Ayakkabı');
      final colorName = i % 2 == 0 ? 'Kahverengi' : 'Krem';
      final ownerType = ownerName == 'Benim'
          ? ClothingOwnerType.self
          : ClothingOwnerType.familyMember;

      return ClothingItem(
        id: 'demo_$i',
        ownerUid: 'demo_user',
        ownerName: ownerName,
        ownerType: ownerType,
        name: isJacket ? 'Ceket #$i' : 'Elbise #$i',
        category: category,
        subcategory: isJacket ? 'Günlük' : 'Klasik',
        colorName: colorName,
        imageUrl: '',
        imagePath: '',
        isShared: false,
        createdAt: DateTime.now().subtract(Duration(days: i)),
        updatedAt: DateTime.now().subtract(Duration(days: i)),
        season: i % 2 == 0 ? 'Kış' : 'Yaz',
        material: i % 2 == 0 ? 'Pamuk' : 'Keten',
        brand: i % 4 == 0 ? 'BuKombin' : null,
        notes: i % 5 == 0 ? 'Hassas yıkama önerilir.' : null,
        tags: i % 2 == 0 ? const ['günlük', 'favori'] : const ['şık'],
        usageCount: i,
        careInstructions: i % 3 == 0 ? '30 derecede yıka.' : null,
        isFavorite: i % 4 == 0,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFamily = state.current?.isFamilyAccount ?? false;

    final filtered = _items.where((it) {
      final matchesQuery =
          _query.isEmpty || it.name.toLowerCase().contains(_query.toLowerCase());

      final matchesFilter = _filter == 'Tümü' || it.category == _filter;

      final matchesScope = !isFamily ||
          _scope == 'Tüm Aile Giysileri' ||
          _scope == 'Ortak Giysiler'
          ? true
          : it.ownerName == _scope;

      if (!matchesQuery || !matchesFilter || !matchesScope) {
        return false;
      }

      if (_scope == 'Ortak Giysiler') {
        return it.isShared || it.ownerType == ClothingOwnerType.shared;
      }

      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: WardrobeHeader(
                title: 'Dolabım',
                query: _query,
                onQueryChanged: (v) => setState(() => _query = v),
                grid: _grid,
                onToggleGrid: () => setState(() => _grid = !_grid),
                onOpenFilter: () => _openFilterSheet(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CategoryChips(
                      value: _filter,
                      onChanged: (v) => setState(() => _filter = v),
                    ),
                    const SizedBox(height: 10),
                    if (isFamily) ...[
                      FamilyScopeChips(
                        scope: _scope,
                        onChanged: (v) => setState(() => _scope = v),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      '${filtered.length} parça bulundu',
                      style: const TextStyle(color: WardrobePalette.textMuted),
                    ),
                    const SizedBox(height: 14),
                    if (_grid)
                      ItemsGrid(
                        items: filtered,
                        showOwner: isFamily && _scope == 'Tüm Aile Giysileri',
                      )
                    else
                      ItemsList(
                        items: filtered,
                        showOwner: isFamily && _scope == 'Tüm Aile Giysileri',
                      ),
                    const SizedBox(height: 16),
                    AddItemButton(
                        onTap: () async {
                          final added = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddClothingItemSheet(),
                          );
                          if (!context.mounted) return;
                          if (added == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Yeni giysi başarıyla eklendi.')),
                            );
                          }
                          },
                    ),
                    const SizedBox(height: 14),
                    SmartCareSection(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Akıllı bakım önerileri yakında bağlanacak')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: WardrobePalette.bg1,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Filtrele',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: WardrobePalette.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Tümü', 'Üst', 'Alt', 'Ayakkabı'].map((f) {
                  final selected = _filter == f;
                  return ChoiceChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: WardrobePalette.textBrown.withOpacity(0.12),
                    backgroundColor: Colors.white.withOpacity(0.60),
                    side: BorderSide(
                      color: selected
                          ? WardrobePalette.textBrown
                          : WardrobePalette.borderSoft,
                    ),
                    labelStyle: TextStyle(
                      color: selected
                          ? WardrobePalette.textBrown
                          : WardrobePalette.textDark,
                      fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Not: Filtre yapısı korunup yeni modele uyarlanmıştır.',
                style: TextStyle(color: WardrobePalette.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}