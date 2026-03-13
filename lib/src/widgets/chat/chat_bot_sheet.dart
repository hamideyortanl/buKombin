import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../icons/outfit_line_icon.dart';
import 'chat_message.dart';

class ChatBotSheet extends StatefulWidget {
  /// Mesajlar dışarıdan gelir ki FAB kapat aç yapınca sohbet kaybolmasın.
  final ValueNotifier<List<ChatMessage>> messages;

  const ChatBotSheet({super.key, required this.messages});

  @override
  State<ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<ChatBotSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _listCtrl = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final current = List<ChatMessage>.from(widget.messages.value);
    current.add(ChatMessage(isUser: true, text: text));
    current.add(ChatMessage(isUser: false, text: _demoReply(text)));
    widget.messages.value = current;

    _controller.clear();

    // Küçük ekranlarda overflow yerine düzgün kaydırma için:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listCtrl.hasClients) return;
      _listCtrl.animateTo(
        _listCtrl.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  String _demoReply(String input) {
    // Local demo responses (no network). Replace with your real AI endpoint later.
    final lower = input.toLowerCase();
    if (lower.contains('kombin') || lower.contains('öner')) {
      return 'Hemen! Üstte açık ton, altta koyu ton deneyelim. İstersen etkinlik türünü yaz: İş / Okul / Düğün 👗';
    }
    if (lower.contains('renk')) {
      return 'Kahve, bej ve taş tonları buKombin paletine cuk oturuyor. Kontrast için küçük bir siyah detay ekleyebilirsin.';
    }
    return 'Not aldım. Daha net öneri için: hava durumu, etkinlik ve ayakkabı tercihini söyle 🙂';
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final maxBubbleW = (mq.size.width * 0.78).clamp(220.0, 360.0);

    return Container(
      decoration: BoxDecoration(
        color: BuKombinColors.beige1.withOpacity(0.98),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: BuKombinColors.stone2.withOpacity(0.35),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // ✅ Sadece sizin ikon
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: OutfitLineIcon(size: 22),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Chatbot',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Messages
            Expanded(
              child: ValueListenableBuilder<List<ChatMessage>>(
                valueListenable: widget.messages,
                builder: (context, messages, _) {
                  return ListView.builder(
                    controller: _listCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      final align =
                      m.isUser ? Alignment.centerRight : Alignment.centerLeft;

                      final bg = m.isUser
                          ? BuKombinColors.brown2.withOpacity(0.12)
                          : Colors.white.withOpacity(0.75);

                      final border = m.isUser
                          ? BuKombinColors.brown2.withOpacity(0.25)
                          : BuKombinColors.accent.withOpacity(0.35);

                      return Align(
                        alignment: align,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxBubbleW),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: border),
                            ),
                            child: Text(m.text),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Input
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 10,
                bottom: mq.viewInsets.bottom + 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Mesaj yaz...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _send,
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: buKombinPrimaryButtonGradient(),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: BuKombinColors.beige1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
