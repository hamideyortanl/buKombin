import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/clothing_item.dart';
import '../../state/app_state.dart';
import 'services/wardrobe_service.dart';
import 'wardrobe_palette.dart';
import 'widgets/add_clothing_item_sheet.dart';
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
  final _service = WardrobeService();

  bool _grid = true;
  String _query = '';
  String _filter = 'Tümü';
  String _scope = 'Ben';

  List<String> _scopeOptions = const ['Ben', 'Ortak Giysiler', 'Tüm Aile Giysileri'];

  @override
  void initState() {
    super.initState();
    _loadScopeOptions();
  }

  Future<void> _loadScopeOptions() async {
    try {
      final owners = await _service.fetchFamilyOwnerNames();
      if (!mounted) return;

      final options = <String>['Ben'];

      for (final owner in owners) {
        final trimmed = owner.trim();
        if (trimmed.isEmpty) continue;
        if (!options.contains(trimmed)) {
          options.add(trimmed);
        }
      }

      options.add('Ortak Giysiler');
      options.add('Tüm Aile Giysileri');

      setState(() {
        _scopeOptions = options;
        if (!_scopeOptions.contains(_scope)) {
          _scope = 'Ben';
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFamily = state.current?.isFamilyAccount ?? false;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<ClothingItem>>(
          stream: _service.streamWardrobeItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Dolap verileri alınırken hata oluştu:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final allItems = snapshot.data ?? <ClothingItem>[];
            final filtered = _filterItems(allItems, isFamily);

            return CustomScrollView(
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
                            scopes: _scopeOptions,
                            onChanged: (v) => setState(() => _scope = v),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          '${filtered.length} parça bulundu',
                          style: const TextStyle(color: WardrobePalette.textMuted),
                        ),
                        const SizedBox(height: 14),
                        if (filtered.isEmpty)
                          _buildEmptyState()
                        else if (_grid)
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
                              await _loadScopeOptions();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Yeni giysi başarıyla eklendi.'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        SmartCareSection(
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Akıllı bakım önerileri sonraki adımda bağlanacak.'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<ClothingItem> _filterItems(List<ClothingItem> items, bool isFamily) {
    return items.where((it) {
      final q = _query.trim().toLowerCase();

      final matchesQuery = q.isEmpty ||
          it.name.toLowerCase().contains(q) ||
          it.category.toLowerCase().contains(q) ||
          it.subcategory.toLowerCase().contains(q) ||
          it.colorName.toLowerCase().contains(q) ||
          it.ownerName.toLowerCase().contains(q);

      final matchesFilter = _filter == 'Tümü' || it.category == _filter;

      bool matchesScope = true;

      if (isFamily) {
        if (_scope == 'Ben') {
          matchesScope = it.ownerType == ClothingOwnerType.self && !it.isShared;
        } else if (_scope == 'Ortak Giysiler') {
          matchesScope = it.isShared || it.ownerType == ClothingOwnerType.shared;
        } else if (_scope == 'Tüm Aile Giysileri') {
          matchesScope = true;
        } else {
          matchesScope = it.ownerName == _scope;
        }
      }

      return matchesQuery && matchesFilter && matchesScope;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.60),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WardrobePalette.borderSoft),
      ),
      child: const Column(
        children: [
          Icon(Icons.checkroom_outlined, size: 40, color: WardrobePalette.textBrown),
          SizedBox(height: 12),
          Text(
            'Henüz bu filtreye uygun giysi yok.',
            style: TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Yeni bir ürün ekleyerek dolabını oluşturmaya başlayabilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: WardrobePalette.textMuted),
          ),
        ],
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
                children: ['Tümü', 'Üst', 'Alt', 'Elbise', 'Ayakkabı', 'Dış Giyim', 'Aksesuar']
                    .map((f) {
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
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isMineLabel(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'ben' ||
        normalized == 'kendim' ||
        normalized == 'self';
  }
}