import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/user_profile_service.dart';
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
  final UserProfileService _userProfileService = UserProfileService();

  final List<Map<String, String>> _members = [];

  final _nameC = TextEditingController();
  final _roleC = TextEditingController();

  bool _showAddForm = false;
  bool _isSaving = false;
  String? _error;
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
      _error = null;
    });
  }

  Future<void> _done() async {
    if (!_canContinue || _isSaving) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      setState(() => _error = 'Oturum bulunamadı. Lütfen tekrar giriş yapın.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await _userProfileService.saveFamilyMembers(
        uid: firebaseUser.uid,
        members: _members,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootShell()),
            (r) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Aile üyeleri kaydedilemedi. Lütfen tekrar deneyin.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingFamilyHeader(
                title: 'Aile Hesabı',
                stepText: '3/3',
                progress: 1,
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 22),
              const _IntroBlock(),
              const SizedBox(height: 18),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
              ],
              if (_isSaving) ...[
                const Text(
                  'Kaydediliyor...',
                  style: TextStyle(color: Color(0xFF6B675F)),
                ),
                const SizedBox(height: 12),
              ],
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
              OnboardingFamilyFooter(
                enabled: _canContinue && !_isSaving,
                onTap: _done,
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