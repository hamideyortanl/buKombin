import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../state/app_state.dart';
import '../home/root_shell.dart';
import 'onboarding_family_members_screen.dart';

// ✅ widgets/avatar klasöründen
import 'widgets/avatar/onboarding_avatar_header.dart';
import 'widgets/avatar/onboarding_avatar_photo_section.dart';
import 'widgets/avatar/onboarding_avatar_measurements_card.dart';
import 'widgets/avatar/onboarding_avatar_footer.dart';

class OnboardingAvatarScreen extends StatefulWidget {
  final String? gender;
  final String? femaleMode; // open/closed

  const OnboardingAvatarScreen({
    super.key,
    this.gender,
    this.femaleMode,
  });

  @override
  State<OnboardingAvatarScreen> createState() => _OnboardingAvatarScreenState();
}

class _OnboardingAvatarScreenState extends State<OnboardingAvatarScreen> {
  final _heightC = TextEditingController();
  final _weightC = TextEditingController();
  final _chestC = TextEditingController();
  final _waistC = TextEditingController();
  final _hipC = TextEditingController();

  String? _gender;
  String? _femaleMode; // ✅ yeni
  String? _error;

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    _gender = widget.gender;
    _femaleMode = widget.femaleMode;

    void listen() {
      if (mounted) setState(() {});
    }

    _heightC.addListener(listen);
    _weightC.addListener(listen);
    _chestC.addListener(listen);
    _waistC.addListener(listen);
    _hipC.addListener(listen);
  }

  @override
  void dispose() {
    _heightC.dispose();
    _weightC.dispose();
    _chestC.dispose();
    _waistC.dispose();
    _hipC.dispose();
    super.dispose();
  }

  bool get _hasImage => _imageBytes != null && _imageBytes!.isNotEmpty;

  // ✅ Fotoğraf şart değil: sadece boy + kilo yeter
  bool get _canContinue {
    final h = _heightC.text.trim();
    final w = _weightC.text.trim();
    // min 2, max 3 kuralı submit'te ayrıca var ama burada da minimumu gözetelim
    return h.length >= 2 && w.length >= 2;
  }

  Future<void> _pickImage() async {
    setState(() => _error = null);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;

      final f = result.files.first;

      setState(() {
        _imageBytes = f.bytes;
        _imageName = f.name;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Fotoğraf seçilirken bir hata oluştu.');
    }
  }

  // ✅ AI butonu hep aktif (görsele bağlı değil)
  void _createAiAvatar() {
    setState(() => _error = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hasImage
            ? 'AI Avatar oluşturma (demo)'
            : 'AI Avatar (demo) • Fotoğraf yüklersen daha iyi sonuç alırsın'),
      ),
    );
  }

  String? _validateNumberField(String label, String v, {bool required = false}) {
    final t = v.trim();
    if (required && t.isEmpty) return 'Lütfen en az boy ve kilo bilgilerini giriniz.';
    if (t.isEmpty) return null; // opsiyonel alan boş olabilir

    // sadece rakam zaten formatter ile zorlanıyor ama yine de güvenlik
    if (!RegExp(r'^\d+$').hasMatch(t)) return '$label sadece rakam olmalı.';
    if (t.length < 2) return '$label en az 2 haneli olmalı.';
    if (t.length > 3) return '$label en fazla 3 haneli olmalı.';
    return null;
  }

  void _next() {
    setState(() => _error = null);

    final hErr = _validateNumberField('Boy', _heightC.text, required: true);
    final wErr = _validateNumberField('Kilo', _weightC.text, required: true);
    final cErr = _validateNumberField('Göğüs', _chestC.text);
    final waErr = _validateNumberField('Bel', _waistC.text);
    final hipErr = _validateNumberField('Kalça', _hipC.text);

    final firstErr = hErr ?? wErr ?? cErr ?? waErr ?? hipErr;
    if (firstErr != null) {
      setState(() => _error = firstErr);
      return;
    }

    final state = context.read<AppState>();
    final isFamily = state.current?.isFamilyAccount ?? false;

    if (isFamily) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingFamilyMembersScreen()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootShell()),
            (r) => false,
      );
    }
  }

  static const _bg1 = Color(0xFFE8DDD5);
  static const _bg2 = Color(0xFFD4C5B9);
  static const _bg3 = Color(0xFFC9B8A8);

  static const _textDark = Color(0xFF3E2723);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    // burada gender senin projende bazen 'female/male' bazen 'Kadın/Erkek' olabiliyor
    // görünümü bozmadan sadece ikon seçiyoruz:
    final g = (_gender ?? '').toLowerCase();
    final placeholderIcon = (g.contains('kad') || g.contains('fem'))
        ? Icons.face_3_outlined
        : (g.contains('erk') || g.contains('male'))
        ? Icons.face_6_outlined
        : Icons.camera_alt_outlined;

    return Scaffold(
      // Ortak tema: tüm sayfalarda arka plan beyaz.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingAvatarHeader(
                      title: 'AI Avatar',
                      stepText: '2/3',
                      progress: 2 / 3,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 18),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 140),
                        children: [
                          const Text(
                            'Fotoğraf yükleyin ve ölçülerinizi girin, size uygun öneriler üretelim.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _textMuted, height: 1.4),
                          ),
                          const SizedBox(height: 18),

                          OnboardingAvatarPhotoSection(
                            placeholderIcon: placeholderIcon,
                            imageBytes: _imageBytes,
                            imageName: _imageName,
                            onPickImage: _pickImage,
                            onAiAvatar: _createAiAvatar, // ✅ hep aktif
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],

                          const SizedBox(height: 22),

                          OnboardingAvatarMeasurementsCard(
                            heightC: _heightC,
                            weightC: _weightC,
                            chestC: _chestC,
                            waistC: _waistC,
                            hipC: _hipC,
                          ),

                          // ✅ femaleMode burada tutuluyor (şimdilik UI'yi bozmayalım diye göstermiyoruz)
                          // İleride istersen debug için gösterebilirsin:
                          // Text('gender=$_gender femaleMode=$_femaleMode'),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: OnboardingAvatarFooter(
                    enabled: _canContinue,
                    onTap: _next,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
