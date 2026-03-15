import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import 'wardrobe_item_card.dart';

class ItemsGrid extends StatelessWidget {
  final List<ClothingItem> items;
  final bool showOwner;
  final ValueChanged<ClothingItem>? onItemTap;

  const ItemsGrid({
    super.key,
    required this.items,
    required this.showOwner,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.86,
      ),
      itemBuilder: (_, i) => WardrobeItemCard(
        item: items[i],
        showOwner: showOwner,
        onTap: () => onItemTap?.call(items[i]),
      ),
    );
  }
}
