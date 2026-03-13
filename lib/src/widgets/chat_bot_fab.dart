import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'chat/chat_bot_sheet.dart';
import 'chat/chat_message.dart';
import 'icons/outfit_line_icon.dart';

class ChatBotFab extends StatefulWidget {
  const ChatBotFab({super.key});

  @override
  State<ChatBotFab> createState() => _ChatBotFabState();
}

class _ChatBotFabState extends State<ChatBotFab> {
  // ✅ Mesajlar FAB içinde tutulur: sheet kapanıp açılsa bile sohbet kalır
  final ValueNotifier<List<ChatMessage>> _messages = ValueNotifier<List<ChatMessage>>(
    const [
      ChatMessage(isUser: false, text: 'Merhaba! Ben buKombin asistanın. Bugün ne giysek?'),
    ],
  );

  @override
  void dispose() {
    _messages.dispose();
    super.dispose();
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            // scrollController burada şart değil, sheet içinde kendi list controller var.
            return ChatBotSheet(messages: _messages);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openChat,
      backgroundColor: BuKombinColors.brown2,
      foregroundColor: BuKombinColors.beige1,
      // ✅ Sadece sizin ikon
      // ✅ Welcome'daki ikonla aynı çizim/renk
      child: const OutfitLineIcon(size: 22),
    );
  }
}
