import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import 'wardrobe_item_row.dart';

class ItemsList extends StatelessWidget {
  final List<ClothingItem> items;
  final bool showOwner;
  final ValueChanged<ClothingItem>? onItemTap;

  const ItemsList({
    super.key,
    required this.items,
    required this.showOwner,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => WardrobeItemRow(
        item: items[i],
        showOwner: showOwner,
        onTap: () => onItemTap?.call(items[i]),
      ),
    );
  }
}
