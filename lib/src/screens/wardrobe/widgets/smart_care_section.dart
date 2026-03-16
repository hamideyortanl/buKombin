import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../care/wardrobe_care_engine.dart';
import '../care/wardrobe_care_models.dart';
import '../services/wardrobe_service.dart';
import '../wardrobe_palette.dart';
import 'smart_care_tile.dart';

class SmartCareSection extends StatelessWidget {
  final List<ClothingItem> items;

  const SmartCareSection({super.key, required this.items});

  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    final tips = WardrobeCareEngine.generateTips(items);
    final previewTips = tips.take(3).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: WardrobePalette.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(colors: [WardrobePalette.g1, WardrobePalette.g2]),
                    ),
                    child: const Icon(Icons.notifications_active_outlined, color: _textLight, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Akıllı Bakım',
                      style: TextStyle(color: WardrobePalette.textDark, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tips.isEmpty
                    ? 'Şimdilik uyarı gerektiren bir bakım önerisi görünmüyor.'
                    : 'Kumaş türü, mevsim, kullanım sayısı ve yıkama durumuna göre öneriler.',
                style: const TextStyle(color: WardrobePalette.textMuted),
              ),
              const SizedBox(height: 14),
              if (tips.isEmpty)
                const _EmptyCareCard()
              else ...[
                ...previewTips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SmartCareTile(
                        emoji: tip.emoji,
                        title: tip.title,
                        subtitle: tip.message,
                        gradient: _gradientForPriority(tip),
                        onTap: () => _showTipDialog(context, tip),
                      ),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showAllTips(context, tips),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Tümünü Gör'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _gradientForPriority(WardrobeCareTip tip) {
    if (tip.priority >= 100) {
      return const LinearGradient(colors: [Color(0xFFFFF4D6), Color(0xFFFFF8EA)]);
    }
    if (tip.priority >= 80) {
      return const LinearGradient(colors: [Color(0xFFEAF4FF), Color(0xFFF4FBFF)]);
    }
    return const LinearGradient(colors: [Color(0xFFF4FAF4), Color(0xFFF9FFF5)]);
  }

  bool _canSendToLaundry(WardrobeCareTip tip) => !tip.item.isInLaundry && (tip.emoji == '🧺' || tip.priority >= 95);

  Future<void> _showTipDialog(BuildContext context, WardrobeCareTip tip) async {
    final service = WardrobeService();
    final profile = WardrobeCareEngine.buildProfile(tip.item);

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('${tip.emoji} ${tip.title}'),
        content: Text(tip.message),
        actions: [
          if (_canSendToLaundry(tip))
            TextButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _sendToLaundry(context, service, tip.item, profile);
              },
              icon: const Icon(Icons.local_laundry_service_outlined),
              label: const Text('Yıkamaya At'),
            ),
          if (tip.item.isInLaundry)
            TextButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _markAsClean(context, service, tip.item);
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Yıkamadan Çıktı'),
            ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam')),
        ],
      ),
    );
  }

  void _showAllTips(BuildContext context, List<WardrobeCareTip> tips) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (_) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Tüm bakım önerileri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WardrobePalette.textDark)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: tips.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final tip = tips[index];
                      return SmartCareTile(
                        emoji: tip.emoji,
                        title: tip.title,
                        subtitle: tip.message,
                        gradient: _gradientForPriority(tip),
                        actionLabel: _canSendToLaundry(tip)
                            ? 'Yıkamaya At'
                            : (tip.item.isInLaundry ? 'Yıkamadan Çıktı' : null),
                        onTap: () {
                          Navigator.of(context).pop();
                          _showTipDialog(context, tip);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendToLaundry(
    BuildContext context,
    WardrobeService service,
    ClothingItem item,
    FabricCareProfile profile,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('🧺 ${item.name} yıkamaya atılsın mı?'),
        content: Text('Öneri:\n• ${profile.washTemperature}\n• ${profile.washMethod}\n• ${profile.dryingMethod}'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yıkamaya At')),
        ],
      ),
    );

    if (confirmed != true) return;

    await service.markItemAsWashing(itemId: item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} yıkamada olarak işaretlendi.')),
    );
  }

  Future<void> _markAsClean(
    BuildContext context,
    WardrobeService service,
    ClothingItem item,
  ) async {
    await service.markItemAsClean(itemId: item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} tekrar aktif hale getirildi.')),
    );
  }
}

class _EmptyCareCard extends StatelessWidget {
  const _EmptyCareCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WardrobePalette.borderSoft),
        color: Colors.white,
      ),
      child: const Row(
        children: [
          Text('🌿', style: TextStyle(fontSize: 26)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bakım dengede görünüyor', style: TextStyle(color: WardrobePalette.textDark, fontWeight: FontWeight.w700)),
                SizedBox(height: 3),
                Text('Kıyafet detaylarından sistemin önerdiği yıkama özetini inceleyebilirsin.', style: TextStyle(color: WardrobePalette.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
