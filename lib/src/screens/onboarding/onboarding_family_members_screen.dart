import 'package:flutter/material.dart';

import '../home/root_shell.dart';

import 'widgets/family/onboarding_family_header.dart';
import 'widgets/family/onboarding_family_member_row.dart';
import 'widgets/family/onboarding_family_add_form.dart';
import 'widgets/family/onboarding_family_dashed_add_button.dart';
import 'widgets/family/onboarding_family_footer.dart';

class OnboardingFamilyMembersScreen extends StatefulWidget {
  const OnboardingFamilyMembersScreen({super.key});

  @override
  State<OnboardingFamilyMembersScreen> createState() =>
      _OnboardingFamilyMembersScreenState();
}

class _OnboardingFamilyMembersScreenState
    extends State<OnboardingFamilyMembersScreen> {
  final List<Map<String, String>> _members = [];

  final _nameC = TextEditingController();
  final _roleC = TextEditingController();

  bool _showAddForm = false;
  String _selectedAvatar = '👤';

  static const List<String> _avatarOptions = [
    '👤',
    '👨',
    '👩',
    '🧑',
    '👧',
    '👦',
    '👴',
    '👵'
  ];

  @override
  void dispose() {
    _nameC.dispose();
    _roleC.dispose();
    super.dispose();
  }

  bool get _canContinue => _members.isNotEmpty;

  void _add() {
    final name = _nameC.text.trim();
    final role = _roleC.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _members.add({
        'name': name,
        'role': role.isEmpty ? 'Üye' : role,
        'avatar': _selectedAvatar,
      });
      _nameC.clear();
      _roleC.clear();
      _selectedAvatar = '👤';
      _showAddForm = false;
    });
  }

  void _done() {
    if (!_canContinue) return; // ✅ zorunlu kural

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootShell()),
          (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ortak tema: tüm sayfalarda arka plan beyaz.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24), // TSX p-6
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // ✅ Header + Back
                OnboardingFamilyHeader(
                  title: 'Aile Hesabı',
                  stepText: '3/3',
                  progress: 1,
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 22),

                // ✅ Intro
                const _IntroBlock(),

                const SizedBox(height: 18),

                // ✅ Content scroll (footer sabit kalacak)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 18),
                    children: [
                      if (_members.isNotEmpty) ...[
                        for (int i = 0; i < _members.length; i++) ...[
                          OnboardingFamilyMemberRow(
                            name: _members[i]['name'] ?? '',
                            role: _members[i]['role'] ?? '',
                            avatar: _members[i]['avatar'] ?? '👤',
                            onDelete: () =>
                                setState(() => _members.removeAt(i)),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],

                      if (_showAddForm)
                        OnboardingFamilyAddForm(
                          nameC: _nameC,
                          roleC: _roleC,
                          avatarOptions: _avatarOptions,
                          selectedAvatar: _selectedAvatar,
                          onSelectAvatar: (a) =>
                              setState(() => _selectedAvatar = a),
                          onCancel: () {
                            setState(() {
                              _showAddForm = false;
                              _nameC.clear();
                              _roleC.clear();
                              _selectedAvatar = '👤';
                            });
                          },
                          onAdd: _add,
                        )
                      else
                        OnboardingFamilyDashedAddButton(
                          onTap: () => setState(() => _showAddForm = true),
                        ),
                    ],
                  ),
                ),

                // ✅ Footer (Stack/Positioned yok = overflow yok)
                OnboardingFamilyFooter(
                  enabled: _canContinue,
                  onTap: _done,
                  // zorunlu kural mesajı
                  helperText: _canContinue
                      ? null
                      : 'Devam etmek için en az 1 aile üyesi eklemelisiniz.',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock();

  static const textBrown = Color(0xFF4A3428);
  static const textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(Icons.group_outlined, color: textBrown, size: 26),
            SizedBox(width: 10),
            Text(
              'Aile Üyeleri',
              style: TextStyle(
                color: textBrown,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Aileniz için ayrı gardırop profilleri oluşturun',
          style: TextStyle(color: textMuted, height: 1.4),
        ),
      ],
    );
  }
}
