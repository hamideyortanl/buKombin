import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../state/app_state.dart';
import '../../services/user_profile_service.dart';
import '../home/root_shell.dart';
import 'onboarding_family_members_screen.dart';

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
  final UserProfileService _userProfileService = UserProfileService();

  final _heightC = TextEditingController();
  final _weightC = TextEditingController();
  final _chestC = TextEditingController();
  final _waistC = TextEditingController();
  final _hipC = TextEditingController();

  String? _gender;
  String? _femaleMode;
  String? _error;
  bool _isSaving = false;

  Uint8List? _imageBytes;
  String? _imageName;

  String? _skinTone;
  String? _faceShape;
  String? _eyeColor;
  String? _hairColor;
  String? _hairTexture;
  String? _hairLength;

  static const List<String> _skinToneOptions = [
    'Açık',
    'Buğday',
    'Esmer',
    'Koyu',
  ];

  static const List<String> _faceShapeOptions = [
    'Oval',
    'Yuvarlak',
    'Kare',
    'Kalp',
    'Uzun',
  ];

  static const List<String> _eyeColorOptions = [
    'Kahverengi',
    'Ela',
    'Mavi',
    'Yeşil',
    'Gri',
  ];

  static const List<String> _hairColorOptions = [
    'Siyah',
    'Kahverengi',
    'Kumral',
    'Sarı',
    'Kızıl',
  ];

  static const List<String> _hairTextureOptions = [
    'Düz',
    'Dalgalı',
    'Kıvırcık',
  ];

  static const List<String> _hairLengthOptions = [
    'Kısa',
    'Orta',
    'Uzun',
    'Toplu',
  ];

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

  bool get _isClosedMode => (_femaleMode ?? '').toLowerCase() == 'closed';

  bool get _canContinue {
    final h = _heightC.text.trim();
    final w = _weightC.text.trim();

    final hasBaseFields = h.length >= 2 &&
        w.length >= 2 &&
        _skinTone != null &&
        _faceShape != null &&
        _eyeColor != null;

    if (_isClosedMode) return hasBaseFields;

    return hasBaseFields &&
        _hairColor != null &&
        _hairTexture != null &&
        _hairLength != null;
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

  void _createAiAvatar() {
    setState(() => _error = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasImage
              ? 'AI Avatar oluşturma sonraki adımda eklenecek.'
              : 'AI Avatar için fotoğraf yüklersen daha iyi sonuç alırız.',
        ),
      ),
    );
  }

  String? _validateNumberField(String label, String v, {bool required = false}) {
    final t = v.trim();
    if (required && t.isEmpty) {
      return 'Lütfen en az boy ve kilo bilgilerini giriniz.';
    }
    if (t.isEmpty) return null;

    if (!RegExp(r'^\d+$').hasMatch(t)) return '$label sadece rakam olmalı.';
    if (t.length < 2) return '$label en az 2 haneli olmalı.';
    if (t.length > 3) return '$label en fazla 3 haneli olmalı.';
    return null;
  }

  Future<void> _saveAndContinue() async {
    setState(() => _error = null);

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      setState(() => _error = 'Oturum bulunamadı. Lütfen tekrar giriş yapın.');
      return;
    }

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

    if (_skinTone == null || _faceShape == null || _eyeColor == null) {
      setState(() => _error = 'Lütfen ten tonu, yüz şekli ve göz rengini seçiniz.');
      return;
    }

    if (!_isClosedMode &&
        (_hairColor == null || _hairTexture == null || _hairLength == null)) {
      setState(() => _error = 'Lütfen saç rengi, dokusu ve uzunluğunu seçiniz.');
      return;
    }

    final height = int.tryParse(_heightC.text.trim());
    final weight = int.tryParse(_weightC.text.trim());
    final chest =
    _chestC.text.trim().isEmpty ? null : int.tryParse(_chestC.text.trim());
    final waist =
    _waistC.text.trim().isEmpty ? null : int.tryParse(_waistC.text.trim());
    final hips =
    _hipC.text.trim().isEmpty ? null : int.tryParse(_hipC.text.trim());

    setState(() => _isSaving = true);

    try {
      await _userProfileService.updateUserProfile(
        uid: firebaseUser.uid,
        data: {
          'avatar': {
            'height': height,
            'weight': weight,
            'chest': chest,
            'waist': waist,
            'hips': hips,
            'skinTone': _skinTone,
            'faceShape': _faceShape,
            'eyeColor': _eyeColor,
            'hairColor': _isClosedMode ? null : _hairColor,
            'hairTexture': _isClosedMode ? null : _hairTexture,
            'hairLength': _isClosedMode ? null : _hairLength,
            'photoName': _imageName,
            'hasUploadedPhoto': _hasImage,
          },
        },
      );

      if (!mounted) return;

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
    } catch (_) {
      setState(() {
        _error = 'Avatar profili kaydedilemedi. Lütfen tekrar deneyin.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    final g = (_gender ?? '').toLowerCase();
    final placeholderIcon = (g.contains('kad') || g.contains('fem'))
        ? Icons.face_3_outlined
        : (g.contains('erk') || g.contains('male'))
        ? Icons.face_6_outlined
        : Icons.camera_alt_outlined;

    return Scaffold(
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
                          'Ölçülerinizi ve görünüş özelliklerinizi girin. Böylece size benzeyen dijital bir temsil oluşturalım.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _textMuted, height: 1.4),
                        ),
                        const SizedBox(height: 18),
                        OnboardingAvatarPhotoSection(
                          placeholderIcon: placeholderIcon,
                          imageBytes: _imageBytes,
                          imageName: _imageName,
                          onPickImage: _pickImage,
                          onAiAvatar: _createAiAvatar,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        if (_isSaving) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Kaydediliyor...',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF6B675F)),
                          ),
                        ],
                        const SizedBox(height: 22),
                        OnboardingAvatarMeasurementsCard(
                          heightC: _heightC,
                          weightC: _weightC,
                          chestC: _chestC,
                          waistC: _waistC,
                          hipC: _hipC,
                          skinTone: _skinTone,
                          faceShape: _faceShape,
                          eyeColor: _eyeColor,
                          hairColor: _hairColor,
                          hairTexture: _hairTexture,
                          hairLength: _hairLength,
                          skinToneOptions: _skinToneOptions,
                          faceShapeOptions: _faceShapeOptions,
                          eyeColorOptions: _eyeColorOptions,
                          hairColorOptions: _hairColorOptions,
                          hairTextureOptions: _hairTextureOptions,
                          hairLengthOptions: _hairLengthOptions,
                          showHairFields: !_isClosedMode,
                          onSkinToneChanged: (v) => setState(() => _skinTone = v),
                          onFaceShapeChanged: (v) => setState(() => _faceShape = v),
                          onEyeColorChanged: (v) => setState(() => _eyeColor = v),
                          onHairColorChanged: (v) => setState(() => _hairColor = v),
                          onHairTextureChanged: (v) => setState(() => _hairTexture = v),
                          onHairLengthChanged: (v) => setState(() => _hairLength = v),
                        ),
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
                  enabled: _canContinue && !_isSaving,
                  onTap: () {
                    if (!_isSaving) {
                      _saveAndContinue();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}