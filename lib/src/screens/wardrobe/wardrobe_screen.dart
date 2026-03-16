import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/clothing_item.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'care/wardrobe_care_engine.dart';
import 'care/wardrobe_care_models.dart';
import 'services/care_notification_coordinator.dart';
import 'services/wardrobe_service.dart';
import 'wardrobe_item_detail_screen.dart';
import 'wardrobe_metadata.dart';
import 'wardrobe_palette.dart';
import 'widgets/add_clothing_item_sheet.dart';
import 'widgets/add_item_button.dart';
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
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _searchDebounce;
  bool _grid = true;
  bool _showFilterAction = false;
  String _query = '';
  String _liveQuery = '';
  String _filter = 'Tümü';
  String _scope = 'Ben';

  List<String> _scopeOptions = const ['Ben', 'Ortak Giysiler', 'Tüm Aile Giysileri'];

  @override
  void initState() {
    super.initState();
    _loadScopeOptions();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadScopeOptions() async {
    try {
      final owners = await _service.fetchFamilyOwnerNames();
      if (!mounted) return;
      final options = <String>['Ben'];
      for (final owner in owners) {
        final trimmed = owner.trim();
        if (trimmed.isNotEmpty && !options.contains(trimmed)) {
          options.add(trimmed);
        }
      }
      options.addAll(['Ortak Giysiler', 'Tüm Aile Giysileri']);
      setState(() {
        _scopeOptions = options;
        if (!_scopeOptions.contains(_scope)) {
          _scope = 'Ben';
        }
      });
    } catch (_) {}
  }

  void _handleQueryChanged(String value) {
    setState(() {
      _liveQuery = value;
      _showFilterAction = true;
    });

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _query = value);
    });
  }

  void _dismissSearchAndFilter() {
    FocusScope.of(context).unfocus();
    _searchFocusNode.unfocus();
    if (_showFilterAction) {
      setState(() => _showFilterAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFamily = context.select<AppState, bool>(
      (state) => state.current?.isFamilyAccount ?? false,
    );

    return Scaffold(
      body: Column(
        children: [
          WardrobeHeader(
            title: 'Dolabım',
            query: _liveQuery,
            focusNode: _searchFocusNode,
            onQueryChanged: _handleQueryChanged,
            grid: _grid,
            onToggleGrid: () => setState(() => _grid = !_grid),
            onOpenFilter: () => _openFilterSheet(context),
            filterActionOpen: _showFilterAction,
            onFilterActionChanged: (open) => setState(() => _showFilterAction = open),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _dismissSearchAndFilter,
              child: _WardrobeItemsSection(
                service: _service,
                isFamily: isFamily,
                grid: _grid,
                query: _query,
                filter: _filter,
                scope: _scope,
                scopeOptions: _scopeOptions,
                onScopeChanged: (value) => setState(() => _scope = value),
                onItemTap: _openItemDetail,
                onAddItem: _handleAddItem,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddItem() async {
    _dismissSearchAndFilter();
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddClothingItemSheet(),
    );

    if (!mounted) return;

    _dismissSearchAndFilter();
    if (added == true) {
      await _loadScopeOptions();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yeni giysi başarıyla eklendi.')),
      );
    }
  }

  Future<void> _openItemDetail(ClothingItem item) async {
    _dismissSearchAndFilter();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WardrobeItemDetailScreen(item: item)),
    );
    if (!mounted) return;
    _dismissSearchAndFilter();
  }

  void _openFilterSheet(BuildContext context) {
    _dismissSearchAndFilter();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: WardrobePalette.bg1,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (_, setSheetState) => SafeArea(
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.78,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (_, scrollController) => SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const SizedBox(height: 8),
                Text(
                  'Filtrele ve Görünüm',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: WardrobePalette.textDark,
                      ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: WardrobePalette.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Tümü', ...WardrobeMetadata.categories].map((filterOption) {
                    final selected = _filter == filterOption;
                    return ChoiceChip(
                      label: Text(filterOption),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _filter = filterOption);
                        setSheetState(() {});
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Listeleme Şekli',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: WardrobePalette.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Kart'),
                        selected: _grid,
                        onSelected: (_) {
                          setState(() => _grid = true);
                          setSheetState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Liste'),
                        selected: !_grid,
                        onSelected: (_) {
                          setState(() => _grid = false);
                          setSheetState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WardrobePalette.textBrown,
                    ),
                    child: const Text(
                      'Uygula',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WardrobeItemsSection extends StatefulWidget {
  final WardrobeService service;
  final bool isFamily;
  final bool grid;
  final String query;
  final String filter;
  final String scope;
  final List<String> scopeOptions;
  final ValueChanged<String> onScopeChanged;
  final ValueChanged<ClothingItem> onItemTap;
  final Future<void> Function() onAddItem;

  const _WardrobeItemsSection({
    required this.service,
    required this.isFamily,
    required this.grid,
    required this.query,
    required this.filter,
    required this.scope,
    required this.scopeOptions,
    required this.onScopeChanged,
    required this.onItemTap,
    required this.onAddItem,
  });

  @override
  State<_WardrobeItemsSection> createState() => _WardrobeItemsSectionState();
}

class _WardrobeItemsSectionState extends State<_WardrobeItemsSection> {
  final _coordinator = const CareNotificationCoordinator();
  String _lastTipSignature = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ClothingItem>>(
      stream: widget.service.streamWardrobeItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
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
        final filtered = _filterItems(
          allItems,
          widget.isFamily,
          widget.query,
          widget.filter,
          widget.scope,
        );
        final careTips = WardrobeCareEngine.generateTips(allItems);
        _maybeNotify(careTips);

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            BuKombinMetrics.pageHorizontalPadding,
            16,
            BuKombinMetrics.pageHorizontalPadding,
            120,
          ),
          children: [
            if (widget.isFamily) ...[
              FamilyScopeChips(
                scope: widget.scope,
                scopes: widget.scopeOptions,
                onChanged: widget.onScopeChanged,
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
            else if (widget.grid)
              ItemsGrid(
                items: filtered,
                showOwner: widget.isFamily && widget.scope == 'Tüm Aile Giysileri',
                onItemTap: widget.onItemTap,
              )
            else
              ItemsList(
                items: filtered,
                showOwner: widget.isFamily && widget.scope == 'Tüm Aile Giysileri',
                onItemTap: widget.onItemTap,
              ),
            const SizedBox(height: 16),
            AddItemButton(onTap: widget.onAddItem),
            const SizedBox(height: 14),
            SmartCareSection(items: allItems),
          ],
        );
      },
    );
  }

  void _maybeNotify(List<WardrobeCareTip> tips) {
    if (tips.isEmpty) return;

    final signature = tips
        .take(5)
        .map((tip) => '${tip.item.id}|${tip.priority}|${tip.item.usageCount}|${tip.item.laundryStatus}|${tip.item.lastWashedAt?.millisecondsSinceEpoch ?? 0}')
        .join('~');

    if (signature == _lastTipSignature) return;
    _lastTipSignature = signature;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _coordinator.pushCareTips(tips);
    });
  }

  static List<ClothingItem> _filterItems(
    List<ClothingItem> items,
    bool isFamily,
    String query,
    String filter,
    String scope,
  ) {
    var result = List<ClothingItem>.from(items);

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((item) {
        final haystack = [
          item.name,
          item.category,
          item.subcategory,
          item.colorName,
          item.ownerName,
          item.laundryStatusLabel,
          if (item.brand != null) item.brand!,
          if (item.material != null) item.material!,
          if (item.fabricBlend != null) item.fabricBlend!,
          if (item.careInstructions != null) item.careInstructions!,
          ...item.tags,
        ].join(' ').toLowerCase();
        return haystack.contains(q);
      }).toList();
    }

    if (filter != 'Tümü') {
      result = result.where((item) => item.category == filter).toList();
    }

    if (isFamily) {
      switch (scope) {
        case 'Ben':
          result = result
              .where((item) => item.ownerType == ClothingOwnerType.self && !item.isShared)
              .toList();
          break;
        case 'Ortak Giysiler':
          result = result
              .where((item) => item.isShared || item.ownerType == ClothingOwnerType.shared)
              .toList();
          break;
        case 'Tüm Aile Giysileri':
          break;
        default:
          result = result.where((item) => item.ownerName == scope).toList();
      }
    } else {
      result = result
          .where((item) => item.ownerType == ClothingOwnerType.self || item.ownerName == 'Ben')
          .toList();
    }
    return result;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WardrobePalette.borderSoft),
      ),
      child: const Column(
        children: [
          Icon(Icons.checkroom_outlined, size: 34, color: WardrobePalette.textMuted),
          SizedBox(height: 10),
          Text(
            'Seçilen filtrelere uygun parça bulunamadı.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WardrobePalette.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Yeni parça ekleyebilir veya filtreleri değiştirebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: WardrobePalette.textMuted),
          ),
        ],
      ),
    );
  }
}
