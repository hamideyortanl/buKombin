import 'dart:ui';
import 'package:flutter/material.dart';

import '../../widgets/chat/chat_bot_sheet.dart';
import '../../widgets/chat/chat_message.dart';
import '../../widgets/icons/outfit_line_icon.dart';
import '../community/community_screen.dart';
import '../outfits/outfits_screen.dart';
import '../profile/profile_screen.dart';
import '../wardrobe/wardrobe_screen.dart';
import 'home_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  // Sohbet geçmişi RootShell'de tutulur: sekmeler değişse bile sohbet kalır.
  final ValueNotifier<List<ChatMessage>> _messages = ValueNotifier<List<ChatMessage>>(
    const [
      ChatMessage(isUser: false, text: 'Merhaba! Ben buKombin asistanın. Bugün ne giysek?'),
    ],
  );

  final _screens = const [
    HomeScreen(),
    WardrobeScreen(),
    OutfitsScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

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
            return ChatBotSheet(messages: _messages);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _BottomNav(
        index: _index,
        onChanged: (i) {
          // Chatbot tam ortada: menünün 3. öğesi (index 2) sekme değiştirmez.
          if (i == 2) {
            _openChat();
            return;
          }
          setState(() => _index = i);
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.index, required this.onChanged});

  static const _borderSoft = Color(0x66B4A193);
  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.70),
                border: Border.all(color: _borderSoft),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A3428).withOpacity(0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  backgroundColor: Colors.transparent,
                  indicatorColor: const Color(0xFFB4A193).withOpacity(0.35),
                  labelTextStyle: WidgetStateProperty.all(
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      color: selected ? _textBrown : _textBrown.withOpacity(0.65),
                    );
                  }),
                ),
                child: NavigationBar(
                  height: 70,
                  selectedIndex: index,
                  onDestinationSelected: onChanged,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Ana',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.checkroom_outlined),
                      selectedIcon: Icon(Icons.checkroom),
                      label: 'Dolap',
                    ),
                    NavigationDestination(
                      // ✅ Menünün ortasındaki chatbot alanı: sadece buranın arka planı kahverengi
                      // (logo hissi vermesi için)
                      icon: _AssistantNavPill(),
                      selectedIcon: _AssistantNavPill(),
                      label: 'Asistan',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: 'Topluluk',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profil',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssistantNavPill extends StatelessWidget {
  const _AssistantNavPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF4A3428),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3428).withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      // ✅ Çizimi/ikonu değiştirmiyoruz: welcome'daki ikonla birebir aynı.
      child: const OutfitLineIcon(size: 22),
    );
  }
}
