import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

import 'models/clothing_item.dart';
import 'wardrobe_palette.dart';
import 'widgets/add_item_button.dart';
import 'widgets/category_chips.dart';
import 'widgets/family_scope_chips.dart';
import 'widgets/items_grid.dart';
import 'widgets/items_list.dart';
import 'widgets/smart_care_section.dart';
import 'widgets/wardrobe_header.dart';

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

  final List<ClothingItem> _items = List.generate(
    18,
    (i) => ClothingItem(
      name: i % 2 == 0 ? 'Ceket #$i' : 'Elbise #$i',
      owner: i % 3 == 0 ? 'Anne' : (i % 4 == 0 ? 'Baba' : 'Sen'),
      category: i % 3 == 0 ? 'Üst' : (i % 3 == 1 ? 'Alt' : 'Ayakkabı'),
      color: i % 2 == 0 ? BuKombinColors.brown2 : BuKombinColors.accent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFamily = state.current?.isFamilyAccount ?? false;

    final filtered = _items.where((it) {
      final matchesQuery = _query.isEmpty || it.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == 'Tümü' || it.category == _filter;

      // İşlev aynı kalsın diye mevcut scope mantığını bozmadım
      final matchesScope = !isFamily ||
              _scope == 'Tüm Aile Giysileri' ||
              _scope == 'Ortak Giysiler'
          ? true
          : it.owner == _scope;

      if (!matchesQuery || !matchesFilter || !matchesScope) return false;
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
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Giysi ekleme (demo)')),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SmartCareSection(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Akıllı Bakım (demo)')),
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
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: WardrobePalette.textDark),
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
                      color: selected ? WardrobePalette.textBrown : WardrobePalette.borderSoft,
                    ),
                    labelStyle: TextStyle(
                      color: selected ? WardrobePalette.textBrown : WardrobePalette.textDark,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Not: Filtre işlevi korunmuştur. Tasarım görünümüne uyarlanmıştır.',
                style: TextStyle(color: WardrobePalette.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}
